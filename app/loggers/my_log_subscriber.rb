require 'csv'

class MyLogSubscriber < ActiveSupport::LogSubscriber
    @@log_entries = []
    @@log_lock = Mutex.new

    def initialize
      super
      subscribe_to_current_user_change

      require 'json'
      json_string = File.read('app/loggers/mylog.log')
      @@log_lock.synchronize do
        begin
          @@log_entries = JSON.parse(json_string)
        rescue JSON::ParserError => e
          @@log_entries = []
        end
      end

      json_string = File.read('app/loggers/current_user.log')
      begin
        @active_user = JSON.parse(json_string)
      rescue JSON::ParserError => e
        @active_user = nil
      end
    end

    def self.log_entries
      puts 'get log_entries'
      @@log_lock.synchronize { @@log_entries }
    end

    def self.save_log
      require 'json'
      # puts 'current logs number: ' + @@log_entries.size.to_s
      @@log_lock.synchronize do
        json_string = JSON.generate(@@log_entries, JSON::PRETTY_STATE_PROTOTYPE)
        File.write('app/loggers/mylog.log', json_string)
      end
        # puts 'translate logs to json string: ' + json_string
    end

    def self.export_log
      csv_data = generate_csv_data
      File.open('log/csvlog.csv', "w") do |file|
        file.write(csv_data)
      end
    end

    def self.generate_csv_data
      csv_data = CSV.generate do |csv|
        # csv << ["user_id", "action", "object", "brief_message", "message", "time"] # CSV 表头
        @@log_lock.synchronize do
          csv << @@log_entries.first.keys

          @@log_entries.each do |log|
            # csv << [log[:user_id], log[:action], 'object', log[:brief_message], 
              # log[:message], log[:time]] # 每行数据
            csv << log.values
          end
        end
      end
  
      csv_data
    end
  
    def sql(event)
      # 解析日志消息并将结果存储到数据结构中
      # active_user = RequestStore.store[:current_user]
=begin
      if @active_user != nil
        puts 'user: ' + @active_user.username
      else 
        puts 'user: visitor'
      end
      if event != nil
        puts "get a event: {name: " + (event.name == nil ? 'nil' : event.name) + ", " + 
        "sql-name: " + (event.payload[:name] == nil ? 'nil' : event.payload[:name]) + 
        " ,sql: " + (event.payload[:sql] == nil ? 'nil' : event.payload[:sql]) + "}"
      else
        puts 'nil event'
      end
=end
      # MyLogSubscriber.log_entries << {
        # timestamp: event.time,
        # severity: event.severity,
        # message: event.message
      # }
      parseEvent(event)
    end

    def parseEvent(event)
      action = (event.payload[:sql] != nil ? extract_first_word(event.payload[:sql]) : 'nil')
      object = (event.payload[:sql] != nil ? extract_table_name(event.payload[:sql]) : 'nil')
      brief_message = (event.payload[:name] != nil ? event.payload[:name] : 'nil')
      if @active_user == nil
        id = 'nil'
        is_admin = false
      elsif @active_user.is_a?(Hash)
        id = @active_user["id"]
        is_admin = @active_user["is_admin"]
      elsif @active_user.is_a?(User)
        id = @active_user.id
        is_admin = @active_user.is_admin
      else
        id = 'nil'
        is_admin = false
      end

      @@log_lock.synchronize do
        @@log_entries << {
          user_id: id,
          is_admin: is_admin,
          action: action,
          object: object,
          brief_message: brief_message,
          message: event.payload[:sql],
          time: Time.now
        }
        puts "log entries num: " + @@log_entries.size.to_s
      end
    end

    def extract_first_word(str)
      words = str.split(' ')
      first_word = words.first
      return first_word
    end

    def extract_table_name(query)
      # match_data = query.match(/FROM\s+"([^"]+)"/)
      match_data = query.scan(/FROM\s+"([^"]+)"/).flatten
      match_data = match_data + query.scan(/FROM\s+(\w+)/).flatten
      if match_data
        return match_data
      else
        return 'nil'
      end
    end

    def self.select_log(user_id=nil, action=nil, start_time=nil, object=nil, path=nil, 
    export=false, custom_users)
      ret_log = []
      behaviour_stat = (action != nil or object != nil) and !export
      behaviour_table = {}
      behaviour_sum = 0
      @@log_lock.synchronize do 
        @@log_entries.reverse_each do |log|
          log_user_id = log["user_id"] == nil ? log[:user_id] : log["user_id"]
          log_action = log["action"] == nil ? log[:action] : log["action"]
          log_object = log["object"] == nil ? log[:object] : log["object"]
          log_time = log["time"] == nil ? log[:time] : Time.parse(log["time"])
          is_admin = log["is_admin"] == nil ? log[:is_admin] : log["is_admin"]
=begin
          if user_id == nil or (log_user_id.to_i == user_id.to_i) or 
            (log_user_id == 'nil' and user_id.to_s == 'visitor')
            if action == nil or log_action.to_s.match(action.to_s)
              if object == nil or log_object.include?(object.to_s)
                # puts log_time
                # puts start_time
                if start_time == nil or (start_time <= log_time)
                  ret_log << log
                elsif start_time != nil and (start_time > log_time)
                  break
                end
              end
            end
          end
=end
          if start_time == nil or (start_time <= log_time)
            if action == nil or log_action.to_s.match(action.to_s)
              if object == nil or log_object.include?(object.to_s)

                if behaviour_stat and !is_admin and log_user_id.to_s != 'nil'
                  if behaviour_table.include?(log_user_id.to_s)
                    num = behaviour_table[log_user_id.to_s]
                    behaviour_table[log_user_id.to_s] = num + 1
                  else
                    behaviour_table[log_user_id.to_s] = 1
                  end
                  behaviour_sum += 1
                end

                if user_id == nil or (log_user_id.to_i == user_id.to_i) or 
                  (log_user_id == 'nil' and user_id.to_s == 'visitor')
                  ret_log << log
                end
              end
            end
          elsif start_time != nil and (start_time > log_time)
            break
          end
        end
      end

      ret_data = {}
      if (export)
        # 生成csv数据
        ret_log = ret_log.reverse
        csv_data = CSV.generate do |csv|
          csv << ret_log.first.keys

          ret_log.each do |log|
            csv << log.values
          end
        end

        if path == nil
          file_path = 'log/select/'
        else
          file_path = 'log/' + path + '/'
        end
=begin
        file_path += 'select'

        if (user_id != nil)
          file_path += '_id-' + user_id.to_s
        end
        if (action != nil)
          file_path += '_action-' + action.to_s
        end
        if (start_time != nil)
          file_path += '_time-' + start_time.to_s
        end
        if object != nil
          file_path += '_object-' + object.to_s
        end
=end
        file_path += 'select.csv'
        File.open(file_path , "w") {
          |file|
          file.write(csv_data)
        }
      else
        # 补充不活跃用户的信息
        custom_users.each do |custom_user|
          if behaviour_table.include?(custom_user.to_s)
            
          else
            behaviour_table[custom_user.to_s] = 0
          end
        end

        # 利用哈希表的统计结果，返回各个用户的该行为数量
        if behaviour_stat and (behaviour_table.size > 0)
          # puts behaviour_sum.to_s + " / " + behaviour_table.size.to_s
          avg = behaviour_sum.to_f / behaviour_table.size.to_f
          ret_data[:avg] = avg
          if (user_id != nil)
            # 针对该用户，返回其偏差
            user_behaviour_num = behaviour_table[user_id.to_s]
            if user_behaviour_num == nil
              user_behaviour_num = 0
            end
            # puts user_id.to_s + ' behaviour_num: ' + user_behaviour_num.to_s
            ret_data[:user_offset] = avg == 0 ? 0 : (user_behaviour_num - avg) / avg.to_f
          else
            #返回偏差值超过标准差2倍以上的用户
            std_dev = get_std_dev(behaviour_table, avg)
            special_users = []
            behaviour_table.each do |key, value|
              if value - avg >= 2 * std_dev
                special_users << key
              end
            end

            if (special_users.size > 0)
              ret_data[:special_users] = special_users
            end
            ret_data[:std_dev] = std_dev
          end
        end
      end

      # ret_log.size
      ret_data[:ret_log_size] = ret_log.size

      ret_data
    end

    def self.get_std_dev(behaviour_table, avg)
      std_dev = 0
      if behaviour_table.size == 0
        return std_dev
      end
      behaviour_table.each do |key, value|
        std_dev += (value - avg) ** 2
      end
      std_dev = std_dev.to_f / behaviour_table.size

      std_dev /= Math.sqrt(std_dev)

      std_dev
    end

    private 

    def subscribe_to_current_user_change
      ActiveSupport::Notifications.subscribe('current_user.changed') do |name, start, finish, id, payload|
        RequestStore.store[:current_user] = payload[:user]
        @active_user = payload[:user]
        # puts 'get current_user change: ' + payload[:user].to_json
        save_active_user
      end
    end

    def save_active_user
      if @active_user == nil
        File.write('app/loggers/current_user.log', 'null')
      else
        File.write('app/loggers/current_user.log', @active_user.to_json)
      end
    end
  end
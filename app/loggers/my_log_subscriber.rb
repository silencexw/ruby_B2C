require 'csv'

class MyLogSubscriber < ActiveSupport::LogSubscriber
    @@log_entries = []
    @@log_lock = Mutex.new

    def initialize
      super
      subscribe_to_current_user_change

      require 'json'
      json_string = File.read('app/loggers/mylog.log')
      begin
        @@log_entries = JSON.parse(json_string)
      rescue JSON::ParserError => e
        @@log_entries = []
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
      json_string = JSON.generate(@@log_entries, JSON::PRETTY_STATE_PROTOTYPE)
      # puts 'translate logs to json string: ' + json_string
      File.write('app/loggers/mylog.log', json_string)
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
        csv << log_entries.first.keys

        @@log_entries.each do |log|
          # csv << [log[:user_id], log[:action], 'object', log[:brief_message], 
            # log[:message], log[:time]] # 每行数据
          csv << log.values
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
      elsif @active_user.is_a?(Hash)
        id = @active_user["id"]
      elsif @active_user.is_a?(User)
        id = @active_user.id
      else
        id = 'nil'
      end

      @@log_lock.synchronize do
        @@log_entries << {
          user_id: id,
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
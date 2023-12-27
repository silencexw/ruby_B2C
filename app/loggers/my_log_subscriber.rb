class MyLogSubscriber < ActiveSupport::LogSubscriber
    # @log_entries = []

    def initialize
      super
      subscribe_to_current_user_change
      @log_entries = []
      @active_user = nil
    end

    def self.log_entries
      puts 'get log_entries'
      @log_entries# ||= []
    end
  
    def sql(event)
      # 解析日志消息并将结果存储到数据结构中
      # active_user = RequestStore.store[:current_user]
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
      @log_entries << {
        user: @current_user,
        action: action,
        object: object,
        message: event.payload[:sql]
      }
      puts "log entries num: " + @log_entries.size.to_s
    end

    def extract_first_word(str)
      words = str.split(' ')
      first_word = words.first
      return first_word
    end

    def extract_table_name(query)
      match_data = query.match(/FROM\s+"([^"]+)"/)
      if match_data
        return match_data.captures[0]
      else
        return 'nil'
      end
    end

    private 

    def subscribe_to_current_user_change
      ActiveSupport::Notifications.subscribe('current_user.changed') do |name, start, finish, id, payload|
        RequestStore.store[:current_user] = payload[:user]
        @active_user = payload[:user]
        puts 'get current_user change: ' + payload[:user].to_json
      end
    end
  end
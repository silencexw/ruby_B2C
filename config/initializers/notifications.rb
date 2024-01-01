# 创建一个新的订阅器实例
my_log_subscriber = MyLogSubscriber.new

# 订阅器绑定在'sql.active_record'事件上
ActiveSupport::Notifications.subscribe('active_record', my_log_subscriber)
Que.error_notifier = proc do |error, job|
  # TODO: Send error notifications
end

# Temporary workaround for https://github.com/que-rb/que/issues/425
# until Que merges https://github.com/que-rb/que/pull/423/files
unless ::ActiveRecord::Base.respond_to?(:clear_active_connections!)
  class ::ActiveRecord::Base
    def self.clear_active_connections!
      ::ActiveRecord::Base.connection_handler.clear_active_connections!(:all)
    end
  end
end

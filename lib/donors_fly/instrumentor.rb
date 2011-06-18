module Net
  class HTTP

    def request_with_instrumentation(req, body=nil, &block)
      # #request gets called twice if the connection isn't started
      # we only want to log the request once, so we ignore the unstarted one.
      if started?
        ActiveSupport::Notifications.instrument('request.http', {
            :host => address,
            :path => req.path,
            :method => req.method,
            :ssl => use_ssl?,
            :authorization => req['authorization']
        }) do
          request_without_instrumentation(req, body, &block)
        end
      else
        request_without_instrumentation(req, body, &block)
      end
    end

    alias_method_chain :request, :instrumentation

  end
end

module DonorsFly
  class LogSubscriber < ActiveSupport::LogSubscriber

    def request(event)
      return unless logger.info?
      host = event.payload[:host]
      path = event.payload[:path]
      method = event.payload[:method].upcase
      ssl = event.payload[:ssl]

      color, name, value = WHITE, method, url(host, path, ssl)

      name = "#{name} (%.1fms)" % [event.duration]
      info "  #{color(name, color, true)} #{value}"
    end

    protected

    def url(host, path, ssl)
      proto = ssl ? 'https://' : 'https://'
      proto + host + path
    end
  end
end

DonorsFly::LogSubscriber.attach_to :http
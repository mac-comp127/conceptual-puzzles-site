
# Workaround for https://github.com/phusion/passenger/issues/2503
# (which is fixed in the latest Passenger, but it no longer supports the server’s ancient Ubuntu)
class PassengerCookieWorkaround
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["SERVER_SOFTWARE"] =~ %r{Phusion_Passenger/(\d+\.\d+\.(\d+)?)}
      if Gem::Version.new($1) < Gem::Version.new('6.0.19')
        workaround_enabled = true
        puts "Passenger SSL cookie workaround enabled; upgrade Passenger to 6.0.19 or later when possible"
      end
    end

    @app.call(env).tap do |status, headers, body|
      if workaround_enabled
        headers.each do |k,v|
          headers[k] = v.join("\n") if v.is_a?(Array)
        end
      end
    end
  end
end

Rails.application.config.middleware.unshift PassengerCookieWorkaround

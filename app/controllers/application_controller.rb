class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # before_filter :redis_connection
  before_filter :connection_available?

  def redis_connection
    begin
      if session[:password].blank? then
        @redis ||= Redis.new(url: "redis://#{session[:user]}")
      else
        @redis ||= Redis.new(url: "redis://:#{session[:password]}@#{session[:user]}")
      end
      @redis.ping
      session[:connected] = true
    rescue => e
      session[:connected] = nil
      logger.info "Deu erro ao connectar no Redis: #{e}"
      flash[:error] = "Connection to redis failed"
      redirect_to controller: :login, action: :index
    end
    @redis
  end

  def connection_available?
    unless redis_connection
      session[:connected] = nil
      logger.info "SESSION CONNECTED? #{session[:connected]}"
      flash[:error] = "Please, connect to redis"
      redirect_to controller: :login, action: :index
    end
  end

end

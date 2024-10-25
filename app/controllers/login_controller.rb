class LoginController < ApplicationController

  before_filter :redis_connection, except: [:index, :create]
  before_filter :connection_available?, except: [:index, :create]

  before_action :verify_login, except: [:destroy]

  def index
  end

  def create
    session[:user] = params[:user]
    session[:password] = params[:password]

    redirect_to controller: :dashboard, action: :index
  end

  def destroy
    session[:user] = nil
    session[:password] = nil
    session[:connected] = nil
    redirect_to controller: :login, action: :index
  end

  private
  def verify_login
    logger.info "SESSION CONNECTED? #{session[:connected]}"
    redirect_to controller: :dashboard, action: :index if session[:connected] == true
  end

end

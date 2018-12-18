class AdminPanelController < ApplicationController
  def index
    if cookies['admin']
      redirect_to :controller => 'events', :action => 'index'
    end
  end

  def signin
    @login = params[:login]
    @password = params[:password]

    if @login == 'elonsoft' && @password == 'elonsoftadm'
      cookies['admin'] = true
      redirect_to :controller => 'events', :action => 'index'
    else
      flash.now.notice = 'Неверный логин или пароль'
      render 'index'
    end
  end

  def signout
    cookies.delete('admin')
    redirect_to :controller => 'events', :action => 'index'
  end
end

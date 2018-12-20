class AdminPanelController < ApplicationController
  def index
    if cookies['_adm_id']
      redirect_to :controller => 'events', :action => 'index'
    end
  end

  def signin
    @login = params[:login]
    @password = params[:password]

    if @login == 'elonsoft' && @password == 'elonsoftadm'
      secretId = SecureRandom.random_number 1000
      cookies['_adm_id'] = secretId
      session[secretId] = true
      redirect_to :controller => 'events', :action => 'index'
    else
      flash.now.notice = 'Неверный логин или пароль'
      render 'index'
    end
  end

  def signout
    secretId = cookies['_adm_id']
    session.delete(secretId)
    cookies.delete('_adm_id')
    redirect_to :controller => 'events', :action => 'index'
  end
end

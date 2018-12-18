class EventsController < ApplicationController
  def index
    @admin = cookies['admin']
    @search = Event.ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @events = @search.result.paginate(page: params[:page], per_page: 8)
  end

  def new
    @event = Event.new
  end

  def past
    @events = Event.all.where("date < ?", Time.now.in_time_zone('Moscow').to_date)
  end

  def upcoming
    @events = Event.all.where("date >= ?", Time.now.in_time_zone('Moscow').to_date)
  end

  def show
    @admin = cookies['admin']
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)

    if (@event.save)
      current_date = Time.now.in_time_zone('Moscow').to_date

      #Проверяем предстоящее ли мероприятие и делаем рассылку
      if event_params["date"].to_date > current_date
        @subscribers = Subscriber.all
        @subscribers.each do |subscriber|
          SubscribeMailer.with(email: subscriber.email).subscriptions_email.deliver_now
        end
      end
      redirect_to @event
    else
      render 'new'
    end
  end

  def edit
    if !cookies['admin']
      redirect_to :controller => 'admin_panel', :action => 'index'
    end
    @event = Event.find(params[:id])
  end

  def update
    if !cookies['admin']
      redirect_to :controller => 'admin_panel', :action => 'index'
    end
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      redirect_to @event
    else
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  private def event_params
    params.require(:event).permit(:title, :date, :start_time, :short_desc, :desc, :city, :address, :image, :link, :organizer_id)
  end
end

class EventsController < ApplicationController
  def index
    @search = Event.ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @events = @search.result.paginate(page: params[:page], per_page: 6)
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
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)

    if (@event.save)
      current_date = Time.now.in_time_zone('Moscow').to_date
      if event_params["date"].to_date > current_date
        @subscribers = Subscriber.all
        @subscribers.each do |subscriber|
          SubscribeMailer.with(email: subscriber.email).subscriptions_email.deliver_later
        end
      end
      redirect_to @event
    else
      render 'new'
    end

  end

  private def event_params
    params.require(:event).permit(:title, :date, :start_time, :short_desc, :desc, :city, :address, :image, :link, :organizer_id)
  end
end

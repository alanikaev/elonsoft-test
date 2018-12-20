#Не добавил поддержку часовых поясов, проверяю все по Москве...

class EventsController < ApplicationController
  def index
    @admin = true if is_admin
    @search = Event.ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @events = @search.result.paginate(page: params[:page], per_page: 8)
  end

  def new
    @event = Event.new
  end

  def past
    @events = Event.all.where('date < ?', Time.now.in_time_zone('Moscow').to_date).paginate(page: params[:page], per_page: 8)
  end

  def upcoming
    @events = Event.all.where('date >= ?', Time.now.in_time_zone('Moscow').to_date).paginate(page: params[:page], per_page: 8)
  end

  def show
    @admin = true if is_admin
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)

    if (@event.save)
      current_date = Time.now.in_time_zone('Moscow').to_date

      #Проверяем предстоящее ли мероприятие и делаем рассылку
      if event_params['date'].to_date > current_date
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
    if !is_admin
      redirect_to :controller => 'admin_panel', :action => 'index'
    end
    @event = Event.find(params[:id])
  end

  def update
    if !is_admin
      redirect_to :controller => 'admin_panel', :action => 'index'
    end
    @event = Event.find(params[:id])

    #Удаляем старые файлы если пользователь загружает новые(для того чтобы убрать их из Amazon S3 и вместо них залить новые)
    @event.image.remove! if check_image(event_params['image'])
    @event.attachment_file.remove! if check_file(event_params['attachment_file'])

    if @event.update_attributes(event_params)
      redirect_to @event
    else
      render 'edit'
    end
  end

  def destroy
    @admin = true if is_admin
    if @admin
      @event = Event.find(params[:id])
      @event.image.remove!
      @event.destroy
      redirect_to events_path
    else
      redirect_to admin_panel_signin_path
    end
  end

  def download_file
    @event = Event.find(params[:id])
    redirect_to @event.attachment_file.url
  end

  def ics
    @event = Event.find(params[:id])
    cal = Icalendar::Calendar.new
    filename = @event.title
    date = @event.date.to_s.tr('-', '').to_i

    cal.event do |e|
      e.dtstart = Icalendar::Value::Date.new(date)
      e.summary = @event.short_desc
      e.url = @event.link
      e.location = @event.city + ',' + @event.address
    end

    send_data(cal.to_ical,
              type: 'text/calendar',
              disposition: 'attachment',
              filename: filename + '.ics')
    GC.start
  end

  private def event_params
    params.require(:event).permit(:title, :date, :start_time, :short_desc, :desc, :city, :address, :image, :attachment_file, :link, :organizer_id, :all_tags)
  end

  private def is_admin
    secretKey = cookies['_adm_id']
    if secretKey
      session[secretKey]
    else
      false
    end
  end

  private def check_image(image)
    if image.to_s.include?(".png") or image.to_s.include?(".jpg") or image.to_s.include?(".jpeg")
      true
    end
  end

  private def check_file(file)
    if file.to_s.include?(".pdf") or file.to_s.include?(".doc") or file.to_s.include?(".docx")
      true
    end
  end
end

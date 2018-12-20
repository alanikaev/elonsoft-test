class SubscribeMailer < ApplicationMailer
  def subscriptions_email
    @email = params[:email]
    @url = "https://elonsoft.herokuapp.com/events/upcoming"
    mail(to: @email, subject: 'Оповещение о новых мероприятиях')
  end
end

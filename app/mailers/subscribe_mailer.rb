class SubscribeMailer < ApplicationMailer
  def subscriptions_email
    @email = params[:email]
    @url = "http://localhost:3000/events/upcoming"
    mail(to: @email, subject: 'Оповещение о новых мероприятиях')
  end
end

class OrganizersController < ApplicationController

  def index
    @organizers = Organizer.all.order(:name)
  end

  def new
    @organizer = Organizer.new
  end

  def show
    @organizer = Organizer.find(params[:id])
    @events = Event.all.where(organizer_id: @organizer.id)
  end

  def create
    @organizer = Organizer.new(organizer_params)

    if (@organizer.save)
      redirect_to @organizer
    else
      render 'new'
    end
  end

  private def organizer_params
    params.require(:organizer).permit(:name,:desc)
  end
end

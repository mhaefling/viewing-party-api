class Api::V1::ViewingPartiesController < ApplicationController

  def create
    if User.find(params[:user_id])
      ViewingParty.validate_viewing_times(viewing_party_params)
      new_party = ViewingParty.create_party(User.find(params[:user_id]), User.validate_invitees(params[:invitees]), viewing_party_params)
      render json: ViewingPartySerializer.format_viewing_party(new_party)
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title)
  end
end
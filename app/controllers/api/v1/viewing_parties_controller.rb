class Api::V1::ViewingPartiesController < ApplicationController

  def create
    if User.validate_host(params[:user_id])
      ViewingParty.check_viewing_times(viewing_party_params)
      new_viewing_party = ViewingParty.create_party(params[:user_id], ViewingParty.validate_invitees(params[:invitees]), viewing_party_params)
      render json: ViewingPartySerializer.format_viewing_party(new_viewing_party)
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title)
  end
end
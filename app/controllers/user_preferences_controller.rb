class UserPreferencesController < ApplicationController
  def edit
    @preferences = current_user.prefs
  end

  def update
    current_user.update_preferences(params[:preferences])
    @preferences = current_user.prefs
    redirect_to :back
  end

end

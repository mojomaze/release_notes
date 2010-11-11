class UserPreferencesController < ApplicationController
  def edit
    @preferences = current_user.preferences
  end

  def update
    current_user.update_attribute(:prefs, params[:preferences])
    @preferences = current_user.preferences
    redirect_to :back
  end

end

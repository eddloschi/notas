class NotesController < ApplicationController
  before_action :authenticate_user!

  def index
    @notes = Note.where(user: current_user)
  end
end

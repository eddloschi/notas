class NotesController < ApplicationController
  before_action :authenticate_user!

  def index
    @notes = Note.where(user: current_user).order(updated_at: :desc)
  end

  def new
    @note = Note.new(color: 'Gold')
  end

  def create
    @note = Note.new(note_params.merge(user: current_user))
    if @note.save
      redirect_to notes_path
    else
      render :new, status: 422
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    if @note.update(note_params)
      redirect_to notes_path
    else
      render :edit, status: 422
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :body, :color)
  end
end

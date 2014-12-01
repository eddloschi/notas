class NotesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource only: [:edit, :update, :destroy]

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
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @note.update(note_params)
      redirect_to notes_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @note.destroy
      redirect_to notes_path
    else
      flash[:alert] = I18n.t('errors.delete_note')
      redirect_to notes_path, status: :unprocessable_entity
    end
  end

  def search
    @notes = Note.where(user: current_user)
      .where(' notes.title LIKE ? OR notes.body LIKE ?',
        "%#{params[:query]}%", "%#{params[:query]}%")
      .order(updated_at: :desc)
    if @notes.count > 0
      flash.now[:notice] = I18n.t('messages.n_notes_found', count: @notes.count)
    else
      flash.now[:alert] = I18n.t('messages.no_notes_found')
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :body, :color)
  end
end

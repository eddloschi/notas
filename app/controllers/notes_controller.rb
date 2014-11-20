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

  def destroy
    @note = Note.find(params[:id])
    if @note.destroy
      redirect_to notes_path
    else
      flash[:alert] = @note.errors.full_messages.join('\n')
      redirect_to notes_path, status: 422
    end
  end

  def search
    @notes = Note.where(user: current_user)
      .where(' notes.title like ? or notes.body like ?', "%#{params[:query]}%", "%#{params[:query]}%")
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

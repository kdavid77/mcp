class NotesController < ApplicationController
  before_action :logged_in_user, only: [:show, :create, :destroy]
  
  def show
    @user = current_user
    @notes = @user.notes.paginate(page: params[:page])
    @note = Note.find_by(id: params[:id])
  end
  
  def new
    if logged_in?
      @user = current_user
      @new_note = current_user.notes.build
    else
      redirect_to root_url
    end
  end
  
  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      flash[:success]="Note created"
      redirect_to notes_path
    else
      flash[:danger]="Something went wrong..."
      redirect_to notes_path
    end
  end
  
  def edit
    @edit_note = Note.find_by(id: params[:id])
  end
  
  def update
    @note = Note.find_by(id: params[:id])
    if @note.update_attributes(note_params)
      flash[:success]="Note successfully edited."
    else
      flash[:danger]="Something went wrong..."
    end
    redirect_to @note
  end
  
  def destroy
    note = Note.find_by(id: params[:id])
    note.destroy
    flash[:success]="Note deleted. "
    redirect_to notes_path
  end
  
  def index
    if logged_in?
      @user = current_user
      @notes = @user.notes.where("content LIKE ?", "%"+params[:search_keywords].to_s+"%").paginate(page: params[:page])
      @new_note = current_user.notes.build
    else
      redirect_to root_url
    end
  end
  
  private
    def note_params
      params.require(:note).permit(:content)
    end
    
    def correct_user
      @note = current_user.notes.find_by(id: params[:id])
      redirect_to root_url if @note.nil
    end
    
    def search_results
      keywords = "%"+params[:search_keywords]+"%"
    end
end

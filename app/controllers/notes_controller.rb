class NotesController < ApplicationController
  before_action :logged_in_user, only: [:show, :create, :edit, :update, :destroy]
  
  def show
    @user = current_user
    @notes = @user.notes.paginate(page: params[:page])
    @note = Note.find_by(id: params[:id])    
    highlight(@note, session[:search_keywords]) if @note && session[:search_keywords]
  end
  
  def new
    @new_note = Note.new
    redirect_to root_url if not logged_in?
  end
  
  def create
    @new_note = current_user.notes.build(note_params)
    if @new_note.save
      flash[:success]="Note created"
      redirect_to notes_path
    else
      render 'new'
    end
  end
  
  def edit
    @edit_note = Note.find_by(id: params[:id])
    if @edit_note.archived
      redirect_to notes_path
    end
  end
  
  def archive
    @archive_note = Note.find_by(id: params[:id])
    @archive_note.update_attribute( :archived, 'true')
    redirect_to notes_path
  end
  
  def activate
    @archive_note = Note.find_by(id: params[:id])
    @archive_note.update_attribute( :archived, 'false')
    redirect_to notes_path
  end
    
  def update
    @edit_note = Note.find_by(id: params[:id])
    if @edit_note.update_attributes(note_params)
      flash[:success]="Note successfully edited."
      redirect_to @edit_note
    else
      render 'edit'
    end
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
      session[:show_archived_notes]||='false'

      if params[:show_archived_notes] 
	session[:show_archived_notes]=params[:show_archived_notes]
      end
      
      if params[:search_keywords]
	session[:search_keywords]=params[:search_keywords]
      else
	session.delete(:search_keywords)
      end
      
      @active_notes = @user.notes.where(archived: false)
				  .where("content LIKE ? OR title LIKE ?", 
				         "%"+session[:search_keywords].to_s+"%", 
				         "%"+session[:search_keywords].to_s+"%")
				  .paginate(page: params[:page])
      if session[:show_archived_notes]=='true'        
	@archived_notes = @user.notes.where(archived: true)
				      .where("content LIKE ? OR title LIKE ?", 
				             "%"+session[:search_keywords].to_s+"%", 
				             "%"+session[:search_keywords].to_s+"%")
				      .paginate(page: params[:page])
      end
      if session[:search_keywords]
	@active_notes.each do |note|
	  #note.title = note.title.gsub session[:search_keywords], "<b>" + session[:search_keywords] + "</b>"
	  #note.content = note.content.gsub(session[:search_keywords], "<b>" + session[:search_keywords] + "</b>")
	  highlight(note, session[:search_keywords])
	end if @active_notes
	@archived_notes.each do |note|
	  #note.title = note.title.gsub session[:search_keywords], "<b>" + session[:search_keywords] + "</b>"
	  #note.content = note.content.gsub(session[:search_keywords], "<b>" + session[:search_keywords] + "</b>")
	  highlight(note, session[:search_keywords])
	end if @archived_notes
      end
    else
    redirect_to root_url
    end
  end
  
  private
    def highlight(target, part)
      target.title = target.title.gsub part, '<b>' + part + '</b>'
      target.content = target.content.gsub part, '<b>' + part + '</b>'
    end
  
    def note_params
      params.require(:note).permit(:title, :content, :archived)
    end
    
    def correct_user
      @note = current_user.notes.find_by(id: params[:id])
      redirect_to root_url if @note.nil
    end
    
    def search_results
      keywords = "%"+params[:search_keywords]+"%"
    end
end

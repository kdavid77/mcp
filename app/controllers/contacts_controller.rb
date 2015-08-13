class ContactsController < ApplicationController
  before_action :logged_in_user
  
  def new
    @new_contact = Contact.new
    redirect_to root_url if not logged_in?
  end
  
  def create
    @new_contact = current_user.contacts.build(contact_params)
    if @new_contact.save
      flash[:success] = "Contact created"
      redirect_to contacts_path
    else
      render 'new'
    end
  end
  
  def show
    @user = current_user
    @contact = Contact.find_by(id: params[:id])
  end
  
  def index
    if logged_in?
      @user = current_user
      @contacts = @user.contacts.paginate(page: params[:page])
    else
      redirect_to root_url
    end
  end
  
  def edit
    @edit_contact = Contact.find_by(id: params[:id])
  end
  
  def update
    @edit_contact = Contact.find_by(id: params[:id])
    if @edit_contact.update_attributes(contact_params)
      flash[:success]="Contact edited"
      redirect_to @edit_contact
    else
      render 'edit'
    end
  end
  
  def destroy
    contact = Contact.find_by(id: params[:id])
    contact.destroy
    flash[:success]="Contact deleted"
    redirect_to contacts_path
  end
  
  private
  
    def contact_params
      params.require(:contact).permit(:name, :memo)
    end
end

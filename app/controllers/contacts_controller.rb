class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]

  # GET /contacts or /contacts.json
  def index
    @contacts = Contact
      .order(:name)
      .page(params[:page])
      .per(15)
  end

  # GET /contacts/1 or /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @contact.build_address
    get_kinds_for_select
  end

  # GET /contacts/1/edit
  def edit
    if (@contact.address == nil)
      @contact.build_address
    end
    get_kinds_for_select
  end

  # POST /contacts or /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to contact_url(@contact), notice: t('Message.New.Success.Contact') }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to contact_url(@contact), notice: t('Message.Edit.Success.Contact') }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url, notice: t('Message.Delete.Success.Contact') }
      format.json { head :no_content }
    end
  end

  private
    def get_kinds_for_select
      @kinds = Kind.all
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact
      .includes("kind")
      .includes("phones")
      .includes("address")
      .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contact_params
      params.require(:contact).permit(
        :name,
        :email,
        :kind_id,
        :rmk,
        address_attributes: [:street, :city, :state, :id ],
        phones_attributes: [:id, :phone, :_destroy])
    end
end

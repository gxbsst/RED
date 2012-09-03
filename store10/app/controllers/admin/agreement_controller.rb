class Admin::AgreementController < Admin::BaseController
  include ActionView::Helpers::TextHelper
  
  def index
    @title = "Agreement List"
    @agreements = Agreement.find(:all, :include => :agreement_versions)
  end

  def new
    @title = "New Agreement"
    @agreement = Agreement.new
  end
  
  def edit
    @title = "Edit Agreement"
    @agreement = Agreement.find(params[:id])
    render :action => "new"
  end
  
  def save
    if params[:id].blank?
      @title = "Create New Agreement"
      @agreement = Agreement.create(params[:agreement])
    else
      @title = "Editing Download item"
      @agreement = Agreement.find(params[:id])
      @agreement.update_attributes(params[:agreement])
    end
    
    if @agreement.errors.empty?
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
  
  def destroy
    Agreement.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  # Agreement Version Manager Begin Here.
  def new_version
    @title = "Create New Agreement Version"
    @agreement = Agreement.find(params[:id])
    @version = AgreementVersion.new
  end
  
  def save_version
    # Determine @version is new or exist
    # params[:id] empty     => new
    # params[:id] not empty => exist
    if params[:id].blank?
      @title = "Create New Agreement Version"
      @agreement = Agreement.find(params[:agreement][:id])
      @version = AgreementVersion.new(params[:version])
      render(:action => "new_version") && return unless @version.valid?
      @version.version = (@agreement.agreement_versions.size == 0 ? 1 : @agreement.agreement_versions.collect{|o| o.version }.max + 1)
      @agreement.agreement_versions << @version
    else
      @title = "Create New Agreement Version"
      @agreement = Agreement.find(params[:agreement][:id])
      @version = AgreementVersion.find(params[:id])
      @version.update_attributes(params[:version])
      render(:action => "new_version") && return unless @version.valid?
    end
    redirect_to :action => "edit", :id => @agreement.id
  end
  
  def show_version
    @title = "Show Agreement Version"
    @version = AgreementVersion.find(params[:id])
    @agreement = @version.agreement
    render :action => "new_version"
  end
  
  def destroy_version
    version = AgreementVersion.find(params[:id])
    agreement = version.agreement
    version.destroy
    redirect_to :action => 'edit', :id => agreement.id
  end
  
  def preview
    render :text => textilize(params[:version][:content])
  end
end

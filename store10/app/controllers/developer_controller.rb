class DeveloperController < ApplicationController
  # layout 'static_pages'

  def index
    # render :text => 'Test'
    @page_title = 'RED / Developer'
    if @request.method == :get
      @sdk = SdkSurvey.new
    else
      @sdk = SdkSurvey.new(params[:sdk_survey])
      if @sdk.save     
        begin
          # Send Mail...
          # filename = 'Terms_and_Conditions_07.24.08.pdf'
          OrdersMailer.deliver_sdk(@sdk)
          OrdersMailer.deliver_sdk_staff(@sdk)
          @sdk.update_attributes( :send_mailed => true)
          # Send Mail to staff
          flash[:notice] = "Application Step 1 Complete. Please check your email #{@sdk.email} for the PDF Agreement and additional instructions. <br /><br />
          Thank you."
        rescue => e
          # raise  e
          @sdk.errors[:email].blank? ? flash[:notice] = 'Not Success!' : flash[:notice] = "#{@sdk.errors[:email]}" 
        end
      else 
         
       @sdk.errors[:email].blank? ? flash[:notice] = 'Not Success!' : flash[:notice] = "#{@sdk.errors[:email]}" 
        # redirect_to :action => 'index' 
      end
    end
  end



  # def download
  #   unless params[:sid]
  #     redirect_to "/404.html"
  #     return
  #   end
  #   
  #   begin
  #     @sdk= SdkSurvey.find(:all , :conditions => ["sid =? ", params[:sid].to_s]).first
  #     # Redirect broswer to expired page if this was already expired.
  #     # TODO: we need new expired page in the future.
  #     raise if @sdk.expired?
  #   # 
  #   # Generate a symbolic link for this file to download.
  #   # After deploied on server, a CRON job will clean up these links every 30 minutes.
  #   # path = Digest::SHA1.hexdigest("#{session.session_id} @ #{Time.now.to_f}")
  #   path = Digest::SHA1.hexdigest("#{session.session_id} @ #{Time.now.to_f}")
  #   filename = 'RED_R3D_SDK_Agreement.pdf.zip'
  #   FileUtils.mkdir "./public/downloads/#{path}" unless File.directory? "./public/downloads/#{path}"
  #   target_file = "./public/downloads/#{path}/#{filename}"
  #   
  #   unless File.symlink("../../../private/#{filename}", target_file) == 0
  #     render :text => "Sorry, system is busy now. Please try again several seconds later."
  #     return false
  #   end
  #   
  #   # # Log this file name in database.
  #   File.open('log/download.log', 'a') { |file| file.puts "downloads/#{path}/#{filename}" }
  #     
  #   redirect_to "/downloads/#{path}/#{filename}"
  #     
  #   rescue => e
  #     # raise e
  #     # render :text => 'The file is expired!'
  #     redirect_to "/404.html"
  #     # return
  #   end
  # end

  # def confirm
  #   # Mime::Type.register 'application/pdf', :pdf  
  #   
  #   if @request.method == :post
  #     @sdk = SdkSurvey.new(params[:sdk_survey])
  #     if @sdk.save     
  #     # Send Mail...
  #      OrdersMailer.deliver_sdk("4.pdf")
  #     else 
  #       redirect_to :action => 'index' 
  #     end
  #   end
  # end
  # 

  # private
  #  def generate_pdf(obj)
  #    content = "Name: #{obj.last_name} \n Email: #{obj.email} \n "
  #    pdf = PDF::Writer.new
  #    pdf.select_font "Times-Roman"
  #    pdf.text content, :font_size => 14, :justification => :left
  #    pdf.save_as("#{RAILS_ROOT}/tmp/#{obj.id}.pdf")
  #  end
  #  
end

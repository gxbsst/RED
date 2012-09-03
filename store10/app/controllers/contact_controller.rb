# Create contact ticket and submit to RT server located at: https://rt.red.com
# Warning:
# Since Rails recommented that we should process such request in RESTful form,
# we will merge this controller with <code>Contact::TicketsController</code>.
# Now all models has been moved under namespace <code>Contact</code>
class ContactController < ApplicationController
  layout 'application'
  
  def tickets
    if request.get?
      show
    elsif request.post?
      create
    end
  end
  
  private
  
  # TODO:
  # Should we display the corrent ticket if an existing UUID is given?
  def show
    # @ticket = Contact::Ticket.find_by_uuid(params[:id])
    raise UnknowsAction
  end
  
  def create
    @ticket = Contact::Ticket.new(params[:contact])
    @ticket.user_agent = request.env['HTTP_USER_AGENT']
    
    @ticket.save && @ticket.submit
    render :action => 'create'
  end
end

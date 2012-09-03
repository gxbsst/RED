# :event_id,           :integer
# :name,               :string
# :email,              :string
# :province,           :string
# :city,               :string
# :company_name,       :string
# :company_website,     :string
# :created_at,         :datetime
# :address,            :string
# :mobile_phone,       :string
# :fixed_phone,        :string
# :reason,             :text
# :participanter_name, :text
# :available_time,     :text
# :camera_type_using,  :string
# :scope_of_business,  :string
# :serial_number,      :string
# :deleted,            :boolean, :null => false, :default => false

class Participant < ActiveRecord::Base
  belongs_to :event, :class_name => "Event", :foreign_key => "event_id"
  validates_presence_of :name,:email,:province,:city,:mobile_phone,:scope_of_business,:event_id
  
  # Searches for participants
  # Uses product name, city, or eamil
  def self.search(search_term, count=false, limit_sql=nil)
    if (count == true) then
      sql = "SELECT COUNT(*) "
    else
      sql = "SELECT DISTINCT * "
    end
    sql << "FROM participants "
    sql << "WHERE name LIKE ? "
    sql << "OR email LIKE ? "
    sql << "OR city LIKE ? "
    sql << "ORDER BY id DESC "
    sql << "LIMIT #{limit_sql}" if limit_sql
    arg_arr = [sql, "%#{search_term}%", "%#{search_term}%", "%#{search_term}%"]
    if (count == true) then
      count_by_sql(arg_arr)
    else
      find_by_sql(arg_arr)
    end
  end 

end
class News < ActiveRecord::Base
   acts_as_textiled :content
   acts_as_textiled :description

   validates_presence_of :title

    def random_id
      self.new_record? ? @random_id || self.class.generate_random_id : attributes['random_id']
    end
    
    private
    def self.generate_random_id
      Time.now.to_i.to_s
    end
end

class Report < ApplicationRecord
 has_many :conservation_records, dependent: :destroy
 
 validates :start_date, :end_date, presence: true 

end

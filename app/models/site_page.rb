class SitePage < ActiveRecord::Base
  belongs_to :page
  belongs_to :site

  # validates :page_id, :site_id, presence: true, numericality: { :only_integer => true }
end

class SiteProduct < ActiveRecord::Base
  belongs_to :site
  belongs_to :product
end

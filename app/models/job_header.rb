class JobHeader < ActiveRecord::Base
  attr_accessible :date_due, :inside_edge, :job, :outside_edge, :panel_profile, :wood_type, :drawer_type, :bottom_type, :bottom_notes, :totals
end

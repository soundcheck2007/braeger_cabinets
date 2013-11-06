class JobDetail < ActiveRecord::Base
  attr_accessible :door_no, :door_qty, :door_size, :door_style, :job_id, :notes, :panel_info, :style_rail_info
end

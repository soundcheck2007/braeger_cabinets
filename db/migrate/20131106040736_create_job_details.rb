class CreateJobDetails < ActiveRecord::Migration
  def change
    create_table :job_details do |t|
      t.integer :job_id
      t.integer :door_no
      t.integer :door_qty
      t.string :door_size
      t.string :door_style
      t.string :style_rail_info
      t.string :panel_info
      t.string :notes

      t.timestamps
    end
  end
end

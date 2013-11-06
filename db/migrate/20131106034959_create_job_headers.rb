class CreateJobHeaders < ActiveRecord::Migration
  def change
    create_table :job_headers do |t|
      t.string :job
      t.string :wood_type
      t.string :inside_edge
      t.string :outside_edge
      t.string :panel_profile
      t.date :date_due
      t.string :drawer_type
      t.string :bottom_type
      t.string :bottom_notes

      t.timestamps
    end
  end
end

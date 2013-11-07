class AddTotalsToJobHeader < ActiveRecord::Migration
  def change
    add_column :job_headers, :totals, :string
  end
end

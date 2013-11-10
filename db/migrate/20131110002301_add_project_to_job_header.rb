class AddProjectToJobHeader < ActiveRecord::Migration
  def change
    add_column :job_headers, :project, :string
  end
end

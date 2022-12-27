class RemoveBodyFromTask < ActiveRecord::Migration[7.0]
  def change
    remove_column :tasks, :body, :string
  end
end

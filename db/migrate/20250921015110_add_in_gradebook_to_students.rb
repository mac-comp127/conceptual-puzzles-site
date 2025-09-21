class AddInGradebookToStudents < ActiveRecord::Migration[7.2]
  def change
    add_column :students, :in_gradebook, :boolean, default: true, null: false
  end
end

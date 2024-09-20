class AddNameToStudents < ActiveRecord::Migration[7.2]
  def change
    add_column :students, :name, :string
  end
end

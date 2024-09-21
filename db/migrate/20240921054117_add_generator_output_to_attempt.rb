class AddGeneratorOutputToAttempt < ActiveRecord::Migration[7.2]
  def change
    rename_column :attempts, :content, :problem_html
    add_column :attempts, :solution_html, :text
    add_column :attempts, :generator_log, :text
  end
end

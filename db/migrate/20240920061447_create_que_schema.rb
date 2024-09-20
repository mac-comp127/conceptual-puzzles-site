class CreateQueSchema < ActiveRecord::Migration[7.2]
  def up
    Que.migrate!(version: 7)
  end

  def down
    # Migrate to version 0 to remove Que entirely.
    Que.migrate!(version: 0)
  end
end

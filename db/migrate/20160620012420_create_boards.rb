class CreateBoards < ActiveRecord::Migration
  def change
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
    
    create_table :boards, id: false do |t|
      t.uuid "id", primary_key: true
      t.text "p1"
      t.text "p2"
      t.text "status"
    end

    add_index :boards, :status
  end
end

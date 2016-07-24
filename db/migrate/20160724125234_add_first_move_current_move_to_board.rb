class AddFirstMoveCurrentMoveToBoard < ActiveRecord::Migration
  def change
  	add_column :boards, :first_move, :text
  	add_column :boards, :current_move, :text
  end
end

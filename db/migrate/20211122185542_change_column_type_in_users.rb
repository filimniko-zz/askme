class ChangeColumnTypeInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :avatar_url, :string
  end
end

class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, index: true, null: false
      t.string :email, index: true, null: false, unique: true

      t.timestamps null: false
    end
  end
end

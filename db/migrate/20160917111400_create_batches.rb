class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.string :file, null: false
      t.string :batch_type, null: false
      t.string :status, null: false, default: 'created'
      t.integer :success_ids, array: true, default: []
      t.text :general_failures, array: true, default: []
      t.json :batch_failures, default: []

      t.timestamps null: false
    end
  end
end

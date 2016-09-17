class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.string :file, null: false
      t.string :batch_type, null: false
      t.string :status, null: false, default: 'created'
      t.json :results, default: []

      t.timestamps null: false
    end
  end
end

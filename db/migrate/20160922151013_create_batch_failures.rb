class CreateBatchFailures < ActiveRecord::Migration
  def change
    create_table :batch_failures do |t|
      t.references :batch, index: true, foreign_key: true, null: false
      t.integer :klass_id
      t.json :csv_data, default: {}
      t.text :klass_errors, array: true, default: []
      t.string :result

      t.timestamps null: false
    end
  end
end

class RemoveBatchFailuresColumnFromBatches < ActiveRecord::Migration
  def change
    remove_column :batches, :batch_failures
  end
end

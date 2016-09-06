class ChangeNameOfColumn < ActiveRecord::Migration[5.0]
  def self.up
    rename_column :competitions, :dataEnd, :dateEnd
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end

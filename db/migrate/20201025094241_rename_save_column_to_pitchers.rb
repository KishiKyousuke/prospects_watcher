class RenameSaveColumnToPitchers < ActiveRecord::Migration[6.0]
  def change
    rename_column :pitchers, :save, :number_of_save
  end
end

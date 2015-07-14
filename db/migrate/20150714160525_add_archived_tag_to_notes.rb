class AddArchivedTagToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :archived, :boolean, default: false
  end
end

class UpdateVenuesAddPageContent < ActiveRecord::Migration
  def self.up
    add_column :venues, :page_content, :text
    add_column :venues, :page_title, :string
  end

  def self.down
    remove_column :venues, :page_content
    remove_column :venues, :page_title
  end
end

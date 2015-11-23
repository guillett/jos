class RenameArticlesSections < ActiveRecord::Migration
  def self.up
    rename_table :articles_sections, :section_article_links
  end

  def self.down
    rename_table :section_article_links, :articles_sections
  end
end

class AddDetailsToSectionArticleLinks < ActiveRecord::Migration
  def change
    add_column :section_article_links, :start_date, :datetime
    add_column :section_article_links, :end_date, :datetime
    add_column :section_article_links, :state, :string
    add_column :section_article_links, :order, :integer
  end
end

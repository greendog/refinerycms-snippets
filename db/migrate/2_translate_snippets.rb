class TranslateSnippets < ActiveRecord::Migration

  def up
    ::Refinery::Snippets::Snippet.reset_column_information
    unless ::Refinery::Snippets::Snippet::Translation.table_exists?
      ::Refinery::Snippets::Snippet.create_translation_table!({
                                                                  :body => :text
                                                              }, {
                                                                  :migrate_data => true
                                                              })
    end
  end

  def down
    ::Refinery::Snippets::Snippet.reset_column_information

    ::Refinery::Snippets::Snippet.drop_translation_table!
  end

end
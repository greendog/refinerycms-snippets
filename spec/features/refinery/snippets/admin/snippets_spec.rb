# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Snippets" do
    describe "Admin" do
      describe "snippets" do
        refinery_login_with :refinery_user

        describe "snippets list" do
          before do
            FactoryGirl.create(:snippet, :title => "UniqueTitleOne")
            FactoryGirl.create(:snippet, :title => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.snippets_admin_snippets_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.snippets_admin_snippets_path

            click_link "Add New Snippet"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Title", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Snippets::Snippet.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Title can't be blank")
              Refinery::Snippets::Snippet.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:snippet, :title => "UniqueTitle") }

            it "should fail" do
              visit refinery.snippets_admin_snippets_path

              click_link "Add New Snippet"

              fill_in "Title", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Snippets::Snippet.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:snippet, :title => "A title") }

          it "should succeed" do
            visit refinery.snippets_admin_snippets_path

            within ".actions" do
              click_link "Edit this snippet"
            end

            fill_in "Title", :with => "A different title"
            click_button "Save"

            page.should have_content("'A different title' was successfully updated.")
            page.should have_no_content("A title")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:snippet, :title => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.snippets_admin_snippets_path

            click_link "Remove this snippet forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Snippets::Snippet.count.should == 0
          end
        end

      end
    end
  end
end

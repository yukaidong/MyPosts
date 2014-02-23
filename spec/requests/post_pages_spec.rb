require 'spec_helper'

describe "Post pages" do
	subject{ page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }
	
	describe "post creation" do
		before { visit new_post_path}

		describe "with invalid information" do
			it "should not create a post" do
				expect { click_button "Post" }.not_to change(Post, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before do
				fill_in 'Title', with: "test"
				fill_in 'Content', with: "Hello World!"
			end
			it "should create a post" do
				expect { click_button "Post" }.to change(Post, :count).by(1)
			end

		end
	end

	describe "post index" do
		before do
      30.times{FactoryGirl.create(:post, user: user)}
			visit posts_path
		end
		after(:all){Post.delete_all}

    it "should list each post title" do
      Post.paginate(page: 1).each do |post|
        expect(page).to have_selector('li',text: post.title)
      end
    end
	end

	describe "post destruction" do
		before { FactoryGirl.create(:post, user: user) }

		describe "as correct user" do
			before { visit posts_path }

			it "should delete a post" do
				expect { click_link "delete" }.to change(Post, :count).by(-1)
			end
		end
	end

end

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
			let(:tag){"tag1,tag2"}
			before do
				fill_in 'Title', with: "test"
				fill_in 'Content', with: "Hello World!"
				fill_in 'Tags', with: tag
			end

			it "should create a post" do
				expect { click_button "Post" }.to change(Post, :count).by(1)
			end

			describe "should add tags to the post" do
				before{ click_button "Post" }

				it{should have_content('tag1')}
				it{should have_content('tag2')}
			end

		end
	end

	describe "index" do
		before do
      30.times{FactoryGirl.create(:post, user: user,tag_list:"tag1,tag2" )}
			visit posts_path
		end
		after(:all){Post.delete_all}

    it "should list each post title" do
      Post.paginate(page: 1).each do |post|
        expect(page).to have_selector('li',text: post.title)
        expect(page).to have_link(post.title, href: post_path(post))
      end
    end

	end

	describe "show" do
		let(:post){FactoryGirl.create(:post,user: user,tag_list:"tag1,tag2") }

		before { visit post_path(post) }

		it {should have_title(post.title)}
		it {should have_content(post.title) }
		
	  it "should list each tag" do
	    post.tag_list.each do |tag|
	      expect(page).to have_link(tag, href:user_tag_path(user,tag))
	    end
	  end
	end

	describe "destruction" do
		before { FactoryGirl.create(:post, user: user) }

		describe "as correct user" do
			before { visit posts_path }

			it "should delete a post" do
				expect { click_link "delete" }.to change(Post, :count).by(-1)
			end
		end
	end

end

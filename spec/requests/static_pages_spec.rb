require 'spec_helper'

describe "Static Pages"  do
	subject{page}

	describe "Home" do
		let(:user) { FactoryGirl.create(:user) }

		before do
      30.times{FactoryGirl.create(:post, user: user)}
      visit root_path
		end
		after(:all){Post.delete_all}

		describe "for non-signed-in user" do
    	it "should list each post title" do
    	  Post.paginate(page: 1).each do |post|
    	    expect(page).to have_selector('li',text: post.title)
    	  end
    	end

		end
	end
end
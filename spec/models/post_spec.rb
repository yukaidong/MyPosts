require 'spec_helper'

describe Post do
	let(:user){FactoryGirl.create(:user)}
	before {@post = user.posts.build(title: "Hello", content: "Hello World!")}

	subject{@post}
	it { should respond_to(:title) }
	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should eq user }

	it { should be_valid }

	describe "when user_id is not present" do
		before {@post.user_id = nil}
		it { should_not be_valid }
	end

	describe "with blank title" do
		before { @post.title = " " }
		it { should_not be_valid }
	end

	describe "with title that is too long" do
		before{ @post.title = "a"*100 }
		it { should_not be_valid}
	end

	describe "with blank content" do
		before { @post.content = " " }
		it { should_not be_valid }
	end

end

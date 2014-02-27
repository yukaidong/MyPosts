require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) {FactoryGirl.create(:user)}
    before do
      sign_in user
      visit users_path
    end

    it {should have_title('All users')}
    it {should have_content('All users')}

    describe "pagination" do
      before(:all){30.times{FactoryGirl.create(:user)}}
      after(:all){User.delete_all}

      it{should have_selector('div.pagination')}

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li',text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete')}

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin)}
        before do
          sign_in admin
          visit users_path
        end

        it {should have_link('delete', href: user_path(User.first))}
        it "should be able to delete another user" do
          expect do
            click_link('delete',match: :first)
          end.to change(User, :count).by(-1)
        end
        it {should_not have_link('delete', href: user_path(admin))}
      end
    end

  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "profile page" do
	  let(:user) { FactoryGirl.create(:user) }
    let(:tag){"tag1"}

    before do
      30.times{FactoryGirl.create(:post, user: user,tag_list:"#{tag},tag2" )}
      visit user_path(user)
    end

  	it { should have_content(user.name) }
  	it { should have_title(user.name) }

    describe "posts" do
      it "should list all of the user's posts" do
        user.posts.paginate(page: 1).each do |post|
          expect(page).to have_link(post.title, post_path(post))
        end
      end

      describe "on a tag" do
        let(:unrealated_tag){"tag2"}
        let(:unrelated_post){FactoryGirl.create(:post,user: user,title: "Unrealated",tag_list: unrealated_tag)}        
        before{visit user_tag_path(user,tag)}

        it { should have_content(tag)}

        it "should list each post title on that tag" do
          Post.tagged_with(tag,:on => :tags, :owned_by => user).paginate(page:1).each do |post|
            expect(page).to have_link(post.title, post_path(post))
          end
        end

        it "should not list post title without that tag" do          
          expect(page).not_to have_content(unrelated_post.title)
        end

    end

    end

  end

  describe "sign up" do
    before { visit signup_path }
    let(:submit){"Create my account"}

    describe "with invalid information" do
      it "should not create a user" do
        expect {click_button submit}.not_to change(User, :count)
      end
      
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect {click_button submit}.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before {click_button submit}
        let(:user){User.find_by(email: "user@example.com") }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

    end
  end

  describe "edit" do
    let(:user){FactoryGirl.create(:user)}
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it {should have_content('Update your profile') }
      it {should have_title('Edit user') }
      it {should have_link('change', href: 'http://gravatar.com/emails')}
    end

    describe "with invalid information" do
      before {click_button "Save changes"}

      it { should have_content('error')}
    end

    describe "with valid information" do
      let(:new_name){"New name"}
      let(:new_email){"new@example.com"}
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end
      it {should have_title(new_name)}
      it {should have_success_message}
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name}
      specify { expect(user.reload.email).to eq new_email }
    end
  end

end
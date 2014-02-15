require 'spec_helper'

describe "AuthenticationPages" do
	subject {page}

	describe "signin page" do
		before {visit signin_path}

		it {should have_content('Sign in')}
		it {should have_title('Sign in')}
	end

	describe "sign in" do
		before {visit signin_path}
		describe "with invalid information" do
			before {click_button "Sign in"}

			it {should have_title('Sign in')}
			it {should have_error_message('Invalid')}

			describe "after clicking another page" do
				before {click_link "Help"}
				it {should_not have_error_message}
			end
		end

		describe "with valid information" do
			let(:user){ FactoryGirl.create(:user)}
			before {valid_signin(user)}

			it {should have_title(user.name)}
			it {should have_link('Profile', href: user_path(user))}
			it {should have_link('Sign out', href: signout_path)}
			it {should_not have_link('Sgin in', href: signin_path)}

		    describe "followed by sign out" do
        		before {click_link "Sign out"}
        		it {should have_link('Sign in')}
      		end
		end
	end

end

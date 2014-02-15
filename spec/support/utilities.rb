include ApplicationHelper

def full_title(page_title)
  base_title = "My Posts"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
  	expect(page).to have_selector('div.alert.alert-danger', text: message)
  end
end
require "rails_helper"

feature 'User creates account' do
  scenario 'Happy path' do
    visit new_user_path
    fill_in 'Email', with: 'elvis@graceland.org'
    fill_in 'Password', with: 'pr1sc1lla'
    fill_in 'Password one more time', with: 'pr1sc1lla'
    click_on 'Sign me up!'
    expect(page).to have_content 'Welcome aboard! Your account has been created.'
  end

  scenario 'Left email blank' do
    visit new_user_path
    fill_in 'Password', with: 'pr1sc1lla'
    fill_in 'Password one more time', with: 'pr1sc1lla'
    click_on 'Sign me up!'
    expect(page).to have_content "Email can't be blank"
  end

  scenario "Passwords don't match" do
    visit new_user_path
    fill_in 'Email', with: 'elvis@graceland.org'
    fill_in 'Password', with: 'pr1sc1lla'
    fill_in 'Password one more time', with: 'l1sa-mar13'
    click_on 'Sign me up!'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario "Email already exists" do
    user = FactoryGirl.create(:user, email: 'elvis@graceland.org')

    visit new_user_path
    fill_in 'Email', with: 'elvis@graceland.org'
    fill_in 'Password', with: 'pr1sc1lla'
    fill_in 'Password one more time', with: 'pr1sc1lla'
    click_on 'Sign me up!'
    expect(page).to have_content "Email has already been taken"
  end
end

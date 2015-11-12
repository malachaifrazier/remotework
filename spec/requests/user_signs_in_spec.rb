require "rails_helper"

feature 'User signs in' do
  given(:user) { FactoryGirl.create(:user) }

  scenario 'Happy path' do
    visit new_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Come on in!'
    expect(page).to have_content "Welcome back! You are now signed in."
    expect(page).to have_content "Your account"
  end

  scenario 'Bad email' do
    visit new_session_path
    fill_in 'Email', with: 'l1sa-mar13@graceland.org'
    fill_in 'Password', with: user.password
    click_on 'Come on in!'
    expect(page).to have_content "Bad email/password combination."
  end

  scenario 'Bad password' do
    visit new_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'peanut-butter-banana'
    click_on 'Come on in!'
    expect(page).to have_content "Bad email/password combination."
  end

  scenario 'Blank fields' do
    visit new_session_path
    click_on 'Come on in!'
    expect(page).to have_content "Bad email/password combination."
  end

  scenario 'Log back out' do
    visit new_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Come on in!'

    # How to do a delete in Capybara. 
    # http://stackoverflow.com/questions/9228831/how-to-make-capybara-do-a-delete-request-in-a-cucumber-feature
    page.driver.submit :delete, session_path, {}

    expect(page).to have_content "You have been signed out."
    expect(page).to have_content "Sign in"
  end
end

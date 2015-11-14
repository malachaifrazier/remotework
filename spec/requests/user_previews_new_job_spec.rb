require "rails_helper"

feature 'User previews new job posting' do
  given(:job_title)           { 'Car Wash' }
  given(:job_description)     { "Well, I quit my job down at the car wash / Left my mama a goodbye note / By sundown I'd left Kingston, With my guitar under my coat" }
  given(:how_to_apply)        { 'Email elvis@carwash.com' }
  given(:company_name)        { 'Heartbreak Hotel' }
  given(:company_location)    { 'Lonely Street' }
  given(:company_website)     { 'http://www.example.com' }
  given(:company_description) { "You should've heard them knocked out jailbirds sing/Let's rock, everybody, let's rock/Everybody in the whole cell block/Was dancin' to the Jailhouse Rock" }

  context 'No account' do
    scenario 'User has no account' do
      visit new_job_path
      fill_in_job_fields
      choose 'Create a new account'
      within(:css, '.spec-new') do
        fill_in 'Email address', with: 'elvis@graceland.org'
        fill_in 'Password', with: 'peanutbutterbanana'
        fill_in 'Confirm Password', with: 'peanutbutterbanana'
      end
      click_button 'Preview your post'
      assert_content(page)
    end
  end

  context 'Existing account' do
    given(:user) { FactoryGirl.create(:user) }

    scenario 'User has an account and signs in on the job post page' do
      visit new_job_path
      fill_in_job_fields
      choose 'Sign in to an existing account'
      within(:css, '.spec-existing') do
        fill_in 'Email address', with: user.email
        fill_in 'Password', with: user.password
      end
      click_button 'Preview your post'
      assert_content(page)
    end
    
    scenario 'User has an account and is already signed into the app' do
      visit new_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Come on in!'
      visit new_job_path
      expect(page).to have_content("You are signed in as #{user.email}")
      fill_in_job_fields
      click_button 'Preview your post'
      assert_content(page)
    end
  end

  def fill_in_job_fields
    fill_in 'Job Title', with: job_title
    fill_in 'Job Description', with: job_description
    fill_in 'Instructions for how to apply', with: how_to_apply
    fill_in 'Company Name', with: company_name
    fill_in 'Company Location', with: company_location
    fill_in 'Company Website', with: company_website
    fill_in 'Tell us about your company and why it rocks', with: company_description
  end

  def assert_content(page)
    expect(page).to have_content "Preview"      
    expect(page).to have_content(job_title)
    expect(page).to have_content(job_description)
    expect(page).to have_content(how_to_apply)
    expect(page).to have_content(company_name)
    # expect(page).to have_content(company_location)
    expect(page).to have_content(company_description)    
  end
end

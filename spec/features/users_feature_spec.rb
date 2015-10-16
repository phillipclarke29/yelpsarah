require 'rails_helper'

feature "User can sign in and out" do
  context "user not signed in and on the homepage" do
    it "should see a 'sign in' link and a 'sign up' link" do
      visit('/')
      expect(page).to have_link('Sign in')
      expect(page).to have_link('Sign up')
    end

    it "should not see 'sign out' link" do
      visit('/')
      expect(page).not_to have_link('Sign out')
    end

    it "must be logged in to create restaurant" do
      visit('/')
      click_link('Add a restaurant')
      expect(page).not_to have_button('Create Restaurant')
    end
  end

  context "user signed in on the homepage" do
    before do
      visit('/')
      click_link('Sign up')
      fill_in('Email', with: 'test@example.com')
      fill_in('Password', with: 'testtest')
      fill_in('Password confirmation', with: 'testtest')
    end

    it "should see 'sign out' link" do
      expect { click_button('Sign up') }.to change(User, :count).by(1)
      expect(page).to have_link('Sign out')
    end

    it "should not see a 'sign in' link and a 'sign up' link" do
      click_button('Sign up')
      visit('/')
      expect(page).not_to have_link('Sign in')
      expect(page).not_to have_link('Sign up')
    end
  end
end

feature "Once logged in on the website" do
  before do
    first_user = build :first_user
    sign_up(first_user)
  end

  it "can only edit restaurants which they've created" do
    click_link('Add a restaurant')
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
    click_link('Sign out')
    second_user = build :second_user
    sign_up(second_user)
    expect(page).not_to have_content('Edit KFC')
  end

  it "can only delete restaurants which they've created" do
    click_link('Add a restaurant')
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
    click_link('Sign out')
    second_user = build :second_user
    sign_up(second_user)
    expect(page).not_to have_content('Delete KFC')
  end

  it "can only add a single review to a website" do
    click_link('Add a restaurant')
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
    click_link "Review KFC"
    fill_in 'Thoughts', with: 'Great'
    click_button 'Leave Review'
    expect(page).not_to have_content("Review KFC")

  end

end

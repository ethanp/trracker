require 'rails_helper'

describe "Navbar", type: :feature do
  describe 'logged in' do
    let(:u) { create(:user) }
    before :each do
      login_as(u, scope: :user)
      visit '/'
    end
    after(:each) { logout :user }
    it { expect(page).to have_title('Trracker') }
    it { expect(page).to have_link('Logout', href: "/users/sign_out") }
    it { expect(page).to have_link('Categories', href: "/categories/1") }
    it { expect(page).to have_link('Tasks', href: "/tasks") }
    it { expect(page).to have_link('About', href: "/static/about") }
    it { expect(page).to have_link('Edit profile', href: "/users/edit") }
  end
  describe 'not logged in' do
    before(:each) { visit '/' }
    it { expect(page).to have_link('Login', href: "/users/sign_in") }
    it { expect(page).to have_link('Sign up', href: "/users/sign_up") }
    it { expect(page).to have_title('Trracker') }
    it { expect(page).to have_link('About', href: "/static/about") }
  end
end

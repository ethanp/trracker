require 'rails_helper'

feature "Navbar" do
  describe 'logged in' do
    let(:u) { create(:user) }
    before do
      login_as(u, scope: :user)
      visit '/'
    end
    after { logout :user }
    it { expect(page).to have_title('Trracker') }
    it { expect(page).to have_link('Logout', href: destroy_user_session_path) }
    it { expect(page).to have_link('Categories', href: categories_path) }
    it { expect(page).to have_link('Tasks', href: list_tasks_path) }
    it { expect(page).to have_link('About', href: about_path) }
    it { expect(page).to have_link('Edit profile', href: edit_user_registration_path) }
    it { expect(page).to have_link('Home', href: home_path) }
    it { expect(page).to have_text(u.full_name) }
  end
  describe 'not logged in' do
    before { visit '/' }
    it { expect(page).to have_link('Login', href: new_user_session_path) }
    it { expect(page).to have_link('Sign up', href: new_user_registration_path) }
    it { expect(page).to have_title('Trracker') }
    it { expect(page).to have_link('About', href: about_path) }
  end
end

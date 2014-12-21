require 'rails_helper'

feature "Categories Index" do
  describe 'Buttons' do
    # let() is lazily-evaluated
    let(:u) { create :user }
    before do
      create :category
      login_as(u, scope: :user)
      visit categories_path
    end
    after { logout :user }
    it 'should have a link that loads the new category form' do
      click_link 'New Category'
      expect(page).to have_button('Create Category')
    end
    it 'clicking category should go to its page' do
      click_link 'Categ'
      expect(page).to have_selector('h1', text: 'Categ')
    end
    it 'clicking delete button should remove that category from the user' do
      c = u.categories.count
      click_link 'Delete'
      expect(u.categories.count).to eq(c-1)
    end
    it 'edit button loads edit form' do
      click_link 'Edit'
      expect(page).to have_text('Edit category')
    end
  end
end

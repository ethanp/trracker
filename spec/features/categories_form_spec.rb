require 'rails_helper'

feature 'Category start and end dates' do
  scenario 'filled in from nil by form' do
    login_as create(:user)
    c = create :category, start_date: nil, end_date: nil
    visit category_path(c)
    expect(page).to have_text 'No start or end dates set'
    click_link 'Edit Category'
    fill_in 'category_start_date', with: '12/20/2014 6:19 PM'
    fill_in 'category_end_date', with: '12/24/2014 6:19 PM'
    click_button 'Update Category'

    expect(page).to have_text 'Starts: Sat, December 20, 2014'
    expect(page).to have_text 'Ends: Wed, December 24, 2014'
  end
end

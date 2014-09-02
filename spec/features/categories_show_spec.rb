require 'rails_helper'

feature "Categories Show" do
  describe 'Buttons' do
    let(:u) { create :user }
    let(:c) { create :category }
    create
    before do
      let (:ta) { create :task }
      let (:tb) { create :task, name: 'Tasket' }
      login_as(u, scope: :user)
      visit category_path(c)
    end
    after { logout :user }
  end
end

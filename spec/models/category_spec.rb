require 'rails_helper'

describe Category do
  context 'validates correctly' do
    it 'is valid with a name and user_id' do
      c = build(:category)
      expect(c).to be_valid
    end

    it 'is invalid without a name' do
      c = build(:category, name: nil)
      expect(c).to_not be_valid
    end

    it 'is invalid without a user_id' do
      # "!" means raise an error if it is not successful,
      # without an exclamation it will just return "false"
      c = build(:category, user_id: nil)
      expect(c).to_not be_valid
    end

    it 'is invalid when the user already has a category with the same name' do
      create(:category)
      c = build(:category)
      expect(c).to_not be_valid
    end

    it 'is valid when another user already has a category with the same name' do
      create(:category)
      c = build(:category, user_id: 2)
      expect(c).to be_valid
    end

    it 'is invalid when name is longer than 30 characters' do
      c = build(:category, name: '01234567891123456789212345678931')
      expect(c).to_not be_valid
    end
  end

  context 'inter-operates with Tasks correctly' do
    it 'lists tasks by descending order of duedate'
    it 'deletes associated tasks on delete'
  end
end

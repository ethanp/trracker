require 'rails_helper'

describe Task do
  context 'validates correctly' do
    it 'is valid with just a name, category_id and priority' do
      t = build(:task)
      expect(t).to be_valid
    end
    it 'is invalid without a name' do
      t = build(:task, name: nil)
      expect(t).to_not be_valid
    end
    it 'is invalid without a category_id' do
      t = build(:task, category_id: nil)
      expect(t).to_not be_valid
    end
    it 'is invalid without a priority' do
      t = build(:task, priority: nil)
      expect(t).to_not be_valid
    end
    it 'is invalid if a task exists with the same name in the same category' do
      create(:task)
      t = build(:task, priority: 3)
      expect(t).to_not be_valid
    end
    it 'is valid if a task exists with the same name in a different category' do
      create(:task)
      t = build(:task, category_id: 2, priority: 3)
      expect(t).to be_valid
    end
    it 'is invalid if the name is longer than 30 characters' do
      t = build(:task, name: '1234567891123456789212345678931')
      expect(t).to_not be_valid
    end
  end
end

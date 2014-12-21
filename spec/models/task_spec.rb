require 'rails_helper'

describe Task do
  context 'validations' do
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
    it 'is invalid if the name is longer than 60 characters' do
      v = '1234567891123456789212345678931234567891123456789212345678931'
      t = build(:task, name: v)
      expect(t).to_not be_valid
    end
    it 'can take a complete field' do
      t = build(:task, complete: true)
      expect(t).to be_valid
    end
    it 'can take a duedate field' do
      t = build(:task, duedate: DateTime.now)
      expect(t).to be_valid
    end
  end

  context 'ActiveRecord scopes' do
    it 'returns only tasks due_within_two_weeks' do
      t1 = create(:task, name: 'A', duedate: DateTime.now + 1.days)
      t2 = create(:task, name: 'B', duedate: DateTime.now + 2.days)
      t3 = create(:task, name: 'C', duedate: DateTime.now + 17.days)
      # :match_array means the order is ignored
      expect(Task.due_within_two_weeks).to match_array([t1,t2])
    end
    it 'returns only tasks due_before(date)' do
      t1 = create(:task, name: 'A', duedate: DateTime.now + 1.days)
      t2 = create(:task, name: 'B', duedate: DateTime.now + 2.days)
      t3 = create(:task, name: 'C', duedate: DateTime.now + 7.days)
      expect(Task.due_before(DateTime.now + 6.days)).to match_array([t1,t2])
    end
    it 'returns only complete tasks' do
      t1 = create(:task, name: 'A', complete: true)
      t2 = create(:task, name: 'B', complete: true)
      t3 = create(:task, name: 'C', complete: false)
      expect(Task.complete).to match_array([t1,t2])
    end
    it 'returns only incomplete tasks' do
      t1 = create(:task, name: 'A', complete: true)
      t2 = create(:task, name: 'B', complete: true)
      t3 = create(:task, name: 'C', complete: false)
      expect(Task.incomplete).to match_array([t3])
    end
  end

  context 'Ruby class methods' do
    it 'returns seconds spent on its intervals'
    it 'returns an appropriate heatmap_hash_array'
    it 'returns an appropriate time_per_day hash'
  end
end

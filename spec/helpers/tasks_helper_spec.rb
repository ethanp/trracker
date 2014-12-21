require 'rails_helper'

describe TasksHelper do
  context 'index_css_class' do
    it 'returns "warning" if task is incomplete and due within 3 days' do
      t1 = create(:task, duedate: DateTime.now + 2.days)
      expect(index_css_class(t1)).to eq("warning")
    end
    it 'returns "info" if task is incomplete and due between 3 and 7 days' do
      t1 = create(:task, duedate: DateTime.now + 4.days)
      expect(index_css_class(t1)).to eq("info")
    end
    it 'returns "nil" if task is incomplete and due in more than 7 days' do
      t1 = create(:task, duedate: DateTime.now + 8.days)
      expect(index_css_class(t1)).to be_nil
    end
    it 'returns "nil" if task is has no duedate' do
      t1 = create(:task, duedate: nil)
      expect(index_css_class(t1)).to be_nil
    end
    it 'returns "success" if task is has no duedate' do
      t1 = create(:task, complete: true)
      expect(index_css_class(t1)).to eq("success")
    end
  end
end


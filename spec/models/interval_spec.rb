require 'rails_helper'

describe Interval do
  describe 'validations' do
    it 'is valid with a start, end, and task_id' do
      i = build(:interval)
      expect(i).to be_valid
    end
    it 'is invalid without a start' do
      i = build(:interval, start: nil)
      expect(i).to_not be_valid
    end
    it 'is invalid without an end' do
      i = build(:interval, end: nil)
      expect(i).to_not be_valid
    end
    it 'is invalid without a task_id' do
      i = build(:interval, task_id: nil)
      expect(i).to_not be_valid
    end
  end

  describe 'class methods' do
    it 'returns seconds_spent' do
      i = build(:interval)
      expect(i.seconds_spent).to eq(1 * 60 * 60)
    end
    it 'returns a heatmap_hash_array' do
      s = "Sat, 02 Aug 2014 19:30:00 -0500".to_datetime
      e = s + 1.hour
      i = build(:interval, start: s, end: e)
      expect(i.heatmap_base_data).to eq(
        [
          {
            day: 6,
            date: "08/02/14",
            hour: 19,
            value: 0.5
          }, {
            day: 6,
            date: "08/02/14",
            hour: 20,
            value: 0.5
          }
        ]
      )
    end
  end
end

require 'rails_helper'

describe Category do

  it 'is valid with a name and user_id' do
    category = Category.new(
      name: 'Categ',
      user_id: 1)
    expect(category).to be_valid
  end
  it 'is invalid without a name' do
  end

  it 'is invalid without a user_id' do

  end
  it 'is has a unique name within this user' do

  end
  it 'is at most 30 characters' do

  end
  it 'lists tasks by descending order of duedate' do # is this kosher?

  end
  it 'deletes associated tasks on delete' do         #  |-> these are task-related

  end
end

module ApplicationHelper
  def datepicker_format(field)
    field.nil? ? nil : field.strftime(Time::DATE_FORMATS[:datetimepicker])
  end
  def date_string(date)
    date.nil? ? "" : date.strftime(Date::DATE_FORMATS[:full_text])
  end

  def add_missing_dates(arr)
    # arr is an array of these: { :date, :name (category.name), :value }
    dates = arr.map { |x| x[:date] }
    f = DateTime.strptime(dates.first, "%m/%d/%y")
    l = DateTime.strptime(dates.last, "%m/%d/%y")
    all_dates = (0..(l-f).to_i).map { |i| (f+i).strftime("%m/%d/%y") }
    by_name = arr.group_by { |x| x[:name] }
    not_sure = all_dates.flat_map do |date|
      by_name.map do |name, objects|
        value_zero_hash = { date: date, name: name, value: 0 }
        objects.select{ |x| x[:date] == date }.give_default(value_zero_hash)
      end
    end
    not_sure.flatten.sort_by { |x| [x[:date], x[:name]] } # sort by date /then/ name
  end

  # [
  #   {
  #     :date ("mm/dd/yy")
  #     :categ_1_name (hours on this date, defaults to zero)
  #     ...     ...     ...
  #     :categ_n_name (hours on this date)
  #   }
  # ]
  #
  # > h = [{a: 1, b: 2}, {a: 1, c: 3}, {a: 2, b: 3}]
  # > h.group_by{|x|x[:a]}.values.map{|arr|
  #     arr.inject({}){|agg,hsh|agg.merge(hsh)}
  #   }
  #
  #     => [{:a=>1, :b=>2, :c=>3}, {:a=>2, :b=>3}]
  #
  def landing_page_data
    date_name_sum_hashes = Category.all.flat_map do |c|
      times_per_task = c.tasks.flat_map { |x| x.time_per_day }
      times_by_date = times_per_task.group_by { |x| x[:date] }.values
      times_by_date.map do |x|
        sum = x.inject(0.0) { |sum, hash| sum + hash[:value] }
        { date: x.first[:date], :"#{c.name}" => sum }
      end
    end
    categs_by_date = date_name_sum_hashes.group_by { |hsh| hsh[:date] }
    categ_names = Category.all.map { |c| c.name.to_sym }
    base_hash = categ_names.inject({}) { |agg,sym| agg.merge({sym => 0}) }
    final = categs_by_date.values.map do |arr|
      arr.inject(base_hash) { |agg,hsh| agg.merge(hsh) }
    end
    return final.to_json
  end

  #   We need one entry per Category.
  #   The "title" is for the title of the AmChart graph
  #   The "valueField" refers to the name of the key for the
  #       data for this graph from the JSON blob created above
  #   Since I'm using the Category.name for the JSON field,
  #       they should be the same
  # [
  #   {
  #     "title": "Category Name 1",
  #     "valueField": "Category Name 1",
  #     "fillAlphas": 0.4
  #   }, {
  #     "title": "Category Name 2",
  #     "valueField": "Category Name 2",
  #     "fillAlphas": 0.4
  #   },
  #
  def landing_page_graphs
    Category.all.map do |c|
      {
          title: c.name,
          valueField: c.name,
          fillAlphas: 0.4
      }
    end.to_json
  end
end

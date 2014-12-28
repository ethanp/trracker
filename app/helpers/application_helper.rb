module ApplicationHelper
  def datepicker_format(field)
    field.nil? ? nil : field.strftime(t_fmt :datetimepicker)
  end
  def date_string(date)
    date.nil? ? "" : date.strftime(d_fmt :full_text)
  end

  def add_missing_dates arr
    # @arr is an array of: { date: :mdy, categ1.name: sum, categ2.name: sum, ...}
    dates = arr.map { |x| x[:date] }
    f = DateTime.strptime(dates.first, d_fmt(:mdy))
    l = DateTime.strptime(dates.last, d_fmt(:mdy))
    all_date_strs = (0..(l-f).to_i).map { |i| (f+i).strftime(d_fmt :mdy) }
    by_date_str = arr.group_by { |x| x[:date] }
    all_date_strs.map do |date_str|
      if by_date_str.has_key? date_str
        by_date_str[date_str][0]
      else
        base_hash.merge date: date_str
      end
    end
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
    categs_by_date = Category.all.flat_map do |c|
      c.tasks
          .flat_map { |x| x.time_per_day }
          .group_by { |x| x[:date] }.values
          .map do |x|
            sum = x.inject(0.0) { |sum, hash| sum + hash[:value] }
            { date: x.first[:date], :"#{c.name}" => sum }
      end
    end
       .group_by { |hsh| hsh[:date] }
       .values.map { |arr| arr.inject(base_hash) { |agg,hsh| agg.merge(hsh) } }
       .sort_by { |hsh| hsh[:date] } # sorting turns "Kiki" into graph
    add_missing_dates(categs_by_date).to_json.html_safe
  end

  def base_hash
    Category.all.map { |c| c.name.to_sym }.inject({}) do |agg,sym|
      agg.merge({sym => 0})
    end
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
    end.to_json.html_safe
  end
end

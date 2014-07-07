json.array!(@intervals) do |interval|
  json.extract! interval, :id, :start, :end, :task_id
  json.url interval_url(interval, format: :json)
end

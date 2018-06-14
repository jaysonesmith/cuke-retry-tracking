When('this fails') do
  p "url in failing step: #{TRACING.url}"
  raise
end

When('this passes') do
  p "url in passing step: #{TRACING.url}"
end

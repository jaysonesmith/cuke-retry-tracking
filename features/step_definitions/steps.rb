When('this fails') do
  p "url in failing step: #{TRACING.url}"
  raise
end

When('this passes') do
  p "url in passing step: #{TRACING.url}"
end

When('example {word} {word}') do |title, behavior|
  p "example #{title} - url in outline step: #{TRACING.url}"
  raise if behavior == 'fails'
end

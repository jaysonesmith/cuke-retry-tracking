Given('a url') do
  @url = 'http://foo.com/'
  @url += "trace_token=#{TRACING_TOKEN}" if TRACING
end

When('this fails') do
  puts "url in failing step: #{@url}"
  raise
end

When('this passes') do
  puts "url in passing step: #{@url}"
end

require 'cucumber'

require_relative 'tracing'

TRACING = Tracing.new

Before do |scenario|
  TRACING.url = TRACING.past_scenario == scenario.name ? 'https://foo.com?tracing_param=bar' : 'https://foo.com'
end

After do |scenario|
  TRACING.past_scenario = scenario.name if scenario.failed?
end

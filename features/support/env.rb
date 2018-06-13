require 'cucumber'

TRACING_TOKEN = 'abc'

Before do |scenario|
  TRACING = PAST_SCENARIO == scenario.name
end

After do |scenario|
  PAST_SCENARIO = scenario.name if scenario.failed?
  Object.send(:remove_const, :PAST_SCENARIO) unless scenario.failed?
  Object.send(:remove_const, :TRACING)
end

# Tracing manages tracing behavior and tracking scenarios.
class Tracing
  attr_accessor :past_scenario, :url

  def initialize
    @past_scenario = ''
    @url = ''
  end
end

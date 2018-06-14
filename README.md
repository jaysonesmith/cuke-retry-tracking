# cuke-behavior-on-retry

## What?

A simple way of tracking what scenarios are being retried using Cucumber's built in `--retry` flag
so that conditional behavior can be performed as needed.

## Why?

I needed to solve this for a work related use case.

## How?

Create a class for tracking and some logic in our `Before` and `After` methods so that we can keep
track of things and behave appropriately. If something isn't being retried, logic effectively resets
what we've changed. The behavior I've got in my actual implementation is slightly different and
includes more as we have different needs, but this illustrates the gist of things.

***!!! Note - This example works due to the current behavior of Cucumber's `retry` flag to
immediately retrying the same scenario after it has failed. (Including Scenario Outlines) !!!***

```ruby
TRACING = Tracing.new

Before do |scenario|
  # if the curent scenario is named the same as the past_scenario, we're retrying so change
  # things accordingly. If not, effectively return things to default.
  TRACING.url = TRACING.past_scenario == scenario.name ? 'https://foo.com?tracing_param=bar' : 'https://foo.com'
end

After do |scenario|
  # update past_scenario name if the most recently ended scenario has failed
  TRACING.past_scenario = scenario.name if scenario.failed?
end
```

## Example

### `bundle exec cucumber --retry 2`

#### Output
```gherkin
Feature: Mixed feature

"url in failing step: https://foo.com"
  Scenario: Failing in mixed feature # features/mixed.feature:3
    When this fails                  # features/step_definitions/steps.rb:1
       (RuntimeError)
      ./features/step_definitions/steps.rb:3:in `"this fails"'
      features/mixed.feature:4:in `When this fails'

"url in failing step: https://foo.com?tracing_param=bar"
  Scenario: Failing in mixed feature # features/mixed.feature:3

"url in failing step: https://foo.com?tracing_param=bar"
  Scenario: Failing in mixed feature # features/mixed.feature:3

"url in passing step: https://foo.com"
  Scenario: Passing in mixed feature # features/mixed.feature:6
    When this passes                 # features/step_definitions/steps.rb:6

"example a - url in outline step: https://foo.com"
  Scenario Outline: Mixed scenario outline # features/mixed.feature:9
    When example <title> <behavior>        # features/mixed.feature:10

    Examples:
      | title | behavior |
      | a     | fails    |
       (RuntimeError)
      ./features/step_definitions/steps.rb:12:in `"example {word} {word}"'
      features/mixed.feature:14:in `When example a fails'
      features/mixed.feature:10:in `When example <title> <behavior>'
"example a - url in outline step: https://foo.com?tracing_param=bar"
"example a - url in outline step: https://foo.com?tracing_param=bar"
"example b - url in outline step: https://foo.com"
      | b     | fails    |
       (RuntimeError)
      ./features/step_definitions/steps.rb:12:in `"example {word} {word}"'
      features/mixed.feature:15:in `When example b fails'
      features/mixed.feature:10:in `When example <title> <behavior>'
"example b - url in outline step: https://foo.com?tracing_param=bar"
"example b - url in outline step: https://foo.com?tracing_param=bar"
"example c - url in outline step: https://foo.com"
      | c     | passes   |
"example d - url in outline step: https://foo.com"
      | d     | fails    |
       (RuntimeError)
      ./features/step_definitions/steps.rb:12:in `"example {word} {word}"'
      features/mixed.feature:17:in `When example d fails'
      features/mixed.feature:10:in `When example <title> <behavior>'
"example d - url in outline step: https://foo.com?tracing_param=bar"
"example d - url in outline step: https://foo.com?tracing_param=bar"

Feature: Passing

"url in passing step: https://foo.com"
  Scenario: Pass     # features/passing.feature:3
    When this passes # features/step_definitions/steps.rb:6

"url in passing step: https://foo.com"
  Scenario: Pass Again # features/passing.feature:6
    When this passes   # features/step_definitions/steps.rb:6

Failing Scenarios:
cucumber features/mixed.feature:3 # Scenario: Failing in mixed feature
cucumber features/mixed.feature:14 # Scenario Outline: Mixed scenario outline, Examples (#1)
cucumber features/mixed.feature:15 # Scenario Outline: Mixed scenario outline, Examples (#2)
cucumber features/mixed.feature:17 # Scenario Outline: Mixed scenario outline, Examples (#4)

8 scenarios (4 failed, 4 passed)
16 steps (12 failed, 4 passed)
0m0.051s
```
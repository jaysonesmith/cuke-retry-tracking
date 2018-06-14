Feature: Mixed feature

  Scenario: Failing in mixed feature
    When this fails
  
  Scenario: Passing in mixed feature
    When this passes

  Scenario Outline: Mixed scenario outline
    When example <title> <behavior>

    Examples:
    | title | behavior |
    | a     | fails    |
    | b     | fails    |
    | c     | passes   |
    | d     | fails    |
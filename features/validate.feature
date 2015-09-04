Feature: Platform definition validate

  As an Infracoder developing the vaquero command line tool
  I want to routinely test the syntactic health of the platform definition files against the plugin definition
  In order to support consistent maintenance of large and multi-environment platforms

  Scenario: Request help with validate command

    When I get general help for "vaquero_io help validate"
    Then the exit status should be 0
    And the output should contain "Usage:"
    And the output should contain "vaquero_io validate [ENV|{all}]"

  Scenario: Validation of a correctly defined platform

    When I run `vaquero_io validate`
    Then the exit status should be 0
    And the output should contain "validate command"
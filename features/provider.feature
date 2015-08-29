Feature: Provider plugin gems

  As an Infracoder developing the vaquero command line tool
  I want to test the accuracy of the Provider gem interactions for the Provider command
  In order to maintain the users ability to use custom infrastructure targets

  Scenario: Request help with Provider commands

    When I get general help for "vaquero_io help provider"
    Then the exit status should be 0
    And the following commands should be documented:
      |list|
      |discover|

  Scenario: List installed Providers

    When I run `vaquero_io provider --list`
    Then the output should contain "vaquero_io"

  Scenario: Discover available Providers

    When I run `vaquero_io provider --discover`
    Then the output should contain "vaquero_io"

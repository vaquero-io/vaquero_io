Feature: Provider plugin modules

  As an Infracoder developing the putenv command line tool
  I want to test the accuracy of the Provider plugin interactions for the PROVIDER command
  In order to maintain the users ability to use and create provider plugins for custom infrastructure targets

  Scenario: List installed Providers

    When I run `putenv provider list`
    Then the exit status should be 0
    And the output should contain "[NOT YET IMPLEMENTED]"

  Scenario: Install new Provider

    When I run `putenv provider install`
    Then the exit status should be 0
    And the output should contain "called with no arguments"

    When I run `putenv provider install example`
    Then the exit status should be 0
    And the output should contain "[NOT YET IMPLEMENTED]"

  Scenario: Update installed Provider(s)

    When I run `putenv provider update`
    Then the exit status should be 0
    And the output should contain "[NOT YET IMPLEMENTED]"

  Scenario: Remove Provider

    When I run `putenv provider remove`
    Then the exit status should be 0
    And the output should contain "called with no arguments"

    When I run `putenv provider remove example`
    Then the exit status should be 0
    And the output should contain "[NOT YET IMPLEMENTED]"

  Scenario: Initialize new Provider yml template

    When I run `putenv provider init`
    Then the exit status should be 0
    And the output should contain "[NOT YET IMPLEMENTED]"

Feature: Behavior of CLI with general features and commands

  As an Infracoder developing a command line tool
  I want to have the basic structure of the tool setup
  In order to engage in the BDD of the tool

  Scenario: General help banner works

    When I get general help for "putenv"
    Then the exit status should be 0
    And the banner should be present
    And the following commands should be documented:
      |help|
      |version|

  Scenario: Can display gem version

    When I run `putenv -v`
    Then the output should display the version

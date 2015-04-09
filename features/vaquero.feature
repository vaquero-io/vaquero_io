Feature: Behavior of CLI with general features and commands

  As an Infracoder developing a command line tool
  I need to have the basic structure of the tool created
  In order to engage in the BDD of the tool

  Scenario: Request help with commands

    When I get general help for "vaquero"
    Then the exit status should be 0
    And the banner should be present
    And the following commands should be documented:
      |help|
      |version|
      |plugin|
      |new|

  Scenario: Display gem version

    When I run `vaquero -v`
    Then the output should display the version

# commands
#
#  $vaquero new <appname>, create yml folder structure for new platform definition
#  $vaquero generate <environment>, generate new environment yml for current platform
#  $vaquero validate [-e <env>, -p] no param is all, -e is specific env, -p is platform files only
#  $vaquero build

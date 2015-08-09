Feature: Provider plugin gems

  As an Infracoder developing the vaquero command line tool
  I want to test the accuracy of the Provider gem interactions for the Provider command
  In order to maintain the users ability to use and create provider plugin gems for custom infrastructure targets

  Scenario: Request help with Provider commands

    When I get general help for "vaquero_io help provider"
    Then the exit status should be 0
    And the following commands should be documented:
      |list|
      |template|

  Scenario: List installed Providers

#    Given a file named "../../lib/providers/vaquero-test-a/Providerfile.yml" with:
#    When I run `vaquero_io provider --list`
#    Then the exit status should be 0
#    And the output should contain "test-installed-a (0.0.0.a)"

  Scenario: New Providerfile template

#    When I run `vaquero_io provider --template`
#    Then the exit status should be 0
#    And the output should contain "create  Providerfile.yml"
#    And the following files should exist:
#      |Providerfile.yml|
#    And the file "Providerfile.yml" should contain:
#    """
#    provider:
#      # define the plugin name that can be used to select this provider from the command line or environmental variable
#      name:
#      version: 0.0.0
#    """
#

Feature: Provider plugin modules

  As an Infracoder developing the putenv command line tool
  I want to test the accuracy of the Provider plugin interactions for the PLUGIN command
  In order to maintain the users ability to use and create provider plugins for custom infrastructure targets

  Scenario: Request help with PLUGIN commands

    When I get general help for "putenv plugin"
    Then the exit status should be 0
    And the following commands should be documented:
      |help|
      |list|
      |init|
      |install|
      |update|
      |remove|

  Scenario: List installed Providers

    Given a file named "../../lib/providers/putenv-test-a/Providerfile.yml" with:
    """
    provider:
      name: test-installed-a
      version: 0.0.0.a
    """
    Given a file named "../../lib/providers/putenv-test-b/Providerfile.yml" with:
    """
    provider:
      name: test-installed-b
      version: 0.0.0.b
    """
    When I run `putenv plugin list`
    Then the exit status should be 0
    And the output should contain "test-installed-a (0.0.0.a)"
    And the output should contain "test-installed-b (0.0.0.b)"
    And I will clean up the test plugin "lib/providers/putenv-test-a" when finished
    And I will clean up the test plugin "lib/providers/putenv-test-b" when finished

  Scenario: New Providerfile template

    When I run `putenv plugin init`
    Then the exit status should be 0
    And the output should contain "create  Providerfile.yml"
    And the following files should exist:
      |Providerfile.yml|
    And the file "Providerfile.yml" should contain:
    """
    provider:
      # define the plugin name that can be used to select this provider from the command line or environmental variable
      name:
      version: 0.0.0
    """

    When I run `putenv plugin init example`
    Then the exit status should be 0
    And the output should contain "called with arguments"

  Scenario: Install new Provider

    When I run `putenv plugin install`
    Then the exit status should be 0
    And the output should contain "called with no arguments"

    When I run `putenv plugin install https://github.com/ActiveSCM/putenv-plugin-test.git`
    Then the exit status should be 0
    And the output should contain "Successfully installed putenv-plugin-test"
    And the following files should exist:
      |../../lib/providers/putenv-plugin-test/Providerfile.yml|
      |../../lib/providers/putenv-plugin-test/putenv_plugin_test.rb|
    And the file "../../lib/providers/putenv-plugin-test/Providerfile.yml" should contain:
    """
    provider:
      name: putenv-plugin-test
      version: 0.1.0.pre
      location: https://github.com/ActiveSCM/putenv-plugin-test.git
    """
    And I will clean up the test plugin "lib/providers/putenv-plugin-test" when finished

    Given a file named "../../lib/providers/putenv-plugin-test/Providerfile.yml" with:
    """
    provider:
      name: putenv-plugin-test
      version: 0.1.0.pre
      location: https://github.com/ActiveSCM/putenv-plugin-test.git
    """
    When I run `putenv plugin install https://github.com/ActiveSCM/putenv-plugin-test.git`
    Then the exit status should be 0
    And the output should contain "putenv-plugin-test already installed"
    And I will clean up the test plugin "lib/providers/putenv-plugin-test" when finished

  Scenario: Update installed Provider(s)

    Given a file named "../../lib/providers/putenv-plugin-test/Providerfile.yml" with:
    """
    provider:
      name: putenv-plugin-test
      version: 0.1.0.pre
      location: https://github.com/ActiveSCM/putenv-plugin-test.git
    """
    When I run `putenv plugin update putenv-plugin-test`
    Then the exit status should be 0
    And the output should contain "putenv-plugin-test provider already at current version"
    And I will clean up the test plugin "lib/providers/putenv-plugin-test" when finished

    Given a file named "../../lib/providers/putenv-plugin-test/Providerfile.yml" with:
    """
    provider:
      name: putenv-plugin-test
      version: 0.0.0.pre
      location: https://github.com/ActiveSCM/putenv-plugin-test.git
    """
    When I run `putenv plugin update putenv-plugin-test`
    Then the exit status should be 0
    And the output should contain "Updated putenv-plugin-test version 0.0.0.pre -> 0.1.0.pre"
    And I will clean up the test plugin "lib/providers/putenv-plugin-test" when finished

  Scenario: Remove Provider

    When I run `putenv plugin remove`
    Then the exit status should be 0
    And the output should contain "called with no arguments"

    When I run `putenv plugin remove putenv-plugin-test`
    Then the exit status should be 1
    And the output should contain "Missing or invalid Providerfile"

    Given a file named "../../lib/providers/putenv-plugin-test/Providerfile.yml" with:
    """
    provider:
      name: putenv-plugin-test
      version: 0.1.0.pre
      location: https://github.com/ActiveSCM/putenv-plugin-test.git
    """
    When I run `putenv plugin remove putenv-plugin-test`
    Then the exit status should be 0
    And the output should contain "putenv-plugin-test removed"
    And I will clean up the test plugin "lib/providers/putenv-plugin-test" when finished

Feature: New platform definition files for specified provider

  As an Infracoder developing the vaquero command line tool
  I want to test the ability to create platform definition template files for a provider
  In order to assist the user in creating and maintaining definition files for product platforms

  Scenario: Request help with NEW commands

    When I run `vaquero help new`
    Then the exit status should be 0
    And the output should contain "Usage:"
    And the output should contain "new"


  Scenario: Create new platform definition file based on current provider

    Given a file named "../../lib/providers/vaquero-test-a/Providerfile.yml" with:
    """
    provider:
      name: vaquero-test-a
      version: 0.1.0
      location:

      structure:

        require:
          - file1
          - file2
          - file3

        platform:
          path:
          params:
            count:
              type: integer
              range: 1..100
            runlist:
              array:
                type: string
                match: 'regex'
            componentrole:
              type: string
              match: 'regex'
            chefserver:
              type: string
              match: 'regex'

        file1:
          path: 'folder1/'
          params:
            location:
              type: string
              match: 'regex'
            host:
              type: string
              match: 'regex'

        file2:
          path: 'folder1/'
          params:
            vlanid:
              type: string
              match: 'regex'
            gateway:
              type: IP
            netmask:
              type: integer
              range: 1..24

        file3:
          path: 'folder2/'
          params:
            ram:
              type: integer
              range: 128..262144
            cpu:
              type: integer
              range: 1..16
            drive:
              hash:
                mount:
                  type: string
                  match: 'regex'
                capacity:
                  type: integer
                  range: 8..2048
            image:
              type: string
              match: 'regex'
    """
    Given a file named "../../lib/providers/vaquero-test-a/templates/platform.yml" with:
    """
    platform:
    """
    Given a file named "../../lib/providers/vaquero-test-a/templates/file1.yml" with:
    """
    file1:
    """
    Given a file named "../../lib/providers/vaquero-test-a/templates/file2.yml" with:
    """
    file2:
    """
    Given a file named "../../lib/providers/vaquero-test-a/templates/file3.yml" with:
    """
    file3:
    """
    Given a file named "../../lib/providers/vaquero-test-a/vaquero_test_a.rb" with:
    """
    """
    When I run `vaquero new --provider vaquero-test-a`
    Then the exit status should be 0
    And the output should contain "Platform definition files successfully created"
    And the following files should exist:
      |platform.yml|
      |folder1/file1.yml|
      |folder1/file2.yml|
      |folder2/file3.yml|
    And I will clean up the test plugin "lib/providers/vaquero-test-a" when finished

Feature: Provider Health check

  As an Infracoder developing the putenv command line tool
  I want to routinely test the syntactic health of the platform definition files against the plugin definition
  In order to support consistent maintenance of large and multi-environment platforms

  Scenario: Health check of a correctly defined platform

    Given a file named "platform.yml" with:
    """
    platform:
      product: aw
      provider: putenv-vsphere
      plugin_version: 0.1.0.pre

      environments:
        - int
        - qa

      nodename:
        - 'node'
        - instance

      # You can add any other custom attributes to the platform definition
      # by creating additional yml files with key values. The referenced
      # files are, by convention, assumed to have the following structure:
      #
      # tags:
      #
      #   tagset1: &tagset1
      #     key1: value
      #     key2: value
      #     ...
      #
      #   tagset2:
      #     <<: *tagset1
      #     key2: override value
      #
      #
      # Example: array of string
      #
      # references:
      #   path: 'infrastructure/'
      #   keyfiles:
      #     - tags
      #

      # Pools are used to define all the required elements of a component.
      # If you have a front-end web tier, the number of servers in the pool,
      # the ram, cpu, image to use, etc, are all defined in a pool
      # definition.
      #
      # The keys defined in this template are considered required for this plugin
      # though you can add additional keys either through references files
      # or directly.
      #
      # vcenter         reference to record set in vcenter required file
      # network         reference to record set in network required file
      # compute         reference to record set in compute required file
      # count           The number of components in the load balance pool
      # runlist         Chef runlist(s) for the node, array of strings
      # componentrole   optional custom role created by substituting the component name for # in the supplied string
      # chefserver      url for chef server
      # addresses       not necessary to define specific values in a pool definition, must include array of IP in component
      #
      # Example
      #
      # pools:
      #   webdefault: &webdefault
      #     vcenter: nonprod
      #     network: devweb
      #     compute: nonprodweb
      #     count: 2
      #     runlist:
      #       - 'role[loc_uswest]'
      #       - 'role[base]'
      #     componentrole: 'role[aw_#]'
      #     chefserver: https://chef
      #
      #
      pools:

        defaultpool: &defaultpool
          vcenter: nonprod
          networks: devweb
          compute: nonprodweb
          count: 2
          runlist:
            - 'role[loc_uswest]'
            - 'recipe[loc_uswest]'
          componentrole: 'role[aw_#]'
          chefserver: https://manage.chef.io
          addresses:
            -

      components:

        api:
          <<: *defaultpool
          addresses:
            - 10.10.10.1
            - 10.10.10.2

        aui:
          <<: *defaultpool
          addresses:
            - 10.10.10.10
            - 10.10.10.20
    """
    Given a file named "infrastructure/compute.yml" with:
    """
    compute:
      # The compute name is used to specify the compute resources used in the provsioning of the component node
      #
      # Example:
      #
      #   dev:
      #     cpu: 2
      #     ram: 1
      #     drive:
      #       mount: '/media/data'\
      #       capacity: 8192
      #
      #   prod:
      #     cpu: 2
      #     ram: 12
      #     drive:
      #       mount: '/media/data'\
      #       capacity: 8192
      #
      default: &default
        cpu: 1
        ram: 2048
        drive:
          mount: '/media/data'
          capacity: 8192
        image: 'centos_2015.xxx'

      nonprodweb:
        <<: *default

    """
    Given a file named "infrastructure/networks.yml" with:
    """
    networks:
      # Any number of networks may be specified. Networks are assigned to components as part
      # of the component definition. The vcenter vlan id is used to specify the network.
      #
      # Example:
      #
      #  devweb:
      #    vlanid: DEV_WEB_NET
      #    gateway: 10.10.128.1
      #    netmask: 19
      #
      devweb:
        vlanid: DEV_WEB_NET
        gateway: 10.10.128.1
        netmask: 19

    """
    Given a file named "infrastructure/vcenter.yml" with:
    """
    vcenter:
      # you can add as many vcenter definitions as required. The default file configuratioon
      # includes two in the form of a production and non production datacenter.
      # Key elements are as follows:
      #
      # geo           geographic location of a physical data center. Primarily for use in DR defintions
      # timezone      node timezone setting
      # host          hostname of vcenter management server
      # datacenter    vcenter 'datacenter' folder
      # imagefolder   vcenter resource folder where the clone image is located
      # destfolder    vcenter resource folder destination for provisioned vms
      # resourcepool  vcenter resource pool for the provisioned vms
      # appendenv     if true the destfolder path will be appended with the environment name
      # appenddomain  if true the domain will be pre-pended with environment name
      # datastore     prefix of desired datastorecluster.  knife vsphere datastorecluster maxfree will determine
      # domain        domain for fqdn of host
      # dnsips        ips of dns servers
      #
      # Example
      #
      #  locations:
      #      nonprod: &vcenter
      #        geo: west
      #        timezone: 085
      #
      #        host: 'vcwest.corp.local'
      #        datacenter: 'WCDC NonProd'
      #        imagefolder: 'Corporate/Platform Services/Templates'
      #        destfolder: 'Corporate/Platform Services/app'
      #        resourcepool: 'App-Web Linux/Corporate'
      #        appendenv: true
      #        appenddomain: true
      #        appendtier: false
      #        datastore: 'NonProd_Cor_PlaSer'
      #
      #        domain: dev.corp.local
      #        dnsips:
      #          - 10.10.10.5
      #          - 10.10.10.6
      #
      #      prod:
      #        <<: *vcenter
      #
      #        datacenter: 'WCDC Prod'
      #        datastore: 'Prod_Cor_PlaSer'
      #
      #        domain: corp.local
      #        dnsips:
      #          - 10.20.100.5
      #          - 10.20.100.6
      #
      nonprod: &default
        location: west
        host: vcenter.local
        datacenter: WCDC_nonprod
        imagefolder: 'compute/images'
        destfolder: 'aw/nonprod'
        resourcepool: 'aw'
        datastore: 'aw_data'
        domain: active.local
        envsubdomain: true
        dnsips:
          - 10.20.30.40

      prod:
        <<: *default

    """
    When I run `putenv health -p putenv-vsphere`
    Then the exit status should be 0
    And the output should contain "Success:"

  Scenario: Health check of a incorrectly defined platform (stress each param in test platform.yml)

    # for required files: this test only omits. See later test for validation of provided entries
    # for runlists: test emtpy array
    # for componentrole: test mismatch regex

    Given a file named "platform.yml" with:
    """
    platform:
      product: aw
      provider: putenv-vsphere
      plugin_version: 0.1.0.pre

      environments:
        -

      nodename:
        -

      # You can add any other custom attributes to the platform definition
      # by creating additional yml files with key values. The referenced
      # files are, by convention, assumed to have the following structure:
      #
      # tags:
      #
      #   tagset1: &tagset1
      #     key1: value
      #     key2: value
      #     ...
      #
      #   tagset2:
      #     <<: *tagset1
      #     key2: override value
      #
      #
      # Example: array of string
      #
      # references:
      #   path: 'infrastructure/'
      #   keyfiles:
      #     - tags
      #

      # Pools are used to define all the required elements of a component.
      # If you have a front-end web tier, the number of servers in the pool,
      # the ram, cpu, image to use, etc, are all defined in a pool
      # definition.
      #
      # The keys defined in this template are considered required for this plugin
      # though you can add additional keys either through references files
      # or directly.
      #
      # vcenter         reference to record set in vcenter required file
      # network         reference to record set in network required file
      # compute         reference to record set in compute required file
      # count           The number of components in the load balance pool
      # runlist         Chef runlist(s) for the node, array of strings
      # componentrole   optional custom role created by substituting the component name for # in the supplied string
      # chefserver      url for chef server
      # addresses       not necessary to define specific values in a pool definition, must include array of IP in component
      #
      # Example
      #
      # pools:
      #   webdefault: &webdefault
      #     vcenter: nonprod
      #     network: devweb
      #     compute: nonprodweb
      #     count: 2
      #     runlist:
      #       - 'role[loc_uswest]'
      #       - 'role[base]'
      #     componentrole: 'role[aw_#]'
      #     chefserver: https://chef
      #
      #
      pools:

        defaultpool: &defaultpool
          count: 0
          runlist:
            - 'role[loc_uswest]'
            - 'recipe[loc_uswest]'
          componentrole: 'role[aw_#]'
          chefserver: https://manage.chef.io
          addresses:
            -

      components:

        api:
          <<: *defaultpool
          addresses:
            - 10.10.10.1
            - 10.10.10.2

        aui:
          <<: *defaultpool
          addresses:
            - 10.10.10.10
            - 10.10.10.20
    """
    Given a file named "infrastructure/compute.yml" with:
    """
    compute:
      # The compute name is used to specify the compute resources used in the provsioning of the component node
      #
      # Example:
      #
      #   dev:
      #     cpu: 2
      #     ram: 1
      #     drive:
      #       mount: '/media/data'\
      #       capacity: 8192
      #
      #   prod:
      #     cpu: 2
      #     ram: 12
      #     drive:
      #       mount: '/media/data'\
      #       capacity: 8192
      #
      default: &default
        cpu: 1
        ram: 2048
        drive:
          mount: '/media/data'
          capacity: 8192
        image: 'centos_2015.xxx'

      nonprodweb:
        <<: *default

    """
    Given a file named "infrastructure/networks.yml" with:
    """
    networks:
      # Any number of networks may be specified. Networks are assigned to components as part
      # of the component definition. The vcenter vlan id is used to specify the network.
      #
      # Example:
      #
      #  devweb:
      #    vlanid: DEV_WEB_NET
      #    gateway: 10.10.128.1
      #    netmask: 19
      #
      devweb:
        vlanid: DEV_WEB_NET
        gateway: 10.10.128.1
        netmask: 19

    """
    Given a file named "infrastructure/vcenter.yml" with:
    """
    vcenter:
      # you can add as many vcenter definitions as required. The default file configuratioon
      # includes two in the form of a production and non production datacenter.
      # Key elements are as follows:
      #
      # geo           geographic location of a physical data center. Primarily for use in DR defintions
      # timezone      node timezone setting
      # host          hostname of vcenter management server
      # datacenter    vcenter 'datacenter' folder
      # imagefolder   vcenter resource folder where the clone image is located
      # destfolder    vcenter resource folder destination for provisioned vms
      # resourcepool  vcenter resource pool for the provisioned vms
      # appendenv     if true the destfolder path will be appended with the environment name
      # appenddomain  if true the domain will be pre-pended with environment name
      # datastore     prefix of desired datastorecluster.  knife vsphere datastorecluster maxfree will determine
      # domain        domain for fqdn of host
      # dnsips        ips of dns servers
      #
      # Example
      #
      #  locations:
      #      nonprod: &vcenter
      #        geo: west
      #        timezone: 085
      #
      #        host: 'vcwest.corp.local'
      #        datacenter: 'WCDC NonProd'
      #        imagefolder: 'Corporate/Platform Services/Templates'
      #        destfolder: 'Corporate/Platform Services/app'
      #        resourcepool: 'App-Web Linux/Corporate'
      #        appendenv: true
      #        appenddomain: true
      #        appendtier: false
      #        datastore: 'NonProd_Cor_PlaSer'
      #
      #        domain: dev.corp.local
      #        dnsips:
      #          - 10.10.10.5
      #          - 10.10.10.6
      #
      #      prod:
      #        <<: *vcenter
      #
      #        datacenter: 'WCDC Prod'
      #        datastore: 'Prod_Cor_PlaSer'
      #
      #        domain: corp.local
      #        dnsips:
      #          - 10.20.100.5
      #          - 10.20.100.6
      #
      nonprod: &default
        location: west
        host: vcenter.local
        datacenter: WCDC_nonprod
        imagefolder: 'compute/images'
        destfolder: 'aw/nonprod'
        resourcepool: 'aw'
        datastore: 'aw_data'
        domain: active.local
        envsubdomain: true
        dnsips:
          - 10.20.30.40

      prod:
        <<: *default

    """
    When I run `putenv health -p putenv-vsphere`
    And the output should contain "Empty environments definition"
    And the output should contain "Empty nodename convention"
    And the output should contain "No references to required file:vcenter"
    And the output should contain "No references to required file:network"
    And the output should contain "No references to required file:compute"
    And the output should contain "Validation error: api:count"
#    And the output should contain "Validation error: api:count"
#    And the output should contain "Validation error: api:count"
#    And the output should contain "Validation error: api:count"
#    And the output should contain "Validation error: api:count"
#    And the output should contain "Validation error: api:count"
#    And the output should contain "Validation error: api:count"
#    And the output should contain "Validation error: api:count"
#    And the output should contain "Validation error: api:count"
#    And the output should contain "Validation error: api:count"
#    And the output should contain "Validation error: api:count"
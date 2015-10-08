module VaqueroIo
  # mixin for validating local definition files against providerfile.yml from provider gem
  module ValidateUtils
    def validate_platform(pf)
      # At this point, trying to keep the platform definition DRY I haven't repeated
      # the platform key in each environment definition. You define it once in platform.bak
      # and then each environment definition is just the differences. But this also means
      # that the logic to loop through the keys for validation looks a bit different for
      # the platform keys than for the infrastructure keys. Hence, this section feels
      # inelegant to me. But I haven't though of a more elegant way to do this yet.
      validate_infrastructure(pf.definition, pf.environments)
      validate_profile(pf.definition, pf.environments)
      true
    end

    def validate_infrastructure(definition, environments)
      # this will loop through the providerfile.yml infrastructure definitions and
      # compare to each environment - by comparing the plugin to the local file rather
      # than the other way around custom attributes will not cause an error
      #
      # for each infrastructure definition in the providerfile
      definition['infrastructure'].each do |infra|
        # validate infra definition against each role, in each environment
        validate_infra_component(infra, definition[infra], environments)
      end
    end

    def validate_profile(definition, environments)
      # this will loop through the providerfile.yml profile definitions and
      # compare to each environment - by comparing the plugin to the local file rather
      # than the other way around custom attributes will not cause an error
      #
      # for each platform component in the providerfile
      definition['platform'].each do |component, shouldbe|
        validate_profile_component(component, shouldbe, environments)
      end
    end

    def validate_infra_component(component, definition, environments)
      # for each item defined in this infrastructure component
      definition.each do |item, shouldbe|
        # compare to each role in each environment
        environments.each do |env, roles|
          roles.each do |role, _role_keys|
            # inelegantly passing this entry tracker downstream to facilitate error messages
            entry = "validate [#{env}][#{role}][#{component}][#{item}]"
            VaqueroIo.config.write_log.info(entry)
            value_to_definition(entry, environments[env][role][component][item], shouldbe)
          end
        end
      end
    end

    def validate_profile_component(component, shouldbe, environments)
      environments.each do |env, roles|
        roles.each do |role, _role_keys|
          # inelegantly passing this entry tracker downstream to facilitate error messages
          entry = "validate [#{env}][#{role}][#{component}]"
          VaqueroIo.config.write_log.info(entry)
          value_to_definition(entry, environments[env][role][component], shouldbe)
        end
      end
    end

    def value_to_definition(entry, value, expression)
      # arrays and hashes recursively call to allow nested definitions
      case
      when value.class == Hash
        value.each { |hk, hv| value_to_definition(entry, hv, expression['hash'][hk]) }
      when value.class == Array
        value.each { |av| value_to_definition(entry, av, expression['array']) }
      else
        do_validate(entry, value, expression)
      end
    end

    # this method is way too long and messy and I don't like passing the current entry point down
    # through the methods but until it can be done better there is no real value
    # in breaking this method down into individual type methods
    #
    # rubocop: disable LineLength
    # rubocop: disable Metrics/AbcSize
    # rubocop: disable CyclomaticComplexity
    # rubocop: disable PerceivedComplexity
    # rubocop: disable MethodLength
    def do_validate(entry, value, expression)
      fail StandardError, "empty string at #{entry}" if value.nil?
      case expression['type']
      when 'string'
        fail StandardError, "invalid string at #{entry}" unless value.match(Regexp.new(expression['match']))
      when 'integer'
        rng = expression['range'].split('..').map { |d| Integer(d) }
        fail StandardError, "integer out of range at #{entry}" unless Range.new(rng[0], rng[1]).member?(value)
      when 'IP'
        fail StandardError, "invalid IP at #{entry}" unless Resolv::IPv4::Regex.match(value)
      when 'URL'
        fail StandardError, "invalid URL at #{entry}" unless value.match(URI.regexp)
      when 'boolean'
        # I realize useing double negative to coerce boolean is not preferred, but...
        # rubocop: disable DoubleNegation
        fail StandardError, "invalid boolean at #{entry}" unless !!value == value
        # rubocop: enable DoubleNegation
      else
        fail StandardError, "unknown validate type #{entry}"
      end
    end
    # rubocop: enable LineLength
    # rubocop: enable Metrics/AbcSize
    # rubocop: enable CyclomaticComplexity
    # rubocop: enable PerceivedComplexity
    # rubocop: enable MethodLength
  end
end

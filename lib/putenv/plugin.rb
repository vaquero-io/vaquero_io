require 'pathname'
require 'yaml'
require 'git'
require 'fileutils'

module Putenv
  # top level comment
  class Plugin < Thor
    include Thor::Actions

    # list of installed providers (includes PWD)
    # rubocop:disable LineLength
    desc 'list', DESC_PLUGIN_LIST
    def list
      installed_providers.each { |k, v| puts "#{k} (#{v}) #{ENV[PUTENV_PROVIDER] == k ? '<default' : ''}" }
    end
    # rubocop:enable LineLength

    desc 'init', DESC_PLUGIN_INIT
    def init
      template(TEMPLATE_PROVIDER, PROVIDERFILE)
    end

    # rubocop:disable LineLength
    desc 'install LOCATION', DESC_PLUGIN_INSTALL
    def install(path)
      latest = get_working_copy(path)
      if installed_providers.key?(latest['name'])
        puts "#{latest['name']} already installed"
      else
        FileUtils.cp_r("#{TMP_INSTALL_FOLDER}/.", "#{PROVIDERS_PATH}#{latest['name']}")
        puts "Successfully installed #{latest['name']} (#{latest['version']})"
      end if latest != NO_PROVIDER_FILE
      clear_working_copy
      fail(IOError, NO_PROVIDER_FILE) if latest == NO_PROVIDER_FILE
    end
    # rubocop:enable LineLength

    # rubocop:disable MethodLength, LineLength
    desc 'update [PROVIDER]', DESC_PLUGIN_UPDATE
    def update(plugin = '')
      update_list = {}
      providers = installed_providers
      if plugin.empty?
        update_list = providers
      else
        if installed_providers.key?(plugin)
          update_list[plugin] = providers[plugin]
        else
          update_list = NO_PROVIDER_FILE
        end
      end
      update_list.each { |prov, ins_vers| update_plugin(prov, ins_vers) } if update_list != NO_PROVIDER_FILE
      fail(IOError, NO_PROVIDER_FILE) if update_list == NO_PROVIDER_FILE
    end
    # rubocop:enable MethodLength, LineLength

    desc 'remove PROVIDER', DESC_PLUGIN_REMOVE
    def remove(plugin)
      if installed_providers.key?(plugin)
        FileUtils.remove_dir("#{PROVIDERS_PATH}#{plugin}")
        puts "#{plugin} removed"
      else
        fail(IOError, NO_PROVIDER_FILE)
      end
    end

    private

    def get_working_copy(path)
      Git.clone(path, TMP_INSTALL_FOLDER)
      NO_PROVIDER_FILE_FILE unless File.file?(TMP_INSTALL_PROVIDER)
      YAML.load_file(TMP_INSTALL_PROVIDER).fetch('provider', NO_PROVIDER_FILE)
    end

    def clear_working_copy
      FileUtils.remove_dir(TMP_INSTALL_FOLDER)
    end

    def installed_providers
      providers = {}
      Pathname.glob(LIST_PLUGINS_PATH).each do |prov|
        plugin = YAML.load_file(prov).fetch('provider')
        providers[plugin['name']] = plugin['version']
      end
      providers
    end

    def plugin_locations
      locations = {}
      Pathname.glob(LIST_PLUGINS_PATH).each do |prov|
        plugin = YAML.load_file(prov).fetch('provider')
        locations[plugin['name']] = plugin['location']
      end
      locations
    end

    # rubocop:disable LineLength
    def update_plugin(plugin, version)
      locations = plugin_locations
      latest = get_working_copy(locations[plugin])
      if latest['version'] != version
        FileUtils.remove_dir("#{PROVIDERS_PATH}#{plugin}")
        FileUtils.cp_r("#{TMP_INSTALL_FOLDER}/.", "#{PROVIDERS_PATH}#{latest['name']}")
        puts "Updated #{plugin} version #{version} -> #{latest['version']}"
      else
        puts "#{plugin}#{PLUGINS_CURRENT}"
      end
      clear_working_copy
    end
    # rubocop:enable LineLength

    def self.source_root
      File.dirname(__FILE__)
    end
  end
end

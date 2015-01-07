require 'pathname'
require 'yaml'
require 'git'
require 'fileutils'

module Putenv
  # top level comment
  class Plugin < Thor
    include Thor::Actions
    desc 'list', DESC_PLUGIN_LIST
    def list
      installed_providers.each { |k, v| puts "#{k} (#{v})" }
    end

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
        FileUtils.cp_r("#{INSTALL_WORK_FOLDER}/.", "#{PATH_PROVIDERS}#{latest['name']}")
        puts "Successfully installed #{latest['name']} (#{latest['version']})"
      end if latest != NO_PROVIDER
      clear_working_copy
      fail(IOERROR, NO_PROVIDER) if latest == NO_PROVIDER
    end
    # rubocop:enable LineLength

    # https://github.com/ActiveSCM/putenv-vsphere.git
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
          update_list = NO_PROVIDER
        end
      end
      update_list.each { |prov, ins_vers| update_plugin(prov, ins_vers) } if update_list != NO_PROVIDER
      fail(IOERROR, NO_PROVIDER) if update_list == NO_PROVIDER
    end
    # rubocop:enable MethodLength, LineLength

    desc 'remove PROVIDER', DESC_PLUGIN_REMOVE
    def remove(plugin)
      puts "remove #{plugin} [NOT YET IMPLEMENTED]"
    end

    private

    def get_working_copy(path)
      Git.clone(path, INSTALL_WORK_FOLDER)
      NO_PROVIDER unless File.file?(INSTALL_WORK_PROVIDER)
      YAML.load_file(INSTALL_WORK_PROVIDER).fetch('provider', NO_PROVIDER)
    end

    def clear_working_copy
      FileUtils.remove_dir(INSTALL_WORK_FOLDER)
    end

    def installed_providers
      providers = {}
      PATH_LIST_PLUGINS.each do |path|
        Pathname.glob(path).each do |prov|
          plugin = YAML.load_file(prov).fetch('provider')
          providers[plugin['name']] = plugin['version']
        end
      end
      providers
    end

    def plugin_locations
      locations = {}
      PATH_LIST_PLUGINS.each do |path|
        Pathname.glob(path).each do |prov|
          plugin = YAML.load_file(prov).fetch('provider')
          locations[plugin['name']] = plugin['location']
        end
      end
      locations
    end

    # rubocop:disable LineLength
    def update_plugin(plugin, version)
      locations = plugin_locations
      latest = get_working_copy(locations[plugin])
      if latest['version'] != version
        FileUtils.remove_dir("#{PATH_PROVIDERS}#{plugin}")
        FileUtils.cp_r("#{INSTALL_WORK_FOLDER}/.", "#{PATH_PROVIDERS}#{latest['name']}")
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

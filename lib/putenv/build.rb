module Putenv
  # Instantiates the platform
  # builds the environment hash then
  # passes to provider plugin
  class Build < Thor::Group
    include Thor::Actions

    # Build subcommand arguments and options
    # rubocop:disable LineLength
    argument :env, type: :string, desc: DESC_BUILD
    class_option :all, type: :boolean, aliases: '-a', desc: DESC_BUILD_ALL
    class_option :component, type: :string, aliases: '-c', desc: DESC_BUILD_COMPONENT
    class_option :node, type: :numeric, aliases: '-n', desc: DESC_BUILD_NODE
    class_option :verbose, type: :boolean, aliases: '-v', default: false
    class_option :provider, type: :string, aliases: '-p'

    # TODO: we don't have a tier definition any longer
    # class_option :tier, type: :string, aliases: '-t', desc: DESC_BUILD_TIER
    # TODO: Concurrency is an aspect of the provisioner not the tool so somehow you
    # have to find a way to pass/set any kind of provider required options that is plugin agnostic
    # class_option :concurrency, type: :numeric, aliases: '-C', default: 8, desc: DESC_BUILD_CONCURRENCY
    # TODO: What to do about logfiles?
    # class_option :logfiles, type: :string, aliases: '-l', default: 'logs', desc: DESC_BUILD_LOGFILES
    # rubocop:enable LineLength

    def self.source_root
      File.dirname(__FILE__)
    end

    def build
      # TODO: Initially, i am just passing the entire
      # environment hash to the plugin
      # But this can be further broken down based on parameters passed to build
      test = Putenv::Platform.new(Putenv::Provider.new(options[:provider]))
      test.environment(env)
      test.provision(test.env_definition)
    end
  end
end

clearing :on
# notification :growl, sticky: true

group :red_green_refactor, halt_on_fail: true do
  guard :rspec, all_after_pass: true, all_on_start: true, cmd: 'bundle exec rspec' do
    require 'guard/rspec/dsl'
    dsl = Guard::RSpec::Dsl.new(self)
    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)
    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)
  end

  guard 'cucumber' do
    watch(%r{/^features/.+\.feature$/})
    watch(%r{/^features/support/.+$/}) { 'features' }
    watch(%r{/^features/step_definitions/(.+)_steps\.rb$/}) do |m|
      Dir[File.join("**/#{m[1]}.feature")][0] || 'features'
    end
  end

  guard :rubocop do
    watch(%r{/.+\.rb$/})
    watch(%r{/(?:.+/)?\.rubocop\.yml$/}) { |m| File.dirname(m[0]) }
  end
end
#
#
# guard 'yard' do
#   watch(%r{app/.+\.rb})
#   watch(%r{lib/.+\.rb})
#   watch(%r{ext/.+\.c})
# end

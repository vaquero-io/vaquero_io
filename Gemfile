source 'https://rubygems.org'

# gem dependencies in vaquero_io.gemspec
gemspec

Gem::Deprecate.skip_during do
  Gem::Specification.find_all_by_name(/^(vaquero_io_)/).each do |g|
    gem g.name, require: false
  end
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
end

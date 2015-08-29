require 'rspec/expectations'
require 'aruba/cucumber'
require 'cucumber'
require 'fileutils'

ENV['PATH'] = "/lib#{File::PATH_SEPARATOR}#{ENV['PATH']}"

require 'aruba/cucumber'
require 'aruba/in_process'
require 'putenv/runner'
require 'coveralls'

ENV['PATH'] = "/lib#{File::PATH_SEPARATOR}#{ENV['PATH']}"

Coveralls.wear!

Aruba::InProcess.main_class = Putenv::Runner
Aruba.process = Aruba::InProcess

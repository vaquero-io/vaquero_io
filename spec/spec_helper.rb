$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
#
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

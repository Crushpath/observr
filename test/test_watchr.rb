require 'test/test_helper'

class TestObservr < MiniTest::Unit::TestCase

  def setup
    Observr.options = nil
  end

  ## options

  test "debug option" do
    assert_equal false, Observr.options.debug
    Observr.options.debug = true
    assert_equal true,  Observr.options.debug
  end

  ## functionality

  test "debug" do
    assert_empty capture_io { Observr.debug('abc') }.first
    Observr.options.debug = true
    assert_equal "[observr debug] abc\n", capture_io { Observr.debug('abc') }.first
  end

  test "picking handler" do

    if Observr::HAVE_REV

    Observr.handler = nil
    ENV['HANDLER'] = 'linux'
    assert_equal Observr::EventHandler::Unix, Observr.handler

    Observr.handler = nil
    ENV['HANDLER'] = 'bsd'
    assert_equal Observr::EventHandler::Unix, Observr.handler

    Observr.handler = nil
    ENV['HANDLER'] = 'unix'
    assert_equal Observr::EventHandler::Unix, Observr.handler

    end

    if Observr::HAVE_FSE

    Observr.handler = nil
    ENV['HANDLER'] = 'darwin'
    assert_equal Observr::EventHandler::Darwin, Observr.handler

    Observr.handler = nil
    ENV['HANDLER'] = 'osx'
    assert_equal Observr::EventHandler::Darwin, Observr.handler

    Observr.handler = nil
    ENV['HANDLER'] = 'fsevent'
    assert_equal Observr::EventHandler::Darwin, Observr.handler

    end

    Observr.handler = nil
    ENV['HANDLER'] = 'mswin'
    assert_equal Observr::EventHandler::Portable, Observr.handler

    Observr.handler = nil
    ENV['HANDLER'] = 'cygwin'
    assert_equal Observr::EventHandler::Portable, Observr.handler

    Observr.handler = nil
    ENV['HANDLER'] = 'portable'
    assert_equal Observr::EventHandler::Portable, Observr.handler

    Observr.handler = nil
    ENV['HANDLER'] = 'other'
    assert_equal Observr::EventHandler::Portable, Observr.handler
  end
end


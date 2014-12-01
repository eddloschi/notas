ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

module JSHelper
  def use_js
    Capybara.current_driver = :webkit
    @js = true
  end

  def teardown
    super
    if @js
      Capybara.use_default_driver
      @js = false
    end
  end
end

module SessionHelper
  def log_in
    visit '/users/sign_in'
    fill_in 'Email', with: users(:eu).email
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
  end

  def teardown
    super
    Capybara.reset_sessions!
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include JSHelper
  include SessionHelper
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

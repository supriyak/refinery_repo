# Load the rails application
require File.expand_path('../application', __FILE__)
require 'thinking_sphinx/deltas/delayed_delta'
# Initialize the rails application
Refinery::Application.initialize!

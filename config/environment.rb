# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Deildu::Application.initialize!

Mime::Type.register "application/x-bittorrent", :torrent

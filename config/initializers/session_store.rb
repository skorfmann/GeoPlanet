# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_geoplanet_session',
  :secret      => 'f4b9dea8ff5b2d85708eb2fc3b4012f62822e5f7eea84a8d3bfe85e8f6f5d703241e8427d4ad472eb2c9f0789ca8381ccc5a0590ca5a1912d2533a5d82baf866'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

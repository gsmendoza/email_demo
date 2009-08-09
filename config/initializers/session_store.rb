# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_email_demo_session',
  :secret      => '29b77e49c0a7b14e1a225178ab3a1ce1f7cc250e2c0eebc867421046b23ae5e046b8f85b8bba676e0b215535b24b05bf2efc37519cfd58b227ab52f3f7fedd47'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

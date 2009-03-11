# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_repo_man_session',
  :secret      => '7852b3e0a935b9e372938c0dab465257de05f222cc70e8bb65ebd2de4c8103177290e4cb5dbcc1b034b5dd215c94af788f6ee83b24fa6845e18c5702f164287e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

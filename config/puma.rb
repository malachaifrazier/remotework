# config/puma.rb
threads 4,8
workers 2
port 4444
preload_app!

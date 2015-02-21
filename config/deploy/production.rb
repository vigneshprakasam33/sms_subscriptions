# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{ubuntu@ec2-54-69-3-56.us-west-2.compute.amazonaws.com}
role :web, %w{ubuntu@ec2-54-69-3-56.us-west-2.compute.amazonaws.com}
role :db,  %w{ubuntu@ec2-54-69-3-56.us-west-2.compute.amazonaws.com}

set :stage, :production

# Replace 127.0.0.1 with your server's IP address!
server 'ec2-54-69-3-56.us-west-2.compute.amazonaws.com', user: 'ubuntu', roles: %w{web app}

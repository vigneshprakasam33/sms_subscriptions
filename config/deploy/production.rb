#encoding: utf-8
role :app, %w{ubuntu@ec2-54-69-3-56.us-west-2.compute.amazonaws.com}
role :web, %w{ubuntu@ec2-54-69-3-56.us-west-2.compute.amazonaws.com}
role :db,  %w{ubuntu@ec2-54-69-3-56.us-west-2.compute.amazonaws.com}

set :stage, :production

# Replace 127.0.0.1 with your server's IP address!
server 'ec2-54-69-3-56.us-west-2.compute.amazonaws.com', user: 'ubuntu', roles: %w{web app}

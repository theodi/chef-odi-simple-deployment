require 'spec_helper'

# Make sure nginx is running
describe service("nginx") do
  it { should be_running }
end

# Make sure vhosts have the correct stuff
describe file("/etc/nginx/sites-enabled/deploytest.theodi.org") do
  it { should be_file }
  its(:content) { should match "server_name deploytest.theodi.org;" }
  its(:content) { should match "proxy_pass http://deployment-test-app;" }
end

# Make sure we have some code
describe file("/var/www/deploytest.theodi.org/current/hello.rb") do
  it { should be_file }
end

# Make sure we have environment correctly
describe file("/var/www/deploytest.theodi.org/current/.env") do
  its(:content) { should match /SUCH: test/ }
end

# Make sure foreman job is running
describe service("deployment-test-app-web-1") do
  it { should be_running }
end

# Check we can actually access the thing
describe command("curl -H 'Host: deploytest.theodi.org' localhost") do
  it { should return_stdout /Hello, world!/ }
end

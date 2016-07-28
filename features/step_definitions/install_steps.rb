require 'open3'
require_relative 'vars.rb'

When(/^I setup machine for deploy$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'setup'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^it should be successful$/) do
  expect(@status.success?).to eq(true)
end

And(/^Git should be installed$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'git --version'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to match("git version")
end

And(/^Pip should be installed$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'pip --version'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to match("pip")
end

And(/^Pexpect should be installed$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'pip list | grep pexpect'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to match("pexpect")
end

And(/^heroku toolbelt should be installed$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'heroku --version | grep heroku'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to match("heroku-")
end


When(/^I setup Heroku account$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'heroku_setup'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^Heroku account credentials should be correct$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'sudo cat #{ANSIBLE_HOME}/.netrc | grep #{EMAIL}'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to include("#{EMAIL}")
end

And(/^Heroku app should exist$/) do
  cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'find_app'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
end

When(/^I clone repo and deploy app$/) do
  cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'git_clone,heroku_push'"
  output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^app should be available on port 80$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'curl -I #{APP_URL} | grep 200'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to include("200 OK")
end

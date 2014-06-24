#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
ver = node["ruby"]["version"]
package "openssl-devel" do
  action :install
end

git "/home/vagrant/.rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  revision   "master"
  user       "vagrant"
  group      "vagrant"
  action     :sync
end

directory "/home/vagrant/.rbenv/plugins" do
  owner  "vagrant"
  group  "vagrant"
  action :create
end

git "/home/vagrant/.rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  revision   "master"
  user       "vagrant"
  group      "vagrant"
  action     :sync
end

ruby_block ".zshrc" do
  block do
    file = Chef::Util::FileEdit.new("/home/vagrant/.zshrc")
    file.insert_line_if_no_match(/RBENV_ROOT/, <<EOH)

export RBENV_ROOT=/home/vagrant/.rbenv
export PATH=/home/vagrant/.rbenv/bin:$PATH
eval $(rbenv init\ -)
source $HOME/.rbenv/completions/rbenv.zsh
EOH
    file.write_file
  end
end

template "rbenv.sh" do
  owner  "vagrant"
  group  "vagrant"
  path   "/home/vagrant/rbenv.sh"
  source "rbenv.sh.erb"
end

bash "rbenv install #{ver}" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source rbenv.sh; /home/vagrant/.rbenv/bin/rbenv install #{ver}"
  action :run
  not_if { ::File.exists? "/home/vagrant/.rbenv/versions/#{ver}" }
end

bash "rbenv rehash" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source rbenv.sh; /home/vagrant/.rbenv/bin/rbenv rehash"
  action :run
end

bash "rbenv global #{ver}" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source rbenv.sh; /home/vagrant/.rbenv/bin/rbenv global #{ver}"
  action :run
end

bash "bundler" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source rbenv.sh; /home/vagrant/.rbenv/shims/gem install bundler"
  action :run
  not_if { ::File.exists? "/home/vagrant/.rbenv/shims/bundle" }
end

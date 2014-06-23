#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
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
    %w{
      export\ RBENV_ROOT=/home/vagrant/.rbenv
      export\ PATH=/home/vagrant/.rbenv/bin:$PATH
      eval\ $(rbenv\ init\ -)
      source\ $HOME/.rbenv/completions/rbenv.zsh
    }.each do |string|
      file.insert_line_if_no_match(string, string)
    end
    file.write_file
  end
end

template "rbenv.sh" do
  owner  "vagrant"
  group  "vagrant"
  path   "/home/vagrant/rbenv.sh"
  source "rbenv.sh.erb"
end

bash "rbenv install 2.0.0-p353" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source rbenv.sh; /home/vagrant/.rbenv/bin/rbenv install 2.0.0-p353"
  action :run
  not_if { ::File.exists? "/home/vagrant/.rbenv/versions/2.0.0-p353" }
end

bash "rbenv rehash" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source rbenv.sh; /home/vagrant/.rbenv/bin/rbenv rehash"
  action :run
end

bash "rbenv global 2.0.0-p353" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source rbenv.sh; /home/vagrant/.rbenv/bin/rbenv global 2.0.0-p353"
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

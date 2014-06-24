#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
ver = node["nodejs"]["version"]

package "openssl-devel" do
  action :install
end

directory "/home/vagrant/.nenv" do
  action :create
end


git "/home/vagrant/.nvm" do
  repository "git://github.com/creationix/nvm.git"
  reference "master"
  action :checkout
  user "vagrant"
  group "vagrant"
end

ruby_block ".zshrc" do
  block do
    file = Chef::Util::FileEdit.new("/home/vagrant/.zshrc")
    file.insert_line_if_no_match(/\.nvm/, <<EOH)

source $HOME/.nvm/nvm.sh
EOH
    file.write_file
  end
end


bash "Install nodejs" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source .nvm/nvm.sh; nvm install #{ver}; nvm alias default #{ver}"
  action :run
  not_if { ::File.exists? "/home/vagrant/.nvm/#{ver}" }
end

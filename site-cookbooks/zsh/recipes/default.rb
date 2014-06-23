#
# Cookbook Name:: zsh
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "zsh" do
  action :install
end

git "/home/vagrant/.oh-my-zsh" do
  repository "git://github.com/robbyrussell/oh-my-zsh.git"
  reference "master"
  action :checkout
  user "vagrant"
  group "vagrant"
  not_if { ::File.exists? "/home/vagrant/.oh-my-zsh" }
end

bash "Set vagrant's shell to zsh" do
  code 'chsh -s /bin/zsh vagrant'
  not_if 'test "/bin/zsh" = "$(grep vagrant /etc/passwd | cut -d: -f7)"'
end

bash "Copy template to home" do
  user  'vagrant'
  group 'vagrant'
  code  'cp -p /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc'
  not_if { ::File.exists? '/home/vagrant/.zshrc' }
end

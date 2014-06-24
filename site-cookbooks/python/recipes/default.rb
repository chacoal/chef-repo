#
# Cookbook Name:: python
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

pyver = node["python"]["version"]

%W{
zlib-devel
bzip2-devel
openssl-devel
ncurses-devel
sqlite-devel
readline-devel
tk-devel
gdbm-devel
db4-devel
libpcap-devel
xz-devel
}.each do |pkg|
  package pkg do
    action :install
  end
end

execute "Install pip" do
  command 'curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py -o - | sudo python'
  action :run
end

git "/home/vagrant/.pyenv" do
  repository "git://github.com/yyuu/pyenv.git"
  reference "master"
  action :checkout
  user "vagrant"
  group "vagrant"
end

template "pyenv.sh" do
  owner  "vagrant"
  group  "vagrant"
  path   "/home/vagrant/pyenv.sh"
  source "pyenv.sh.erb"
end

bash "pyenv install #{pyver}" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source pyenv.sh; pyenv install #{pyver}"
  action :run
  not_if { ::File.exists? "/home/vagrant/.pyenv/versions/#{pyver}" }
end

bash "pyenv rehash" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source pyenv.sh; pyenv rehash"
  action :run
end

ruby_block ".zshrc" do
  block do
    file = Chef::Util::FileEdit.new("/home/vagrant/.zshrc")
    file.insert_line_if_no_match(/PYENV_ROOT/, <<EOH)

export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval $(pyenv\ init -)
source $HOME/.pyenv/completions/pyenv.zsh
EOH
    file.write_file
  end
end

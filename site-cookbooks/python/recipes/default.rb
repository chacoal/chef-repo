#
# Cookbook Name:: python
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "python" do
  command 'yum -y groupinstall "Development Tools"'
  action :run
end

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

execute "pip" do
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

bash "pyenv install 2.7.6" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source pyenv.sh; pyenv install 2.7.6"
  action :run
  not_if { ::File.exists? "/home/vagrant/.pyenv/versions/2.7.6" }
end

bash "pyenv rehash" do
  user   "vagrant"
  group  "vagrant"
  environment "HOME" => '/home/vagrant'
  cwd    "/home/vagrant"
  code   "source pyenv.sh; pyenv rehash"
  action :run
end

bash "virtualenv" do
  code 'pip install virtualenv virtualenvwrapper setuptools'
  action :run
end

ruby_block ".zshrc" do
  block do
    file = Chef::Util::FileEdit.new("/home/vagrant/.zshrc")
    %w{
      export\ PYENV_ROOT=$HOME/.pyenv
      export\ PATH=$PYENV_ROOT/bin:$PATH
      eval\ $(pyenv\ init\ -)
      source\ $HOME/.pyenv/completions/pyenv.zsh
      export WORKON_HOME=$HOME/.virtualenvs
      source\ /usr/bin/virtualenvwrapper.sh
    }.each do |string|
      file.insert_line_if_no_match(/#{string}/, string)
    end
    file.write_file
  end
end


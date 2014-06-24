#
# Cookbook Name:: vim
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%W{
python-devel
perl-devel
ruby-devel
lua-devel
perl-ExtUtils-Embed
}.each do |pkg|
  package pkg do
    action :install
  end
end

directory "/home/vagrant/src" do
  owner "vagrant"
  group "vagrant"
  mode 0755
  action :create
end

bash "get vim source" do
  user "vagrant"
  group "vagrant"
  cwd "/home/vagrant/src"
  environment "HOME" => "/home/vagrant"
  code "hg clone https://code.google.com/p/vim/"
  action :run
  not_if { ::File.exists? "/home/vagrant/src/vim" }
end

bash "vim build" do
  user "vagrant"
  group "vagrant"
  cwd "/home/vagrant/src/vim"
  environment "HOME" => "/home/vagrant"
  code <<-EOH
    ./configure\
      --with-features=huge \
      --prefix=/usr/local\
      --enable-multibyte \
      --enable-rubyinterp \
      --enable-pythoninterp \
      --enable-perlinterp \
      --enable-luainterp \
      --enable-cscope\
      --disable-selinux\
      --enable-fail-if-missing
    make
    sudo make install
  EOH
  action :run
end


bash "install neobundle" do
  user "vagrant"
  group "vagrant"
  cwd "/home/vagrant"
  environment "HOME" => "/home/vagrant"
  code "curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh"
end


template ".vimrc" do
  path "/home/vagrant/.vimrc"
  source "vimrc.erb"
  owner "vagrant"
  group "vagrant"
  mode 0644
end

template "bundles.yml" do
  path "/home/vagrant/.vim/bundles.yml"
  source "bundles.yml.erb"
  owner "vagrant"
  group "vagrant"
  mode 0644
end

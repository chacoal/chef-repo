#
# Cookbook Name:: golang
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/home/vagrant/src" do
  owner "vagrant"
  group "vagrant"
  mode 0755
  action :create
end

directory "/home/vagrant/gop" do
  owner "vagrant"
  group "vagrant"
  mode 0755
  action :create
end

bash "Go source dowload" do
  cwd "/home/vagrant/src"
  user "vagrant"
  group "vagrant"
  environment "HOME" => "/home/vagrant"
  code "hg clone -u release https://code.google.com/p/go"
  action :run
  not_if { ::File.exists? "/home/vagrant/src/go" }
end

bash "Go build" do
  cwd "/home/vagrant/src/go/src"
  user "vagrant"
  group "vagrant"
  environment "HOME" => "/home/vagrant"
  code "./all.bash"
  action :run
  not_if { ::File.exists? "/home/vagrant/src/go/bin/go" }
end

ruby_block ".zshrc" do
  block do
    file = Chef::Util::FileEdit.new("/home/vagrant/.zshrc")
    file.insert_line_if_no_match(/GOROOT/, <<EOH)

export GOARCH=amd64
export GOOS=linux
export GOROOT=$HOME/src/go
export GOPATH=$HOME/gop
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
EOH
    file.write_file
  end
end

template "golang.sh" do
  owner  "vagrant"
  group  "vagrant"
  path   "/home/vagrant/golang.sh"
  source "golang.sh.erb"
end

%W{
code.google.com/p/go.tools/cmd/cover
code.google.com/p/go.tools/cmd/eg
code.google.com/p/go.tools/cmd/godex
code.google.com/p/go.tools/cmd/godoc
code.google.com/p/go.tools/cmd/goimports
code.google.com/p/go.tools/cmd/gotype
code.google.com/p/go.tools/cmd/ssadump
code.google.com/p/go.tools/cmd/vet
github.com/daviddengcn/go-colortext
github.com/golang/lint
github.com/jessevdk/go-flags
github.com/jstemmer/gotags
github.com/lestrrat/peco/cmd/peco
github.com/mattn/go-runewidth
github.com/nsf/gocode
github.com/nsf/termbox-go
}.each do |pkg|
  bash "go get #{pkg}" do
  cwd "/home/vagrant"
    user "vagrant"
    group "vagrant"
    environment "HOME" => "/home/vagrant"
    code "source golang.sh; go get #{pkg}"
  end
end

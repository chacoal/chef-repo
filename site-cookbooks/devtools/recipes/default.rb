#
# Cookbook Name:: devtools
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute "Install python build tools" do
  command 'yum -y groupinstall "Development Tools"'
  action :run
end

package "man" do
  action :install
end

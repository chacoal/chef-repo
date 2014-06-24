#
# Cookbook Name:: clang
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%W{
clang-devel
clang-analyzer
}.each do |pkg|
  package pkg do
    action :install
  end
end

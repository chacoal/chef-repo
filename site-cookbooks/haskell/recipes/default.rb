#
# Cookbook Name:: haskell
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%W{
ghc-haskell-platform-devel
}.each do |pkg|
  package pkg do
    action :install
  end
end

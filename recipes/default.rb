#
# Cookbook Name:: extract
# Recipe:: default
#
# Copyright 2012, Asbjorn Kjaer
#
# All rights reserved - Do Not Redistribute
#

%w{ tar unzip bzip2 }.each do |pgk|
   package pkg do
      action :install
   end
end

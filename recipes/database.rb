# Copyright 2015 Martijn van der Woud - The Crimson Cricket Internet Services
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

database_client_host = node['cc-webapp']['database']['client_host']
database_name = node['cc-webapp']['database']['database_name']
database_username = node['cc-webapp']['database']['username']

database_root_password = data_bag_item('credentials', node['cc-webapp']['hostname'])['mysql_root_password']
database_password = data_bag_item('credentials', node['cc-webapp']['hostname'])['mysql_webapp_password']

mysql_service 'default' do
  version '5.7'
  bind_address '0.0.0.0'
  initial_root_password database_root_password
  action [:create, :start]
end


mysql_client 'default' do
  action :create
end


mysql2_chef_gem 'default' do
  action :install
end


mysql_connection_info = {:host => '127.0.0.1',
                         :username => 'root',
                         :password => database_root_password}



mysql_database database_name do
  connection mysql_connection_info
  action :create
end



mysql_database_user database_username do
  connection mysql_connection_info
  password database_password
  host database_client_host
  action :create
end


mysql_database_user database_username do
  connection mysql_connection_info
  database_name database_name
  host database_client_host
  privileges [:all ]
  action :grant
end

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


include_recipe 'cc-webapp-cookbook::mysql_server'

execute 'create_mysql_database' do
  command 'mysql -u root -p' + database_root_password + ' -h 127.0.0.1 -e "CREATE SCHEMA IF NOT EXISTS ' + database_name + ' CHARACTER SET = ' +  node['cc-webapp']['database']['encoding'] + '"'
  sensitive true
end


execute 'create_mysql_user' do
  command 'mysql -u root -p' + database_root_password + ' -h 127.0.0.1 -e "GRANT ALL ON \\`' + database_name + '\\`.* TO \'' + database_username +  '\'@\'' + database_client_host + '\' IDENTIFIED BY \'' + database_password + '\'"'
  sensitive true
end

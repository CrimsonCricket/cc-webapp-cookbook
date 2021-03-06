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


database_root_password = data_bag_item('credentials', node['cc-webapp']['hostname'])['mysql_root_password']
database_data_dir = node['cc-webapp']['database']['data_dir']

mysql_service 'webapp' do
  version node['cc-webapp']['database']['mysql_version']
  package_version node['cc-webapp']['database']['mysql_package_version']
  bind_address '0.0.0.0'
  data_dir database_data_dir
  initial_root_password database_root_password
  action [:create, :start]
end


mysql_client 'default' do
  package_version node['cc-webapp']['database']['mysql_package_version']
  action :create
end



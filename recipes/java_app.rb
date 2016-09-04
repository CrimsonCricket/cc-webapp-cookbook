# Copyright 2016 Martijn van der Woud - The Crimson Cricket Internet Services
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


include_recipe 'cc-webapp-cookbook::hostsfile_entry'
include_recipe 'java'

application_config_dir = '/etc/' + node['cc-webapp']['appname']
application_run_as_user = node['cc-webapp']['application_run_as_user'] % {appname: node['cc-webapp']['appname']}

database_host_ip = node['cc-webapp']['database']['host_ip']
database_name = node['cc-webapp']['database']['database_name']
database_username = node['cc-webapp']['database']['username']

directory application_config_dir do
  owner application_run_as_user
  mode '5500'
end


template application_config_dir + '/persistence.properties' do
  source 'persistence.properties.erb'
  owner application_run_as_user
  mode '0400'
  variables(
      :database_host_ip => database_host_ip,
      :database_name => database_name,
      :database_username => database_username,
      :encrypted_password => node['cc-webapp']['database']['encrypted_password']
  )
end

template application_config_dir + '/log4j.properties' do
  source 'log4j.properties.erb'
  owner application_run_as_user
  mode '0400'
end



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

host_name = node['cc-webapp']['hostname']
internal_host_name = node['cc-webapp']['internal_hostname']
host_ip = node['cc-webapp']['host_ip']


hostsfile_entry host_ip do
  hostname  internal_host_name
  unique    true
end


if node['cc-webapp']['tomcat']['enable_debugger']
  node.override['tomcat']['catalina_options'] =
      node['tomcat']['catalina_options'] +
      ' -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=' + host_ip + ':8000'
end

if node['cc-webapp']['tomcat']['enable_remote_jmx']
  node.override['tomcat']['catalina_options'] = node['tomcat']['catalina_options'] + ' -Dcom.sun.management.jmxremote'
  node.override['tomcat']['catalina_options'] = node['tomcat']['catalina_options'] + ' -Dcom.sun.management.jmxremote.port=9991'
  node.override['tomcat']['catalina_options'] = node['tomcat']['catalina_options'] + ' -Dcom.sun.management.jmxremote.authenticate=false'
  node.override['tomcat']['catalina_options'] = node['tomcat']['catalina_options'] + ' -Dcom.sun.management.jmxremote.ssl=false'
  node.override['tomcat']['catalina_options'] = node['tomcat']['catalina_options'] + ' -Djava.rmi.server.hostname=' + internal_host_name
end


include_recipe 'java'
include_recipe 'tomcat'
include_recipe 'apache2'
include_recipe 'apache2::mod_proxy_ajp'


web_app 'webapp' do
  template 'webapp.conf.erb'
  server_name host_name
  server_admin node['cc-webapp']['admin_email']
  ajp_port node['tomcat']['ajp_port']
end

webapp_config_dir = '/etc/' + node['cc-webapp']['appname']

template node['cc-webapp']['tomcat']['setenv_path'] do
  source 'setenv.sh.erb'
  owner node['tomcat']['user']
  mode '0500'
  variables(
      :app_name => node['cc-webapp']['appname'].upcase,
      :encryption_key => data_bag_item('credentials', host_name)['properties_encryption_key'],
      :webapp_config_dir => webapp_config_dir
  )
end


directory webapp_config_dir do
  owner node['tomcat']['user']
  mode '5500'
end

database_host_ip = node['cc-webapp']['database']['host_ip']
database_name = node['cc-webapp']['database']['database_name']
database_username = node['cc-webapp']['database']['username']


template webapp_config_dir + '/persistence.properties' do
  source 'persistence.properties.erb'
  owner node['tomcat']['user']
  mode '0400'
  variables(
      :database_host_ip => database_host_ip,
      :database_name => database_name,
      :database_username => database_username,
      :encrypted_password => node['cc-webapp']['database']['encrypted_password']
  )
end

template webapp_config_dir + '/log4j.properties' do
  source 'log4j.properties.erb'
  owner node['tomcat']['user']
  mode '0400'
end





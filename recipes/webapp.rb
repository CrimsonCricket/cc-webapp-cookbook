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
app_server_name = node['cc-webapp']['app_server_name']
internal_host_name = node['cc-webapp']['internal_hostname']
host_ip = node['cc-webapp']['host_ip']


hostsfile_entry host_ip do
  hostname  internal_host_name
  unique    true
end


include_recipe 'java'
app_name = node['cc-webapp']['appname']
webapp_config_dir = '/etc/' + node['cc-webapp']['appname']
tomcat_user = 'tomcat_' + app_name


tomcat_install app_name do
  exclude_manager true
  exclude_hostmanager true
end



environment_variables = {
    :JAVA_OPTS => node['cc-webapp']['tomcat']['java_options']
}
environment_variables[app_name.upcase + '_ENCRYPTION_KEY'] = data_bag_item('credentials', host_name)['properties_encryption_key']
environment_variables[app_name.upcase + '_LOGGING_CONFIG'] = webapp_config_dir + '/log4j.properties'

catalina_opts = ''

if node['cc-webapp']['tomcat']['enable_debugger']
  catalina_opts += ' -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=' + host_ip + ':8000'
end


if node['cc-webapp']['tomcat']['enable_remote_jmx']
  catalina_opts += ' -Dcom.sun.management.jmxremote'
  catalina_opts += ' -Dcom.sun.management.jmxremote.port=9991'
  catalina_opts += ' -Dcom.sun.management.jmxremote.authenticate=false'
  catalina_opts += ' -Dcom.sun.management.jmxremote.ssl=false'
  catalina_opts += ' -Djava.rmi.server.hostname=' + internal_host_name
end

if catalina_opts != ''
  environment_variables['CATALINA_OPTS'] = catalina_opts
end


tomcat_service app_name do
  action :start
  env_vars [environment_variables]
end


include_recipe 'apache2'
include_recipe 'apache2::mod_proxy_ajp'


if node['cc-webapp']['enable_ssl']
  include_recipe 'apache2::mod_ssl'

  #make sure to upload the necessary certificate, key and certificate chain in your own recipe
  web_app 'webapp' do
    template 'webapp_ssl.conf.erb'
    server_name app_server_name
    server_admin node['cc-webapp']['admin_email']
    ajp_port node['cc-webapp']['tomcat']['ajp_port']
    certificate_file node['cc-webapp']['certificate_file']
    certificate_key_file node['cc-webapp']['certificate_key_file']
    certificate_chain_file node['cc-webapp']['certificate_chain_file']
  end

  web_app 'webapp_redirect' do
    template 'webapp_redirect_to_https.conf.erb'
    server_name app_server_name
  end

else
  web_app 'webapp' do
    template 'webapp.conf.erb'
    server_name app_server_name
    server_admin node['cc-webapp']['admin_email']
    ajp_port node['cc-webapp']['tomcat']['ajp_port']
  end

end




directory webapp_config_dir do
  owner tomcat_user
  mode '5500'
end

database_host_ip = node['cc-webapp']['database']['host_ip']
database_name = node['cc-webapp']['database']['database_name']
database_username = node['cc-webapp']['database']['username']


template webapp_config_dir + '/persistence.properties' do
  source 'persistence.properties.erb'
  owner tomcat_user
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
  owner tomcat_user
  mode '0400'
end





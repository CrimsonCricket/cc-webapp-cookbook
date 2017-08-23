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

app_name = node['cc-webapp']['appname']
webapp_config_dir = '/etc/' + node['cc-webapp']['appname']


tomcat_install app_name do
	exclude_manager true
	exclude_hostmanager true
end

include_recipe 'cc-webapp-cookbook::java_app'

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
	action [:enable, :start]
	env_vars [environment_variables]
end

include_recipe 'cc-webapp-cookbook::apache_httpd'






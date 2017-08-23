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

app_server_name = node['cc-webapp']['app_server_name']


include_recipe 'apache2'
include_recipe 'apache2::mod_proxy_ajp'

if node['cc-webapp']['enable_web_sockets']
	include_recipe 'apache2::mod_proxy_http'
	include_recipe 'apache2::mod_proxy_wstunnel'
end

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
		enable_web_sockets node['cc-webapp']['enable_web_sockets']
		web_sockets_base_path node['cc-webapp']['web_sockets_base_path']
		http_connector_port node['cc-webapp']['tomcat']['http_port']
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
		enable_web_sockets node['cc-webapp']['enable_web_sockets']
		web_sockets_base_path node['cc-webapp']['web_sockets_base_path']
		http_connector_port node['cc-webapp']['tomcat']['http_port']
	end

end

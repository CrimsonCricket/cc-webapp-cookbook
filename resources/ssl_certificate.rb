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

resource_name :ssl_certificate

property :certificate_file, String, required: true
property :certificate_source, String, required: true
property :ssl_sources_cookbook, String, required: true
property :certificate_chain_file, String, required: true
property :certificate_chain_source, String, required: true
property :certificate_key_file, String, required: true
property :ssl_key, String, required: true


action :install do
	cookbook_file certificate_file do
		source certificate_source
		cookbook ssl_sources_cookbook
		mode '0644'
		owner 'root'
		group 'root'
	end

	cookbook_file certificate_chain_file do
		source certificate_chain_source
		cookbook ssl_sources_cookbook
		mode '0644'
		owner 'root'
		group 'root'
	end

	group 'ssl-cert' do
		action :create
	end

	directory '/etc/ssl/private' do
		owner 'root'
		group 'ssl-cert'
		mode '0710'
		action :create
	end

	template certificate_key_file do
		source 'ssl.key.erb'
		cookbook 'cc-webapp-cookbook'
		owner 'root'
		group 'ssl-cert'
		mode '0640'
		variables(
			:key => ssl_key
		)
	end
end


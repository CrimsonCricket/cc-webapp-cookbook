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


host_name = node['cc-webapp']['hostname']

ssl_certificate 'ssl' do
	certificate_file node['cc-webapp']['certificate_file']
	certificate_source node['cc-webapp']['certificate_source']
	ssl_sources_cookbook node['cc-webapp']['ssl_sources_cookbook']
	certificate_chain_file node['cc-webapp']['certificate_chain_file']
	certificate_chain_source node['cc-webapp']['certificate_chain_source']
	certificate_key_file node['cc-webapp']['certificate_key_file']
	ssl_key data_bag_item('credentials', host_name)['ssl_key']
	action :install
end

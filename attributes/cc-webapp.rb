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

default['cc-webapp']['hostname'] = 'localhost'
default['cc-webapp']['internal_hostname'] = 'localhost'
default['cc-webapp']['app_server_name'] = 'localhost'
default['cc-webapp']['host_ip'] = '127.0.0.1'
default['cc-webapp']['admin_email'] = 'admin@email.com'
default['cc-webapp']['enable_ssl'] = false
default['cc-webapp']['appname'] = 'my_web_app'
default['cc-webapp']['database']['host_ip'] = '127.0.0.1'
default['cc-webapp']['database']['client_host'] = '%'
default['cc-webapp']['database']['database_name'] = 'webapp'
default['cc-webapp']['database']['username'] = 'webapp'
default['cc-webapp']['database']['encrypted_password'] = 'CHANGE_ME'
default['cc-webapp']['database']['mysql_version'] = '5.7'
default['cc-webapp']['logging']['template'] = 'log4j.properties.erb'
default['cc-webapp']['tomcat']['enable_debugger'] = false
default['cc-webapp']['tomcat']['enable_remote_jmx'] = false
default['cc-webapp']['tomcat']['ajp_port'] = 8009
default['cc-webapp']['tomcat']['java_options'] = '-Djava.awt.headless=true -Xmx512m -XX:+UseConcMarkSweepGC -Djava.security.egd=file:/dev/./urandom'

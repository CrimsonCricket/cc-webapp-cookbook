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

name 'cc-webapp-cookbook'
maintainer 'Martijn van der Woud - The Crimson Cricket Internet Services'
maintainer_email 'martijn@crimsoncricket.nl'
license 'Apache 2.0'
description 'Chef recipes for web applications based on Java/Tomcat/Mysql'
long_description 'Chef recipes for web applications based on Java/Tomcat/Mysql'
version '2.1.2'

depends 'hostsfile'
depends 'java'
depends 'tomcat'
depends 'apache2'
depends 'mysql'
depends 'database'
depends 'mysql2_chef_gem'

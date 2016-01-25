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

override['tomcat']['deploy_manager_apps'] = false
override['tomcat']['java_options'] = '-Djava.awt.headless=true -Xmx512m -XX:+UseConcMarkSweepGC -Djava.security.egd=file:/dev/./urandom'
override['tomcat']['tomcat_auth'] = false
override['tomcat']['uriencoding'] = 'UTF-8'
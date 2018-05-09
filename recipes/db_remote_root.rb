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

database_root_password = data_bag_item('credentials', node['cc-webapp']['hostname'])['mysql_root_password']


execute 'create_mysql_user' do
  command 'mysql -u root -p' + database_root_password + ' -h 127.0.0.1 -e "GRANT ALL ON *.* TO \'root\'@\'%\' IDENTIFIED BY \'' + database_root_password + '\' WITH GRANT OPTION"'
  sensitive true
end


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

default['java']['install_flavor'] = 'adoptopenjdk'
default['java']['jdk_version'] = 11
default['java']['adoptopenjdk']['variant'] = 'hotspot'
default['java']['adoptopenjdk']['11']['x86_64']['hotspot']['url'] = 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.7%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.7_10.tar.gz'
default['java']['adoptopenjdk']['11']['x86_64']['hotspot']['checksum'] = 'ee60304d782c9d5654bf1a6b3f38c683921c1711045e1db94525a51b7024a2ca'


override['tomcat']['deploy_manager_apps'] = false
override['tomcat']['java_options'] = '-Djava.awt.headless=true -Xmx512m -XX:+UseConcMarkSweepGC'
override['tomcat']['tomcat_auth'] = false
default['cc-webapp']['tomcat']['setenv_path'] = '/usr/share/tomcat7/bin/setenv.sh'
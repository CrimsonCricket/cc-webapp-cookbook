class Chef
  class Provider
    class Mysql2ChefGem
      class MysqlAssumingClientInstalled < Chef::Provider::LWRPBase
        include Chef::DSL::IncludeRecipe
        use_inline_resources if defined?(use_inline_resources)

        def whyrun_supported?
          true
        end

        action :install do
          include_recipe 'build-essential::default'

          gem_package 'mysql2' do
            gem_binary RbConfig::CONFIG['bindir'] + '/gem'
            version new_resource.gem_version
            action :install
          end
        end

        action :remove do
          gem_package 'mysql2' do
            gem_binary RbConfig::CONFIG['bindir'] + '/gem'
            action :remove
          end
        end
      end
    end
  end
end

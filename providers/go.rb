#
# Author:: Nathan Holland <nathanh@granicus.com>
# Cookbook Name:: application_go
# Provider:: go # # Copyright:: 2015, Granicus, Inc <nathanh@granicus.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


include Chef::DSL::IncludeRecipe

action :before_compile do
end

action :before_deploy do
end

action :before_migrate do
  ['src', 'pkg', 'bin'].each do |directory_name|
    directory ::File.join(go_path, directory_name) do
    end
  end

  directory ::File.join(go_path, 'src', @package) do
  end

  env 'GO_PATH' do
    action :create
    value go_path
  end

  execute 'move original files into go path' do
    command "mv !go #{package_path}"
    cwd release_path
  end

  execute 'get dependencies' do
    command 'go get ./...'
    cwd package_path
  end
end

action :before_symlink do
end

action :before_restart do
  execute 'build binary' do
    command "go build -o #{::File.join(release_path, project_name)}"
    cwd package_path
  end
end

action :after_restart do
end

protected

def package_path
  go_package_path(@package)
end

def project_name
  @package.split('/').last
end

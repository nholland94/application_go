def go_path
  ::File.join(release_path, 'go')
end

def go_package_path(package)
  ::File.join(go_path, 'src', package)
end

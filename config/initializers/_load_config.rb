env_file = "#{Rails.root}/config/env.yml"

if File.exists?(env_file)
  env = YAML.load_file(env_file)
  env.each do |k, v|
    ENV[k] = v if ENV[k].nil?
  end
end

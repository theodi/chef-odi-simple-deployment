define :foremanise, :params => {} do
  name = params[:name]
  user = params[:user]
  cwd = params[:cwd]
  root_dir = params[:root_dir]
  port = params[:port]

  script 'Make dirs for Foreman' do
    interpreter 'bash'
    user 'root'
    code <<-EOF
      mkdir -p /var/log/#{name}
      chown #{user} /var/log/#{name}
      mkdir -p /var/run/#{name}
      chown #{user} /var/run/#{name}
    EOF
  end

  script 'Generate startup scripts with Foreman' do
    interpreter 'bash'
    cwd cwd
    user user
    code <<-EOF
      echo "PATH=/home/#{user}/.rbenv/shims:/usr/local/bin:/usr/bin:/bin" > #{root_dir}/shared/path_env
      /home/#{user}/.rbenv/shims/bundle exec foreman export \
        -a #{name} \
        -u #{user} \
        -t config/foreman \
        -p #{port} \
        -e #{cwd}/.env,#{root_dir}/shared/path_env \
        upstart /tmp/init
    EOF
  end

  script 'Copy startup scripts into the right place' do
    interpreter 'bash'
    user 'root'
    code <<-EOF
      mv /tmp/init/* /etc/init/
    EOF
  end
end

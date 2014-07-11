define :foremanise, :params => {} do
  user = params[:user]

  script 'Make dirs for Foreman' do
    interpreter 'bash'
    user 'root'
    code <<-EOF
      mkdir -p /var/log/#{params[:name]}
      chown #{user} /var/log/#{params[:name]}
      mkdir -p /var/run/#{params[:name]}
      chown #{params[:user]} /var/run/#{params[:name]}
    EOF
  end

  script 'Generate startup scripts with Foreman' do
    interpreter 'bash'
    cwd params[:cwd]
    user params[:user]
    code <<-EOF
      echo "PATH=/home/#{user}/.rbenv/shims:/usr/local/bin:/usr/bin:/bin" > #{params[:root_dir]}/shared/path_env
      /home/#{user}/.rbenv/shims/bundle exec foreman export \
        -a #{params[:name]} \
        -u #{user} \
        -t config/foreman \
        -p 3000 \
        -e #{cwd}/.env,#{params[:root_dir]}/shared/path_env \
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

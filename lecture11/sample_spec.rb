require 'spec_helper'

# web server がインストールされているかをテスト
describe package('nginx') do
  it { should be_installed }
end

# web server が動作しているかをテスト
describe service('nginx') do
  it { should be_running }
end

# http port　テスト
describe port(80) do
  it { should be_listening }
end

# ssh port テスト
describe port(22) do
  it { should be_listening }
end

# localhost 接続テスト
describe command('curl http://127.0.0.1:#{listen_port}/_plugin/head/ -o /dev/null -w "%{http_code}\n" -s') do
  its(:stdout) { should match /^200$/ }
end

# DB テスト
describe service('mysqld') do
  it { should be_enabled }
  it { should be_running }
end

# DB port テスト
describe port(3306) do
  it { should be_listening }
end 

# IP の ping をテスト
describe host('18.181.154.185') do
  it { should be_reachable }
end

# 代码生成时间: 2025-09-20 17:50:09
# 进程管理器API
class ProcessManagerAPI < Grape::API
  # 列出当前所有进程
  get '/processes' do
    # 获取当前系统中的所有进程
    processes = `ps -ef`.split('\
').drop(1)
    # 格式化进程信息
    processes.map { |process| process.split(' ', 11)[0..10].join(' ') }.to_json
  end

  # 启动一个新进程
  post '/processes/:start_command' do
    start_command = params[:start_command]
    # 错误处理
    if start_command.nil? || start_command.empty?
      error!('Start command is required', 400)
    end
    # 启动新进程
    output, status = Open3.capture2e(start_command)
    if status.success?
      'Process started successfully'.to_json
    else
      error!("Failed to start process: #{output}", 500)
    end
  end

  # 停止一个进程
  delete '/processes/:pid' do
    pid = params[:pid]
    # 错误处理
    unless pid.is_a?(Integer) && pid > 0
      error!('Invalid process ID', 400)
    end
    # 停止进程
    system(
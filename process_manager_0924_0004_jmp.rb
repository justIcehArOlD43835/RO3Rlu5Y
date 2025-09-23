# 代码生成时间: 2025-09-24 00:04:57
# 进程管理器 Grape API
class ProcessManager < Grape::API
  # 列出所有运行中的进程
  get '/processes' do
    # 使用 `ps` 命令列出所有进程，并使用 `grep` 过滤特定进程
    # 这里以列出所有 Ruby 进程为例
    `ps aux | grep ruby`
  end

  # 启动一个新的进程
  post '/start_process' do
    # 接收一个参数，指定要启动的进程名称
    params = params_with_pagination
    process_name = params[:process_name]

    # 检查进程名称是否提供
    error!('Process name is required', 400) if process_name.blank?

    # 使用 `system` 方法启动进程
    # 这里以启动一个简单的 Ruby 脚本为例
    system("ruby #{process_name}")
  end

  # 停止一个进程
  delete '/stop_process/:pid' do
    # 从 URL 参数中获取进程 ID
    pid = params[:pid]

    # 检查进程 ID 是否提供
    error!('Process ID is required', 400) if pid.blank?

    # 使用 `kill` 命令停止进程
    # 这里使用 `SIGTERM` 信号，可以根据需要使用其他信号
    system("kill -SIGTERM #{pid}")
  end

  # 错误处理中间件
  error(StandardError) do
    # 返回一个错误响应
    { error: 'An error occurred', status: status }
  end
end

# 运行 Grape API
run! if __FILE__ == $0
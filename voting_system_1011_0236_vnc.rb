# 代码生成时间: 2025-10-11 02:36:21
# 定义投票实体
class Vote < Grape::Entity
  expose :id, documentation: { type: 'integer', desc: '唯一标识符' }
  expose :voter_id, documentation: { type: 'integer', desc: '投票者ID' }
  expose :option_id, documentation: { type: 'integer', desc: '投票选项ID' }
end

# 定义选项实体
class Option < Grape::Entity
  expose :id, documentation: { type: 'integer', desc: '唯一标识符' }
  expose :text, documentation: { type: 'string', desc: '选项文本' }
end

# 定义投票系统API
class VotingAPI < Grape::API
  # 列出所有选项
  get '/options' do
    # 假设有一个选项集合
    options = [
      { id: 1, text: 'Option 1' },
      { id: 2, text: 'Option 2' },
      { id: 3, text: 'Option 3' }
    ]
    present options, with: Option
  end

  # 投票
  post '/vote' do
    # 解析请求体
    vote = JSON.parse(request.body.read)
    # 验证参数
    error!('Voter ID is missing', 400) if vote['voter_id'].nil?
    error!('Option ID is missing', 400) if vote['option_id'].nil?
    # 这里可以添加数据库操作，保存投票记录
    # 假设投票成功
    present({ id: 1, voter_id: vote['voter_id'], option_id: vote['option_id'] }, with: Vote)
  end
end

# 配置Swagger文档
add_swagger_documentation base_path: '/api',
  mount_path: '/swagger',
  api_version: 'v1'

# 运行API
run! if __FILE__ == $0

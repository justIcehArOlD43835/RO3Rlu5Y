# 代码生成时间: 2025-09-17 23:25:16
# 数据库配置
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'users.db')

# 用户模型
class User < ActiveRecord::Base
  # 密码加密
  has_secure_password
  # 验证用户名和密码是否正确
  validate :authenticate_user!
end

# 用户实体
class UserEntity < Grape::Entity
  expose :id
  expose :username
  expose :password, documentation: { hidden: true }
end

# 登录验证系统
class LoginAPI < Grape::API
  format :json
  content_type :json, 'application/json'
  prefix :api
  mount_path '/login'

  # 登录路由
  params do
    requires :username, type: String, desc: '用户名'
    requires :password, type: String, desc: '密码'
  end
  post '/login' do
    user = User.find_by(username: params[:username])
    if user&.valid_password?(params[:password])
      # 生成token
      token = user.create_token
      { success: true, message: '登录成功', token: token }
    else
      # 登录失败
      error!('用户名或密码错误', 401)
    end
  end

  # 私有方法
  private
  # 验证用户名和密码是否正确
  def authenticate_user!
    if !user || !user.valid_password?(password)
      errors.add(:base, '用户名或密码错误')
    end
  end
end

# 数据库迁移
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :authentication_token
      t.timestamps
    end
  end
end

# 运行数据库迁移
CreateUsers.new.change

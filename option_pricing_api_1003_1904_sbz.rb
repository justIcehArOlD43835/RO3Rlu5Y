# 代码生成时间: 2025-10-03 19:04:47
# 使用GRAPE框架创建的期权定价API
require 'grape'
require 'grape-entity'
require 'json'

# 导入数学库，用于计算期权定价
require 'mathn'

# 定义期权定价实体
class OptionPricingEntity < Grape::Entity
  expose :s, documentation: { type: 'float', desc: '股票当前价格' }
  expose :k, documentation: { type: 'float', desc: '期权执行价格' }
  expose :t, documentation: { type: 'float', desc: '到期时间（年）' }
  expose :r, documentation: { type: 'float', desc: '无风险利率' }
  expose :sigma, documentation: { type: 'float', desc: '股票波动率' }
  expose :type, documentation: { type: 'string', desc: '期权类型（call或put）' }
end

# 定义期权定价API
class OptionPricingAPI < Grape::API
  # 定义API版本
  version 'v1', using: :path
  # 定义API前缀
  prefix 'api'

  # 定义GET请求路径
  get '/option_pricing' do
    # 验证参数
    params = params_with_coefficient
    if params[:type] != 'call' && params[:type] != 'put'
      error!('400', 'Invalid option type')
    end

    # 调用期权定价模型
    price = option_price(params)

    # 返回期权定价结果
    {
      price: price,
      params: params
    }.to_json
  end

  private

  # 定义系数参数
  def params_with_coefficient
    declared(params).merge(
      s: params[:s].to_f,
      k: params[:k].to_f,
      t: params[:t].to_f,
      r: params[:r].to_f,
      sigma: params[:sigma].to_f,
      type: params[:type].to_s
    )
  end

  # 定义期权定价模型
  def option_price(params)
    # 使用Black-Scholes模型计算欧式期权价格
    s = params[:s]
    k = params[:k]
    t = params[:t]
    r = params[:r]
    sigma = params[:sigma]
    type = params[:type]

    d1 = Math.sqrt(t) * ((Math.log(s / k) + (r + 0.5 * sigma ** 2) * t) / (sigma * Math.sqrt(t)))
    d2 = d1 - sigma * Math.sqrt(t)

    if type == 'call'
      price = s * Math.exp(-r * t) * cumulative_distribution_function(d1) - k * Math.exp(-r * t) * cumulative_distribution_function(d2)
    else
      price = k * Math.exp(-r * t) * (1 - cumulative_distribution_function(-d2)) - s * Math.exp(-r * t) * (1 - cumulative_distribution_function(-d1))
    end

    price
  end

  # 定义标准正态分布的累积分布函数
  def cumulative_distribution_function(x)
    (1 + Math.erf(x / (Math.sqrt(2) * 1.7155))) / 2.0
  end
end

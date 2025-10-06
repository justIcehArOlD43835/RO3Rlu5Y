# 代码生成时间: 2025-10-07 02:09:19
# TextFileAnalyzer is a Grape API for analyzing text files
class TextFileAnalyzer < Grape::API
  # 定义用于分析的实体
  class AnalysisResultEntity < Grape::Entity
    expose :word_count, :character_count, :line_count
  end

  # 定义路由和分析逻辑
  namespace :analyze do
    params do
      requires :file_path, type: String, desc: 'The path to the text file for analysis'
    end
    get do
      # 错误处理：检查文件是否存在
      unless File.exist?(params[:file_path])
        error!('File not found', 404)
      end

      # 读取文件并进行分析
      content = File.read(params[:file_path])
      word_count = content.scan(/\w+/).length
      character_count = content.length
      line_count = content.count("
") + 1

      # 返回分析结果
      present({
        word_count: word_count,
        character_count: character_count,
        line_count: line_count
      }, with: AnalysisResultEntity)
    end
  end
end

# 运行Grape API
run!
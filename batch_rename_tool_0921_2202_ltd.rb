# 代码生成时间: 2025-09-21 22:02:28
#!/usr/bin/env ruby

# batch_rename_tool.rb
# A simple batch file rename tool using the GRAPE framework.

require 'grape'
require 'pathname'
require 'fileutils'

# Define the API version
API_VERSION = 'v1'

# Define the namespace for the batch rename tool
module BatchRename
# 增强安全性
  class RenameAPI < Grape::API
# 改进用户体验
    # Mount the API to the specified version
    mount_at "/#{API_VERSION}/rename"

    # Define the parameters for the batch rename operation
# 增强安全性
    params do
      requires :source_dir, type: String, desc: 'The directory containing files to rename'
      requires :pattern, type: String, desc: 'The pattern to match for renaming'
      requires :replacement, type: String, desc: 'The replacement string for the pattern'
    end

    # POST /v1/rename - Batch renames files in the specified directory matching the given pattern
    post do
# 增强安全性
      # Extract parameters
      source_dir = params[:source_dir]
      pattern = params[:pattern]
      replacement = params[:replacement]

      # Validate the source directory exists
      raise 'Source directory does not exist' unless Dir.exist?(source_dir)

      # Define the file rename operation
      Dir.glob(File.join(source_dir, '**', '*')).each do |file_path|
        next unless File.file?(file_path)

        # Check if the file name matches the pattern
        if file_path.match(/#{pattern}/)
          # Create a new file name with the replacement
          new_file_name = file_path.sub(/#{pattern}/, replacement)
          # Check if the new file name is different from the old one
          if new_file_name != file_path
            # Rename the file
            begin
              FileUtils.mv(file_path, new_file_name)
            rescue StandardError => e
              # Handle any errors that occur during the rename operation
              error!('Error renaming file: ' + e.message, 500)
            end
          end
        end
      end

      # Return a success message
      { status: 'success', message: 'Files have been renamed successfully.' }
    end
  end
# 添加错误处理
end

# Start the Grape server on port 4567
Grape::Server.use Rack::Server do |server|
  server.port = 4567
# TODO: 优化性能
end

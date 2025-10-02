# 代码生成时间: 2025-10-02 23:12:46
# 图论算法实现
# 使用Grape框架

require 'grape'
require 'set'

module Graph
  class API < Grape::API
    # 定义图的基本结构
    class Graph
      attr_accessor :nodes, :edges
      
      def initialize
        @nodes = Set.new
        @edges = []
      end
      
      # 添加节点
      def add_node(node)
        @nodes.add(node)
      end
      
      # 添加边
      def add_edge(node1, node2)
        @edges.push([node1, node2])
      end
      
      # 验证图是否连通
      def connected?
        visited = Set.new
        depth_first_search(@nodes.first, visited)
        visited.length == @nodes.length
      end
      
      # 深度优先搜索
      def depth_first_search(current_node, visited)
        visited.add(current_node)
        @edges.each do |edge|
          if edge.include?(current_node) && !visited.include?(edge - [current_node].first)
            depth_first_search(edge - [current_node].first, visited)
          end
        end
      end
    end
    
    # 定义API路由
    resources :graphs do
      # 创建图
      post do
        graph = Graph::Graph.new
        # 添加节点和边
        params.each do |key, value|
          case key
          when 'nodes'
            value.each { |node| graph.add_node(node) }
          when 'edges'
            value.each { |edge| graph.add_edge(edge.first, edge.last) }
          else
            error!('Invalid parameter', 400)
          end
        end
        # 返回图是否连通的结果
        { connected: graph.connected? }
      end
    end
  end
end

# 运行API服务
run Graph::API
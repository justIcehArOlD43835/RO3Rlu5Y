# 代码生成时间: 2025-10-09 22:34:54
# cluster_management.rb
# This Grape API provides a simple cluster management system.

require 'grape'
require 'grape-entity'
require 'active_support/core_ext/hash/deep_merge'

# Define entities for request and response
class ClusterEntity < Grape::Entity
  expose :id, documentation: { type: 'integer', desc: 'Unique identifier for the cluster' }
  expose :name, documentation: { type: 'string', desc: 'Name of the cluster' }
  expose :nodes, using: NodeEntity, documentation: { type: 'NodeEntity', desc: 'Nodes belonging to the cluster' }
end

class NodeEntity < Grape::Entity
  expose :id, documentation: { type: 'integer', desc: 'Unique identifier for the node' }
  expose :ip, documentation: { type: 'string', desc: 'IP address of the node' }
  expose :status, documentation: { type: 'string', desc: 'Current status of the node' }
end

# Define the Cluster API
class ClusterAPI < Grape::API
  format :json

  # Fetch a list of all clusters
  get '/clusters' do
    # Fetch clusters from a database or external service (mocked here)
    clusters = [
      { id: 1, name: 'Cluster A', nodes: [{ id: 101, ip: '192.168.1.1', status: 'active' }] },
      { id: 2, name: 'Cluster B', nodes: [{ id: 102, ip: '192.168.1.2', status: 'inactive' }] }
    ]
    present clusters, with: ClusterEntity
  end

  # Create a new cluster
  post '/clusters' do
    # Validate request parameters
    cluster_params = declared(params).merge({ nodes: [] }) # Ensure nodes is always present
    unless cluster_params[:name] && cluster_params[:nodes].is_a?(Array)
      error!('Invalid cluster parameters', 400)
    end
    # Create cluster in a database or external service (mocked here)
    new_cluster = { id: SecureRandom.uuid, name: cluster_params[:name], nodes: cluster_params[:nodes] }
    { cluster: new_cluster }
  end

  # Fetch a specific cluster by ID
  get '/clusters/:id' do
    cluster = find_cluster(params[:id])
    error!('Cluster not found', 404) unless cluster
    present cluster, with: ClusterEntity
  end

  # Update a cluster
  put '/clusters/:id' do
    cluster = find_cluster(params[:id])
    error!('Cluster not found', 404) unless cluster
    cluster_params = declared(params)
    # Update cluster in a database or external service (mocked here)
    updated_cluster = cluster.deep_merge(cluster_params)
    { cluster: updated_cluster }
  end

  # Delete a cluster
  delete '/clusters/:id' do
    cluster = find_cluster(params[:id])
    error!('Cluster not found', 404) unless cluster
    # Delete cluster from a database or external service (mocked here)
  end

  private

  # Mock method to find a cluster by ID
  def find_cluster(id)
    clusters = [
      { id: 1, name: 'Cluster A', nodes: [{ id: 101, ip: '192.168.1.1', status: 'active' }] },
      { id: 2, name: 'Cluster B', nodes: [{ id: 102, ip: '192.168.1.2', status: 'inactive' }] }
    ]
    clusters.find { |cluster| cluster[:id] == id.to_s }
  end
end

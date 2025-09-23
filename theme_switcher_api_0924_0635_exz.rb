# 代码生成时间: 2025-09-24 06:35:19
# Define a simple entity for the theme
class ThemeEntity < Grape::Entity
  expose :id, documentation: { type: 'integer', desc: 'Theme identifier' }
  expose :name, documentation: { type: 'string', desc: 'Theme name' }
end

# Define the API version
class ThemeApi < Grape::API
  # Version 1 of the API
  version 'v1', using: [:header, :path], vendor: 'my-api'
  format :json

  # Routes
  resource :themes do
    # List available themes
    get do
      # Error handling
      error!('No themes found', 404) if Theme.none?
      # Retrieve all themes
      Theme.all.map { |theme| present theme, with: ThemeEntity }
    end

    # Switch themes
    put ':theme_id/switch' do
      # Error handling
      error!('Theme not found', 404) unless theme = Theme.find(params[:theme_id])
      # Error handling
      error!('Invalid theme transition', 422) unless theme.can_switch?

      # Update the theme status and return the updated theme
      present theme.update_attribute(:active, true), with: ThemeEntity
    end
  end
end

# Example Theme model (should be in a separate model file)
class Theme < ActiveRecord::Base
  # Check if the theme can be switched
  def can_switch?
    # Simple check for illustration purposes
    # In a real-world scenario, this would include more logic
    active == false
  end
end
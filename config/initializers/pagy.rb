# frozen_string_literal: true

require 'pagy/extras/bootstrap'
require 'pagy/backend'
require 'pagy/frontend'
Pagy::DEFAULT[:size] = [3, 4, 4, 3] # nav bar links
# Better user experience handled automatically
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page

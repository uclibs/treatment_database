# frozen_string_literal: true

require 'pagy/extras/bootstrap'
require 'pagy/backend'
require 'pagy/frontend'
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page

# frozen_string_literal: true

# Use this variable to enable or disable Shibboleth authentication
# example:
# if SHIBBOLETH_ENABLED
#   # do something
# else
#   # do something else
# end

shibboleth_config = YAML.safe_load(ERB.new(Rails.root.join('config/shibboleth.yml').read).result)
SHIBBOLETH_ENABLED = shibboleth_config[Rails.env]['shibboleth_enabled']

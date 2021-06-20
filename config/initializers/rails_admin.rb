require "nested_form/engine"
require "nested_form/builder_mixin"

RailsAdmin.config do |config|
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  config.audit_with :paper_trail, 'Person', 'PaperTrail::Version'

  config.excluded_models << Admin

  config.show_gravatar = false

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    history_index
    history_show
  end
end

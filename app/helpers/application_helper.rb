module ApplicationHelper
  def status(model)
    I18n.t model.workflow_state, scope: [:workflow_state]
  end
end

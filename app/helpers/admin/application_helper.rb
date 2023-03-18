module Admin::ApplicationHelper
  def raicon_data_attributes
    {
      data: {
        'raicon-controller': controller_path,
        'raicon-action': action_name
      }
    }
  end
end

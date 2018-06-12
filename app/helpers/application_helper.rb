module ApplicationHelper
  def alert_class_for(flash_type)
    {
      success: "bg-success",
      error: "bg-error",
      alert: "bg-warning",
      notice: "bg-info",
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end

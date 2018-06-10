module ApplicationHelper
  def alert_class_for(flash_type)
    {
      success: "bg-green-light",
      error: "bg-red-light",
      alert: "bg-red-light",
      notice: "bg-blue-light",
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end

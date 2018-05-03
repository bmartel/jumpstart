module ApplicationHelper
  def alert_class_for(flash_type)
    {
      success: "bg-green-lighter text-green",
      error: "bg-red-lighter text-red",
      alert: "bg-yellow-lighter text-yellow",
      notice: "bg-blue-lighter text-blue",
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end

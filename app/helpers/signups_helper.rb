module SignupsHelper
  def status_badge_class(status)
    case status
    when 'pending'
      'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300'
    when 'approved'
      'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300'
    when 'denied'
      'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300'
    else
      'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300'
    end
  end
end

[Date, DateTime, Time].each do |clazz|
  clazz.class_eval { include ::DateExtensions }
end

# extensions for Date classes
module DateExtensions
  # like upto but step by month
  def upto_by_month(max)
    da = self.dup.to_date
    while da <= max.to_date
      yield da
      da = da >> 1
    end
  end

  # like upto but step by year
  def upto_by_year(max, &block)
    da = self.dup.to_date
    while da <= max
      yield da
      da = da >> 12
    end
  end
end
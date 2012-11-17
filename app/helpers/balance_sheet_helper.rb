module BalanceSheetHelper

  def balances_by_risk_class_chart_url(dataset, colors)
    data_values, set_colors, set_labels = [], [], []

    # collect credit/debit data, colors and labels for legend
    [ :credit, :debit ].each do |key|
      colors.reverse_each do |colspec|
        risk_class_id = colspec.first
        values = dataset.collect {|m| m[:"#{key}_by_risk_class"][risk_class_id].to_i / 1000.0 }
        if !values.all?(&:zero?)
          set_colors << colspec.second[key]
          set_labels << "#{t "balance_sheet.#{key}"}: #{colspec.second[:label]}"
          data_values << values
        end
      end
    end

    # collect x axis labels
    total_labels = dataset.collect {|m| number_with_precision(m[:total] / 1000.0, :precision => 1) }
    month_labels = dataset.collect {|m| m[:date].to_datetime.to_s(:short_month) }
    year_labels = dataset.collect {|m| m[:date].month == 1 ? m[:date].year : "" }

    # calculate y axis bounds
    lower_bound = dataset.collect {|m| m[:debit] }.min.to_i / 1000.0
    upper_bound = dataset.collect {|m| m[:credit] }.max.to_i / 1000.0
    lower_bound, upper_bound = bounds_with_margin(lower_bound, upper_bound)

    # calculate position of zero line (percent of chart height)
    zero_position = zero_axis(lower_bound, upper_bound)

    "http://chart.apis.google.com/chart?" <<
      "cht=bvs&" << # vertical stacked bar chart
      "chd=t:#{data_values.map{|s| s.join(',')}.join('|')}&" << # data sets
      "chds=#{lower_bound},#{upper_bound}&chxr=2,#{lower_bound},#{upper_bound}|5,#{lower_bound},#{upper_bound}&" << # scaling and y axis range
      "chxt=x,x,y,t,t,r&chxl=0:|#{month_labels.join('|')}|1:|#{year_labels.join('|')}|4:||||||#{t 'balance_sheet.total'}:|3:|#{total_labels.join('|')}&" << # axis & labels
      "chm=h,AAAAAA,0,#{'%0.5f' % zero_position},0.5,-1&" << # zero line
      "chs=710x400&chbh=25,15&chco=#{set_colors.join(',')}&" << # size and style
      "chdl=#{set_labels.join('|')}&chdlp=r&" << # legend
      "chtt=#{t 'balance_sheet.balances_by_risk_class_chart_title'}" # title
  end

  def asset_growth_chart_url(dataset)
    data_values = dataset.collect {|m| m[:total].to_i / 1000.0 }

    # collect x axis labels
    total_labels = dataset.collect {|m| m[:date].month == 12 || m == dataset.last ? number_with_precision(m[:total].to_i / 1000.0, :precision => 1) : ""}
    year_labels = dataset.collect {|m| m[:date].month == 1 ? m[:date].year : " " }

    # calculate y axis bounds
    lower_bound = dataset.collect {|m| m[:total].to_i }.min.to_i / 1000.0
    lower_bound = 0 if lower_bound > 0
    upper_bound = dataset.collect {|m| m[:total].to_i }.max.to_i / 1000.0
    lower_bound, upper_bound = bounds_with_margin(lower_bound, upper_bound)

    # calculate position of zero line (percent of chart height)
    zero_position = zero_axis(lower_bound, upper_bound)

    "http://chart.apis.google.com/chart?" <<
      "cht=lc&" << # line chart
      "chd=t:#{data_values.map(&:to_s).join(',')}&" << # data sets
      "chds=#{lower_bound},#{upper_bound}&chxr=1,#{lower_bound},#{upper_bound}|4,#{lower_bound},#{upper_bound}&" << # scaling and y axis range
      "chxt=x,y,t,t,r&chxs=0,0000DD,lt&chxtc=0,4&chxl=0:|#{year_labels.join('|')}|3:||||||#{t 'balance_sheet.total'}:|2:|#{total_labels.join('|')}&" << # axis & labels
      "chs=710x300&chls=4&chco=9DFF00&" << # size and style
      "chtt=#{t 'balance_sheet.asset_growth_chart_title'}" # title
  end

  def future_payments_chart_url(dataset)
    # all data points for min/max/bounds/hline calculations
    values = [ 0,
               dataset[:balance],
               dataset[:balance] - dataset[:payouts],
               dataset[:balance] - dataset[:payouts] + dataset[:deposits],
               dataset[:total]
             ].map {|v| v.to_i / 1000.0}

    # calculate payout/deposit bar sections
    payouts_base, payouts_positive_section, payouts_negative_section = split_bar(dataset[:balance], dataset[:balance] - dataset[:payouts])
    deposits_base, deposits_positive_section, deposits_negative_section = split_bar(dataset[:balance] - dataset[:payouts], dataset[:total])

    data_values =  [ [ 0, payouts_base, deposits_base, 0] ]     # invisible "pedastals" for payout/deposits bars
    data_values << [ dataset[:balance], 0, 0, dataset[:total] ] # balance and total
    data_values << [ 0, payouts_positive_section, 0, 0 ]        # positive section of payouts
    data_values << [ 0, payouts_negative_section, 0 ,0 ]        # negative section of payouts
    data_values << [ 0, 0, deposits_positive_section, 0 ]       # positive section of deposits
    data_values << [ 0, 0, deposits_negative_section, 0 ]       # negative section of deposits

    total_labels = [dataset[:balance], -dataset[:payouts], dataset[:deposits], dataset[:total] ].collect {|v| "#{number_with_delimiter(v.round)}€" }

    # calculate y axis bounds
    lower_bound, upper_bound = bounds_with_margin(values.min, values.max)

    # calculate positions of horizontal lines (percent of chart height)
    hline_positions = values.collect {|v| horizontal_position(v, lower_bound, upper_bound)}

    "http://chart.apis.google.com/chart?" <<
      "cht=bvs&" << # vertical stacked bar chart
      "chd=t:#{data_values.collect{|s| s.map{|v| v / 1000}.join(',')}.join('|')}&" << # data sets
      "chxr=2,#{lower_bound},#{upper_bound}|3,#{lower_bound},#{upper_bound}&chds=#{lower_bound},#{upper_bound}&" << # scaling and y axis range
      "chxt=x,x,y,r&chxl=1:|#{total_labels.join('|')}|0:|#{t 'balance_sheet.balances'}|#{t 'balance_sheet.payouts'}|#{t 'balance_sheet.deposits'}|#{t 'balance_sheet.sum'}&" << # axis & labels
      "chm=#{hline_positions.map {|p| "h,AAAAAA,0,#{'%0.5f' % p},0.5,-1"}.join('|') }&" << # horizontal lines
      "chs=350x250&chco=00000000,999999,FF6600,FF6600,9DFF00,9DFF00&chbh=30,50&" << # size and style
      "chtt=#{t 'balance_sheet.future_payments_chart_title'}" # title
  end

  def balances_by_account_class_chart_url(dataset, colors)
    values, labels, set_colors = [], [], []

    dataset.reject {|s| s.first.nil?}.sort {|a,b|
      brightness(colors[b.first][:color]) <=> brightness(colors[a.first][:color])
    }.each do |account_class, total|
      next if total <= 0 # accounts with positive credit balance only
      values << total
      labels << (colors[account_class] ? colors[account_class][:label] : t('balance_sheet.unknown_account_class'))
      set_colors << colors[account_class][:color]
    end
    set_colors = ['9DFF00'] if set_colors.compact.empty?

    "http://chart.apis.google.com/chart?" <<
      "cht=p&" << # 2D pie chart
      "chd=t:#{values.join(',')}&" << # data set
      "chds=0,#{values.max}&" << # data scaling
      "chl=#{labels.join('|')}&" << # labels
      "chs=360x175&chco=#{set_colors.join(',')}&" << # size and colors
      "chtt=#{t 'balance_sheet.balances_by_account_class_chart_title'}" # title
  end

private

  def brightness(color)
    color.scan(/../).inject(0) {|sum,v| sum + v.hex } rescue 0
  end

  def zero_axis(lower_bound, upper_bound)
    horizontal_position(0, lower_bound, upper_bound)
  end

  def horizontal_position(value, lower_bound, upper_bound)
    (lower_bound.abs + value) / [lower_bound, upper_bound].map(&:abs).sum
  end

  def bounds_with_margin(lower_bound, upper_bound, relative_margin = 0.1)
    margin = [lower_bound, upper_bound].map(&:abs).max * relative_margin
    return lower_bound.zero? ? lower_bound : lower_bound - margin, upper_bound + margin
  end

  def split_bar(y_from, y_to)
    base = positive_section = negative_section = 0
    if (y_from > 0 && y_to > 0) || (y_from < 0 && y_to < 0) # bar does not cross zero axis
      base = y_from.abs < y_to.abs ? y_from : y_to
      if y_from > 0 # is bar completely in positive section?
        positive_section = (y_to - y_from).abs
      else          # bar is completely in negative section
        negative_section = -(y_to - y_from).abs
      end
    else # bar crosses zero axis
      positive_section = y_from > 0 ? y_from : y_to
      negative_section = y_from < 0 ? y_from : y_to
    end
    return base, positive_section, negative_section
  end

end

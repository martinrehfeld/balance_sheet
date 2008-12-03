module BalanceSheetHelper
  
  def balances_by_risk_class_chart_url(dataset, colors)
    data_values, set_colors, set_labels = [], [], []

    # collect credit/debit data, colors and labels for legend
    [ {:reverse_each => :credit}, {:each => :debit} ].each do |processing_instruction|
      iterator, key = processing_instruction.keys.first, processing_instruction.values.first
      colors.send iterator do |colspec|
        risk_class_id = colspec.first
        values = dataset.collect {|m| m[:"#{key}_by_risk_class"][risk_class_id].to_i / 1000.0 }
        if !values.all?(&:zero?)
          set_colors << colspec[1][key]
          set_labels << "#{t "balance_sheet.#{key}"}: #{colspec[1][:label]}"
          data_values << values
        end
      end
    end

    # collect x axis labels
    total_labels = dataset.collect {|m| number_with_delimiter(m[:total].to_i) }
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
  
  def future_payments_chart_url(dataset)
    dataset = { :balance => 60000, :payouts => 10000, :deposits => 30000, :total => 80000 }
    values = [ 0, dataset[:balance],
               dataset[:balance] - dataset[:payouts],
               dataset[:balance] - dataset[:payouts] + dataset[:deposits],
               dataset[:total] ].map {|v| v.to_i / 1000.0}
    
    payouts_base = dataset[:balance] - dataset[:payouts] > 0 ? dataset[:balance] - dataset[:payouts] : 0
    data_values =  [ [ 0, payouts_base, payouts_base, 0] ] # invisible "pedastal" for payout/deposits bars
    data_values << [ dataset[:balance], 0, 0, dataset[:total] ] # balance and total
    data_values << [ 0, 10000, 0, 0 ] # positive section of payouts
    data_values << [ 0, 0, 0 ,0 ] # negative section of payouts
    data_values << [ 0, 0, 30000, 0 ] # positive section of deposits
    data_values << [ 0, 0, 0 ,0 ] # negative section of deposits
    
    total_labels = [dataset[:balance], -dataset[:payouts], dataset[:deposits], dataset[:total] ].collect {|v| number_with_delimiter(v) + '€' }

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
  
private

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

end

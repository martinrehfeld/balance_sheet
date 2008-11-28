module BalanceSheetHelper
  
  def google_chart_url(dataset, colors)
    data_values = []
    set_colors = []
    set_labels = []
    
    # collect credit data
    colors.reverse_each do |colspec|
      risk_class_id = colspec.first
      values = dataset.collect {|m| m[:credit_by_risk_class][risk_class_id] || 0.0 }
      if !values.all?(&:zero?)
        set_colors << colspec[1][:credit]
        set_labels << "credit: #{colspec[1][:label]}"
        data_values << values
      end
    end

    # collect debit data 
    colors.each do |colspec|
      risk_class_id = colspec.first
      values = dataset.collect {|m| m[:debit_by_risk_class][risk_class_id] || 0.0 }
      if !values.all?(&:zero?)
        set_colors << colspec[1][:debit]
        set_labels << "debit: #{colspec[1][:label]}"
        data_values << values
      end
    end
    
    total_labels = dataset.collect {|m| "%0.0f" % m[:total] }
    month_labels = dataset.collect {|m| m[:date].strftime("%b") }
    year_labels = dataset.collect {|m| m[:date].month == 1 ? "#{m[:date].year}..." : "" }
    
    lower_bound = dataset.collect {|m| m[:debit] }.min * 1.05
    upper_bound = dataset.collect {|m| m[:credit] }.max * 1.05
    
    "http://chart.apis.google.com/chart?" <<
      "cht=bvs&" << # vertical stacked bar chart
      "chd=t:#{data_values.map{|s| s.join(',')}.join('|')}&" << # data sets
      "chds=#{lower_bound},#{upper_bound}&chxr=2,#{lower_bound},#{upper_bound}|5,#{lower_bound},#{upper_bound}&" << # scaling and y axis range
      "chxt=x,x,y,t,t,r&chxl=0:|#{month_labels.join('|')}|1:|#{year_labels.join('|')}|4:||||||Total:|3:|#{total_labels.join('|')}&" << # axis & labels
      "chs=710x400&chbh=25,15&chco=#{set_colors.join(',')}&" << # size and style
      "chdl=#{set_labels.join('|')}&chdlp=r&" << # legend
      "chtt=Monthly Balances By Risk Class" # title
  end

end

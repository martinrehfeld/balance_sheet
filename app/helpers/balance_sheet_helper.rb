module BalanceSheetHelper
  
  def google_chart_url(dataset, colors)
    credit_dataset = dataset.collect {|m| m[:credit] }
    minimum = credit_dataset.min
    
    debit_dataset = dataset.collect {|m| m[:debit] }
    maximum = debit_dataset.max
    
    data_values = []
    set_colors = []
    set_labels = []
    
    # collect credit data
    colors.each do |colspec|
      risk_class_id = colspec.first
      set_colors << colspec[1][:credit]
      set_labels << colspec[1][:label]
      data_values << dataset.collect {|m| m[:credit_by_risk_class][risk_class_id] || 0 }
    end

    # collect debit data 
    colors.reverse_each do |colspec|
      risk_class_id = colspec.first
      set_colors << colspec[1][:debit]
      set_labels << colspec[1][:label]
      data_values << dataset.collect {|m| m[:debit_by_risk_class][risk_class_id] || 0 }
    end
    
    total_labels = dataset.collect {|m| "%0.0f" % m[:total] }
    month_labels = dataset.collect {|m| m[:date].strftime("%b") }
    year_labels = dataset.collect {|m| m[:date].month == 1 ? "#{m[:date].year}..." : "" }
    
    bound = [minimum, maximum].map(&:abs).max
    
    "http://chart.apis.google.com/chart?" <<
      "cht=bvs&" << # vertical stacked bar chart
      "chd=t:#{data_values.map{|s| s.join(',')}.join('|')}&" << # data sets
      "chds=#{-bound},#{bound}&chxr=2,#{-bound},#{bound}&" << # scaling and y axis range
      "chxt=x,x,y,t,t&chxl=0:|#{month_labels.join('|')}|1:|#{year_labels.join('|')}|4:||||||Total:|3:|#{total_labels.join('|')}&" << # axis & labels
      "chs=640x400&chg=100,50,1,5&chbh=25,15&chco=#{set_colors.join(',')}&" << # size, grid and style
      "chdl=#{set_labels.join('|')}&chdlp=r&" << # legend
      "chtt=Monthly Balances By Risk Class" # title
  end

end

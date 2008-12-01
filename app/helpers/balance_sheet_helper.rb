module BalanceSheetHelper
  
  def google_chart_url(dataset, colors)
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
    margin = [lower_bound, upper_bound].map(&:abs).max * 0.1 # 10% margin to x-axis
    lower_bound -= margin unless lower_bound.zero?
    upper_bound += margin
    
    "http://chart.apis.google.com/chart?" <<
      "cht=bvs&" << # vertical stacked bar chart
      "chd=t:#{data_values.map{|s| s.join(',')}.join('|')}&" << # data sets
      "chds=#{lower_bound},#{upper_bound}&chxr=2,#{lower_bound},#{upper_bound}|5,#{lower_bound},#{upper_bound}&" << # scaling and y axis range
      "chxt=x,x,y,t,t,r&chxl=0:|#{month_labels.join('|')}|1:|#{year_labels.join('|')}|4:||||||#{t 'balance_sheet.total'}:|3:|#{total_labels.join('|')}&" << # axis & labels
      "chs=710x400&chbh=25,15&chco=#{set_colors.join(',')}&" << # size and style
      "chdl=#{set_labels.join('|')}&chdlp=r&" << # legend
      "chtt=#{t 'balance_sheet.chart_title'}" # title
  end

end

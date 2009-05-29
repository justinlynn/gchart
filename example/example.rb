$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'gchart'

def chart_image(chart)
  %Q{<img src="#{chart.to_url}" /><br />}
end

File.open(File.join(File.dirname(__FILE__), 'example.html'), "w") do |f|
  f.write '<html><body>'
  
  # line chart
  f.write chart_image(GChart.line(:data => [0, 10, 100]))

  # sparkline chart
  f.write chart_image(GChart.sparkline(:data => [10, 30, 5, 0, 60, 100]))
  
  # bar chart
  f.write chart_image(GChart.bar(:data => [100, 1000, 10000]))
  
  # pie chart (pie3d for a fancier look)
  f.write chart_image(GChart.pie(:data => [33, 33, 34]))
  
  # venn diagram (asize, bsize, csize, ab%, bc%, ca%, abc%)
  f.write chart_image(GChart.venn(:data => [100, 80, 60, 30, 30, 30, 10]))
  
  # scatter plot (x coords, y coords [, sizes])
  f.write chart_image(GChart.scatter(:data => [[1, 2, 3, 4, 5], [5, 4, 3, 2, 1], [1, 2, 3, 4, 5]]))
  
  # map chart
  f.write chart_image(GChart.map(:area => 'usa', :data => {'NY'=>1,'VA'=>3,'CA'=>2}))
  
  # meter
  f.write chart_image(GChart.meter(:data => 70, :label => "70%"))
  
  # chart title
  f.write chart_image(GChart.line(:title => "Awesomeness over Time", :data => [0, 10, 100]))
  
  # data set legend
  f.write chart_image(GChart.line(:data => [[1, 2], [3, 4]], :legend => ["Monkeys", "Ferrets"]))
  
  # data set colors
  f.write chart_image(GChart.line(:data => [[0, 10, 100], [100, 10, 0]], :colors => ["ff0000", "0000ff"]))
  
  
  f.write '</body></html>'
  system('open', f.path)
end
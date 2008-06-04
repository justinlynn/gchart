Gem::Specification.new do |s|
  s.name = %q{gchart}
  s.version = "0.5.0"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Barnette"]
  s.date = %q{2008-06-03}
  s.description = %q{== PROBLEMS/TODO  * Add support fills (area or background), grid lines, shape markers, range markers  * Support shorthand colors and color names * Make venn data specification friendlier  There are lots of missing features. Until they're implemented, you can directly specify query parameters using the :extras key, e.g.,  # provides a legend for each data set g = GChart.line(:data => [[1, 2], [3, 4]], :extras => { "chdl" => "First|Second"})}
  s.email = %q{jbarnette@rubyforge.org}
  s.extra_rdoc_files = ["CHANGELOG.txt", "Manifest.txt", "README.txt"]
  s.files = ["CHANGELOG.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/gchart.rb", "lib/gchart/bar.rb", "lib/gchart/base.rb", "lib/gchart/line.rb", "lib/gchart/map.rb", "lib/gchart/meter.rb", "lib/gchart/pie.rb", "lib/gchart/pie_3d.rb", "lib/gchart/scatter.rb", "lib/gchart/sparkline.rb", "lib/gchart/venn.rb", "lib/gchart/xy_line.rb", "lib/version.rb", "spec/gchart/bar_spec.rb", "spec/gchart/base_spec.rb", "spec/gchart/line_spec.rb", "spec/gchart/map_spec.rb", "spec/gchart/meter_spec.rb", "spec/gchart/pie_3d_spec.rb", "spec/gchart/pie_spec.rb", "spec/gchart/scatter_spec.rb", "spec/gchart/sparkline_spec.rb", "spec/gchart/venn_spec.rb", "spec/gchart/xy_line_spec.rb", "spec/gchart_spec.rb", "spec/helper.rb", "spec/spec.opts"]
  s.has_rdoc = true
  s.homepage = %q{http://gchart.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gchart}
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{GChart uses the Google Chart API to create pretty pictures.}

  s.add_dependency(%q<hoe>, [">= 1.5.3"])
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gchart}
  s.version = "0.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Barnette"]
  s.date = %q{2008-05-11}
  s.description = %q{== PROBLEMS/TODO  * Add grid lines, linear stripes, shape markers, gradient fills * Make venn data specification friendlier * Make documentation more digestible  There are lots of missing features. Until they're implemented, you can directly specify query parameters using the :extras key, e.g.,  # provides a legend for each data set g = GChart.line(:data => [[1, 2], [3, 4]], :extras => { "chdl" => "First|Second"})}
  s.email = %q{jbarnette@rubyforge.org}
  s.extra_rdoc_files = ["CHANGELOG.txt", "Manifest.txt", "README.txt"]
  s.files = ["CHANGELOG.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/gchart.rb", "lib/gchart/axis.rb", "lib/gchart/axis/bottom_axis.rb", "lib/gchart/axis/horizontal_axis.rb", "lib/gchart/axis/left_axis.rb", "lib/gchart/axis/right_axis.rb", "lib/gchart/axis/top_axis.rb", "lib/gchart/axis/vertical_axis.rb", "lib/gchart/bar.rb", "lib/gchart/base.rb", "lib/gchart/colors.rb", "lib/gchart/line.rb", "lib/gchart/map.rb", "lib/gchart/meter.rb", "lib/gchart/pie.rb", "lib/gchart/pie_3d.rb", "lib/gchart/scatter.rb", "lib/gchart/sparkline.rb", "lib/gchart/venn.rb", "lib/gchart/xy_line.rb", "lib/version.rb", "spec/gchart/axis/bottom_axis_spec.rb", "spec/gchart/axis/left_axis_spec.rb", "spec/gchart/axis/right_axis_spec.rb", "spec/gchart/axis/top_axis_spec.rb", "spec/gchart/axis_spec.rb", "spec/gchart/bar_spec.rb", "spec/gchart/base_spec.rb", "spec/gchart/colors_spec.rb", "spec/gchart/line_spec.rb", "spec/gchart/map_spec.rb", "spec/gchart/meter_spec.rb", "spec/gchart/pie_3d_spec.rb", "spec/gchart/pie_spec.rb", "spec/gchart/scatter_spec.rb", "spec/gchart/sparkline_spec.rb", "spec/gchart/venn_spec.rb", "spec/gchart/xy_line_spec.rb", "spec/gchart_spec.rb", "spec/helper.rb", "spec/spec.opts"]
  s.has_rdoc = true
  s.homepage = %q{http://gchart.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gchart}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{GChart uses the Google Chart API to create pretty pictures.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hoe>, [">= 1.5.1"])
    else
      s.add_dependency(%q<hoe>, [">= 1.5.1"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.5.1"])
  end
end

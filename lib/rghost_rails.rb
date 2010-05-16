require 'rghost'

RGhost::Document.class_eval do
  alias_method :grid, :rails_grid
end

class ActionController::Base
  def rghost_render(format, options)
    report = options.delete(:report)

    template = case report
    when Hash
      File.join(report[:controller] || controller_name, report[:action])
    when String, Symbol
      File.join(controller_path, report.to_s)
    when NilClass
      File.join(controller_path, action_name)
    end

    template = view_paths.find_template(template, "rghost.rb", false)

    ActionView::Helpers.included_modules.each do |m|
      extend m
    end

    lines = File.readlines(template.filename)
    doc = eval(lines.join)

    filename = options.delete(:filename)
    rghost = doc.render(format, options)
    output = rghost.output

    raise "RGhost::Error #{rghost.errors} - #{output}" if rghost.error?

    data = output.readlines.join
    rghost.clear_output

    send_data(data, :filename => filename, :type => Mime::Type.lookup_by_extension(format.to_s))
  end
end


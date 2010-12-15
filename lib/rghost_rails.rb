require 'rghost'

RGhost::Document.class_eval do
  alias_method :grid, :rails_grid
end

class ActionController::Base
  def rghost_render(format, options)
    report = options.delete(:report)

    template = case report
    when Hash
      File.join(report[:controller] || controller_name, report[:action].to_s)
    when String, Symbol
      File.join(controller_path, report.to_s)
    when NilClass
      File.join(controller_path, action_name)
    end
    template_file = begin
      template = view_paths.find_template(template, "rghost.rb", false)
      template.filename
    rescue NoMethodError 
      fname = "#{template}.rghost.rb"
      template_dir = view_paths.detect do |path|
        File.exists? File.join(path.to_s,fname)
      end
      File.join(template_dir.to_s,fname)
    end
    
    ActionView::Helpers.included_modules.each do |m|
      extend m
    end
    lines = File.readlines(template_file.to_s)
    
    doc = eval(lines.join)

    filename = options.delete(:filename)
    disposition=options.delete(:disposition) || 'attachment'
    rghost = doc.render(format, options)
    output = rghost.output
    
    raise "RGhost::Error #{rghost.errors} - #{output}" if rghost.error?

    data = output.readlines.join
    rghost.clear_output

    send_data(data, :filename => filename, :disposition => disposition, :type => Mime::Type.lookup_by_extension(format.to_s))
  end
end



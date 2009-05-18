require 'rghost'

RGhost::Document.class_eval do
  alias_method :grid, :rails_grid
end

class ActionController::Base
  def rghost_render(format, options)
    v=case options[:report]
    when Hash
      File.join(view_paths, options[:report][:controller] ||self.controller_name, options[:report][:action])
    when String,Symbol
      File.join(view_paths, controller_path, options[:report].to_s)
    when NilClass
      File.join(view_paths, controller_path, self.action_name)
    end

    ActionView::Helpers.included_modules.each{|m| extend m}
    r=File.readlines("#{v}.rghost.rb")
    @__rgdoc__=nil
    eval("@__rgdoc__=#{r}")
    #instance_eval("@__doc__=#{r}")
    options.delete(:report)
    filename=options.delete(:filename)

    rg=@__rgdoc__.render(format,options)
    out=rg.output
    raise "RGhost::Error #{rg.errors} - #{out}" if rg.error?
    data=out.readlines.join
    rg.clear_output
    send_data(data, :filename => filename, :type => Mime::Type.lookup_by_extension(format.to_s))

  end
  
end
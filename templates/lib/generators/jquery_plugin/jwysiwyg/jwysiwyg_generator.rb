module JqueryPlugin
  module Generators
    class JwysiwygGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_jwysiwyg
        copy_file "jquery.wysiwyg.css", "public/jwysiwyg/jquery.wysiwyg.css"
        copy_file "jquery.wysiwyg.gif", "public/jwysiwyg/jquery.wysiwyg.gif"
        copy_file "jquery.wysiwyg.jpg", "public/jwysiwyg/jquery.wysiwyg.jpg"
        copy_file "jquery.wysiwyg.js", "public/jwysiwyg/jquery.wysiwyg.js"
      end

    end
  end
end


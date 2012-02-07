module JqueryPlugin
  module Generators
    class FancyboxGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_fancybox
        copy_file "blank.gif", "public/fancybox/blank.gif"
        copy_file "fancy_close.png", "public/fancybox/fancy_close.png"
        copy_file "fancy_loading.png", "public/fancybox/fancy_loading.png"
        copy_file "fancy_nav_left.png", "public/fancybox/fancy_nav_left.png"
        copy_file "fancy_nav_right.png", "public/fancybox/fancy_nav_right.png"
        copy_file "fancy_shadow_e.png", "public/fancybox/fancy_shadow_e.png"
        copy_file "fancy_shadow_n.png", "public/fancybox/fancy_shadow_n.png"
        copy_file "fancy_shadow_ne.png", "public/fancybox/fancy_shadow_ne.png"
        copy_file "fancy_shadow_nw.png", "public/fancybox/fancy_shadow_nw.png"
        copy_file "fancy_shadow_s.png", "public/fancybox/fancy_shadow_s.png"
        copy_file "fancy_shadow_se.png", "public/fancybox/fancy_shadow_se.png"
        copy_file "fancy_shadow_sw.png", "public/fancybox/fancy_shadow_sw.png"
        copy_file "fancy_shadow_w.png", "public/fancybox/fancy_shadow_w.png"
        copy_file "fancy_title_left.png", "public/fancybox/fancy_title_left.png"
        copy_file "fancy_title_main.png", "public/fancybox/fancy_title_main.png"
        copy_file "fancy_title_over.png", "public/fancybox/fancy_title_over.png"
        copy_file "fancy_title_right.png", "public/fancybox/fancy_title_right.png"
        copy_file "jquery.easing-1.3.pack.js", "public/fancybox/jquery.easing-1.3.pack.js"
        copy_file "jquery.fancybox-1.3.0.css", "public/fancybox/jquery.fancybox-1.3.0.css"
        copy_file "jquery.fancybox-1.3.0.js", "public/fancybox/jquery.fancybox-1.3.0.js"
        copy_file "jquery.fancybox-1.3.0.pack.js", "public/fancybox/jquery.fancybox-1.3.0.pack.js"
        copy_file "jquery.mousewheel-3.0.2.pack.js", "public/fancybox/jquery.mousewheel-3.0.2.pack.js"
      end

    end
  end
end


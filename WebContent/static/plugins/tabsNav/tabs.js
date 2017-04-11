;
(function ($, document, window, undefined) {
  var TabsNav = function (settings, section) {
    this.settings = settings;
    this.me = section;
    this.nav = this.me.find('.nav a')
    this.content = this.me.find('.item')
    this.init();
  };
  TabsNav.prototype = {
    init: function () {
      this.click();
    },
    click: function () {
      var $this = this;

      this.nav.on('click', function() {
        var index = $(this).index();

        $(this).addClass('current').siblings().removeClass('current');
        $this.content.eq(index).show().siblings().hide();
        
        if (typeof $this.settings.callback === 'function') {
          console.log('function')
          $this.settings.callback(index);
        }

      })
    }
  };



  $.fn.TabsNav = function (options) {
    var _this = this;
    return this.each(function () {
      var settings = $.extend({}, $.fn.TabsNav.defaults, options || {}),
        tabsNav = $(this).data("TabsNav");
      if (!tabsNav) {
        tabsNav = new TabsNav(settings, $(this));
        $(this).data('TabsNav', tabsNav);
      }

    });
  };

  $.fn.TabsNav.defaults = {
    callback: null
  };
})(jQuery, document, window);


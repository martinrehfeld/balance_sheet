// adapted from: http://www.thinksharp.org/extformat-extension-for-thousands-separator-formatting/
// example usage:
//   var euroFormatter = Ext.util.Format.currencyRenderer(2, "€");
Ext.apply(Ext.util.Format, {
  decimalSeparator : '.',
  thousandSeparator : ',',

  currencyRenderer: function(precision, symbol) {
    return (function(value) {
      value = parseFloat(value).toFixed(precision || 2);
      var x = value.split('.');
      var x1 = x[0];
      var x2 = x.length > 1 ? Ext.util.Format.decimalSeparator + x[1] : '';
      var rgx = /(\d+)(\d{3})/;

      while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + Ext.util.Format.thousandSeparator + '$2');
      }

      return x1 + x2 + (symbol ? ' ' + symbol : '');
    });
  },

  numberRenderer: function() {
    return (function (value) {
      return (String(value).replace('.', Ext.util.Format.decimalSeparator));
    });
  }
});


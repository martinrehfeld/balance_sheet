//
// NumberField with fixed decimal precision display
//
Ext.namespace('Application');
Application.FixedNumberField = Ext.extend(Ext.form.NumberField, {

  // override original setValue function to always provide full decimal precision in output
  setValue : function(v){
    v = typeof v == 'number' ? v : parseFloat(String(v).replace(this.decimalSeparator, "."));
    v = isNaN(v) ? '' : String(v.toFixed(this.decimalPrecision)).replace(".", this.decimalSeparator);
    Ext.form.NumberField.superclass.setValue.call(this, v);
  }

});

Ext.reg('fixednumberfield', Application.FixedNumberField);
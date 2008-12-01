if (Ext.form.NumberField) {
  Ext.apply(Ext.form.NumberField.prototype, {
    decimalSeparator: ','
  });
}

// override Ext default translations for DateField
if(Ext.form.DateField){
   Ext.apply(Ext.form.DateField.prototype, {
      minText           : "Das Datum in diesem Feld darf nicht vor dem {0} liegen",
      maxText           : "Das Datum in diesem Feld darf nicht nach dem {0} liegen",
      invalidText       : "{0} ist kein valides Datum - es muß im Format Tag.Monat.Jahr eingegeben werden",
      format            : "d.m.Y",
      altFormats        : "d.m.y|d/m/Y|d-m-y|d-m-Y|d/m|d-m|dm|dmy|dmY|d|Y-m-d"
   });
}

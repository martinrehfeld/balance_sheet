// override Ext default translations for DateField
if(Ext.form.DateField){
  Ext.apply(Ext.form.DateField.prototype, {
    minText           : "The date in this field must not be before {0}",
    maxText           : "The date in this field must not be after {0}",
    invalidText       : "{0} is not a valid date - it must be in the format month/day/year",
    format            : "m/d/Y",
    altFormats        : "m/d/y|m-d-y|m-d-Y|m/d|m-d|md|mdy|mdY|d|Y-m-d"
  });
}

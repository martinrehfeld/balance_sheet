if (Ext.form.NumberField) {
  Ext.apply(Ext.form.NumberField.prototype, {
    decimalSeparator: ','
  });
}

// override Ext default translations for DateField
if (Ext.form.DateField) {
   Ext.apply(Ext.form.DateField.prototype, {
      minText           : "Das Datum in diesem Feld darf nicht vor dem {0} liegen",
      maxText           : "Das Datum in diesem Feld darf nicht nach dem {0} liegen",
      invalidText       : "{0} ist kein valides Datum - es muß im Format Tag.Monat.Jahr eingegeben werden",
      format            : "d.m.Y",
      altFormats        : "d.m.y|d/m/Y|d-m-y|d-m-Y|d/m|d-m|dm|dmy|dmY|d|Y-m-d"
   });
}

if (ExtScaffold.Entry) {
  Ext.apply(ExtScaffold.Entry.prototype, {
    labels: {
       'id': '#'
      ,'entry[account_id]': 'Konto'
      ,'entry[effective_date]': 'Buchungsdatum'
      ,'entry[entry_type_id]': 'Typ'
      ,'entry[value]': 'Wert'
      ,'entry[notes]': 'Notizen'
    },
    title: 'Buchungen',
    collapseButtonLabel: null,
    collapseButtonTooltip: 'Alle Kontendetails zuklappen',
    newButtonLabel: 'Neu...',
    newButtonTooltip: 'Neue Buchung anlegen',
    editButtonLabel: 'Bearbeiten...',
    editButtonTooltip: 'Markierte Buchung bearbeiten',
    selectRowText: 'Bitte zuerst eine Buchung auswählen.',
    deleteButtonLabel: 'Löschen...',
    formToggleButtonLabel: 'Details',
    formToggleButtonTooltip: 'Zeige / Verberge Detail-Maske',
    deleteButtonTooltip: 'Markierte Buchung löschen...',
    deleteConfirmationText: 'Wirklich löschen?',
    deleteFailedText: 'Das Löschen ist fehlgeschlagen. Die Buchung ist evtl. bereits von einem anderen Benutzer gelöscht worden.',
    savingMessage: 'Speichern...',
    saveFailedText: 'Das Speichern ist fehlgeschlagen.  Die Buchung ist evtl. von einem anderen Benutzer gelöscht worden.',
    searchText:'Suchen',
    searchTipText:'Suchbegriff eintippen und die Eingabetaste drücken'
  });
}

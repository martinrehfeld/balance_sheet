
ExtScaffold.Entry = Ext.extend(Ext.Panel, {
  //
  // static text properties (override for i18n)
  //
  labels: {
     'id': '#'
    ,'entry[account_id]': 'Account'
    ,'entry[effective_date]': 'Effective date'
    ,'entry[entry_type_id]': 'Entry type'
    ,'entry[value]': 'Value'
    ,'entry[notes]': 'Notes'
  },
  title: 'Entries',
  collapseButtonLabel: 'Collapse',
  collapseButtonTooltip: 'Collapse all Account groups',
  newButtonLabel: 'New...',
  newButtonTooltip: 'Create new Entry',
  editButtonLabel: 'Edit...',
  editButtonTooltip: 'Edit selected Entry',
  selectRowText: 'Please select a row first.',
  deleteButtonLabel: 'Delete...',
  formToggleButtonLabel: 'Details',
  formToggleButtonTooltip: 'Show / Hide Details',
  deleteButtonTooltip: 'Delete selected Entry...',
  deleteConfirmationText: 'Really delete?',
  deleteFailedText: 'Delete operation failed. The record might have been deleted by someone else.',
  savingMessage: 'Saving...',
  saveFailedText: 'Save operation failed. The record might have been deleted by someone else.',

  //
  // custom properties
  //
  url: '#',
  baseParams: {},

  //
  // private properties
  //
  formPanelWasCollapsed: true,
  selectedRecordId: undefined,

  // defaults for (superclass) config
  layout: 'border',
  border: false,
  cls:    'ext-scaffold',
  
  //
  // public instance methods
  //
  activateGrid: function() {
    var gp = this.getGridPanel();
    var gv = gp.getView();
    var ds = this.getStore();
    
    gp.enable();

    if (this.formPanelWasCollapsed) this.getFormPanel().collapse();

    // give focus to the grid to enable up/down keys
    if (ds.getCount() > 0) {
      if (this.selectedRecordId) {
        var matchingRecords = ds.query('id', this.selectedRecordId);
        if (matchingRecords) {
          gv.focusRow(ds.indexOf(matchingRecords.first())); // focus selected row
        } else {
          gv.focusRow(0); // no matching selection -> focus first row
        }
      } else {
        gv.focusRow(0); // no selection at all -> focus first row
      }
    }
  },
  
  activateForm: function(mode) {
    var fp = this.getFormPanel();

    fp.setFormMode(mode);

    this.formPanelWasCollapsed = fp.collapsed;
    if (fp.collapsed) fp.expand();

    fp.setWidth(fp.initialConfig.width, true);
    this.doLayout(); // re-render border layout to reflect current form width

    if(mode == 'new' || mode == 'edit') {
      this.getGridPanel().disable(); // make new and edit modal by disabling the gridPanel
       // focus first form field -- we need a delay here to allow processing of expand()
      fp.getForm().findField('entry[account_id]').focus(true, 400);
    }
  },
  
  getGridPanel: function() {
    return Ext.getCmp('entry-grid');
  },
  
  getFormPanel: function() {
    return Ext.getCmp('entry-form');
  },
  
  getStore: function() {
    return this.getGridPanel().getStore();
  },
  
  resetForm: function(activateGrid) {
    var fp = this.getFormPanel();
    fp.getForm().reset();
    fp.setFormMode('show');
    if (activateGrid) this.activateGrid();
  },
  
  reloadStore: function(resetForm) {
    this.getStore().load();
    if (resetForm) this.resetForm(true);
  },
  
  refreshFormToggle: function() {
    Ext.getCmp('entry-form-toggle').toggle(!this.getFormPanel().collapsed);
  },
  
  //
  // initComponent
  //
  initComponent: function() {
    var scaffoldPanel = this; // save scope for later reference

    var ds = new Ext.data.GroupingStore({
      proxy: new Ext.data.HttpProxy({
                 url: scaffoldPanel.url + '?format=ext_json',
                 method: 'GET'
             }),
      reader: new Ext.data.JsonReader({
                  root: 'entries',
                  id: 'id',
                  totalProperty: 'results'
              },[
                { name: 'id', mapping: 'entry.id' }
                ,{ name: 'entry[account_id]', mapping: 'entry.account_id', type: 'int' }
                ,{ name: 'entry[effective_date]', mapping: 'entry.effective_date', type: 'date', dateFormat: 'Y-m-d' }
                ,{ name: 'entry[entry_type_id]', mapping: 'entry.entry_type_id', type: 'int' }
                ,{ name: 'entry[value]', mapping: 'entry.value', type: 'float' }
                ,{ name: 'entry[notes]', mapping: 'entry.notes' }
                ,{ name: 'virtual_attributes[account_name]', mapping: 'entry.account_name' }
                ,{ name: 'virtual_attributes[entry_type_name]', mapping: 'entry.entry_type_name' }
                ,{ name: 'virtual_attributes[account_balance]', mapping: 'entry.account_balance' }
              ]),
        remoteSort: true, // turn on server-side sorting
        sortInfo: {field: 'entry[account_id],entry[effective_date]', direction: 'ASC'},
        groupField: 'entry[account_id]'
    });

    var cm = new Ext.grid.ColumnModel([
       { header: scaffoldPanel.labels['entry[account_id]'], dataIndex: 'entry[account_id]', hideable: false }
      ,{ header: scaffoldPanel.labels['entry[effective_date]'], dataIndex: 'entry[effective_date]', renderer: Ext.util.Format.dateRenderer(Ext.form.DateField.prototype.format) }
      ,{ header: scaffoldPanel.labels['entry[entry_type_id]'], dataIndex: 'virtual_attributes[entry_type_name]' }
      ,{ header: scaffoldPanel.labels['entry[value]'], dataIndex: 'entry[value]' }
      ,{ header: scaffoldPanel.labels['entry[notes]'], dataIndex: 'entry[notes]' }
    ]);

    cm.defaultSortable = true; // all fields are sortable by default
    
    // button handlers
    
    function addButtonHandler() {
      scaffoldPanel.selectedRecordId = undefined;
      scaffoldPanel.activateForm('new');
      scaffoldPanel.getFormPanel().getTopToolbar().hide();
    }

    function editButtonHandler() {
      var selected = scaffoldPanel.getGridPanel().getSelectionModel().getSelected();
      if(selected) {
        scaffoldPanel.activateForm('edit');
      } else { 
        alert(scaffoldPanel.selectRowText);
      }
    }
    
    function deleteButtonHandler() {
      var selected = scaffoldPanel.getGridPanel().getSelectionModel().getSelected();
      if(selected) {
        if(confirm(scaffoldPanel.deleteConfirmationText)) {
           var conn = new Ext.data.Connection({
             extraParams: scaffoldPanel.baseParams
           });
           conn.request({
               url: scaffoldPanel.url + '/' + selected.data.id,
               method: 'POST',
               params: { _method: 'DELETE' },
               success: function(response, options) {
                 scaffoldPanel.reloadStore(true);
               },
               failure: function(response, options) {
                 // the delete probably failed because the record is already gone, so let's reload the store
                 scaffoldPanel.reloadStore(true);
                 alert(scaffoldPanel.deleteFailedText);
               }
           });
        }
      } else { 
        alert(scaffoldPanel.selectRowText);
      }
    }
    
    function collapseButtonHandler() {
      scaffoldPanel.getGridPanel().getView().collapseAllGroups();
    }
    
    Ext.apply(this, {
      items: [{
        // add the grid panel to center region
        region: 'center',
        xtype: 'grid',
        id: 'entry-grid',
        ds: ds,
        cm: cm,
        view: new Ext.grid.GroupingView({
          groupTextTpl: '{[values.rs[0].data["virtual_attributes[account_name]"]]} ({[values.rs.length]} {[values.rs.length > 1 ? "Entries" : "Entry"]}, Balance: {[values.rs[0].data["virtual_attributes[account_balance]"]]} EUR)',
          enableGroupingMenu: false,
          hideGroupedColumn: true,
          startCollapsed: true
        }),
        sm: new Ext.grid.RowSelectionModel({
          singleSelect:true,
          listeners: {
            // populate form fields when a row is selected
            'rowselect': function(sm, row, rec) {
              scaffoldPanel.selectedRecordId = rec.data.id;
              scaffoldPanel.getFormPanel().getForm().loadRecord(rec);
            }
          }
        }),
        stripeRows: true,

        // inline toolbars
        tbar: [
          {
              text:    scaffoldPanel.newButtonLabel,
              tooltip: scaffoldPanel.newButtonTooltip,
              handler: addButtonHandler,
              iconCls: 'add'
          },{
              text:    scaffoldPanel.editButtonLabel,
              tooltip: scaffoldPanel.editButtonTooltip,
              handler: editButtonHandler,
              iconCls: 'edit'
          },{
              text:    scaffoldPanel.deleteButtonLabel,
              tooltip: scaffoldPanel.deleteButtonTooltip,
              handler: deleteButtonHandler,
              iconCls: 'remove'
          }, '-', {
              text:    scaffoldPanel.collapseButtonLabel,
              tooltip: scaffoldPanel.collapseButtonTooltip,
              handler: collapseButtonHandler,
              iconCls: 'collapse'
          }, '->', {
            id: 'entry-form-toggle',
            iconCls: 'details',
            text:    scaffoldPanel.formToggleButtonLabel,
            tooltip: scaffoldPanel.formToggleButtonTooltip,
            enableToggle: true,
            handler: function() {
              scaffoldPanel.getFormPanel().toggleCollapse();
            }
          }, '->'
        ],
        plugins:[new Ext.ux.grid.Search({
                    position:'top'
                })],
        listeners: {
          // show form with record on double-click
          'rowdblclick': function(grid, row, e) { scaffoldPanel.activateForm('show'); }
        }

      },{

        // add the form to east region
        region: 'east',
        xtype: 'extscaffoldform',
        id: 'entry-form',
        width: 340,
        collapseMode: 'mini',
        collapsed: true,
        collapsible: true,
        titleCollapse: false,
        hideCollapseTool: true,
        border: false,
        frame: true,
        listeners: {
          // update form-toggle button with new pressed/depressed state
          'expand':   function() { scaffoldPanel.refreshFormToggle(); },
          'collapse': function() { scaffoldPanel.refreshFormToggle(); },

          // prevent collapse when grid is disabled
          'beforecollapse': function() { return !scaffoldPanel.getGridPanel().disabled; }
        },

        tbar: new Ext.Toolbar({
          hideMode: 'visibility',
          items: ['->',
            {
              tooltip: scaffoldPanel.editButtonTooltip,
              handler: editButtonHandler,
              iconCls:'edit'
            },{
              tooltip: scaffoldPanel.deleteButtonTooltip,
              handler: deleteButtonHandler,
              iconCls:'remove'
            }
          ]
        }),

        baseParams: scaffoldPanel.baseParams,
        items: [
          { fieldLabel: scaffoldPanel.labels['entry[account_id]'], name:'virtual_attributes[account_name]', hiddenName: 'entry[account_id]', xtype: 'combo', store: scaffoldPanel.accountNamesStore, triggerAction: 'all', forceSelection: true },
          { fieldLabel: scaffoldPanel.labels['entry[effective_date]'], name: 'entry[effective_date]', xtype: 'xdatefield' },
          { fieldLabel: scaffoldPanel.labels['entry[entry_type_id]'], name:'virtual_attributes[entry_type_name]', hiddenName: 'entry[entry_type_id]', xtype: 'combo', store: scaffoldPanel.entryTypeNamesStore, triggerAction: 'all', forceSelection: true },
          { fieldLabel: scaffoldPanel.labels['entry[value]'], name: 'entry[value]', xtype: 'fixednumberfield', decimalPrecision: 2 },
          { fieldLabel: scaffoldPanel.labels['entry[notes]'], name: 'entry[notes]', xtype: 'textarea' }
        ],

        onOk: function() {
          var selected = scaffoldPanel.getGridPanel().getSelectionModel().getSelected();

          var submitOptions = {
            url: scaffoldPanel.url,
            waitMsg: scaffoldPanel.savingMessage,
            params: { format: 'ext_json' },
            success: function(form, action) {
              // remember assigned record id (relevant when creating new records,
              // will match the known record id otherwise)
              scaffoldPanel.selectedRecordId = action.result.data['entry[id]'];
              scaffoldPanel.reloadStore(true);
            },
            failure: function(form, action) {
              switch (action.failureType) {
                case Ext.form.Action.CLIENT_INVALID:
                case Ext.form.Action.SERVER_INVALID:
                  // validation errors are handled by the form, so we ignore them here
                  break;
                case Ext.form.Action.CONNECT_FAILURE:
                case Ext.form.Action.LOAD_FAILURE:
                  // these might be 404 Not Found or some 5xx Server Error
                  alert(scaffoldPanel.saveFailedText);
                  break;
              }
            }
          };

          scaffoldPanel.getFormPanel().getTopToolbar().show();

          if (scaffoldPanel.getFormPanel().currentMode == 'edit') {
            // set up request for Rails create action
            submitOptions.params._method = 'PUT';
            submitOptions.url = submitOptions.url + '/' + selected.data.id;
          }
          scaffoldPanel.getFormPanel().getForm().submit(submitOptions);
        },

        onCancel: function() {
          var sm = scaffoldPanel.getGridPanel().getSelectionModel();
          var fp = scaffoldPanel.getFormPanel();

          scaffoldPanel.getFormPanel().getTopToolbar().show();
          scaffoldPanel.activateGrid();
          
          // cancel from show mode should always collapse the form-panel (button label: Close)
          if (fp.currentMode == 'show') fp.collapse();
          
          fp.setFormMode('show');
          if (sm.hasSelection()) {
            fp.getForm().loadRecord(sm.getSelected()); // reload previous record version
          } else {
            fp.getForm().reset();
          }
        }
      }]
    });
    
    // try to re-establish selection after datastore load
    ds.on('load', function() {
      if (this.selectedRecordId) {
        var matchingRecords = ds.query('id', this.selectedRecordId);
        if (matchingRecords && matchingRecords.length > 0) {
          this.getGridPanel().getSelectionModel().selectRecords([matchingRecords.first()]);
        } else {
          this.selectedRecordId = undefined; 
          this.resetForm(false);
        }
      }
    }, this);
    
    // make sure form toggle reflects form collapsed state even on initial load
    ds.on('load', function() {
      this.refreshFormToggle();
      this.resetForm(true);
    }, this, { single:true });

    ExtScaffold.Entry.superclass.initComponent.apply(this, arguments);
  },
  
  onRender: function() {
    ExtScaffold.Entry.superclass.onRender.apply(this, arguments);

    // reset form and trigger initial data load
    this.getStore().load();
  }
});


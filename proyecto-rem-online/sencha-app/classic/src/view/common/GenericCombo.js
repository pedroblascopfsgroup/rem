Ext.define('HreRem.view.common.GenericCombo', {
  extend: 'Ext.form.field.ComboBox',
  alias: 'widget.genericcombo',

  require: ['HreRem.model.DDBase', 'HreRem.ux.data.Proxy'],
  
  constructor: function(config) {
	
	var store = new Ext.data.Store({
		model: 'HreRem.model.DDBase',
	    autoLoad: true,
	    proxy: Ext.create('HreRem.ux.data.Proxy',{
			remoteUrl: 'generic/getDiccionarioTareas',
			extraParams: {diccionario: config.diccionario} 
		})
	});
	
	
    Ext.apply(this, config, {
        store: store,
        fieldLabel: config.fieldLabel,
        displayField: 'descripcion',
        valueField: 'codigo',
        queryMode: 'local',
        emptyText:'---',
        hiddenName: config.name,
        labelWidth: labelWidth = 180,
        value: config.value,
        readOnly: config.readOnly
    });

    this.callParent();

  }

});

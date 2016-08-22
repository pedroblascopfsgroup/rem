Ext.define('HreRem.view.common.GenericComboEspecial', {
	extend : 'Ext.form.field.ComboBox',
	alias : 'widget.genericcomboespecial',

	require : [ 'HreRem.model.DDBase', 'HreRem.ux.data.Proxy' ],

	constructor : function(config) {

		var store = new Ext.data.Store({
			model : 'HreRem.model.DDBase',
			autoLoad : true,
			proxy : Ext.create('HreRem.ux.data.Proxy', {
				remoteUrl : 'generic/getComboEspecial',
				extraParams : {
					diccionario : config.diccionario
				}
			})
		});

		Ext.apply(this, config, {
			store : store,
			fieldLabel : config.fieldLabel,
			displayField : 'descripcion',
			valueField : 'id',
			queryMode : 'local',
			emptyText : '---',
			hiddenName : config.name,
			labelWidth : labelWidth = 180,
			value : config.value,
			readOnly: config.readOnly
		});

		this.callParent();

	}

});

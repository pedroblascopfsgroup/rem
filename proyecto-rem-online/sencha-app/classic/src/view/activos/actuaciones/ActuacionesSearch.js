Ext.define('HreRem.view.activos.actuaciones.ActuacionesSearch', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'actuacionessearch',
	isSearchForm : true,
	reference : 'actuacionessearchform',
	title : 'Filtro de Actuaciones',
	layout : 'column',

	defaults : {
		layout : 'form',
		xtype : 'container',
		defaultType : 'textfield',
		style : 'width: 33%'
	},
    
	items : [ {
		items : [{
			xtype : 'comboTipoActuacion',
			name: 'idTipoActuacion'
		},{
			fieldLabel : 'Cliente',
			name: 'cliente'
		}, {
			fieldLabel : 'Gestor',
			name: 'gestor'				
		} ]

	}, {

		items : [ {

			xtype : 'fieldset',
			cls : 'fieldsetBase',
			title : 'Fecha Inicio',			
			defaults : {
				layout : 'hbox'
			},
			items : [ {
				xtype : 'datefield',
				fieldLabel : 'Desde',
				name: 'fechaInicioDesde',
				editable: false,
				format: 'd/m/y'
			}, {
				xtype : 'datefield',
				fieldLabel : 'Hasta',
				name: 'fechaInicioHasta',
				editable: false,
				format: 'd/m/y'
			} ]
		} ]

	}, {

		items : [ {

			xtype : 'fieldset',
			cls : 'fieldsetBase',
			title : 'Fecha Fin',
			defaults : {
				layout : 'hbox'
			},
			items : [ {
				xtype : 'datefield',
				fieldLabel : 'Desde',
				name: 'fechaFinDesde',
				editable: false,
				format: 'd/m/y'
			}, {
				xtype : 'datefield',
				fieldLabel : 'Hasta',
				name: 'fechaFinHasta',
				editable: false,
				format: 'd/m/y'
			} ]
		} ]
	} ]
});
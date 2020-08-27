Ext.define('HreRem.view.trabajosMainMenu.albaranes.AlbaranesSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'albaranessearch',
    isSearchFormTrabajos: true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    layout: {
        type: 'accordion',
        titleCollapse: false,
        animate: true,
        vertical: true,
        multi: true
    },

		initComponent : function() {

		var me = this;
		me.setTitle(HreRem.i18n('title.filtro.albaran'));
		me.items = [

		{
			xtype : 'panel',
			title : HreRem.i18n('title.filtro'),
			layout : 'column',
			columnWidth: 1,
			cls : 'panel-busqueda-directa',
			defaults: {
			       layout: 'form',
			       xtype: 'container',
			       defaultType: 'textfield',
			       style: 'width: 25%'
			 },
			collapsible : false,
			items : [
				{
					items: [
						{
							xtype: 'textfield',
							fieldLabel : HreRem.i18n('fieldlabel.albaran.numAlbaran'),
							name : 'numAlbaran',
							width : 230
						},
						{
							xtype : 'datefield',
							fieldLabel : HreRem.i18n('fieldlabel.albaran.fechaAlbaran'),
							width : 230,
							name : 'fechaAlbaran',
							formatter : 'date("d/m/Y")'
						},
						{
							// revisar display field y valuefield
							xtype : 'combo',
							fieldLabel : HreRem
									.i18n('fieldlabel.albaran.estadoAlbaran'),
							labelWidth : 150,
							width : 230,
							name : 'estadoAlbaran',
							queryMode : 'remote',
							bind : {
								store : '{comboEstadoAlbaran}',
								disabled : '{!comboEstadoAlbaran.value}'
							},
							displayField : 'descripcion',
							valueField : 'codigo'
						}
					]
				},
				{
					items: [
						{
							fieldLabel : HreRem
									.i18n('fieldlabel.albaran.numPrefacturas'),
							name : 'numPrefactura',
							width : 230
						},
						{
							xtype : 'datefield',
							fieldLabel : HreRem
									.i18n('fieldlabel.albaran.fechaPrefacturas'),
							width : 230,
							name : 'fechaPrefactura',
							formatter : 'date("d/m/Y")'
						},
						{
							// revisar display field y valuefield
							xtype : 'combo',
							fieldLabel : HreRem
									.i18n('fieldlabel.albaran.estadoPrefectura'),
							labelWidth : 150,
							width : 230,
							name : 'estadoPrefactura',
							queryMode : 'remote',
							bind : {
								store : '{comboEstadoPrefactura}',
								disabled : '{!comboEstadoPrefactura.value}'
							},
							displayField : 'descripcion',
							valueField : 'codigo'
						}
					]
				},
				{
					items: [
						{
							fieldLabel : HreRem
									.i18n('fieldlabel.albaran.numTrabajos'),
							name : 'numTrabajo',
							width : 230
						},
						{
							xtype : 'textfield',
							fieldLabel : HreRem.i18n('fieldlabel.albaran.fechaAlta'),
							name : 'anyoTrabajo',
//							formatter : 'date("d/m/Y")',
							width : 230
						},
						{
							// revisar display field y valuefield
							xtype : 'combo',
							fieldLabel : HreRem
									.i18n('fieldlabel.albaran.estadoTrabajo'),
							labelWidth : 150,
							width : 230,
							name : 'estadoTrabajo',
							queryMode : 'remote',
							bind : {
								store : '{filtroComboEstadoTrabajo}',
								disabled : '{!filtroComboEstadoTrabajo.value}'
							},
							displayField : 'descripcion',
							valueField : 'codigo'
						}
					]
				},
				{
					items : [
						{
							// revisar display field y valuefield
							xtype : 'combo',
							fieldLabel : HreRem
									.i18n('fieldlabel.albaran.tipologiaTrabajo'),
							labelWidth : 150,
							width : 230,
							name : 'tipologiaTrabajo',
							queryMode : 'remote',
							bind : {
								store : '{comboTipologiaTrabajo}',
								disabled : '{!comboTipologiaTrabajo.value}'
							},
							displayField : 'descripcion',
							valueField : 'codigo'
						}, 
						{
							fieldLabel : HreRem.i18n('fieldlabel.solicitante'),
							name : 'solicitante',
							width : 230
						}, {
							fieldLabel : HreRem.i18n('fieldlabel.proveedor'),
							name : 'proveedor',
							width : 230
						}
					]
				}
			]
		} ];

		me.callParent();
	}
});



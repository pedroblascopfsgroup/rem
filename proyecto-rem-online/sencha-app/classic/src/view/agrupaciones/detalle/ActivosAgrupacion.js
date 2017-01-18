Ext.define('HreRem.view.agrupaciones.detalle.ActivosAgrupacion', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'activosagrupacion',
    reference	: 'activosagrupacion',
    layout		: 'fit',
    scrollable	: 'y',
    requires	: ['HreRem.view.common.GridBaseEditableRow', 'HreRem.model.ActivoAgrupacion',
    	'HreRem.view.agrupaciones.detalle.AgrupacionDetalleModel', 'HreRem.view.agrupaciones.detalle.ActivosAgrupacionList'],

	initComponent: function () {
        var me = this; 

        me.setTitle(HreRem.i18n('title.activos'));

        me.items = [
			{
				xtype		:'fieldset',
				collapsible	: false,
				defaultType	: 'textfieldbase',
				scrollable	: 'y',
				items 		: [
						{
			            	xtype: 'button',
			            	reference: 'btnExportarActivosLoteComercial',
			            	text: HreRem.i18n('title.activo.administracion.exportar.excel'),
			            	handler: 'onClickExportarActivosLoteComercial',
			            	bind : {
								hidden: '{!esAgrupacionLoteComercial}'
							},
							margin: '15 0 0 15'
			            },
				    	{
						    xtype: 'activosagrupacionlist',
						    reference: 'listadoactivosagrupacion'
						}
			    ]
			}
	    ];

		me.callParent();
	},

	funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		var listadoActivosAgrupacion = me.down("[reference=listadoactivosagrupacion]");
	
		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoActivosAgrupacion.getStore().loadPage(1);
	}
});
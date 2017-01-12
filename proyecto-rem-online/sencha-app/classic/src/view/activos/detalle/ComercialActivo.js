Ext.define('HreRem.view.activos.detalle.ComercialActivo', {
    extend		: 'HreRem.view.common.FormBase',
    cls			: 'panel-base shadow-panel',
    xtype		: 'comercialactivo',
    reference	: 'comercialactivoref',
    scrollable	: 'y',
    recordName	: "comercial",
	recordClass	: "HreRem.model.ComercialActivoModel",
    requires	: ['HreRem.model.ComercialActivoModel', 'HreRem.view.activos.detalle.ComercialActivoTabPanel'],

    listeners: {
		boxready:'cargarTabData'
    },

    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.comercial'));

    	me.items = [
    		{
    			xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				collapsible: true,
				reference: 'activoComercialBloqueRef',
				items :
					[
					// Fila 0
						{
				        	xtype : 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('header.situacion.comercial'),
				        	reference: 'cbSituacionComercial',
				        	readOnly: true,
				        	bind : {
							      store : '{comboSituacionComercial}',
							      value : '{comercial.situacionComercialCodigo}'
							}
				        },
				        {
				        	xtype: 'datefieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.fecha.venta'),
				        	reference: 'dtFechaVenta',
				        	bind : {
				        		readOnly: '{comercial.expedienteComercialVivo}',
				        		value: '{comercial.fechaVenta}'
				        	}
						},
						{ 
							xtype: 'textareafieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.observaciones'),
				        	bind: '{comercial.observaciones}',
				        	reference: 'taObservaciones',
							maxLength: 250,
							rowspan: 2,
				        	height: 80
				        },
					// Fila 1
						{
							   xtype: 'currencyfieldbase',
							   fieldLabel: HreRem.i18n('fieldlabel.importe.venta'),
							   reference: 'cncyImporteVenta',
							   bind : {
					        		readOnly: '{comercial.expedienteComercialVivo}',
					        		value: '{comercial.importeVenta}'
							   }
						}
				]
			},
			{
				xtype: 'comercialactivotabpanel' 
			}
    	];

    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.lookupController().cargarTabData(me);
    }
});
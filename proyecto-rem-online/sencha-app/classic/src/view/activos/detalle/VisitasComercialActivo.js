Ext.define('HreRem.view.activos.detalle.VisitasComercialActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'visitascomercialactivo',
    requires	: ['HreRem.view.activos.detalle.VisitasComercialActivoList'],
    scrollable	: 'y',
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {        
        var me = this;
        me.setTitle(HreRem.i18n("title.activos.listado.visitas"));

        me.items = [      			
        	{
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.lista.visitas'),
				collapsible: true,
				items :
					[
		    			{	
		    				xtype: 'visitascomercialactivolist',
		    				reference: 'visitascomercialactivolistref'        				
		    			}
    			]
        	},
        	{
        		xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('fieldlabel.numero.visitasTotal'),
				reference: 'detalleOfertaFieldsetref',
				collapsible: true,
				bind: {
					hidden:'{!activo.isSubcarteraApple}'
				},
				items :
					[
						{
							xtype: 'textfield',
							fieldLabel: HreRem.i18n('fieldlabel.numero.visitasTotal'),
							bind: {
								value: '{activo.visitasTotal}'								
							},
							readOnly: true,
							colspan: 3,
							width: 410
						}
						
					]
        	}
			
        ];

        me.callParent();
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().loadPage(1);
  		});
    } 
});
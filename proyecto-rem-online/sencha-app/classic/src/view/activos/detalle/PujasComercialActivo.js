Ext.define('HreRem.view.activos.detalle.PujasComercialActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'pujascomercialactivo',
    requires	: ['HreRem.view.activos.detalle.PujasComercialActivoList'],
    scrollable	: 'y',
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {        
        var me = this;
        me.setTitle(HreRem.i18n("title.activos.listado.concurrencia"));

        me.items = [      			
        	{
				xtype:'fieldsettable',
				title: HreRem.i18n('title.lista.ofertas.concurrencia'),
				collapsible: true,
				items :
					[
		    			{	
		    				xtype: 'pujascomercialactivolist',
		    				reference: 'pujascomercialactivolistref'        				
		    			}
    			]
        	},
        		{
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.lista.ofertas.concurrencia.historico'),
				collapsible: true,
				items :
					[
		    			{	
		    				xtype: 'historicoconcurrenciagrid'        				
		    			}
    			]
        	}
        	
        ];

        me.callParent();
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		var listadoOfertasConcu = me.down("[reference=pujascomercialactivolistref]");
		listadoOfertasConcu.getStore().load();
    } 
});
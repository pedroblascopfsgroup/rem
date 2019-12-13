Ext.define('HreRem.view.activos.detalle.DocumentosActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'documentosactivo',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'documentosactivoref',
    scrollable	: 'y',
    requires	: ['HreRem.model.AdjuntoActivo','HreRem.model.AdjuntoActivoPromocion','HreRem.model.AdjuntoActivoAgrupacion','HreRem.model.AdjuntoActivoProyecto','Ext.data.Store','HreRem.model.Activo'],

    initComponent: function () {
    	var me = this;
        me.setTitle(HreRem.i18n('title.documentos'));
        
    	var items= [
    	         {
     				xtype:'documentosactivosimple',
					reference: 'listadoDocumentosSimple',
					collapsible: true,
					colspan: 3
    	         },
    	         {
    	     		xtype:'documentosactivopromocion',
    	 			reference: 'listadoDocumentosPromo',
    	            collapsible: true,
    	 			colspan: 3
    	 		},
    	 		{
    	     		xtype:'documentosactivoproyecto',
    	 			reference: 'listadoDocumentosProyecto',
    	            collapsible: true,
//    	            readOnly: true,
    	            bind:{
    	            	disabled: '{!activo.esSarebProyecto}',
    	            	hidden: '{!activo.esSarebProyecto}'
    	            },
    	 			colspan: 3
    	 		}/*,
    	 		{
    	     		xtype:'documentosactivoagrupacion',
    	 			reference: 'listadoDocumentosagrupacion',
    	            collapsible: true,
//    	            readOnly: true,
    	            bind:{
    	            	//hidden: '{visibilidadPestanyaDocumentacionAgrupacion}'
    	            },
    	 			colspan: 3
    	 		}*/
    	];

    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();    	
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load(grid.loadCallbackFunction);
  		});
    }
    
    
});
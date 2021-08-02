Ext.define('HreRem.view.agrupacion.detalle.OfertasComercialAgrupacion', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'ofertascomercialagrupacion',
    reference	: 'ofertascomercialagrupacionref',
    requires	: ['HreRem.view.agrupacion.detalle.OfertasComercialAgrupacionList'],
    scrollable	: 'y',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.activos.listado.ofertas"));
        
        var items = [      			
        			{	
        				xtype: 'ofertascomercialagrupacionlist',
        				reference: 'ofertascomercialagrupacionlistref'        				
        			}
        
        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent(); 
        
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().loadPage(1);
  		});
    },
    
    editFuncion: function(editor, context){
    	var me = this;
    	var estado = context.record.get("codigoEstadoOferta");
    	var gencat = context.record.get("gencat");
    	var msg = HreRem.i18n('msg.desea.aceptar.oferta');
    	
    	if(CONST.ESTADOS_OFERTA['ACEPTADA'] == estado){
    		if(gencat == "true"){
    			msg = HreRem.i18n('msg.desea.aceptar.oferta.activos.gencat');
    		}
    		Ext.Msg.show({
    			title: HreRem.i18n('title.confirmar.oferta.aceptacion'),
    			msg: msg,
    			buttons: Ext.MessageBox.YESNO,
  			    fn: function(buttonId) {
  			    	if (buttonId == 'yes') {
  			    		me.saveFn(editor, me, context);
  			    	}else{
  			    		me.getStore().load();
  			    	}
  			    }
    		})
    	}
    }


});
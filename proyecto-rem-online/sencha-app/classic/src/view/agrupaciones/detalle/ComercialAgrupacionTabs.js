Ext.define('HreRem.view.agrupacion.detalle.ComercialAgrupacionTabs', {
    extend: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'comercialagrupaciontabs',
    reference	: 'comercialagrupaciontabsref',
    layout		: 'fit',
    requires: ['HreRem.view.agrupacion.detalle.VisitasComercialAgrupacion','HreRem.view.agrupacion.detalle.OfertasComercialAgrupacion'],    

	listeners: {
		boxready: function (tabPanel) {   		
    		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}	
			
			if(tab.ocultarBotonesEdicion) {
				tabPanel.down("[itemId=botoneditar]").setVisible(false);
			} else {
            	tabPanel.evaluarBotonesEdicion(tab);
			}
		},
		 beforeshow: function (tabPanel, tabNext, tabCurrent) {
			
    		tabPanel.evaluarBotonesEdicion(tabNext);
		}
    	
        
    },
    
    initComponent: function () {
    	
    	var me = this;
    	
    	var items = [
			{
				xtype: 'ofertascomercialagrupacion'
			},
			{
				xtype: 'visitascomercialagrupacion'
			}
    	];
    	
    	
    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    },
    
    evaluarBotonesEdicion: function(tab) {  
		var me = this;
		var detalleMain = me.up('agrupacionesdetallemain');
		var esTramitable = detalleMain.getViewModel().get('comercialagrupacion.tramitable');
		if(esTramitable == null){
			esTramitable = detalleMain.getViewModel().get('agrupacionficha.tramitable');
		}
		var funcion = $AU.userHasFunction('AUTORIZAR_TRAMITACION_OFERTA');
		var usuariosValidos = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['AUTOTRAMOFR'])
	    		
		if(!esTramitable && funcion && usuariosValidos){
			me.up('agrupacionesdetallemain').down("[itemId=botoneditar]").setVisible(true);
		}else{
			me.up('agrupacionesdetallemain').down("[itemId=botoneditar]").setVisible(false);
			
		}
	}
});
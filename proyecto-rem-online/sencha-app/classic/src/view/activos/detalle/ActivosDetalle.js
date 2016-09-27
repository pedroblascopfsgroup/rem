Ext.define('HreRem.view.activos.detalle.ActivosDetalle', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'activosdetalle',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    requires : ['HreRem.view.activos.detalle.DatosGeneralesActivo', 'HreRem.view.activos.detalle.AdmisionActivo', 'HreRem.view.activos.tramites.TramitesActivo', 
    			'HreRem.view.activos.detalle.ObservacionesActivo', 'HreRem.view.activos.detalle.AgrupacionesActivo', 'HreRem.view.activos.detalle.GestoresActivo', 
    			'HreRem.view.activos.detalle.FotosActivo','HreRem.view.activos.detalle.DocumentosActivo','HreRem.view.activos.detalle.GestionActivo',
    			'HreRem.view.activos.detalle.PreciosActivo','HreRem.view.activos.detalle.Publicacion','HreRem.view.activos.detalle.ComercialActivo'],
    
		
	listeners: {
			    	
    	boxready: function (tabPanel) {    		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}
    	}
	},
	
    initComponent: function() {
    	
    	var me = this;
	    me.callParent(); 
	    $AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'datosgeneralesactivo'})}, 'TAB_ACTIVO_DATOS_GENERALES');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'tramitesactivo'})}, 'TAB_ACTIVO_ACTUACIONES');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'gestoresactivo'})}, 'TAB_ACTIVO_GESTORES');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'observacionesactivo'})}, 'TAB_ACTIVO_OBSERVACIONES');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'fotosactivo'})}, 'TAB_ACTIVO_FOTOS');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'documentosactivo'})}, 'TAB_ACTIVO_DOCUMENTOS');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'agrupacionesactivo'})}, 'TAB_ACTIVO_AGRUPACIONES');
    	// Si el activo esta en agrupacion asistida, se ocultan estas dos pestanyas
    	if(me.lookupController().getViewModel().get('activo').get('integradoEnAgrupacionAsistida')=="false") {
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'admisionactivo'})}, 'TAB_ACTIVO_ADMISION');
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'gestionactivo'})}, 'TAB_ACTIVO_GESTION');
    	}
    	
    	me.add({xtype: 'preciosactivo'});
    	me.add({xtype: 'publicacionactivo'});
    	me.add({xtype: 'comercialactivo'});


    }
    
});
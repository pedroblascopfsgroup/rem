Ext.define('HreRem.view.activos.comercial.solicitudes.SolicitudesMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'solicitudesmain',
    reference	: 'solicitudesMain',
	title		: 'Solicitudes',
	layout : {
		type : 'crossfadecard' // Layout que sobrescribe el layaout card para dar efecto a la transición entre cards. No se utilizará por el momento.
	},   

	closable	: false, 
            
    requires: [
        'HreRem.view.activos.comercial.solicitudes.SolicitudesGestion'/*,
        'HreRem.view.activos.comercial.solicitudes.SolicitudDetalle'*/
    ],
    
   	controller: 'solicitudes',
    /*viewModel: {
        type: 'solicitudes'
    },*/
    
    
    initComponent: function () {
    	
        var me = this;
        
        me.items = [
        	
			{xtype: "solicitudesgestion"}/*,
			{xtype: "solicituddetalle"}*/
        	      
        ] 
        
        me.callParent();
        
    }
});
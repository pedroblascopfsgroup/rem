Ext.define('HreRem.view.activos.comercial.visitas.VisitasTabMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'visitastabmain',
	title		: 'Visitas',
	layout : {
		type : 'vbox',
		align : 'stretch'
	},
	scrollable	: 'y',
    closable	: false, 
            
    requires: [
        'HreRem.view.activos.comercial.visitas.VisitasSearch',
        'HreRem.view.activos.comercial.visitas.VisitasList',
        //'HreRem.view.activos.comercial.visitas.VisitasModel',
        'HreRem.view.activos.comercial.visitas.VisitasController'
    ],
    
    controller: 'visitas',
   /* viewModel: {
        type: 'visitas'
    },   
    */
    initComponent: function () {
    	
        var me = this;
        
        me.items = [
        	
			{xtype: "visitassearch"},
			{xtype: "visitaslist"},
			{xtype: "visitasdetalle"}
        	      
        ] 
        
        me.callParent();
        
    }
});
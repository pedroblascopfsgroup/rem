Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.economicas.CondicionesEconomicasTabMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'condicioneseconomicastabmain',
	title		: 'Condiciones económicas',
	layout : {
		type : 'fit',
		align : 'stretch'
	},   
	scrollable	: 'y',
    closable	: false, 
            
    requires: [
        //'HreRem.view.activos.actuaciones.historicoTareas.HistoricoTareasSearch',
        'HreRem.view.activos.comercial.ofertas.condiciones.economicas.ComisionesList'    
    ],
    
    
   	controller: 'ofertas',
    viewModel: {
        type: 'comisiones'
    },
    
    
    initComponent: function () {
    	
        var me = this;
        
        me.items = [
        	
			{xtype: "condicioneseconomicasdetalle"},
			{xtype: "comisioneslist"}
        	      
        ] 
        
        me.callParent();
        
    }
});
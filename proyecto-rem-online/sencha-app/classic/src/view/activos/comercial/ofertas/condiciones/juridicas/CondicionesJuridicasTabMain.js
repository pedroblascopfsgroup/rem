Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.juridicas.CondicionesJuridicasTabMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'condicionesjuridicastabmain',
	title		: 'Condiciones jurídicas',
	layout : {
		type : 'fit',
		align : 'stretch'
	},   
	scrollable	: 'y',
    closable	: false, 

   	controller: 'ofertas',
    viewModel: {
        type: 'condicionesjuridicas'
    },
    
    
    initComponent: function () {
    	
        var me = this;
        
        me.items = [
        	
			{xtype: "condicionesjuridicasdetalle"},
			{xtype: "licenciaslist"},
			{xtype: "saneamientoslist"}
        	      
        ] 
        
        me.callParent();
        
    }
});
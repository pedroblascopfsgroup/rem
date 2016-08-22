Ext.define('HreRem.view.activos.comercial.ofertas.propuestas.PropuestasTabMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'propuestastabmain',
	title		: 'Propuestas',
	layout : {
		type : 'vbox',
		align : 'stretch'
	},
	scrollable	: 'y',
    closable	: false, 

    controller: 'ofertas',
   /* viewModel: {
        type: 'visitas'
    },   
    */
    initComponent: function () {
    	
        var me = this;
        
        me.items = [
        	
			{xtype: "propuestassearch"},
			{xtype: "propuestaslist"}
        	      
        ] 
        
        me.callParent();
        
    }
});
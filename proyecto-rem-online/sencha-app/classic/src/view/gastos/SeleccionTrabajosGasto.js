Ext.define('HreRem.view.gastos.SeleccionTrabajosGasto', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'selecciontrabajosgasto',
    requires: ['HreRem.view.gastos.SeleccionTrabajosGastoSearch', 'HreRem.view.gastos.SeleccionTrabajosGastoList'],
    layout: {
        type: 'vbox',
        align : 'stretch',
        pack  : 'start'
    },
    width	: Ext.Element.getViewportWidth() / 1.1,    
    //height	: Ext.Element.getViewportHeight() > 600 ? 600 : Ext.Element.getViewportHeight() - 50 ,
    closable: true,		
    closeAction: 'hide',
    		
    controller: 'gastodetalle',
    viewModel: {
        type: 'gastodetalle'
    },
    
    idGasto: null,
    
    parent: null, 
    
    listeners: {
    	
		show: function() {			
			var me = this;
			me.resetWindow();			
		}
		
	},
    
	initComponent: function() {
    	
    	var me = this;
    	
    	me.setTitle(HreRem.i18n('title.seleccion.trabajos'));
    	me.items = [
    	
    	{
    		xtype: 'trabajosgastosearch'
    	},
    	{
    		xtype: 'trabajosgastolist'
    	}
    		  
    	];
    	
    	me.callParent();
    },
    
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('gasto.idGasto', me.idGasto);

    }
});
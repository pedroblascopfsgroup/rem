Ext.define('HreRem.view.gastos.SeleccionTrabajosGasto', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'selecciontrabajosgasto',
    requires: ['HreRem.view.gastos.SeleccionTrabajosGastoSearch', 'HreRem.view.gastos.SeleccionTrabajosGastoList'],
    layout: {
        type: 'vbox',
        align : 'stretch',
        pack  : 'start'
    },
    width	: Ext.Element.getViewportWidth() / 1.2,    
    height	: Ext.Element.getViewportHeight() > 600 ? 600 : Ext.Element.getViewportHeight() - 50 ,
    		
    controller: 'gastodetalle',
    viewModel: {
        type: 'gastodetalle'
    },
    
    gasto: null,
    
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
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Añadir selección', handler: 'onClickBotonAnyadirSeleccionTrabajos', disabled: true},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarSeleccionTrabajos'}];
    	
    	me.items = [
    	
    	{
    		xtype: 'selecciontrabajosgastosearch',
    		reference: 'seleccionTrabajosGastoSearch'
    	},
    	{
    		xtype: 'selecciontrabajosgastolist',
    		reference: 'seleccionTrabajosGastoList'
    	}
    		  
    	];
    	
    	me.callParent();
    },
    
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('gasto', me.gasto);
    	me.getViewModel().notify();
    	
    	Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().loadPage(1);
  		});	

    }
});
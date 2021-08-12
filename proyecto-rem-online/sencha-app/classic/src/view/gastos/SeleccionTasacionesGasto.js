Ext.define('HreRem.view.gastos.SeleccionTasacionesGasto', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'selecciontasacionesgasto',
    requires: ['HreRem.view.gastos.SeleccionTasacionesGastoSearch', 'HreRem.view.gastos.SeleccionTasacionesGastoList'],
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
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Añadir selección', handler: 'asignarSeleccionTasacionesGasto', disabled: true},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'cancelarSeleccionTasacionesGasto'}];
    	
    	me.items = [
    	
    	{
    		xtype: 'selecciontasacionesgastosearch',
    		reference: 'selecciontasacionesgastosearch'
    	},
    	{
    		xtype: 'selecciontasacionesgastolist',
    		reference: 'selecciontasacionesgastolist'
    	}
    		  
    	];
    	
    	me.callParent();
    },
    
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('gasto', me.gasto);
    	me.getViewModel().notify();
    }
});
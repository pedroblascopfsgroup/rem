Ext.define('HreRem.view.expedientes.BuscarCompareciente', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'buscarcompareciente',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 2,    
    //height	: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 50 ,
    //closable: true,		
    //closeAction: 'hide',
    
    idTrabajo: null,
    
    parent: null,
    		
    modoEdicion: null,
    
    presupuesto: null,
    
    controller: 'expedientedetalle',
    viewModel: {
        type: 'expedientedetalle'
    },
    
    requires: ['HreRem.view.expedientes.BuscarComparecienteDetalle'],
    
    listeners: {    
		boxready: function(window) {
			var me = this;
			
			Ext.Array.each(window.down('fieldset').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
					}
			);
		},
		
		show: function() {
			var me = this;
			me.resetWindow();			
		}
	},
    
	initComponent: function() {
    	
    	var me = this;
    	
    	me.buttons = [ { itemId: 'btnAgregar', text: 'Agregar', handler: 'onClickBotonAgregarCompareciente'},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarBusquedaCompareciente'}];
    	
    	me.items = [
					{
						xtype: 'buscarcomparecientedetalle'
						
				}
    	];
    	
    	me.callParent();
    	me.setTitle(HreRem.i18n('title.busqueda.compareciente'));
    },
    
    resetWindow: function() {
    	var me = this,    	
    	form = me.down('formBase');
		form.setBindRecord(me.oferta);
	
    }
    
});
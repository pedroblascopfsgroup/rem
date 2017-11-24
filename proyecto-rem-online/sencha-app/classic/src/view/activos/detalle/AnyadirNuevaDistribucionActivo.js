Ext.define('HreRem.view.activos.detalle.AnyadirNuevaDistribucionActivo', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirnuevadistribucionactivo',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,    
    /*
    idTrabajo: null,
    
    parent: null,
    		
    modoEdicion: null,
    
    presupuesto: null,
    */
    
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    requires: ['HreRem.model.Distribuciones', 'HreRem.view.activos.detalle.AnyadirNuevaDistribucionDetalle'],
    
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
		}
	
	},

	initComponent: function() {
    	
    	var me = this;
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: HreRem.i18n('label.anyadir.distribucion'), handler: 'onClickBotonGuardarDistribucion'},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarDistribucion'}];
    	
    	me.items = [
					{
						xtype: 'anyadirnuevadistribuciondetalle'
					}
    	];
    	
    	me.callParent();
    	me.setTitle(HreRem.i18n('label.anyadir.distribucion'));
    }
    
    
});
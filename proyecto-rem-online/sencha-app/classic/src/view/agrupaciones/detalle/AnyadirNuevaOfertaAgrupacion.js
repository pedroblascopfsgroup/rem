Ext.define('HreRem.view.agrupaciones.detalle.AnyadirNuevaOfertaAgrupacion', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirnuevaofertaagrupacion',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 2,    
    //height	: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 50 ,
    //closable: true,		
    //closeAction: 'hide',
    
    idTrabajo: null,
    
    parent: null,
    		
    modoEdicion: null,
    
    presupuesto: null,
    
    controller: 'agrupaciondetalle',
    viewModel: {
        type: 'agrupaciondetalle'
    },
    
    requires: ['HreRem.model.OfertaComercial', 'HreRem.view.agrupaciones.detalle.AnyadirNuevaOfertaDetalle'],
    
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
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickBotonGuardarOferta'},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarOferta'}];
    	
    	me.items = [
					{
						xtype: 'anyadirnuevaofertadetalle'
				}
    	];
    	
    	me.callParent();
    	me.setTitle(HreRem.i18n('title.nueva.oferta'));
    },
    
    resetWindow: function() {
    	var me = this,    	
    	form = me.down('formBase');
		form.setBindRecord(me.oferta);
	
    }
    
});
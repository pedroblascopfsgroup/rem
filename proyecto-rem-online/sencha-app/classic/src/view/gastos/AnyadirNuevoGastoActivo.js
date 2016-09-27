Ext.define('HreRem.view.gastos.AnyadirNuevoGastoActivo', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirnuevogastoactivo',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,    
    //height	: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 50 ,
    //closable: true,		
    //closeAction: 'hide',
    
    idTrabajo: null,
    
    parent: null,
    		
    modoEdicion: null,
    
    presupuesto: null,
    
    controller: 'gastodetalle',
    viewModel: {
        type: 'gastodetalle'
    },
    
    requires: ['HreRem.view.gastos.AnyadirNuevoGastoActivoDetalle'],
    
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
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Añadir', handler: 'onClickBotonGuardarGastoActivo'},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarGastoActivo'}];
    	
    	me.items = [
					{
						xtype: 'anyadirnuevogastoactivodetalle'
					}
    	];
    	
    	me.callParent();
    	me.setTitle(HreRem.i18n('title.anyadir.activo.agrupacion'));
    },
    
    resetWindow: function() {
    	var me = this,    	
    	form = me.down('formBase');
		form.setBindRecord(me.oferta);
	
    }
    
});
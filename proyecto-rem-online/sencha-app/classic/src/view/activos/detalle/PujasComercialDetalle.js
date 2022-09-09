Ext.define('HreRem.view.activos.detalle.PujasComercialDetalle', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'pujascomercialdetalle',
    reference	: 'windowPujasComercialDetalle',
    layout		: 'fit',
    width		: Ext.Element.getViewportWidth() / 1.5,    
    detallepuja: null,
    detallehistoricoconcurrencia: null,
    modoEdicion: false,
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    listeners: {
		show: function() {
			var me = this;
			me.resetWindow();			
		},
		
		boxready: function(window) {
			var me = this;
			me.initWindow();
		}
	},
	
	initWindow: function() {
    	var me = this;
    	if(me.modoEdicion) {
			Ext.Array.each(me.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) { 								
					field.fireEvent('edit');
					if(index == 0) field.focus();
				}
			);
    	}
    },

	initComponent: function() {
    	var me = this;
    	me.buttons = [ { itemId: 'btnCerrar', text: 'Cerrar', handler: 'onClickBotonCerrarDetallePujas'}];
    	var detallepuja= me.detallepuja.data;
    	me.items = [
			{	
				xtype:'formBase',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.lista.pujas'),
				items :
					[
						{
							xtype: 'pujadetalleofertagrid'
						}
					]
			}
    	];

    	var title= "Número de la oferta: "+detallepuja.numOferta;
    	me.callParent();
    	me.setTitle(title);
    },

    resetWindow: function() {
		var me = this;
    	me.getViewModel().set('detallepuja', me.detallepuja.data);
    }
});
Ext.define('HreRem.view.expedientes.editarAuditoriaDesbloqueo', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'editarAuditoriaDesbloqueo',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,    
    expediente : null,
    viewChained : null,
    controller: 'expedientedetalle',
    requires: ['HreRem.view.expedientes.ExpedienteDetalleModel'],
    listeners: {    
		show: function() {			
			var me = this;
			me.resetWindow();			
		}
	},
	initComponent: function() {
    	var me = this;
    	me.buttons = [
    		{ itemId: 'btnGuardar', 
    		  text: 'Aceptar', 
    		  handler: 'onClickBotonGuardarAuditoria'
    		},
    		{ itemId: 'btnCancelar', 
    		  text: 'Cancelar', 
    		  handler: 'onClickBotonCancelarAuditoria'
    		}
    	];
    	me.items = [
					{
						xtype: 'fieldset', 
						title: HreRem.i18n('fieldlabel.nombre.auditoria.desbloqueo'), 
						
						items: [
		    			   {
		    				   xtype: 'textfield',
		    		           fieldLabel: 'Comentario de desbloqueo',
		    		           width: 400,
		    		           maxLength: 248,
		    		           enforceMaxLength: true,
		    		           name: 'comentario'
		    			   }
		    		]
				}
    	];
    	
    	me.callParent();
    }
});
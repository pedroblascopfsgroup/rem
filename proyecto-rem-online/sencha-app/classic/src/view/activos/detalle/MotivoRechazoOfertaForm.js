Ext.define('HreRem.view.activos.detalle.MotivoRechazoOfertaForm', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'motivorechazoofertawindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() > 700 ? 700 : Ext.Element.getViewportWidth() - 30,    
    height	: Ext.Element.getViewportHeight() > 200 ? 200 : Ext.Element.getViewportHeight() - 30 ,
	cls:'',
	
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    ofertaRecord: null,
    
    modoEdicion: null,
    
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

    	me.setTitle(HreRem.i18n('titulo.motivorechazoform'));
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Guardar', handler: 'onClickBotonGuardarMotivoRechazo'}, { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarMotivoRechazo'}];
    	
    	me.items = [
				{
					xtype: 'fieldset', 
					collapsed: false,
				 	scrollable	: 'y',
					layout: {
				        type: 'table',
				        // The total column count must be specified here
				        columns: 1,
				        trAttrs: {height: '45px', width: '100%'},
				        tdAttrs: {width: '100%'},
				        tableAttrs: {
				            style: {
				                width: '100%'
							}
				        }
					},
					
					items: [
						{ 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.motivorechazoform.tipo'),
							reference: 'comboTipoRechazoOfertaRef',
				        	chainedStore: 'comboMotivoRechazoOferta',
							chainedReference: 'comboMotivoRechazoOfertaRef',
							allowblank: 'false',
				        	bind: {
			            		store: '{comboTipoRechazoOferta}',
			            		value: '{ofertaRecord.tipoRechazoCodigo}'
			            	},
    						listeners: {
			                	select: 'onChangeChainedCombo'
			            	}
				        },
						{ 
							xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.motivorechazoform.motivo'),
				        	reference: 'comboMotivoRechazoOfertaRef',
							allowblank: 'false',
							minWidth: '600',
					        bind: {
			            		store: '{comboMotivoRechazoOferta}',
			            		value: '{ofertaRecord.motivoRechazoCodigo}',
			            		disabled: '{!ofertaRecord.tipoRechazoCodigo}'
			            	}
				        }
					]
		}];
    	
    	me.callParent();
    },
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('ofertaRecord', me.ofertaRecord);
    }
});
    
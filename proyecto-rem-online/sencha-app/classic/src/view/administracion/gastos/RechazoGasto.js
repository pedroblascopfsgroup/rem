Ext.define('HreRem.view.administracion.gastos.RechazoGasto', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'rechazarGasto',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3.5,    
        
    parent: null,
    		
    modoEdicion: null,
    
    listaGastos: null,
	origen : null,
	
    controller: 'administracion',
    
    requires: ['HreRem.model.GastoProveedor'],
    
    listeners: {    
		boxready: function(window) {
			var me = this;
			        	
			Ext.Array.each(window.down('form').query('field[isReadOnlyEdit]'),
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
    	var storeMotivosRechazo = new Ext.data.Store({  
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosRechazoHaya'}
			}
    	}); 
    	me.setTitle(HreRem.i18n('title.motivo.rechazo'));
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Aceptar', handler: 'onClickMotivoRechazoGasto'},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarRechazoGasto'}];
    	
    	me.items = [
    	
			    	{
			    		xtype: 'formBase',
			    		cls: 'rechazar-gasto-form',
			    		layout: 'fit',			    		
			    		collapsed: false,	  				
						recordName: "gastoNuevo",						
						recordClass: "HreRem.model.GastoProveedor",
					    items : [
								{
									xtype:'fieldset',
									cls: 'x-fieldset-anyadir-gasto',
									flex: 1,
									layout: {
									        type: 'table',
									        // The total column count must be specified here
									        columns: 1,
									        trAttrs: {height: '45px', width: '100%'},
									        tableAttrs: {
									            style: {
									                width: '100%'
												}
									        }
									},
									defaultType: 'textfieldbase',
									collapsed: false,
									scrollable	: 'y', 
									align:'left',
							        items: [
												{
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gasto.motivo'),	
													reference: 'comboMotivo',
													allowBlank: false,
													store: storeMotivosRechazo,
													emptyText: HreRem.i18n('txt.seleccionar.motivo'),
    												valueField		: 'codigo',
									            	listeners: {
									            		change: 'onChangeMotivoRechazo'
									            	}
							            	    },
								                {
													xtype: 'textfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gasto.motivo.otros'),
													disabled : true,
													reference: 'otrosMotivoRechazo',
													name: 'otrosMotivoRechazo'
												}
							            	  
							            ]
				
			    			}	
			    		]
			
			    	}
			  ];
			  
			  me.callParent();
	}
});
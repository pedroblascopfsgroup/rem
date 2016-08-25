Ext.define('HreRem.view.expedientes.ExpedienteDetalle', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'expedientedetalle',
	cls			: 'panel-base shadow-panel tabPanel-segundo-nivel',
    requires : ['HreRem.view.expedientes.DatosBasicosExpediente', 'HreRem.view.expedientes.OfertaExpediente',
    			'HreRem.view.expedientes.ReservaExpediente'],
    
		
    listeners: {
   		
			boxready: function (tabPanel) {

				if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
					var tab = tabPanel.items.items[0];
					tabPanel.setActiveTab(tab);
				}
				
				if(tab.ocultarBotonesEdicion) {
					tabPanel.down("[itemId=botoneditar]").setVisible(false);
				} else {		
	            	tabPanel.evaluarBotonesEdicion(tab);
				}
				  					
			},
	    	
			beforetabchange: function (tabPanel, tabNext, tabCurrent) {

	        	tabPanel.down("[itemId=botoneditar]").setVisible(false);	            	
	        	// Comprobamos si estamos editando para confirmar el cambio de pestaña
	        	if (tabCurrent != null) {
	        		if (tabPanel.down("[itemId=botonguardar]").isVisible()){	
	            		Ext.Msg.show({
	            			   title: HreRem.i18n('title.descartar.cambios'),
	            			   msg: HreRem.i18n('msg.desea.descartar'),
	            			   buttons: Ext.MessageBox.YESNO,
	            			   fn: function(buttonId) {
	            			        if (buttonId == 'yes') {
	            			        	var btn = tabPanel.down('button[itemId=botoncancelar]');
	            			        	Ext.callback(btn.handler, btn.scope, [btn, null], 0, btn);
	            			        	tabPanel.getLayout().setActiveItem(tabNext);		            			        	
							            // Si la pestaña necesita botones de edición
					   					if(!tabNext.ocultarBotonesEdicion) {
						            		tabPanel.evaluarBotonesEdicion(tabNext);
					   					}
	            			        }
	            			   }
	        			});            		
	            		return false;
	        		}
	        		// Si la pestaña necesita botones de edición
	        		if(!tabNext.ocultarBotonesEdicion) {
	        			tabPanel.evaluarBotonesEdicion(tabNext);
	        		}
	        		return true;
	        	}
			}
		},
		
		tabBar: {
		    
			items: [
					{
						xtype: 'tbfill'
					},
					{
						xtype: 'buttontab',
						itemId: 'botoneditar',
					    handler	: 'onClickBotonEditar',
					    iconCls: 'edit-button-color'
					},
					{
						xtype: 'buttontab',
						itemId: 'botonguardar',
					    handler	: 'onClickBotonGuardar', 
					    iconCls: 'save-button-color',
				        hidden: true
					},
					{
						xtype: 'buttontab',
						itemId: 'botoncancelar',
					    handler	: 'onClickBotonCancelar', 
					    iconCls: 'cancel-button-color',
					   	hidden: true
					}
			]
		},
		items: [
		        {
		        	xtype: 'datosbasicosexpediente', ocultarBotonesEdicion: true
		        	
		        },
		        {
		        	xtype: 'ofertaexpediente', ocultarBotonesEdicion: true
		        },
		        {
		        	xtype: 'reservaexpediente' 
		        }

		],
		
		evaluarBotonesEdicion: function(tab) {    	
			var me = this;
			me.down("[itemId=botoneditar]").setVisible(false);
			var editionEnabled = function() {
				me.down("[itemId=botoneditar]").setVisible(true);
			}
			
			// Si la pestaña recibida no tiene asignados roles de edicion 
			if(Ext.isEmpty(tab.funPermEdition)) {
				editionEnabled();
			} else {
				$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
			}
			
		}
    
});


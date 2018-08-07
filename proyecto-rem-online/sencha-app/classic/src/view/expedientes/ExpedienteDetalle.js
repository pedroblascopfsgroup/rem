Ext.define('HreRem.view.expedientes.ExpedienteDetalle', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'expedientedetalle',
	cls			: 'panel-base shadow-panel tabPanel-segundo-nivel',
    requires 	: ['HreRem.view.expedientes.DatosBasicosExpediente', 'HreRem.view.expedientes.OfertaExpediente',
    			'HreRem.view.expedientes.ReservaExpediente', 'HreRem.view.expedientes.DiarioGestionesExpediente',
    			'HreRem.view.expedientes.DocumentosExpediente', 'HreRem.view.expedientes.ActivosExpediente',
    			'HreRem.view.expedientes.TramitesTareasExpediente','HreRem.view.expedientes.CondicionesExpediente',
    			'HreRem.view.expedientes.FormalizacionExpediente', 'HreRem.view.expedientes.GestionEconomicaExpediente',
				'HreRem.view.expedientes.CompradoresExpediente', 'HreRem.view.expedientes.OfertaTanteoYRetracto',
				'HreRem.view.expedientes.GestoresExpediente'],
	bloqueado: false,

    listeners	: {
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
				if(tabNext.getTitle() == "Ficha"){
					var itemsExpedienteForm = tabNext.getForm().getFields().items;
			    	
			    	var itemReserva = itemsExpedienteForm.find(function(item){return item.fieldLabel === "Fecha de reserva"});

			    	if(itemReserva != null){
			    		var me = tabNext;
			    		me.lookupController().tareaDefinicionDeOferta(itemReserva);   
			    	}
					
				}
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

		initComponent: function () {
	        var me = this;

	        var items = [];
	    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datosbasicosexpediente', funPermEdition: ['EDITAR_TAB_DATOS_BASICOS_EXPEDIENTES']})}, ['TAB_DATOS_BASICOS_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'ofertaexpediente', ocultarBotonesEdicion: true})}, ['TAB_OFERTA_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'condicionesexpediente', funPermEdition: ['EDITAR_TAB_CONDICIONES_EXPEDIENTES']})}, ['TAB_CONDICIONES_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'activosexpediente', ocultarBotonesEdicion: true})}, ['TAB_ACTIVOS_COMERCIALIZABLES_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'reservaexpediente', bind: {disabled: '{esExpedienteSinReservaOdeTipoAlquiler}'}, funPermEdition: ['EDITAR_TAB_RESERVA_EXPEDIENTES']})}, ['TAB_RESERVA_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'compradoresexpediente', ocultarBotonesEdicion: true})}, ['TAB_COMPRADORES_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'diariogestionesexpediente', ocultarBotonesEdicion: true})}, ['TAB_DIARIO_GESTIONES_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'tramitestareasexpediente', ocultarBotonesEdicion: true})}, ['TAB_TRÁMITES_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'gestoresexpediente', ocultarBotonesEdicion: true})}, ['TAB_GESTORES_EXPEDIENTES']);//Poner permiso especifico?
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'documentosexpediente', ocultarBotonesEdicion: true})}, ['TAB_DOCUMENTOS_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'formalizacionexpediente', funPermEdition: ['EDITAR_TAB_FORMALIZACION_EXPEDIENTES']})}, ['TAB_FORMALIZACION_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'gestioneconomicaexpediente', ocultarBotonesEdicion: true})}, ['TAB_GESTION_ECONOMICA_EXPEDIENTES']);

	        me.addPlugin({ptype: 'lazyitems', items: items});
	        me.callParent();
	    },

		evaluarBotonesEdicion: function(tab) {
			var me = this;
			me.bloquearExpediente(tab,me.bloqueado);
		},
	    bloquearExpediente: function(tab,bloqueado) {    	
			var me = this;
			me.bloqueado = bloqueado;
			me.down("[itemId=botoneditar]").setVisible(false);
			var editionEnabled = function() {
				me.down("[itemId=botoneditar]").setVisible(true);
			}
			
			if(!bloqueado){
				// Si la pestaña recibida no tiene asignados roles de edicion 
				if(Ext.isEmpty(tab.funPermEdition)) {
					editionEnabled();
				} else {
					$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
				}
			}else{
				me.down("[itemId=botoneditar]").setVisible(false);
			}
		}
});
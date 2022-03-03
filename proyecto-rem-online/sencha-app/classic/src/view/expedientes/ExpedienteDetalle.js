Ext.define('HreRem.view.expedientes.ExpedienteDetalle', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'expedientedetalle',
	cls			: 'panel-base shadow-panel tabPanel-segundo-nivel',
    requires 	: ['HreRem.view.expedientes.DatosBasicosExpediente', 'HreRem.view.expedientes.OfertaExpediente',
    			'HreRem.view.expedientes.ReservaExpediente', 'HreRem.view.expedientes.DiarioGestionesExpediente',
    			'HreRem.view.expedientes.DocumentosExpediente', 'HreRem.view.expedientes.ActivosExpediente',
    			'HreRem.view.expedientes.TramitesTareasExpediente','HreRem.view.expedientes.CondicionesExpediente',
    			'HreRem.view.expedientes.FormalizacionExpediente', 'HreRem.view.expedientes.GestionEconomicaExpediente',
				'HreRem.view.expedientes.CompradoresExpediente', 'HreRem.view.expedientes.ScoringExpediente',
				'HreRem.view.expedientes.GestoresExpediente','HreRem.view.expedientes.ScoringExpediente',
				'HreRem.view.expedientes.SeguroRentasExpediente', 'HreRem.model.HstcoSeguroRentas','HreRem.model.DatosBasicosOferta',
				'HreRem.view.expedientes.FormalizacionAlquilerExpediente', 'HreRem.view.expedientes.PlusValiaVentaExpediente',
				'HreRem.view.expedientes.GarantiasExpediente'],

	bloqueado: false,
	procesado: false,
	
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
				this.checkProceso(tabPanel);
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
				
				this.checkProceso(tabPanel);
				
				if(tabNext.getTitle() == HreRem.i18n('title.oferta')){
					tabNext.down("[itemId=botoneditar]").setDisabled(!this.procesado);
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
										this.checkProceso(tabPanel);
	            			        }
	            			   }
	        			});            		
	            		return false;
	        		}
	        		// Si la pestaña necesita botones de edición
	        		if(tabNext.reference === 'reservaExpediente'){
	        			tabPanel.evaluarBotonesEdicion(tabNext);
	        		}else if(!tabNext.ocultarBotonesEdicion) {
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
					    iconCls: 'edit-button-color',
					    disabled: true
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
	        if (me.lookupController().getViewModel().get('expediente').get('esBankia')) {
	        	var dataExpediente = me.lookupController().getView().getViewModel().getData().expediente.getData();
	        	var tipoExpediente = dataExpediente.tipoExpedienteCodigo;
	        	if (dataExpediente.esBankia && (CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER'] == tipoExpediente || CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER_NO_COMERCIAL'] == tipoExpediente)) {
	        		items.push({xtype: 'garantiasexpediente', ocultarBotonesEdicion: false});
	        	}
	        	
	        }
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'activosexpediente', ocultarBotonesEdicion: true})}, ['TAB_ACTIVOS_COMERCIALIZABLES_EXPEDIENTES']);

	        if(me.lookupController().getViewModel().get('expediente').get('isSubcarteraApple')){
	        	if ($AU.userIsRol(CONST.PERFILES['GESTOR_COMERCIAL_BO_INM']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_COMERCIAL_BO_INM']) || $AU.userIsRol(CONST.PERFILES['GESTBOARDING'])
	        			|| $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_FORM'])|| $AU.userIsRol(CONST.PERFILES['SUPERVISOR_FORM'])) {
	        		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'reservaexpediente', bind: {disabled: '{esExpedienteSinReservaOdeTipoAlquiler}'}, funPermEdition: ['EDITAR_TAB_RESERVA_EXPEDIENTES']})}, ['TAB_RESERVA_EXPEDIENTES']);
	        	} else {
	        		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'reservaexpediente', ocultarBotonesEdicion: true})}, ['TAB_RESERVA_EXPEDIENTES']);
	        	}
	        } else if(me.lookupController().getViewModel().get('expediente').get('esBankia')){ 
	        	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'reservaexpediente', ocultarBotonesEdicion: true , funPermEdition: ['EDITAR_TAB_RESERVA_EXPEDIENTES']})}, ['TAB_RESERVA_EXPEDIENTES']);
			}else{
	        	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'reservaexpediente', bind: {disabled: '{esExpedienteSinReservaOdeTipoAlquiler}'}, funPermEdition: ['EDITAR_TAB_RESERVA_EXPEDIENTES']})}, ['TAB_RESERVA_EXPEDIENTES']);
	        }
	        
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'compradoresexpediente', ocultarBotonesEdicion: true})}, ['TAB_COMPRADORES_EXPEDIENTES']);
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'diariogestionesexpediente', ocultarBotonesEdicion: true})}, ['TAB_DIARIO_GESTIONES_EXPEDIENTES']);
	        if(!(me.lookupController().getViewModel().get('expediente.esActivoHayaHome') && me.lookupController().getViewModel().get('expediente.tipoExpedienteCodigo') == CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER']
					&& !me.lookupController().getViewModel().get('expediente.tieneTramiteComercial'))){
				$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'tramitestareasexpediente', ocultarBotonesEdicion: true})}, ['TAB_TRÁMITES_EXPEDIENTES']);
			}
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'gestoresexpediente', ocultarBotonesEdicion: true})}, ['TAB_GESTORES_EXPEDIENTES']);//Poner permiso especifico?
	        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'documentosexpediente', ocultarBotonesEdicion: true})}, ['TAB_DOCUMENTOS_EXPEDIENTES']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'formalizacionexpediente', funPermEdition: ['EDITAR_TAB_FORMALIZACION_EXPEDIENTES']})}, ['TAB_FORMALIZACION_EXPEDIENTES']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'formalizacionalquilerexpediente', funPermEdition: ['EDITAR_TAB_FORMALIZACION_EXPEDIENTES']})}, ['TAB_FORMALIZACION_EXPEDIENTES']);
			
			if(!$AU.userIsRol(CONST.PERFILES['CARTERA_BBVA'])) {
				$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'gestioneconomicaexpediente', ocultarBotonesEdicion: true})}, ['TAB_GESTION_ECONOMICA_EXPEDIENTES']);
			}
			
			items.push({xtype: 'scoringexpediente'});
        	items.push({xtype: 'segurorentasexpediente'});


	        me.addPlugin({ptype: 'lazyitems', items: items});
	        me.callParent();
	    },

		evaluarBotonesEdicion: function(tab) {
			var me = this;
			if(tab.reference === 'reservaExpediente'){
				var tabAnterior = tab.up('expedientedetallemain').down('[reference=condicionesExpediente]');
				me.bloquearExpedienteReserva(tab,me.bloqueado, tabAnterior);
			}else{
				me.bloquearExpediente(tab,me.bloqueado);

			}
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
		},
		
		bloquearExpedienteReserva: function(tab,bloqueado, tabAnterior) {    	
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
				var editarReserva = true;
				if(!Ext.isEmpty(tabAnterior.down('[reference=tieneReserva]'))){
					if(Ext.isEmpty(tabAnterior.down('[reference=tieneReserva]').value) || tabAnterior.down('[reference=tieneReserva]').value == CONST.COMBO_SI_NO['NO']){
						editarReserva = false;
					}
				}else{
					var dataExpediente = me.lookupController().getView().getViewModel().getData().expediente.getData();
		        	if(dataExpediente.solicitaReserva === "0" || !dataExpediente.tieneReserva){
		        		editarReserva = false;
		    		}
				}
				me.down("[itemId=botoneditar]").setVisible(editarReserva);

			}else{
				me.down("[itemId=botoneditar]").setVisible(false);
			}
		},
		
		checkProceso: function(tabPanel){  
    		var me = this;
			me.lookupController().comprobarProcesoAsincrono(tabPanel, me);    	
    	}
});
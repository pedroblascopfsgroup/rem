Ext.define('HreRem.view.activos.CrearNotificacion', {
    extend		: 'HreRem.view.common.TareaBase',
    xtype		: 'crearNotificacion',
    reference	: 'windowCrearNotificacion',
	requires	: ['HreRem.view.activos.detalleCrearNotificacionModel'],
    viewModel: {
        type: 'crearnotificacion'
    },
    title : "Crear comunicación",    

    initComponent: function() {
    	//debugger;
    	var me = this;
    
    	me.items = [
                
            {
			    xtype: 'form',
			    reference: 'formCrearAnotacion',
			    layout: 'column',    
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 98%'
			    },
			    
			    items: [{
					xtype : 'fieldset',
					collapsible : true,
					defaultType : 'textfield',
					defaults : {
						style : 'width: 100%'
						},
						layout : 'column',
						title : 'Comunicaciones',
		
						items : [
						{
							xtype : 'label',
							cls : 'info-tarea',
							html : "En la presente pantalla deberá indicar los campos necesarios para crear una comunicación a otro usuario de la aplicación.<br /><br />" +
									"- Si marca <b>NOTIFICACIÓN</b> deberá rellenar el <b>Usuario</b> al que va dirigida la comunicación, el <b>título</b> de la misma, " +
									"así como la <b>fecha</b> máxima que tiene el destinatario para responder.<br /><br />" +
									"- Si marca <b>AVISO</b> deberá rellenar el <b>Usuario</b> al que va dirigida la comunicación así como el <b>título</b> de la misma. " +
									"Este tipo de comunicación no tendrá posibilidad de respuesta.",
							tipo : 'info'
						} ]
		
					},{
	        		xtype:'fieldset',
					collapsible: false,
					defaultType: 'textfield',
					layout: 'vbox',
				
					items :
						[
						 {
							xtype:'container',
							collapsible: false,
							defaultType: 'textfield',
							margin: '10 0 20 0',
							layout: 'hbox',							
							items :
								[
									{ 
										xtype: 'combobox',
										fieldLabel: 'Tipo comunicación',
										store : new Ext.data.SimpleStore({
											data : [[1, 'NOTIFICACIÓN'], 
											        [2, 'AVISO']],
											fields : ['id', 'descripcion']
										}),
										valueField : 'id',
										displayField : 'descripcion',
										triggerAction : 'all',
										name: 'tipoComunicacion',
										itemId: 'tipoComunicacion',
										margin: '0 45 0 0',
										editable : false,
										allowBlank: false,
										width: Ext.Element.getViewportWidth() /4 -52
									},
									{ 
										xtype: 'datefield',
										fieldLabel: 'Fecha',
										name: 'fechaNotificacion',
										margin: '0 0 0 0',
										allowBlank: false,
										width: Ext.Element.getViewportWidth() /4 -52
									}
//									,
//									{
//							        	xtype: 'combobox',
//							        	fieldLabel: 'Destinatario',
//							        	bind: {
//						            		store: '{storeGestores}'
//						            	},
//						            	valueField: 'id',
//						            	displayField: 'apellidoNombre',
//						            	triggerAction : 'all',
//										name: 'destinatarioNotificacion',
//										itemId: 'destinatarioNotificacion',
//										margin: '0 20 0 0',
//										editable : false,
//								    	allowBlank: false	
//									}	
								]
							},
							
							{
			                	xtype:'container',
								collapsible: false,
								defaultType: 'textfield',
								margin: '0 0 20 0',
								layout: 'hbox',							
								items :
									[
										{
								        	xtype: 'combo',
								        	fieldLabel: 'Tipo de gestor:',
								        	bind: {
							            		store: '{comboTipoGestor}'
							            	},
											reference: 'tipoGestor',
											name: 'tipoGestor',
				        					chainedStore: 'comboUsuarios',
											chainedReference: 'usuarioGestor',
							            	displayField: 'descripcion',
				    						valueField: 'id',
				    						emptyText: 'Introduzca un gestor',
											margin: '0 45 0 0',
											listeners: {
												select: 'onChangeChainedCombo'
											},
											width: Ext.Element.getViewportWidth() /4 -52
										},
										{
								        	xtype: 'combo',
								        	fieldLabel: 'Usuario:',
								        	reference: 'usuarioGestor',
								        	name: 'usuarioGestor',
								        	bind: {
							            		store: '{comboUsuarios}',
							            		disabled: '{!tipoGestor.selection}'
							            	},
							            	displayField: 'apellidoNombre',
				    						valueField: 'id',
				    						mode: 'local',
				    						emptyText: 'Introduzca un usuario',
				    						enableKeyEvents:true,
			    						    listeners: {
			    						     'keyup': function() {
			    						    	   this.getStore().clearFilter();
			    						    	   this.getStore().filter({
			    						        	    property: 'apellidoNombre',
			    						        	    value: this.getRawValue(),
			    						        	    anyMatch: true,
			    						        	    caseSensitive: false
			    						        	})
			    						     },
			    						     'beforequery': function(queryEvent) {
			    						           queryEvent.combo.onLoad();
			    						     }
			    						    },
			    						    width: Ext.Element.getViewportWidth() /4 -52
									  }
					                ]
			                },	
			                {
			                	xtype:'container',
								collapsible: false,
								defaultType: 'textfield',
								margin: '0 0 20 0',
								layout: 'hbox',							
								items :
									[
										{ 
											xtype: 'textfield',
											fieldLabel: 'Título',
											valueField : 'id',
											displayField : 'descripcion',
											triggerAction : 'all',
											name: 'tituloNotificacion',
											itemId: 'tituloNotificacion',
											margin: '0 0 0 0',
											editable : true,
								    		allowBlank: false,
								    		width: Ext.Element.getViewportWidth() /2 -60
										}
					                ]
			                },
//			                {
//			                	xtype:'container',
//								collapsible: false,
//								defaultType: 'textfield',
//								margin: '0 0 20 0',
//								layout: 'hbox',					
//								
//								items :
//									[
//										{ 
//											xtype: 'datefield',
//											fieldLabel: 'Fecha',
//											name: 'fechaNotificacion',
//											margin: '0 20 0 0',
//											allowBlank: false
//										}
//					                ]
//			                },			        
    						{ 
			                	xtype: 'textarea',
			                	fieldLabel: 'Descripción',
		                        name: 'descripcionNotificacion',
		                        itemId: 'descripcionNotificacion',
		                        width: Ext.Element.getViewportWidth() /2 -60
			                }
						 ]
		    		}
			    		
			    ]
					
    	}];
    	
    	me.callParent();
    	
    	me.validacionCampos();
    
    },	
    
    evaluar: function() {
    	var me = this;
    	//debugger;
    	var parametros = me.down("form").getValues();
    	parametros.idActivo = me.idActivo;
        	var url =  $AC.getRemoteUrl('notificacion/saveNotificacion');
        	
    		Ext.Ajax.request({
    			
    		     url: url,
    		     params: parametros,
    		
    		     success: function(response, opts) {
    				me.destroy();
    		     }
    		 });
           
    	
    },
    
    mostrarValidacionesPre : function() {},
    
    mostrarValidacionesPost : function() {},
    
    
	validacionCampos: function() {
		var me = this;
		
		me.deshabilitarCampo(me.down('[name=tipoGestor]'));
		me.deshabilitarCampo(me.down('[name=usuarioGestor]'));
		//me.deshabilitarCampo(me.down('[name=destinatarioNotificacion']));
		me.deshabilitarCampo(me.down('[name=tituloNotificacion]'));
		me.deshabilitarCampo(me.down('[name=fechaNotificacion]'));
		me.deshabilitarCampo(me.down('[name=descripcionNotificacion]'));
		
		me.down('[name=tipoComunicacion]').addListener('change', function(combo){
			if(combo.value == '1'){
				me.habilitarCampo(me.down('[name=tipoGestor]'));
				me.habilitarCampo(me.down('[name=usuarioGestor]'));
				//me.habilitarCampo(me.down('[name=destinatarioNotificacion]'));
				me.habilitarCampo(me.down('[name=tituloNotificacion]'));
				me.habilitarCampo(me.down('[name=fechaNotificacion]'));
				me.habilitarCampo(me.down('[name=descripcionNotificacion]'));
			}else{
				if(combo.value=='2'){
					me.habilitarCampo(me.down('[name=tipoGestor]'));
					me.habilitarCampo(me.down('[name=usuarioGestor]'));
					//me.habilitarCampo(me.down('[name=destinatarioNotificacion]'));
					me.habilitarCampo(me.down('[name=tituloNotificacion]'));
					me.habilitarCampo(me.down('[name=descripcionNotificacion]'));
					me.deshabilitarCampo(me.down('[name=fechaNotificacion]'));
				}
			}
		})
		
	},
    
		habilitarCampo: function(campo) {				    	
	    	var me = this;
	    	campo.setDisabled(false);
	    	me.campoObligatorio(campo);
		},
		deshabilitarCampo: function(campo) {				    	
			var me = this;
			campo.setDisabled(true);
			me.campoNoObligatorio(campo);
		},
		bloquearCampo: function(campo) {
			var me = this;
			campo.setReadOnly(true);
			me.campoNoObligatorio(campo);
		},
		desbloquearCampo: function(campo) {
			var me = this;
			campo.setReadOnly(false);
			me.campoObligatorio(campo);
		},
		borrarCampo: function(campo) {
			campo.setValue(null);
		},
		campoObligatorio: function(campo){
			var me = this;
			if(campo.noObligatorio){
				campo.allowBlank = true;
			}else{
				campo.allowBlank = false;
			}
		},
		campoNoObligatorio: function(campo){
			var me = this;
			campo.allowBlank = true ;
		}
	
});
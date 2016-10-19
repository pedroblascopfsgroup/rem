Ext.define('HreRem.view.trabajos.detalle.FichaTrabajo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'fichatrabajo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    
    recordName: "trabajo",
	
	recordClass: "HreRem.model.FichaTrabajo",
    
    requires: ['HreRem.model.FichaTrabajo'],
    
    initComponent: function () {

        var me = this;
        
        me.setTitle(HreRem.i18n('title.ficha'));
        
        //Si el tipo es de Precios/Publicacion/Sancion no mostrar el bloque -Cuando hay que hacerlo...-
        me.codigoTipoTrabajo = me.lookupController().getViewModel().get('trabajo').get('tipoTrabajoCodigo');
        
        me.items= [
        			{    
                
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',						
						title: HreRem.i18n('title.objeto'),
						items :
							[
				                { 
				                	xtype: 'displayfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.numero.trabajo'),
				                	bind:		'{trabajo.numTrabajo}'
				                },				                
				                { 
				                	xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.propietario.activo'),
									bind:		'{trabajo.propietario}'
				                },
				                {
						        	xtype: 'displayfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
									bind:		'{trabajo.cartera}'
								},			                
				                { 
						        	xtype: 'displayfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.tipo.trabajo'),
						        	bind: '{trabajo.tipoTrabajoDescripcion}'
						        },
						        {
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.solicitante'),
									bind:		'{trabajo.solicitante}'
						        },
								{ 
				                	xtype: 'textareafieldbase',
				                	rowspan: 3,
				                	height: 160,
				                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
				                	width: 		'100%',
				                	bind:		'{trabajo.descripcion}',
				                	maxLength: 256
		                		},
								{ 
									xtype: 'displayfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.trabajo'),						        	
						        	bind: '{trabajo.subtipoTrabajoDescripcion}'
						        },	
						        {
						        	xtype: 'displayfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.proveedor'),
						        	bind: '{trabajo.nombreProveedor}'				        	
						        	
						        },
						        {
						        	xtype: 'checkboxfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.actuacion.cubierta.seguro'),
						        	reference: 'checkCiaAseguradora',
						        	labelWidth: 200,
						        	bind: '{trabajo.cubreSeguro}',
						        	listeners: {
						        		change: function(check, checked) {
						        			var fieldTextCiaAseguradora = check.up("form").down('[reference=comboCiaAseguradora]');
						        			if(checked) {
						        				fieldTextCiaAseguradora.allowBlank=false;
						        			} else {	
						        				fieldTextCiaAseguradora.setValue("");
						        				fieldTextCiaAseguradora.allowBlank=true;						        				
						        				fieldTextCiaAseguradora.validate();
						        			}
						        		}
						        	}
						        },
						        {
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.compania.aseguradora'),
						        	bind: {
					            		store: '{comboCiasAseguradoras}',
					            		value: '{trabajo.ciaAseguradora}'
					            	},
					            	valueField: 'id',
						        	reference: 'comboCiaAseguradora'/*,
						        	listeners: {
						        		change: function(combo) {
						        			
						        			var checkCiaAseguradora = textfield.up("form").down('[reference=checkCiaAseguradora]'),
						        			value = textfield.getValue();
						        			if(Ext.isEmpty(value)) {
						        				checkCiaAseguradora.setValue(false);
						        			} else {	
						        				checkCiaAseguradora.setValue(true);
						        			}
						        		}
						        	}*/
						        	
						        }
						        						   
						        
							]
		           },
           
		           {    
		                
						xtype:'fieldset',
						layout: {
					        type: 'hbox',
					        align: 'stretch'
						},
						defaults:{
					        xtype: 'fieldset',
					        flex: 1
					    }, 
					    collapsible: true,
					    collapsed: false,
						title: HreRem.i18n('title.momento.realizacion'),
						hidden: (this.codigoTipoTrabajo=="04" || this.codigoTipoTrabajo=="05" || this.codigoTipoTrabajo=="06"),
						items :
							[
								{	
									defaultType: 'textfieldbase',
									items: [
									
											
											{
												xtype: 'checkboxfieldbase',
												boxLabel: HreRem.i18n('title.fecha.concreta'),
												bind: '{trabajo.checkFechaConcreta}',
												reference: 'checkFechaConcreta',
												listeners: {
													change: function(check, checked) {
														var form = check.up("form");
														if(checked) {
															form.down("[reference=checkFechaTope]").setValue(false);
															form.down("[reference=checkFechaContinuado]").setValue(false);
															Ext.Array.each(check.up("fieldset").query("field"), function(field, index) {
																field.allowBlank=false;																
															});
														} else {
															Ext.Array.each(check.up("fieldset").query("field"), function(field, index) {
																field.allowBlank=true;
																field.validate();
																field.setValue("");
																															
															});
														}
													}
													
												}
											},
											{
												xtype: 'datefieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.fecha.debe.realizarse.trabajo'),
												minValue: $AC.getCurrentDate(),
												maxValue: null,
												bind: {
														value:  '{trabajo.fechaConcreta}'
												}
											},
											{
												xtype: 'timefieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.hora.debe.realizarse.trabajo'),
												bind: {
													value: '{trabajo.horaConcreta}'
												}
												
											}										
									
									]
								},
								{
									defaultType: 'textfieldbase',
									items: [									
											
											{
												xtype: 'checkboxfieldbase',
												boxLabel:  HreRem.i18n('title.fecha.tope'),												
												bind: '{trabajo.checkFechaTope}',
												reference: 'checkFechaTope',
												listeners: {
													change: function(check, checked) {																		
														var form = check.up("form");
														if(checked) {
															var me =this;
															form.down("[reference=checkFechaConcreta]").setValue(false);
															form.down("[reference=checkFechaContinuado]").setValue(false);
															Ext.Array.each(check.up("fieldset").query("field"), function(field, index) {
																field.allowBlank=false;																
															});
														} else {
															Ext.Array.each(check.up("fieldset").query("field"), function(field, index) {
																field.allowBlank=true;
																field.validate();
																field.setValue("");
																															
															});
														}
													}
													
												}
												
											},	
											{
												xtype: 'datefieldbase',
												reference: 'datefieldFechaTope',
												fieldLabel: HreRem.i18n('fieldlabel.fecha.debe.finalizar.trabajo'),
												minValue: $AC.getCurrentDate(),
												maxValue: null,
												bind: {
													value: '{trabajo.fechaTope}'
												},
												listeners: {
													select: function(datefield, newValue) {
														var form = datefield.up("form");
														form.down("[reference=checkboxUrgente]").setValue(false);
														form.down("[reference=checkboxRiesgoInminente]").setValue(false);
													}
												}
											},
											{
												xtype: 'checkboxfieldbase',
												reference: "checkboxUrgente",
												fieldLabel: HreRem.i18n('fieldlabel.urgente.respuesta.tres.horas'),
												bind: {
													value: '{trabajo.urgente}'															
												},
												listeners: {
													change: function(check, checked) {
														var form = check.up("form");
														if(checked) {
															var fechaTope = $AC.getCurrentDate();
															form.down("[reference=checkboxRiesgoInminente]").setValue(false);
															form.down("[reference=datefieldFechaTope]").setValue(fechaTope);																			
														}
													}
												}
											},
											{
												xtype: 'checkboxfieldbase',
												reference: "checkboxRiesgoInminente",
												fieldLabel: HreRem.i18n('fieldlabel.riesgo.inminente.terceros'),
												bind: {
													value: '{trabajo.riesgoInminenteTerceros}'
												},
												listeners: {
													change: function(check, checked) {
														var form = check.up("form");
														if(checked) {
															var fechaTope = Ext.Date.add($AC.getCurrentDate(), Ext.Date.DAY, 2);
															form.down("[reference=checkboxUrgente]").setValue(false);
															form.down("[reference=datefieldFechaTope]").setValue(fechaTope);																			
														}
													}
												}
											}
											
									
									]	
								},
								{
									defaultType: 'textfieldbase',
									disabled: true,
									items: [									
											
											{
												xtype: 'checkboxfieldbase',
												boxLabel:  HreRem.i18n('title.trabajo.continuado'),
												bind :'{trabajo.checkFechaContinuado}',
												reference: 'checkFechaContinuado',
												listeners: {
													change: function(check, checked) {
														var form = check.up("form");
														if(checked) {
															var me =this;
															form.down("[reference=checkFechaConcreta]").setValue(false);
															form.down("[reference=checkFechaTope]").setValue(false);
															Ext.Array.each(check.up("fieldset").query("field"), function(field, index) {
																field.allowBlank=false;																
															});
														} else {
															Ext.Array.each(check.up("fieldset").query("field"), function(field, index) {
																field.allowBlank=true;
																field.validate();
																field.setValue("");
																															
															});
														}
													}
												}
											},		
											{
												xtype: 'datefieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.fecha.inicio'),
												minValue: $AC.getCurrentDate(),
												maxValue: null,
												bind: {
													value: '{trabajo.fechaInicio}'
												}
											},
											{
												xtype: 'datefieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.fecha.fin'),
												minValue: $AC.getCurrentDate(),
												maxValue: null,
												bind: {
													value: '{trabajo.fechaFin}'	
												}
											},
											{
							                	xtype: 'textareafieldbase',
							                	fieldLabel: HreRem.i18n('fieldlabel.observaciones'),
							                	bind: {
													value: '{trabajo.continuoObservaciones}'	
												},
							                	width: '100%', 
							                	maxLength: 256
					                		}
									
									]
								}

							]               
		
		           },
           
		           {     
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						//title: HreRem.i18n('title.estado'),				
						items :
						
							[						
							
								// Fila 1
								{ 
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.estado'),
						        	bind: {
					            		store: '{comboEstadoTrabajo}',
					            		value: '{trabajo.estadoCodigo}'
					            	},
					            	readOnly: true
						        	
						        },
						        {
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.eleccion.proveedor'),
									bind: '{trabajo.fechaEleccionProveedor}',
									readOnly: true
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.cierre.economico'),
									bind: '{trabajo.fechaCierreEconomico}',
									readOnly: true
								},
						        //Fila 2
						        {
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.valoracion.trabajo'),
						        	bind: {
					            		store: '{comboValoracionTrabajo}',
					            		value: '{trabajo.tipoCalidadCodigo}'
					            	},
						        	readOnly: true
						        },	
						        {
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.validacion'),
									bind: '{trabajo.fechaValidacion}',
									readOnly: true
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.rechazo'),
									bind: '{trabajo.fechaRechazo}',
									readOnly: true
								},	
						        // Fila 3
						        {
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.solicitud'),									
									bind: '{trabajo.fechaSolicitud}',
									readOnly: true
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.ejecucion.real'),
									bind: '{trabajo.fechaEjecucionReal}',
									readOnly: true
								},
								{ 
				                	xtype: 'displayfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.motivo.rechazo'),
				                	bind:	{	
				                		value: '{trabajo.motivoRechazo}'				                					                	
				                	}
				                },				        
						        // Fila 4
							    {
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.aprobacion'),
									bind: '{trabajo.fechaAprobacion}',
									readOnly: true
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.pago'),
									bind: '{trabajo.fechaPago}',
									readOnly: true
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.emision.factura'),
									bind: '{trabajo.fechaEmisionFactura}',
									readOnly: true
								}

							]
		           },
		           {     
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.trabajo.requerido.tercero'),				
						items : [								
									
								{
									fieldLabel: HreRem.i18n('fieldlabel.nombre'),
									bind:'{trabajo.terceroNombre}',
									width: 		'100%',
									colspan: 2	
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.persona.contacto'),
									bind:'{trabajo.terceroContacto}',
									width: 		'100%'
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.email'),
									bind:'{trabajo.terceroEmail}',
									vtype: 'email',
									width: 		'100%'
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.telefono1'),
									bind:'{trabajo.terceroTel1}',
									vtype: 'telefono',
									width: 		'100%'
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.telefono2'),
									bind:'{trabajo.terceroTel2}',
									vtype: 'telefono',
									width: 		'100%'
								},
								{ 
				                	xtype: 'textareafieldbase',
				                	width: 		'90%',
				                	height: 160,
				                	fieldLabel: HreRem.i18n('fieldlabel.direccion'),
				                	bind:		'{trabajo.terceroDireccion}'
		                		}						
						]
		           }
						

        ];
        

    	me.callParent();    	
    	
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		//me.lookupController().cargarTabData(me);
    },
    
    getErrorsExtendedFormBase: function() {
    	
    	var me = this,
    	checkFechaConcreta= me.down("[reference=checkFechaConcreta]"),
    	checkFechaTope = me.down("[reference=checkFechaTope]"),
    	checkFechaContinuado = me.down("[reference=checkFechaContinuado]");

    	if((checkFechaConcreta.checked && checkFechaTope.checked) ||
    	(checkFechaConcreta.checked && checkFechaContinuado.checked) ||
    	(checkFechaTope.checked && checkFechaContinuado.checked) ){
    		me.addExternalErrors(HreRem.i18n("error.validacion.marcado.mas.de.una.opcion"));
    		if(checkFechaConcreta.checked) checkFechaConcreta.markInvalid(HreRem.i18n("error.validacion.marcado.mas.de.una.opcion"));
    		if(checkFechaTope.checked) checkFechaTope.markInvalid(HreRem.i18n("error.validacion.marcado.mas.de.una.opcion"));
    		if(checkFechaContinuado.checked) checkFechaContinuado.markInvalid(HreRem.i18n("error.validacion.marcado.mas.de.una.opcion"));
    	}
    	
    	
    	
    }
});
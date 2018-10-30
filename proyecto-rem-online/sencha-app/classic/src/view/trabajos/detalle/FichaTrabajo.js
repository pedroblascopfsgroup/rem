Ext.define('HreRem.view.trabajos.detalle.FichaTrabajo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'fichatrabajo',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    scrollable	: 'y',
    recordName	: "trabajo",
	recordClass	: "HreRem.model.FichaTrabajo",
    requires	: ['HreRem.model.FichaTrabajo'],

    initComponent: function () {
        var me = this;
        console.log(this);
        me.setTitle(HreRem.i18n('title.ficha'));
        
        //Si el tipo es de Precios/Publicacion/Sancion no mostrar el bloque -Cuando hay que hacerlo...-
        me.codigoTipoTrabajo = me.lookupController().getViewModel().get('trabajo').get('tipoTrabajoCodigo');
        me.idGestorActivoResponsable = me.lookupController().getViewModel().get('trabajo').get('idGestorActivoResponsable');
        me.idSupervisorActivo = me.lookupController().getViewModel().get('trabajo').get('idSupervisorActivo');
        me.idProveedor =  me.lookupController().getViewModel().get('trabajo').get('idProveedor');
        me.idSolicitante =  me.lookupController().getViewModel().get('trabajo').get('idSolicitante');
        me.idResponsableTrabajo = me.lookupController().getViewModel().get('trabajo').get('idResponsableTrabajo');
        me.idSupervisorEdificaciones = me.lookupController().getViewModel().get('trabajo').get('idSupervisorEdificaciones');
        me.idSupervisorAlquileres = me.lookupController().getViewModel().get('trabajo').get('idSupervisorAlquileres');
        me.idSupervisorSuelos = me.lookupController().getViewModel().get('trabajo').get('idSupervisorSuelos');
        var editar = me.lookupController().getViewModel().get('trabajo').get('bloquearResponsable');
        //NOTA: En cuanto a la visualización del campo “Responsable del trabajo”, 
        //lo podrán ver tanto el “Gestor/Supervisor de activo” y el “Gestor/Supervisor de alquileres, edificaciones, suelo”, así comomo, el proveedor y el solicitante.
        var mostrar =  !($AU.getUser().userId ==  me.idResponsableTrabajo|| $AU.getUser().userId ==   me.idSupervisorActivo || 
        		$AU.getUser().userId == me.idGestorActivoResponsable || $AU.getUser().userId == me.idProveedor || $AU.getUser().userId == me.idSolicitante ||
        		$AU.getUser().userId == me.idSupervisorEdificaciones || $AU.getUser().userId == me.idSupervisorAlquileres || $AU.getUser().userId == me.idSupervisorSuelos);
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
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.responsable.trabajo'),
						        	bind: {
					            		store: '{comboResponsableTrabajo}',
					            		value: '{trabajo.idResponsableTrabajo}',
					            		readOnly: '{trabajo.bloquearResponsable}'
					            	},
					            	displayField: 'apellidoNombre',
		    						valueField: 'id',
		    						//readOnly: editar,
		    						hidden: mostrar,
						        	reference: 'comboTrabajoResposable'

						    
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
				                	rowspan: 2,
				                	height: 100,
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
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.supervisor.activo'),
						        	bind: {
					            		store: '{comboSupervisorActivoResponsable}',
					            		value: '{trabajo.idSupervisorActivo}'
					            	},
					            	displayField: 'apellidoNombre',
		    						valueField: 'id',
		    						readOnly: (Ext.isEmpty(this.idSupervisorActivo)),
					            	hidden: (this.codigoTipoTrabajo!="03"),
						        	reference: 'comboSupervisorActivo'
						        },
						        {
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.gestor.activo.responsable'),
						        	bind: {
					            		store: '{comboGestorActivoResponsable}',
					            		value: '{trabajo.idGestorActivoResponsable}'
					            	},
					            	displayField: 'apellidoNombre',
		    						valueField: 'id',
		    						readOnly: (Ext.isEmpty(this.idGestorActivoResponsable)),
					            	hidden: (this.codigoTipoTrabajo!="03"),
						        	reference: 'comboGestorActivoResposable'
						        },
						        { 
									xtype: 'displayfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.promocion'),						        	
						        	bind: '{trabajo.codigoPromocionPrinex}'
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
						        	reference: 'comboCiaAseguradora'
						        },
						        { 
						        	xtype: 'comboboxfieldbase',
						        	colspan: 2,
						        	fieldLabel: HreRem.i18n('fieldlabel.tarifa.plana'),
						        	readOnly: true,
						        	bind: {
					            		store: '{comboSiNoRem}',
										value: '{trabajo.esTarifaPlana}'	            		
					            	}
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
						hidden: (this.codigoTipoTrabajo!="02" && this.codigoTipoTrabajo!="03"),
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
												maxValue: null,
												bind: {
														value:  '{trabajo.fechaConcreta}',
														minValue: '{trabajo.fechaSolicitud}'
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
												xtype: 'checkboxfieldbase',
												boxLabel:  HreRem.i18n('fieldlabel.requerimiento'),												
												reference: 'checkRequerimiento',
												hidden: true,
												bind:{
													value: '{trabajo.requerimiento}',
													hidden: '{!trabajo.esSareb}',
													readonly: '{!trabajo.logadoGestorMantenimiento}'
												}
											},
											{
												xtype: 'datefieldbase',
												reference: 'datefieldFechaTope',
												fieldLabel: HreRem.i18n('fieldlabel.fecha.debe.finalizar.trabajo'),
												maxValue: null,
												bind: {
													value: '{trabajo.fechaTope}',
													minValue: '{trabajo.fechaSolicitud}'
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
									fieldLabel: HreRem.i18n('fieldlabel.fecha.autorizacion.propietario'),
									bind: {
										value: '{trabajo.fechaAutorizacionPropietario}',
										hidden: '{!esVisibleFechaAutorizacionPropietario}',
										readOnly: true
									}
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
									bind: {
										value:'{trabajo.fechaEjecucionReal}',
										hidden: '{!esVisibleFechaEjecucionReal}',
										readOnly: true
									}
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
									readOnly: true,
									rowspan:2
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.validacion'),
									bind: {
										value: '{trabajo.fechaValidacion}',
										hidden: '{!esVisibleFechaValidacion}',
										readOnly: true
										}
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.emision.factura'),
									bind: '{trabajo.fechaEmisionFactura}',
									readOnly: true
								},
								//Fila 5
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.pago'),
									bind: '{trabajo.fechaPago}',
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
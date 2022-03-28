Ext.define('HreRem.view.trabajos.detalle.FichaTrabajo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'fichatrabajo',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    scrollable	: 'y',
    reference   : 'fichatrabajo',
    recordName	: "trabajo",
	recordClass	: "HreRem.model.FichaTrabajo",
    requires	: ['HreRem.model.FichaTrabajo', 'HreRem.view.trabajos.detalle.HistorificacionDeCamposGrid'],
    refreshaftersave: true,
    afterLoad: function () {
    	this.lookupController().desbloqueaCamposSegunEstadoTrabajo(this);
    },
    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.ficha'));
    	me.idTrabajo= me.lookupController().getViewModel().get('trabajo').get('id')
             me.items= [
            	 	{
            	 		xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.general'),
						reference: 'generalFieldSetRef',
						items : [
							 	{ 
				                	xtype: 'displayfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.numero.trabajo'),
				                	bind:		'{trabajo.numTrabajo}'
				                },
				                {
				                	xtype: 'textareafieldbase',
				                	cls: 'force-max-width',
				                	fieldLabel: HreRem.i18n('header.descripcion'),
				                	labelAlign: 'top',
				                	grow: true,
				                	height: 110,
				                	colspan: 3, 
				                	rowspan: 2,
				                	bind: {
				                		value: '{trabajo.descripcionGeneral}'
				                	},
				                	reference: 'descripcionGeneralRef'
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
		    						//readOnly: (Ext.isEmpty(this.gestorActivoCodigo)),
						        	reference: 'comboGestorActivoResposable'
					        	},
					        	 { 
    								xtype: 'comboboxfieldbase',
    								fieldLabel: HreRem.i18n('fieldlabel.primera.actuacion.toma.posesion'),
    								reference: 'tomaDePosesion',
    								bind: {
										store: '{comboSiNoRem}',
	    								value: '{trabajo.tomaPosesion}'
	    								
	    									}
//									listeners: {
//										afterrender: 'hiddenComboTomaPosesion'
//									}
        						},
        						{ 
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.tipo.trabajo'),
									reference: 'tipoTrabajoFicha',
						        	chainedStore: 'comboSubtipoTrabajoFicha',
									chainedReference: 'subtipoTrabajoComboFicha',									
						        	bind: 
						        		{
					            			store: '{storeTipoTrabajoFichaFiltered}',
					            			value: '{trabajo.tipoTrabajoCodigo}'
				            			},
		    						listeners: 
		    							{
					                		select: 'onChangeChainedCombo'
					                		
					            		},
					            	allowBlank: false
						        },
						        { 
									xtype: 'comboboxfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.trabajo'),
						        	reference: 'subtipoTrabajoComboFicha',
						        	editable: false,
						        	bind: 
						        		{
				            				store: '{comboSubtipoTrabajoFicha}',
					            			value: '{trabajo.subtipoTrabajoCodigo}',
					            			disabled: '{!trabajo.tipoTrabajoCodigo}'
					            		},
					            		listeners:{
					            			change:'bloquearCombosFechaConcretayHoraPorSubtipoTomaPosesionYPaquetes'
					            		},
									allowBlank: false
						        },
        						{
        							xtype : 'textfieldbase',
						            reference:'idTarea',
						            fieldLabel : HreRem.i18n('fieldlabel.id.tarea.trabajo'),
						            allowBlank: true,
						            maxLength:10,
						            bind: {
						            	readOnly: '{booleanReadOnlyCampoIdTarea}',
	    								value: '{trabajo.idTarea}'
	    							}
        						},
							 	{ 
				                	xtype: 'textfieldbase',
				                	fieldLabel:  HreRem.i18n('title.general.albaran.numAlbaran'),
				                	bind:		'{trabajo.numAlbaran}',
				                	readOnly: true
				                },
							 	{ 
				                	xtype: 'textfieldbase',
				                	fieldLabel:  HreRem.i18n('title.general.gasto.numGasto'),
				                	bind:		'{trabajo.numGasto}',
				                	readOnly: true,
				                	cls: 'show-text-as-link',
									listeners: {
								        click: {
								            element: 'el', 
								            fn:'onClickGasto'									       
								        }
									}
				                },
							 	{
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.gasto.estado.gasto'),
				                	reference: 'estadoGastoRef',
				                	bind:	{
				                		store: '{comboEstadoGastos}',
				                		value: '{trabajo.estadoGastoCodigo}'
				                	},
				                	readOnly: true
				                },
							 	{ 
				                	xtype: 'checkboxfieldbase',
				                	fieldLabel:  HreRem.i18n('header.gasto.cubierto.seguro'),
				                	bind:		'{trabajo.cubreSeguro}',
				                	reference: 'checkboxCubreSeguroRef'
				                },
						        {
						        	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('title.general.com.aseguradora'),
						        	bind: {
						        		disabled: '{!trabajo.cubreSeguro}',
					            		store: '{comboCiasAseguradoras}',
					            		value: '{trabajo.ciaAseguradora}'
					            	},
					            	valueField: 'id',
						        	reference: 'comboCiaAseguradora'
						        },
							 	{ 
				                	xtype: 'numberfieldbase',
				                	fieldLabel:  HreRem.i18n('header.listado.precios.importe'),
				                	bind:{
				                		disabled: '{!trabajo.cubreSeguro}',
			                			value: '{trabajo.importePrecio}'
				                	},
				                	reference: 'importePrecioAseguradoRef'
				                },
							 	{ 
									xtype: 'checkboxfieldbase',
									reference: "checkboxUrgente",
									fieldLabel: HreRem.i18n('fieldlabel.check.riesgo.urgente'),
									bind: {
										value: '{trabajo.urgente}'		
									},
									readOnly: true
								},
							 	{ 
				                	xtype: 'checkboxfieldbase',
				                	fieldLabel:  HreRem.i18n('title.general.con.riesgos.terceros'),
				                	bind: {
				                		value : '{trabajo.riesgosTerceros}' 
				                	},
				                	reference: 'riesgosTercerosRef',
				                	readOnly: true
				                		
				                },
							 	{ 
				                	xtype: 'checkboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.aplica.comite.trabajo'),
				                	bind:{
				                		value: '{trabajo.aplicaComite}'
				                	},
				                	reference: 'aplicaComiteRef',
				                	readOnly: true,
									listeners:{
										change: 'onChangeCheckAplicaComite'
									}
									
			                   	},
						        {
						        	xtype: 'displayfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.trabajo.dnd.id'),
						        	bind: {
						        		value: '{trabajo.trabajoDnd}',
						        		hidden: '{!trabajo.esTrabajoDND}'
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
			                items :
			                [
				                {
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.trabajo.area.peticionaria'),
				                	bind:{
				                		store: '{comboIdentificadorReam}',
				                		value: '{trabajo.identificadorReamCodigo}'
				                	},
				                	editable: false,
				                	reference: 'comboIdentificadorReamRef',
				                	readOnly: false
				                }
							]
            	 	},
        			{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',						
						title: HreRem.i18n('fieldlabel.comite'),
						bind : {
							disabled: '{!trabajo.aplicaComite}'
						},
						reference: 'comiteFieldSet',
						items :
							[
						        {
						        	fieldLabel:  HreRem.i18n('fieldlabel.resolucion.comite.trabajo'),
						        	xtype: 'comboboxfieldbase',
						        	bind: {
					            		store: '{comboAprobacionComite}',
					            		value: '{trabajo.resolucionComiteCodigo}'
					            	},
						        	reference: 'comboResolucionComite'
						        },
								{
									fieldLabel:  HreRem.i18n('fielblabel.fecha.comite.trabajo'),
									xtype: 'datefieldbase',
									bind: {
											value:  '{trabajo.fechaResolucionComite}'
									},
									reference: 'fechaResolucionComiteRef'
								},
							 	{ 
				                	xtype: 'textfieldbase',
				                	fieldLabel:  HreRem.i18n('title.resolucion.comite.id'),
				                	bind: {
				                		value: '{trabajo.resolucionComiteId}'
				                	},
				                	reference: 'resolucionComiteIdRef'
				                }
							]
        			},
        			{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',						
						title: HreRem.i18n('title.plazos.trabajo.nuevo'),
						reference: 'plazosFieldSet',
						items :
							[
								{
									xtype:'fieldsettable',
									title: HreRem.i18n('fieldlabel.fecha.concreta.trabajo'),
									reference: 'fechaConcretaFieldSet',
									colspan: 3,
									items : [
											{
												fieldLabel: HreRem.i18n('fieldlabel.plazos.fecha.fecha.simple'),
												xtype: 'datefieldbase',
												name: 'fechaConcreta',
												reference: 'fechaConcreta',
												maxValue: null,
												allowBlank: true,
												bind: {
													value: '{trabajo.fechaConcreta}'
												},
												listeners:{
    				        						select: function(x, y, z){
    				        							var field = this; 
    				        							field.up("[reference='plazosFieldSet']").down("[reference='fechaTope']").setMinValue(field.value);
    				        							field.up("[reference='plazosFieldSet']").down("[reference='fechaTope']").validate();
	    				        					},
	    				        					change: function(x, y, z){
														var field = this;
														if(!Ext.isEmpty(field.value)){
															field.up('[reference = fechaConcretaFieldSet]').down('[reference=horaConcreta]').allowBlank = false;
														}else{
															field.up('[reference = fechaConcretaFieldSet]').down('[reference=horaConcreta]').allowBlank = true;
															field.up('[reference = fechaConcretaFieldSet]').down('[reference=horaConcreta]').validate();
														}
													}
												}
											},
											{
												fieldLabel: HreRem.i18n('fieldlabel.plazos.fecha.hora.simple'),
												xtype: 'timefieldbase',
												name: 'horaConcreta',
												reference: 'horaConcreta',
												//colspan:2,			
												format: 'H:i',
												increment: 30,
												allowBlank: true,
												bind: {
													value:  '{trabajo.horaConcreta}'
												},
												listeners:{
													change: function(x, y, z){
														var field = this;
														if(!Ext.isEmpty(field.value)){
															field.up('[reference = fechaConcretaFieldSet]').down('[reference=fechaConcreta]').allowBlank = false;
														}else{
															field.up('[reference = fechaConcretaFieldSet]').down('[reference=fechaConcreta]').allowBlank = true;
															field.up('[reference = fechaConcretaFieldSet]').down('[reference=fechaConcreta]').validate();
														}
													}
												}
											}
									]
								},
								{
									xtype:'fieldsettable',
									defaultType: 'datefieldbase',						
									title: HreRem.i18n('fieldlabel.fecha.tope.trabajo'),
									reference: 'fechaTopeFieldSet',
									colspan: 3,
									items : [
										{
											fieldLabel: HreRem.i18n('fieldlabel.plazos.fecha.fecha.simple'),
											xtype: 'datefieldbase',
											reference: 'fechaTope',
											maxValue: null,
											allowBlank: false,
											bind: {
												value: '{trabajo.fechaTope}'
											},
											listeners:{
	    				        					select: 
	    				        					function(x, y, z){
	    				        						var field = this;
	    				        						field.setMinValue(field.up().up().down("[reference='fechaConcreta']").value);
	    				        						field.validate();
	    				        					}
												}
										}
									]
								}
							]
        			},
					{
						xtype:'fieldsettable',
						title: HreRem.i18n('title.trabajo.informe.situacion'),
						reference: 'informeSituacionFieldSet',
						items : [
					        {
					        	fieldLabel: HreRem.i18n('fieldlabel.estado.trabajo'),
					        	xtype: 'comboboxfieldbase',
					        	bind: {
				            		store: '{comboEstadoSegunEstadoGdaOProveedor}',
				            		value: '{trabajo.estadoCodigo}'
				            	},
				            	listeners:{
		        					select: 
		        					function(x, y, z){
		        						//me.up().previousSibling("[reference='generalFieldSetRef']").down("[reference='aplicaComiteRef']")
		        						var me = this;
		        						var sup = $AU.userIsRol(CONST.PERFILES['HAYASUPER']);
		        						var esGestorActivo = $AU.userIsRol(CONST.PERFILES['GESTOR_ACTIVOS']);
		        						var esProvActivo = $AU.userIsRol(CONST.PERFILES['PROVEEDOR']);
		        						var readOnlyFinalizado = !sup && !esGestorActivo;
		        						if(me.getSelection().data.codigo == "13" && 
		        								me.up().previousSibling("[reference='generalFieldSetRef']").down("[reference='aplicaComiteRef']").checked){
		        							var oldValue = me.bind.value.lastValue;
		        							if( me.up().previousSibling("[reference='comiteFieldSet']").down("[reference='comboResolucionComite']").getValue() == null
		        								 || me.up().previousSibling("[reference='comiteFieldSet']").down("[reference='comboResolucionComite']").getValue() != "APR"){
		        								Ext.MessageBox.alert("Error","No se puede validar un trabajo que aplique comité sin la aprobación del mismo");
		        								for(var i = 0 ; i< me.getStore().getData().length ; i++){
		        									if(me.getStore().getData().items[i].data.codigo == me.bind.value.lastValue){
		        										me.setSelection(me.getStore().getData().items[i])
		        										return;
		        									}
		        								}
		        							}
		        						}
		        						if(me.bind.value.lastValue == "FIN" && me.getValue() == "REJ"){
		        							
		        							//me.up().down("[reference='fechaEjecucionRef']").setValue(null);
		        							me.up().previousSibling("[reference='plazosFieldSet']").down("[reference='fechaConcreta']").setReadOnly(readOnlyFinalizado);
		        							me.up().previousSibling("[reference='plazosFieldSet']").down("[reference='horaConcreta']").setReadOnly(readOnlyFinalizado);
		        							me.up().previousSibling("[reference='plazosFieldSet']").down("[reference='fechaTope']").setReadOnly(readOnlyFinalizado);
		        						}
		        						if(((me.bind.value.lastValue == "REJ" && me.getValue() == "SUB") || me.getValue() == "FIN") && (esProvActivo || sup)){
		        							me.up().down("[reference='fechaEjecucionRef']").setAllowBlank(false);
		        							me.up().down("[reference='fechaEjecucionRef']").validate();
		        						}else{
		        							me.up().down("[reference='fechaEjecucionRef']").setAllowBlank(true);
		        							me.up().down("[reference='fechaEjecucionRef']").validate();
		        						}
		        						me.lookupController().getViewModel().get('trabajo').data.llavesObligatoriasEstadoTrabajo = false;
		        						if((me.bind.value.lastValue == "CUR" && me.getValue() == "FIN") || (me.bind.value.lastValue == "SUB" && me.getValue() == "13")){
		        							me.lookupController().getViewModel().get('trabajo').data.llavesObligatoriasEstadoTrabajo = true;
		        						}
		        						me.lookupController().calcularObligatoriedadCamposLlaves();
		        					},
		        					change: 'finalizacionTrabajoProveedor'
								},
					        	reference: 'comboEstadoTrabajoRef',
					        	colspan: 2
					        },
							{
					        	xtype: 'datefieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.fecha.ejecucion.simple'),
								reference: 'fechaEjecucionRef',
								bind: {
									value: '{trabajo.fechaEjecucionTrabajo}'
								}
							},
						 	{ 
			                	xtype: 'checkboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.tarifa.plana'),
			                	name: 'checkTarifaPlana',
			                	reference: 'checkTarifaPlanaRef',
			                	bind: {
			                		value : '{trabajo.tarifaPlana}' 
			                	},
			                	colspan: 2
			                		
			                },
						 	{ 
			                	xtype: 'checkboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.check.riesgo.siniestro'),
			                	name: 'checkSiniestro',
			                	reference: 'checkSiniestroRef',
			                	bind: {
			                		value : '{trabajo.riesgoSiniestro}' 
			                	}
			                		
			                }
						]
					},
					{
						xtype:'fieldsettable',
						title: HreRem.i18n('title.trabajo.llaves'),
						reference: 'informeSituacionFieldSet',
						bind : {
							hidden: '{!trabajo.visualizarLlaves}'
						},
						items : [
							{
								xtype: 'comboboxfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.proveedor.llaves.trabajo'),
								colspan: 2,
								reference: 'comboProveedorLlave',
								chainedReference: 'comboReceptorLlave',
								bind: {
									store: '{comboProveedorFiltradoManual}',
									value: '{trabajo.idProveedorLlave}'
								},
								displayField: 'nombreComercial',
	    						valueField: 'idProveedor',
								filtradoEspecial: true,
								listeners: {
				                	change: 'onChangeComboProveedorLlave'
				            	}
							},
							{
					        	xtype: 'datefieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.trabajo.llaves.fecha.entrega'),
								reference: 'fechaEntregaTrabajoRef',
								bind: {
									value: '{trabajo.fechaEntregaLlaves}'
								}
							},
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.receptor.llaves.trabajo'),
					        	reference: 'comboReceptorLlave',
					        	colspan: 2,
					        	bind: {
				            		store: '{comboProveedorReceptor}',
									disabled: '{!comboProveedorLlave.selection}',
				            		value: '{trabajo.idProveedorReceptor}'
				            	},
				            	displayField: 'nombre',
								valueField: 'id',
								listeners: {
									change: 'onChangeProveedor'
								}
					        },
						 	{
			                	xtype: 'checkboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.trabajo.llaves.no.aplica'),
			                	reference: 'llavesNoAplicaRef',
			                	bind: {
			                		value : '{trabajo.llavesNoAplica}'
			                	},
			                	listeners: {
									change: 'calcularObligatoriedadCamposLlaves'
								}
			                },
			                {
			                	xtype: 'textfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.calificacion.motivo'),
			                	reference: 'llavesMotivoRef',
			                	flex: 3,
			                	bind: {
			                		disabled: '{!trabajo.llavesNoAplica}',
			                		value: '{trabajo.llavesMotivo}'
			                	}
			                }
						]
					},
					{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							colspan: 3,
							
							reference:'historificacionCampos',
							hidden: false, 
							title: HreRem.i18n("title.historificacion.campos"),
							
							items :
							[
								{
									xtype: "historificacioncamposgrid", 
									reference: "historificacioncamposgrid", 
									colspan: 3,
									idTrabajo: this.lookupController().getViewModel().get('trabajo').get('id'),
									codigoPestanya: CONST.PES_PESTANYAS['FICHA']
								}
							]
		           		}
        ];

    	me.callParent();
    	
    },

    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
});
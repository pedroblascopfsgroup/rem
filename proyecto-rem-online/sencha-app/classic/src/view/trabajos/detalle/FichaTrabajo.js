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
				                	}
				                },
						        {
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.gestor.activo.responsable'),
						        	bind: {
					            		store: '{comboGestorActivoResponsable}',
					            		value: '{trabajo.gestorActivoCodigo}'
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
	    								
	    									},
									listeners: {
										afterrender: 'hiddenComboTomaPosesion'
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
				                	readOnly: true
				                },
							 	{
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.gasto.estado.gasto'),
				                	bind:	{
				                		store: '{comboEstadoGastos}',
				                		value: '{trabajo.estadoGastoCodigo}'
				                	},
				                	readOnly: true
				                },
							 	{ 
				                	xtype: 'checkboxfieldbase',
				                	fieldLabel:  HreRem.i18n('header.gasto.cubierto.seguro'),
				                	bind:		'{trabajo.cubreSeguro}'
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
				                		}
				                },
							 	{ 
									xtype: 'checkboxfieldbase',
									reference: "checkboxUrgente",
									fieldLabel: HreRem.i18n('fieldlabel.check.riesgo.urgente'),
									bind: {
										value: '{trabajo.urgente}'		
									}													
								},
							 	{ 
				                	xtype: 'checkboxfieldbase',
				                	fieldLabel:  HreRem.i18n('title.general.con.riesgos.terceros'),
				                	bind: {
				                		value : '{trabajo.riesgosTerceros}' 
				                	}
				                		
				                },
							 	{ 
				                	xtype: 'checkboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.aplica.comite.trabajo'),
				                	bind:{
				                		value: '{trabajo.aplicaComite}'
				                	}
				                	
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
									}
								},
							 	{ 
				                	xtype: 'numberfieldbase',
				                	fieldLabel:  HreRem.i18n('title.resolucion.comite.id'),
				                	bind: {
				                		value: '{trabajo.resolucionComiteId}'
				                	}
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
												minValue: $AC.getCurrentDate(),
												maxValue: null,
												bind: {
													value: '{trabajo.fechaConcreta}'
												},
												listeners:{
    				        						select: function(x, y, z){
    				        							var field = this;
    				        							field.up("[reference='plazosFieldSet']").down("[reference='fechaTope']").setMinValue(field.value);
    				        							field.up("[reference='plazosFieldSet']").down("[reference='fechaTope']").validate();
    				        							field.up().nextSibling().items.items[0].setValue(null);
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
												bind: {
													value:  '{trabajo.horaConcreta}'
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
											bind: {
												value: '{trabajo.fechaTope}'
											},
											listeners:{
	    				        					select: 
	    				        					function(x, y, z){
	    				        						var field = this;
	    				        						field.setMinValue(field.up().up().down("[reference='fechaConcreta']").value);
	    				        						field.up().up().down("[reference='fechaConcreta']").setValue(null);
	    				        						field.up().up().down("[reference='horaConcreta']").setValue(null);
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
				            		store: '{comboEstadoTrabajoFicha}',
				            		value: '{trabajo.estadoCodigo}'
				            	},
				            	listeners: {
				            		afterrender: function (combo){
				            			this.lookupController().filterStoreEstadoTrabajo(combo.getStore());
				            		}
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
					        	chainedStore: 'comboProveedorLlave',
								chainedReference: 'comboReceptorLlave',
					        	bind: {
				            		store: '{comboProveedorFilteredLlaves}',
				            		value: '{trabajo.idProveedorLlave}'
				            	},
				            	displayField: 'nombreComercial',
	    						valueField: 'idProveedor',
	    						listeners: {
				                	select: 'onChangeComboProveedorGE'
				            	}
					        },
							{
					        	xtype: 'datefieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.trabajo.llaves.fecha.entrega'),
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
				            		value: '{trabajo.idProveedorReceptor}'
				            	},
				            	displayField: 'nombre',
	    						valueField: 'id',
	    						allowBlank: true,
	    						listeners: {
	    							change: 'onChangeProveedor'
	    						}
					        },
						 	{ 
			                	xtype: 'checkboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.trabajo.llaves.no.aplica'),
			                	bind: {
			                		value : '{trabajo.llavesNoAplica}' 
			                	}
			                		
			                },
			                {
			                	xtype: 'textfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.calificacion.motivo'),
			                	bind: {
			                		disabled: '{!trabajo.llavesNoAplica}',
			                		value: '{trabajo.llavesMotivo}'
			                	},
			                	flex: 3
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
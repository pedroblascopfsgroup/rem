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

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.ficha'));
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
		    						readOnly: (Ext.isEmpty(this.idGestorActivoResponsable)),
						        	reference: 'comboGestorActivoResposable'
					        	},
							 	{ 
				                	xtype: 'textfieldbase',
				                	fieldLabel:  HreRem.i18n('title.general.albaran.numAlbaran'),
				                	bind:		'{trabajo.numAlbaran}'
				                },
							 	{ 
				                	xtype: 'textfieldbase',
				                	fieldLabel:  HreRem.i18n('title.general.gasto.numGasto'),
				                	bind:		'{trabajo.numGasto}'
				                },
							 	{ 
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.gasto.estado.gasto'),
				                	bind:	{
				                		store: '{comboEstadoGasto}',
				                		value: '{trabajo.estadoGastoCodigo}'
				                	}
				                },
							 	{ 
				                	xtype: 'checkboxfieldbase',
				                	fieldLabel:  HreRem.i18n('header.gasto.cubierto.seguro'),
				                	bind:		'{trabajo.cubiertoSeguro}'
				                },
						        {
						        	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('title.general.com.aseguradora'),
						        	bind: {
					            		store: '{comboCiasAseguradoras}',
					            		value: '{trabajo.ciaAseguradora}'
					            	},
					            	valueField: 'id',
						        	reference: 'comboCiaAseguradora'
						        },
							 	{ 
				                	xtype: 'numberfieldbase',
				                	fieldLabel:  HreRem.i18n('header.listado.precios.importe'),
				                	bind:		'{trabajo.importePrecio}'
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
						        	xtype: 'comboboxfieldbase',
						        	bind: {
//					            		store: '{storeComite}',
//					            		value: '{trabajo.resolucionComiteCodigo}'
					            	},
						        	reference: 'comboResolucionComite'
						        },
								{
									xtype: 'datefieldbase',
									bind: {
											value:  '{trabajo.fechaResolucionComite}'
									}
								},
							 	{ 
				                	xtype: 'displayfieldbase',
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
									defaultType: 'datefieldbase',						
									title: HreRem.i18n('fieldlabel.fecha.concreta.trabajo'),
									reference: 'fechaConcretaFieldSet',
									colspan: 3,
									items : [
											{
												fieldLabel: HreRem.i18n('fieldlabel.plazos.fecha.fecha.simple'),
												bind: {
													value: '{trabajo.fechaConcreta}'
												}
											},
											{
												fieldLabel: HreRem.i18n('fieldlabel.plazos.fecha.hora.simple'),
												bind: {
													value:  '{trabajo.fechaConcretaHora}'
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
											bind: {
												value: '{trabajo.fechaTope}'
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
					        	title: HreRem.i18n('fieldlabel.estado'),
					        	xtype: 'comboboxfieldbase',
					        	bind: {
				            		store: '{comboEstadoTrabajo}',
				            		value: '{trabajo.estadoTrabajoCodigo}'
				            	},
					        	reference: 'comboEstadoTrabajo',
					        	colspan: 2
					        },
							{
					        	xtype: 'datefieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.fecha.ejecucion.simple'),
								bind: {
									value: '{trabajo.fechaEjecucionTrabajo}'
								}
							},
						 	{ 
			                	xtype: 'checkboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.tarifa.plana'),
			                	bind: {
			                		value : '{trabajo.tarifaPlana}' 
			                	},
			                	colspan: 2
			                		
			                },
						 	{ 
			                	xtype: 'checkboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.check.riesgo.siniestro'),
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
						items : [
					        {
					        	//Combo proovededor. Pdte. de confirmar
					        	xtype: 'comboboxfieldbase',
					        	bind: {
//				            		store: '{aquiElStore}',
				            		value: '{trabajo.proovedorCodigo}'
				            	},
					        	reference: 'comboEstadoTrabajo',
					        	colspan: 2
					        },
							{
					        	xtype: 'datefieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.trabajo.llaves.fecha.entrega'),
								bind: {
									value: '{trabajo.fechaEjecucionTrabajo}'
								}
							},
					        {
					        	//Combo proovededor. Pdte. de confirmar
					        	xtype: 'comboboxfieldbase',
					        	bind: {
//				            		store: '{aquiElStore}',
				            		value: '{trabajo.receptorCodigo}'
				            	},
					        	reference: 'comboEstadoTrabajo',
					        	colspan: 2
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
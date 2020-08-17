Ext.define('HreRem.view.activos.detalle.SaneamientoActivoDetalle', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'saneamientoactivo',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    refreshAfterSave: true,
    disableValidation: true,
    reference: 'saneamientoactivoref',
    scrollable	: 'y',
    launch: null,
    listeners: {
			boxready:'cargarTabData'
	},

	recordName: "saneamiento",

	recordClass: "HreRem.model.ActivoSaneamiento",

	requires : ['HreRem.view.common.FieldSetTable','HreRem.model.Catastro', 'HreRem.model.DocumentacionAdministrativa'
		,'HreRem.model.ActivoInformacionAdministrativa', 'HreRem.view.activos.detalle.ObservacionesActivo'],

    initComponent: function () {
        var me = this;

        me.setTitle(HreRem.i18n('title.admision.saneamiento'));

        var items= [

			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.admision.inscripcion'),
				defaultType: 'textfieldbase',
				layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 1,
			        tdAttrs: {width: '100%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				items :
					[
						{
				        	xtype:'fieldsettable',

				        	defaultType: 'textfieldbase',
							items: [
						        {
									xtype: 'textfieldbase',
									reference: 'gestoriaAsignada',
									fieldLabel: HreRem.i18n('fieldlabel.admision.saneamiento.gestoriaAsig'),
									readOnly: true,
									bind: {
										value:'{saneamiento.gestoriaAsignada}'
									}
						        },
						        {
						        	xtype:'datefieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.admision.saneamiento.fechaAsignacion'),
						        	readOnly: true,
						        	bind: {
										value:'{saneamiento.fechaAsignacion}'
									}
						        }

							]
						},
						{

						}
					]

            },
            //***********************BLOQUE CARGAS************************
            {
            	xtype:'fieldsettable',
				title:HreRem.i18n('title.cargas'),
				defaultType: 'textfieldbase',
				items : [
					{
						xtype : 'comboboxfieldbase',
						fieldLabel : HreRem.i18n('fieldlabel.con.cargas'),
						name : 'estadoActivoCodigo',
						bind : {
							store : '{comboSiNoRem}',
							value : '{saneamiento.conCargas}'
	                    },
	                    readOnly : true
	                },
	                {
	                	xtype : 'textfieldbase',
	                	fieldLabel : HreRem.i18n('fieldlabel.cargas.estado.cargas'),
	                	name : 'estadoCargas',
	                	bind : {
	                		value : '{saneamiento.estadoCargas}'
	                    },
	                    readOnly : true
	                },
	                {
	                	xtype : 'datefieldbase',
	                	fieldLabel : HreRem.i18n('fieldlabel.fecha.revision.cargas'),
	                	bind : {
	                		value: '{saneamiento.fechaRevisionCarga}'
	                    },
	                    readOnly: '{editarCargasActivo}'
	                },
	                {
	                	xtype : 'fieldsettable',
	                	title : HreRem.i18n('title.listado.cargas'),
						reference : 'listadoCargasActivo',
						colspan: 3,
						items : [
							{
								xtype : 'cargasactivogrid',
								reference : 'cargasactivogrid',
								bind : {
							    	topBar : '{!saneamiento.unidadAlquilable}'
								}
							}
						]
		           	}
				]
            },
            //***********************FIN BLOQUE CARGAS********************************
            //***********************BLOQUE PROTECCION OFICIAL************************
            {
         		xtype : 'fieldsettable',
         		title : HreRem.i18n('title.admision.protectoficial'),
				layout: {
					type: 'table',
				    columns: 1
				},
				hidden: true,
				bind: {
			        	hidden: '{!saneamiento.vpo}',
			        	disabled: '{!saneamiento.vpo}'
			    },
				defaultType : 'textfieldbase',
				items : [
					{
						xtype :'container',
						layout: {
							type : 'hbox'
						},
						items : [
							{
								xtype:'fieldset',
								height: 160,
								margin: '0 10 10 0',
								layout: {
									type : 'table',
									columns : 3
					        	},
								defaultType : 'textfieldbase',
								title : HreRem.i18n("title.datos.proteccion"),
								items : [
									{
										xtype : 'comboboxfieldbase',
									 	fieldLabel : HreRem.i18n('fieldlabel.regimen.proteccion'),
									 	bind : {
									 		store: '{comboTipoVpo}',
				            				value: '{saneamiento.tipoVpoCodigo}'
				            			}
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.descalificada'),
			                			bind : {
				            					store: '{comboSiNoRem}',
				            					value: '{saneamiento.descalificado}'
			                			}
						            },
						            {
						                xtype : 'datefieldbase',
						                fieldLabel : HreRem.i18n('fieldlabel.fecha.calificacion'),
						                bind : '{saneamiento.fechaCalificacion}'
						            },
						            {
						               	xtype : 'textfieldbase',
						               	maskRe : /[A-Za-z0-9]/,
									 	fieldLabel : HreRem.i18n('fieldlabel.expediente.calificacion'),
									 	bind : '{saneamiento.numExpediente}'
									},
						            {
						                xtype : 'datefieldbase',
									 	fieldLabel : HreRem.i18n('fieldlabel.vigencia'),
									 	bind : '{saneamiento.vigencia}',
									 	maxValue : null
									}
								]
							},
					        {
					        	xtype :'fieldset',
								height: 160,
					        	margin : '0 10 10 0',
								defaultType : 'textfieldbase',
								title : HreRem.i18n("title.requisitos.fase.adquisicion"),
								items :	[
									{
										xtype : 'comboboxfieldbase',
								        fieldLabel :  HreRem.i18n('fieldlabel.precisa.comunicar.adquisicion'),
								        bind : {
								        	store : '{comboSiNoRem}',
				            				value : '{saneamiento.comunicarAdquisicion}'
				            			}
									},
								    {
										xtype : 'comboboxfieldbase',
								        fieldLabel :  HreRem.i18n('fieldlabel.necesario.inscribir.registro.especial.vpo'),
								        bind : {
								        	store : '{comboSiNoRem}',
				            				value : '{saneamiento.necesarioInscribirVpo}'
				            			 }
								    }]
					        }]
				},
				{
					xtype : 'container',
					layout : {
						columns : 1
				    },
					items : [
				        {
				        	xtype :'fieldsettable',
				        	height : 300,
				        	margin : '0 10 10 0',
							layout : {
						 		type : 'table',
				         		columns : 3
				        	},
							defaultType : 'textfieldbase',
							title : HreRem.i18n("title.requisitos.fase.venta"),
							items : [
								{
									xtype :'fieldset',
							        height : 260,
							        colspan : 1,
							        margin : '0 0 10 0',
									layout : {
										type: 'table',
				         				columns: 3
				        			},
									defaultType : 'textfieldbase',
									title : HreRem.i18n("title.limitaciones.vendedor"),
									items : [
										{
											 xtype : 'comboboxfieldbase',
											 fieldLabel : HreRem.i18n('fieldlabel.necesaria.autorizacion.venta'),
											 bind : {
												 store : '{comboSiNoRem}',
												 value : '{saneamiento.obligatorioAutAdmVenta}'
											 }
										},
										{
											xtype : 'currencyfieldbase',
											fieldLabel : HreRem.i18n('fieldlabel.precio.maximo.venta.vpo'),
					                		bind : '{saneamiento.maxPrecioVenta}'
								        },
								        {
											xtype : 'comboboxfieldbase',
											fieldLabel : HreRem.i18n('fieldlabel.devolucion.ayudas'),
					                		bind : {
					                			store : '{comboSiNoRem}',
												value : '{saneamiento.obligatorioSolDevAyuda}'
											}
								        },
								        {
								        	xtype : 'comboboxfieldbase',
								            fieldLabel : HreRem.i18n('fieldlabel.libertad.cesion'),
								            bind : {
								            	store : '{comboSiNoRem}',
			            						value : '{saneamiento.libertadCesion}'
			            					}
								        },
								        {
								        	xtype : 'comboboxfieldbase',
											fieldLabel : HreRem.i18n('fieldlabel.renuncia.tanteo.retracto'),
											bind : {
												store : '{comboSiNoRem}',
			            						value : '{saneamiento.renunciaTanteoRetrac}'
											}
								        },
								        {
								        	xtype : 'comboboxfieldbase',
								            fieldLabel : HreRem.i18n('fieldlabel.visado.contrato.privado'),
								            bind : {
								            	store : '{comboSiNoRem}',
			            						value : '{saneamiento.visaContratoPriv}'
								            }
								        },
								        {
								        	xtype : 'comboboxfieldbase',
											fieldLabel : HreRem.i18n('fieldlabel.vender.persona.juridica'),
											bind : {
												store : '{comboSiNoRem}',
			            						value : '{saneamiento.venderPersonaJuridica}'
											}
										}]
								},
								{
									xtype :'fieldset',
							        height : 260,
							        margin : '0 10 10 10',
									defaultType : 'textfieldbase',
									title : HreRem.i18n("title.limitaciones.comprador"),
									items : [
										{
											xtype : 'comboboxfieldbase',
										    fieldLabel :  HreRem.i18n('fieldlabel.minusvalia'),
										    bind : {
										    	store : '{comboSiNoRem}',
			            						value : '{saneamiento.minusvalia}'
			            					}
										},
										{
											xtype : 'comboboxfieldbase',
										    fieldLabel :  HreRem.i18n('fieldlabel.inscripcion.registro.demandante.vpo'),
										    bind : {
										    	store : '{comboSiNoRem}',
			            						value : '{saneamiento.inscripcionRegistroDemVpo}'
			            					}
										},
										{
											xtype : 'comboboxfieldbase',
											fieldLabel : HreRem.i18n('fieldlabel.ingresos.inferiores.nivel'),
									        bind : {
									        	store : '{comboSiNoRem}',
			            						value : '{saneamiento.ingresosInfNivel}'
			            					}
										},
										{
											xtype : 'comboboxfieldbase',
										    fieldLabel :  HreRem.i18n('fieldlabel.residencia.comunidad.autonoma'),
										    bind : {
										    	store : '{comboSiNoRem}',
			            						value : '{saneamiento.residenciaComAutonoma}'
			            					}
										},
										{
											xtype : 'comboboxfieldbase',
											fieldLabel : HreRem.i18n('fieldlabel.no.titular.otra.vivienda'),
											bind : {
												store : '{comboSiNoRem}',
			            						value : '{saneamiento.noTitularOtraVivienda}'
			            					}
										}]
								}]
				        }]
				}]
            },
            //***********************FIN BLOQUE PROTECCION OFICIAL********************
            {       	  
				xtype:'fieldsettable',
				title:HreRem.i18n('title.admision.agenda'),
				defaultType: 'textfieldbase',
				border: false,
				items :[
					{
						xtype: "saneamientoagendagrid", 
						reference: "saneamientoagendagridref"
					}
				]
            }/*,
    		{
				xtype: 'fieldsettable',
				items : [{
					xtype: 'observacionesactivo',
					launch: CONST.OBSERVACIONES_TAB_LAUNCH['SANEAMIENTO']
				}]
			}*/
     ];
		me.addPlugin({ptype: 'lazyitems', items: items });
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
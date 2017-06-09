Ext
		.define(
				'HreRem.view.expedientes.ActivoExpedienteCondiciones',
				{
					extend : 'HreRem.view.common.FormBase',
					xtype : 'activoexpedientecondiciones',
					cls : 'panel-base shadow-panel',
					collapsed : false,
					reference : 'activoexpedientecondiciones',
					scrollable : 'y',
					recordName : "expediente",

					recordClass : "HreRem.model.ExpedienteComercial",

					requires : [ 'HreRem.model.ExpedienteComercial' ],

					listeners : {},

					initComponent : function() {

						var me = this;
						me.setTitle(HreRem.i18n('title.condiciones'));
						var items = [ 
						 {
							xtype : 'fieldsettable',
							defaultType : 'textfieldbase',

							title : HreRem.i18n('title.situacion.real.activo'),
							items : [
										{ 
								        	xtype: 'comboboxfieldbase',				        	
									 		fieldLabel: HreRem.i18n('fieldlabel.situacion.titulo'),
								        	bind: {
							            		store: '{comboEstadoTitulo}',
							            		value: '{datosRegistrales.estadoTitulo}'
							            	}
										},
										{ 
								        	xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.con.posesion.inicial'),
								        	bind: {
							            		store: '{comboSiNoRem}',
							            		value: '{condiciones.posesionInicial}'			            		
							            	},
							            	displayField: 'descripcion',
				    						valueField: 'codigo'
								        },
								        { 
								        	xtype: 'comboboxfieldbase',
//								        	editable: false,
								        	fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria'),
								        	bind: {
							            		store: '{comboSituacionPosesoria}',
							            		value: '{condiciones.situacionPosesoriaCodigo}'			            		
							            	},
							            	displayField: 'descripcion',
				    						valueField: 'codigo',
				    						editable: true
								        }
									]
						},
						{
								xtype : 'fieldsettable',
								defaultType : 'textfieldbase',

								title : HreRem.i18n('title.situacion.activo.comunicada.comprador'),
								items : [
											{ 
								        	xtype: 'comboboxfieldbase',				        	
									 		fieldLabel: HreRem.i18n('fieldlabel.situacion.titulo'),
								        	bind: {
							            		store: '{comboEstadoTitulo}',
							            		value: '{datosRegistrales.estadoTitulo}'
							            	}
										},
										{ 
								        	xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.con.posesion.inicial'),
								        	bind: {
							            		store: '{comboSiNoRem}',
							            		value: '{condiciones.posesionInicial}'			            		
							            	},
							            	displayField: 'descripcion',
				    						valueField: 'codigo'
								        },
								        { 
								        	xtype: 'comboboxfieldbase',
//								        	editable: false,
								        	fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria'),
								        	bind: {
							            		store: '{comboSituacionPosesoria}',
							            		value: '{condiciones.situacionPosesoriaCodigo}'			            		
							            	},
							            	displayField: 'descripcion',
				    						valueField: 'codigo',
				    						editable: true
								        } 
										]
						},
						{
							xtype : 'fieldsettable',
							defaultType : 'textfieldbase',

							title : HreRem.i18n('title.renuncia.saneamiento'),
							items : [
										 { 
								        	xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.eviccion'),
								        	bind: {
							            		store: '{comboSiNoRem}',
							            		value: '{condiciones.renunciaSaneamientoEviccion}'			            		
							            	},
							            	displayField: 'descripcion',
				    						valueField: 'codigo'
										},
										{ 
								        	xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.vicios.ocultos'),
								        	bind: {
							            		store: '{comboSiNoRem}',
							            		value: '{condiciones.renunciaSaneamientoVicios}'			            		
							            	},
							            	displayField: 'descripcion',
				    						valueField: 'codigo'
								        }
									]
						}
						];

						me.addPlugin({
							ptype : 'lazyitems',
							items : items
						});

						me.callParent();
					},

					funcionRecargar : function() {

					}
				});
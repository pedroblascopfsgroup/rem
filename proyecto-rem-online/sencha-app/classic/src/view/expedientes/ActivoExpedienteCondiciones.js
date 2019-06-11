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
					recordName : "condiciones",
					saveMultiple: false,
					disableValidation: true,
					recordClass : "HreRem.model.ActivoExpedienteCondicionesModel",
					refreshAfterSave: true, 
					requires : [ 'HreRem.model.ActivoExpedienteCondicionesModel' ],

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
									 		readOnly	: true,
								        	bind: {
							            		store: '{comboEstadoTitulo}',
							            		value: '{condiciones.estadoTituloInformada}'
							            	}
										},
										{ 
								        	xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.con.posesion.inicial'),
								        	readOnly	: true,
								        	bind: {
							            		store: '{comboSiNoRem}',
							            		value: '{condiciones.posesionInicialInformada}'			            		
							            	},
							            	displayField: 'descripcion',
				    						valueField: 'codigo'
								        },
								        { 
								        	xtype: 'comboboxfieldbase',
//								        	editable: false,
								        	readOnly	: true,
								        	fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria'),
								        	bind: {
							            		store: '{comboSituacionPosesoria}',
							            		value: '{condiciones.situacionPosesoriaCodigoInformada}'			            		
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
								        	name: 'estadoTitulo',
									 		fieldLabel: HreRem.i18n('fieldlabel.situacion.titulo'),
								        	bind: {
							            		store: '{comboEstadoTitulo}',
							            		value: '{condiciones.estadoTitulo}'
							            	}
										},
										{ 
								        	xtype: 'comboboxfieldbase',
								        	name: 'posesionInicial',
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
								        	name: 'situacionPosesoriaCodigo',
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
								        	name: 'eviccion',
								        	fieldLabel: HreRem.i18n('fieldlabel.eviccion'),
								        	bind: {
							            		store: '{comboSiNoRem}',
							            		value: '{condiciones.eviccion}'			            		
							            	},
							            	displayField: 'descripcion',
				    						valueField: 'codigo'
										},
										{ 
								        	xtype: 'comboboxfieldbase',
								        	name: 'viciosOcultos',
								        	fieldLabel: HreRem.i18n('fieldlabel.vicios.ocultos'),
								        	bind: {
							            		store: '{comboSiNoRem}',
							            		value: '{condiciones.viciosOcultos}'			            		
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
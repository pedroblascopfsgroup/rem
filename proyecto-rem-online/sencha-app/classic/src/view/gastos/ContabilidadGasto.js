Ext.define('HreRem.view.gastos.ContabilidadGasto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'contabilidadgasto',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'contabilidadgastoref',
    scrollable	: 'y',
	recordName: "contabilidad",
	refreshAfterSave: true,
	recordClass: "HreRem.model.GastoContabilidad",
    
    requires: ['HreRem.model.GastoContabilidad'],
    
    listeners: {
		boxready:'cargarTabData',
		
		activate: function(me, eOpts) {
			var me = this;
			me.lookupController().onActivateActionsContabilidadTab(me);
		}
	},
    
    initComponent: function () {

       var me = this;
        var isCarteraLiberbank = CONST.CARTERA['LIBERBANK'] == me.lookupController().getViewModel().getData().gasto.getData().cartera;
		me.setTitle(HreRem.i18n('title.gasto.contabilidad'));
        var items= [
       
	    						{   
									xtype:'fieldsettable',
//									bind: {
//					        			disabled: '{conEmisor}'
//			            			},
									collapsible: false,
									title: HreRem.i18n('title.gasto.contabilidad.control.presupuestario'),
									items :
										[

													{ 
														xtype:'comboboxfieldbase',
														fieldLabel:  HreRem.i18n('fieldlabel.gasto.contabilidad.ejercicio.imputa.gasto'),
														reference: 'comboboxfieldFechaEjercicio',
										        		bind: {
									            			store: '{comboEjercicioContabilidad}',
									            			value: '{contabilidad.ejercicioImputaGasto}'
									            		},
									            		displayField	: 'anyo',  
														valueField		: 'id',
														readOnly: true
											        },
													{
														xtype: 'datefieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.fecha.contabilizacion'),
														bind:		'{contabilidad.fechaContabilizacion}',
														formatter: 'date("d/m/Y")',
														readOnly: true
													},
													{
														xtype: 'datefieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.fecha.devengo'),
														reference: 'fechaDevengoEspecial',
														bind:		'{contabilidad.fechaDevengoEspecial}',
//														listeners: {
//										                	change: 'onChangeFechaDevengoEspecial'
//										            	},
//										            	editable: false,
														formatter: 'date("d/m/Y")'
													},																								
													{ 
														xtype: 'displayfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.contabilizado.por'),
										                bind: '{contabilidad.contabilizadoPorDescripcion}'
													},														
													{ 
														xtype: 'textfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.periodicidad'),
										                bind: '{contabilidad.periodicidadDescripcion}',
										                readOnly: true						
													},
                                                    {
                                                        xtype: 'comboboxfieldbase',
                                                        fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.activable'),
                                                        reference: 'comboActivable',
                                                        bind: {
                                                            store: '{comboSiNoContabilidad}',
                                                            value: '{contabilidad.comboActivable}'
                                                        },
                                                        hidden: true
                                                    }
										]
					           },
					           {   
									xtype:'fieldsettable',
									collapsible: true,
									collapsable: false,
									reference: 'liberbankGrids',
									hidden : !isCarteraLiberbank,
									title: HreRem.i18n('title.gasto.contabilidad.contabilidad.liberbank'),
									colspan: 3,
									items :
										[
													{ 
														xtype: 'textfieldbase',
														fieldLabel: HreRem.i18n('title.gasto.contabilidad.contabilidad.liberbank.diario1'),
														reference : 'diario1',
										                bind: '{contabilidad.diario1}',
										                colspan: 3,
										                readOnly: true						
													},	

													{ 
														xtype:'fieldsettable',
														collapsible: false,
														refence : 'diario1Grid',
														colspan : 3,
														items :
															[
																{ 
																	xtype: 'textfieldbase',
																	fieldLabel: HreRem.i18n('title.gasto.contabilidad.contabilidad.liberbank.Base'),
																	reference : 'baseDiario1',
													                bind: '{contabilidad.diario1Base}',
													                readOnly: true						
																},
																{ 
																	xtype: 'textfieldbase',
																	fieldLabel: HreRem.i18n('title.gasto.contabilidad.contabilidad.liberbank.tipo.impositivo'),
																	reference : 'tipoImpositivoDiario1',
													                bind: '{contabilidad.diario1Tipo}',
													                readOnly: true						
																},
																{ 
																	xtype: 'textfieldbase',
																	fieldLabel: HreRem.i18n('title.gasto.contabilidad.contabilidad.liberbank.cuota'),
																	reference : 'cuotaDiario1',
																	bind: '{contabilidad.diario1Cuota}',
													                readOnly: true						
																}
																
															]
											        },
											        { 
														xtype: 'textfieldbase',
														fieldLabel: HreRem.i18n('title.gasto.contabilidad.contabilidad.liberbank.diario2'),
														reference : 'diario2',
										                bind: {value: '{contabilidad.diario2}',
										                		hidden : '{contabilidad.isEmpty}'
										                },
										                colspan: 3,
										                readOnly: true						
													},	

											        { 
														xtype:'fieldsettable',
														colspan : 3,
														refence : 'diario2Grid',
														bind : {hidden :'{contabilidad.isEmpty}'},
														collapsible: false,
														items :
															[
																{ 
																	xtype: 'textfieldbase',
																	fieldLabel: HreRem.i18n('title.gasto.contabilidad.contabilidad.liberbank.Base'),
													                bind: {value :'{contabilidad.diario2Base}',
													                	   hidden :'{contabilidad.isEmpty}'
													                },
													                reference : 'baseDiario2',
													                readOnly: true						
																},
																{ 
																	xtype: 'textfieldbase',
																	fieldLabel: HreRem.i18n('title.gasto.contabilidad.contabilidad.liberbank.tipo.impositivo'),
													                bind: { value :'{contabilidad.diario2Tipo}',
													                		hidden :'{contabilidad.isEmpty}'
													                },
													                reference: 'tipoImpositivoDiario2',
													                readOnly: true						
																},
																{ 
																	xtype: 'textfieldbase',
																	fieldLabel: HreRem.i18n('title.gasto.contabilidad.contabilidad.liberbank.cuota'),
																	reference : 'cuotaDiario2',
													                bind: {value :'{contabilidad.diario2Cuota}',
													                	   hidden :'{contabilidad.isEmpty}'
													                },
													                readOnly: true						
																}
																
															]
											        }
										]
					           }
					           
           
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);
    	
    }
});
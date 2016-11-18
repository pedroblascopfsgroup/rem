Ext.define('HreRem.view.gastos.ContabilidadGasto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'contabilidadgasto',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'contabilidadgastoref',
    scrollable	: 'y',
	recordName: "contabilidad",
	
	recordClass: "HreRem.model.GastoContabilidad",
    
    requires: ['HreRem.model.GastoContabilidad'],
    
    listeners: {
		boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.gasto.contabilidad'));
        var items= [
       
	    						{   
									xtype:'fieldsettable',
//									bind: {
//					        			disabled: '{conEmisor}'
//			            			},
									title: HreRem.i18n('title.gasto.contabilidad.control.presupuestario'),
									items :
										[
											{   
												xtype:'fieldset',
												title: HreRem.i18n('title.gasto.contabilidad.real'),
												defaultType: 'textfieldbase',
												height: 250,
				        						margin: '0 10 10 0',
												items :
													[
//														{ 
//															xtype: 'numberfieldbase',
//															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.ejercicio.imputa.gasto'),
//											                bind: {
//											                	value: '{contabilidad.ejercicioImputaGasto}',
//											                	readOnly: '{!esGestorAdministracion}'
//											                }
//														},
														{ 
															xtype:'comboboxfieldbase',
															fieldLabel:  HreRem.i18n('fieldlabel.gasto.contabilidad.ejercicio.imputa.gasto'),
											        		bind: {
										            			store: '{comboEjercicioContabilidad}',
										            			value: '{contabilidad.ejercicioImputaGasto}'
										            		},
										            		displayField	: 'anyo',  
   															valueField		: 'id'
												        },
														{ 
															xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.periodicidad'),
											                bind: '{contabilidad.periodicidadDescripcion}',
											                readOnly: true
														},
														{ 
															xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.cuenta.contable'),
											                bind: '{contabilidad.cuentaContable}'
														},
														{ 
															xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.partidaPresupuestaria'),
											                bind: '{contabilidad.partidaPresupuestaria}'
														}
													
													]
											},
											{   
												xtype:'fieldset',
												defaultType: 'textfieldbase',
												height: 250,
				        						margin: '0 10 10 0',
												title: HreRem.i18n('title.gasto.contabiliadad.contable'),
												items :
													[
														{
															xtype: 'datefieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.fecha.devengo'),
															bind:		'{contabilidad.fechaDevengoEspecial}',
															formatter: 'date("d/m/Y")'
														},
													    { 
															xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.periodicidad.especial'),
											                bind: '{contabilidad.periodicidadEspecialDescripcion}',
											                readOnly: true

														},
														{ 
															xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.cuenta.contable.especial'),
											                bind: '{contabilidad.cuentaContableEspecial}'
														},
					                					{ 
															xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.partida.presupuestaria.especial'),
											                bind: '{contabilidad.partidaPresupuestariaEspecial}'
														}
														
													
													]
											},
											{   
												xtype:'fieldset',
												defaultType: 'textfieldbase',
												height: 250,
												border: false,
				        						margin: '0 10 10 0',
												items :
													[
														{
															xtype: 'datefieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.fecha.contabilizacion'),
															bind:		'{contabilidad.fechaContabilizacion}',
															formatter: 'date("d/m/Y")',
															readOnly: true
														},
														{ 
															xtype: 'displayfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.contabilizado.por'),
											                bind: '{contabilidad.contabilizadoPorDescripcion}'
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
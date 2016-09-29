Ext.define('HreRem.view.gastos.ContabilidadGasto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'contabilidadgasto',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'contabilidadgastoref',
    scrollable	: 'y',
//	recordName: "contabilidad",
//	
//	recordClass: "HreRem.model.ContabilidadGasto",
//    
//    requires: ['HreRem.model.ContabilidadGasto'],
//    
//    listeners: {
//		boxready:'cargarTabData'
//	},
    
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
														{ 
															xtype: 'displayfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.ejercicio.imputa.gasto'),
											                bind: '{contabilidad.ejercicioImputaGasto}'
														},
														{ 
															xtype: 'displayfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.periodicidad'),
											                bind: '{contabilidad.periodicidad}'
														},
														{ 
															xtype: 'displayfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.partidaPresupuestaria'),
											                bind: '{contabilidad.partidaPresupuestaria}'
														},
														{ 
															xtype: 'displayfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.cuenta.contable'),
											                bind: '{contabilidad.cuentaContable}'
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
															colspan: 2,
															bind:		'{contabilidad.fechaDevengo}',
															readOnly	: true
														},	
													    { 
															xtype: 'displayfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.periodicidad.especial'),
											                bind: '{contabilidad.periodicidadEspecial}'
														},
					                					{ 
															xtype: 'displayfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.partida.presupuestaria.especial'),
											                bind: '{contabilidad.partidaPresupuestariaEspecial}'
														},
					                					{ 
															xtype: 'displayfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.cuenta.contable.especial'),
											                bind: '{contabilidad.cuentaContableEspecial}'
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
															colspan: 2,
															bind:		'{contabilidad.fechaContabilizacion}',
															readOnly	: true
														},
														{ 
															xtype: 'displayfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.contabilizado.por'),
											                bind: '{contabilidad.contabilizadoPor}'
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
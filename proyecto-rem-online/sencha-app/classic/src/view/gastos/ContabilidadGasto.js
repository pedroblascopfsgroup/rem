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
									collapsible: false,
									title: HreRem.i18n('title.gasto.contabilidad.control.presupuestario'),
									items :
										[

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
											                readOnly: true,
											                colspan: 2
														},
														{ 
															xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.cuenta.contable'),
											                bind: '{contabilidad.cuentaContable}'											                
														},
														{
															xtype: 'datefieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.fecha.contabilizacion'),
															bind:		'{contabilidad.fechaContabilizacion}',
															formatter: 'date("d/m/Y")',
															readOnly: true,
															colspan: 2
														},
														{ 
															xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.partidaPresupuestaria'),
											                bind: '{contabilidad.partidaPresupuestaria}'
														},	
														{ 
															xtype: 'displayfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.contabilizado.por'),
											                bind: '{contabilidad.contabilizadoPorDescripcion}'
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
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
			var estadoGasto= me.lookupController().getViewModel().get('gasto').get('estadoGastoCodigo');
			var autorizado = me.lookupController().getViewModel().get('gasto').get('autorizado');
	    	var rechazado = me.lookupController().getViewModel().get('gasto').get('rechazado');
	    	var agrupado = me.lookupController().getViewModel().get('gasto').get('esGastoAgrupado');
	    	var gestoria = me.lookupController().getViewModel().get('gasto').get('nombreGestoria')!=null;
			if(this.lookupController().botonesEdicionGasto(estadoGasto,autorizado,rechazado,agrupado,gestoria,this)){
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').setVisible(true);
			}
			else{
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').setVisible(false);
			}
		}
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
														labelWidth: 200,
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
														xtype: 'textfieldbase',
														reference: 'cuentaContable',
														labelWidth: 200,
										                bind: {
										                	value: '{contabilidad.cuentaContable}',
										                	fieldLabel: '{marcaObligatorioCuenta}',
										                	readOnly: '{!esEditableDivarian}'			                 
										                },
										                maskRe: /[0-9]/
													},
													{
														xtype: 'datefieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.fecha.contabilizacion'),
														labelWidth: 200,
														bind:		'{contabilidad.fechaContabilizacion}',
														formatter: 'date("d/m/Y")',
														readOnly: true
													},
													{
														xtype: 'datefieldbase',
														labelWidth: 200,
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
														xtype: 'textfieldbase',
														reference: 'partidaPresupuestaria',
														
														labelWidth: 200,
										                bind: {
										                	value: '{contabilidad.partidaPresupuestaria}',
										                	fieldLabel: '{marcaObligatorioPartida}',
										                	readOnly: '{!esEditableDivarian}'			                 
										                }
													},																								
													{ 
														xtype: 'displayfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.contabilizado.por'),
														labelWidth: 200,
										                bind: '{contabilidad.contabilizadoPorDescripcion}'
													},														
													{ 
														xtype: 'textfieldbase',
														labelWidth: 200,
														fieldLabel: HreRem.i18n('fieldlabel.gasto.contabilidad.periodicidad'),
										                bind: '{contabilidad.periodicidadDescripcion}',
										                readOnly: true						
													},
													{ 
														xtype:'comboboxfieldbase',
														fieldLabel:  HreRem.i18n('fieldlabel.gasto.contabilidad.subpartidaPresupuestaria'),
														labelWidth: 200,
														reference: 'comboboxfieldSubpartidaPresupuestaria',
														listeners:{	
															change:function(){
																		var campoPartidaPresupuestaria = this.lookupController().lookupReference('partidaPresupuestaria');
																		var url = $AC.getRemoteUrl('generic/getPartidaPresupuestaria');
																		var valor = this.value;
																  		
																  		Ext.Ajax.request({
			    			
															    		     url: url,
															    		     params: {idSubpartida : valor},
															    			method: 'GET',
															    		     success: function (a, operation, context) {												
												                                	var data = Ext.decode(a.responseText);												                                											                                	
												                                	
												                                	if(data){												                                
												                                		campoPartidaPresupuestaria.setValue(data.data);
												                                	}
												                                	
												                                },
												                                
												                                failure: function (a, operation, context) {												
												                                	
												                                }
															    		     
															    		 });
																												  		
    	 													}
														},
										        		bind: {
									            			store: '{comboSubpartidaPresupuestaria}',
									            			value: '{contabilidad.idSubpartidaPresupuestaria}',
									            			hidden: '{!esCerberusDivarianApple}'
									            		},
									            		displayField	: 'descripcion',  
														valueField		: 'id'												
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
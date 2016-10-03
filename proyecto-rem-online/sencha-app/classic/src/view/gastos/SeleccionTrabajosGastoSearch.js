Ext.define('HreRem.view.gastos.SeleccionTrabajosGastoSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'selecciontrabajosgastosearch',
    isSearchForm: true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,    
    layout: {
        type: 'accordion',
        titleCollapse: false,
        animate: true,
        vertical: true,
        multi: true
    },    

	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.filtro.trabajos'));
	    me.items= [
	    

		        				{ 
					            	fieldLabel: HreRem.i18n('fieldlabel.numero.trabajo'),
					            	name: 'numTrabajo',
					            	width: 		230
					            },
					            { 
						        	xtype: 'combo',
						        	fieldLabel: HreRem.i18n('fieldlabel.tipo'),
						        	reference: 'filtroComboTipoTrabajo',
						        	name: 'codigoTipo',
						        	bind: {
					            		store: '{comboTipoTrabajo}'
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo',
		    						publishes: 'value'
							    },
								{ 
				                	xtype:'datefield',
							 		fieldLabel: HreRem.i18n('fieldlabel.fecha.peticion.desde'),
							 		width: 		275,
							 		name: 'fechaPeticionDesde',
					            	formatter: 'date("d/m/Y")',
		            	        	listeners : {
						            	change: function (a, b) {
						            		//Eliminar la fechaCreacionhasta e instaurar
						            		//como minValue a su campo el velor de fechaCreacionDesde
						            		var me = this;
						            		me.next().reset();
						            		me.next().setMinValue(me.getValue());
						                }
					            	}
								},
		        
		        	


				            { 
					        	xtype: 'combo',
					        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
					        	labelWidth:	150,
					        	width: 		230,
					        	name: 'codigoSubtipo',
					        	queryMode: 'remote',
					        	forceSelection: true,
					        	bind: {
				            		store: '{filtroComboSubtipoTrabajo}',
				                    disabled: '{!filtroComboTipoTrabajo.value}',
				                    filters: {
				                        property: 'codigoTipoTrabajo',
				                        value: '{filtroComboTipoTrabajo.value}'
				                    }
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
					        },					        					        
							{ 
			                	xtype:'datefield',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.peticion.hasta'),
						 		width: 		275,
						 		name: 'fechaPeticionHasta',
						 		formatter: 'date("d/m/Y")'
							}
					        
            
	    ];
	   	
	    me.callParent();
	}
});
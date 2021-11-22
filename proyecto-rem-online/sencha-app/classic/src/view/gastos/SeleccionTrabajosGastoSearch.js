Ext.define('HreRem.view.gastos.SeleccionTrabajosGastoSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'selecciontrabajosgastosearch',
    collapsible: true,
    collapsed: false,       
    layout: 'column',
	defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield'

    },
	    		

	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.filtro'));
    	me.removeCls('shadow-panel');
  		
    	me.buttonAlign = 'left';
    	me.buttons = [{ reference: 'searchButton', text: 'Buscar', handler: 'onSearchClick', disabled: true },{ text: 'Limpiar', handler: 'onCleanFiltersClick'}];
    	
	    me.items= [
	    
				    {
				    		items: [
					        				{ 
								            	fieldLabel: HreRem.i18n('fieldlabel.numero.trabajo'),
								            	reference: 'numTrabajo',
								            	name: 'numTrabajo',
								            	style: 'width: 33%',
			    								listeners: {
			    									change: 'onChangeNumTrabajo'
			    								}
								            },
								            { 
							                	xtype:'datefield',
										 		fieldLabel: HreRem.i18n('fieldlabel.fecha.peticion.desde'),
										 		name: 'fechaPeticionDesde',
								            	formatter: 'date("d/m/Y")',
					            	        	listeners : {
									            	change: function (a, b) {
									            		//Eliminar la fechaHasta e instaurar
									            		//como minValue a su campo el valor de fechaDesde
									            		var me = this,
									            		fechaHasta = me.up('form').down('[name=fechaPeticionHasta]');
									            		fechaHasta.reset();
									            		fechaHasta.setMinValue(me.getValue());
									                }
								            	}
								            	
											},
											{
												name: 'idProveedor',
												bind: '{gasto.idEmisor}',
												hidden: true,
												allowBlank: false
											},
											{
												name: 'conCierreEconomico',
												value: 1,
												hidden: true
											},
											{
												name: 'facturado',
												value: 0,
												hidden: true
											},
											{
												name: 'numGasto',
												bind: '{gasto.numGastoHaya}',
												hidden: true,
												allowBlank: false
											}
							]
				    },
				    {
				    		items: [
				    						
								            { 
									        	xtype: 'combo',
									        	fieldLabel: HreRem.i18n('fieldlabel.tipo'),
									        	reference: 'filtroComboTipoTrabajo',
									        	name: 'codigoTipo',
									        	bind: {
								            		store: '{filtroComboTipoTrabajo}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						publishes: 'value',
					    						style: 'width: 33%'
										    },
										    { 
							                	xtype:'datefield',
										 		fieldLabel: HreRem.i18n('fieldlabel.fecha.peticion.hasta'),
										 		name: 'fechaPeticionHasta',
										 		formatter: 'date("d/m/Y")'
										 		
											}
				    		]
				    },
				    {
				    		items: [	
				    						{ 
									        	xtype: 'combo',
									        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
									        	reference: 'filtroComboTipoTrabajo1',
									        	name: 'codigoSubtipo',
									        	queryMode: 'remote',
									        	multiSelect: true,
									        	bind: {

								            		store: '{filtroComboSubtipoTrabajo}',
								                    disabled: '{!filtroComboTipoTrabajo.value}',
								                    filters: {
								                        property: 'codigoTipoTrabajo',
								                        value: '{filtroComboTipoTrabajo.value}'
								                    }
								            	},
			    								listeners: {
			    									change: 'onChangeCheckboxCodigoSubtipo'
			    								},
								            	displayField: 'descripcion',
												valueField: 'codigo',
												style: 'width: 33%'
				    						},
 
				    						{ 
									        	xtype: 'combo',
									        	fieldLabel: HreRem.i18n('fieldlabel.cubierto.seguro'),
									        	name: 'cubreSeguro',
									        	bind: {
								            		store: '{comboSiNoRem}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo'
					    						
										    }
				    		]
				    		
				    }		        
            
	    ];
	   	
	    me.callParent();
	}
});
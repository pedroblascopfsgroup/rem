Ext.define('HreRem.view.gastos.AnyadirNuevoGastoActivoDetalle', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'anyadirnuevogastoactivodetalle',
    collapsed: false,
	scrollable	: 'y',
	cls:'',	  				
	recordName: "gastoActivo",						
	recordClass: "HreRem.model.GastoActivo",

    
	initComponent: function() {
    	
    	var me = this;
    	
    	
    	me.items = [
					{
						
								xtype:'fieldset',
								cls	: 'panel-base shadow-panel',
								layout: {
							        type: 'table',
							        // The total column count must be specified here
							        columns: 1,
							        trAttrs: {height: '45px', width: '100%'},
							        tdAttrs: {width: '100%'},
							        tableAttrs: {
							            style: {
							                width: '100%'
										}
							        }
								},
								defaultType: 'textfieldbase',
								collapsed: false,
									scrollable	: 'y',
								cls:'',	    				
				            	items: [
				            	    {
				            	    	name:		'id',
										bind:		'{gastoActivo.id}',
										hidden:		true
				            	    },
				            	    {
										xtype: "combobox",
					    				fieldLabel: HreRem.i18n('title.gasto.detalle.economico.lineas.detalle'),
					    				reference: 'comboLineasDetalleReferenceAnyadir',
					    				name: 'comboLineaDetalleName',
					    				flex: 3,
					    				width:'80%',
					    				margin: '10 0 10 0',
					    				displayField: 'descripcion',
										valueField: 'codigo',
					    				bind: {
					    					store: '{comboLineasDetallePorGasto}'
					    				},
					    				listeners:{
					    					change:'onChangeSeleccionarLineaDetalle'
					    				}
									},
									{
										xtype: "combobox",
					    				fieldLabel: HreRem.i18n('title.gasto.detalle.economico.elementos.lineas.detalle'),
					    				reference: 'comboElementoAAnyadir',
					    				name: 'comboElementoAAnyadir',
					    				flex: 3,
					    				width:'80%',
					    				margin: '10 0 10 0',
					    				displayField: 'descripcion',
										valueField: 'codigo',
					    				bind: {
					    					store: '{storeTipoElemento}'
					    				},
					    				listeners:{
					    					change:'onChangeSeleccionarLineaDetalle'
					    				}
									},
				            	    {
										xtype: "textfield",
				            	    	fieldLabel: HreRem.i18n('title.gasto.detalle.economico.id.elemento.linea.detalle'),
				            	    	name:		'numElemento',
				            	    	reference:	'elementoAnyadir',
				            	    	listeners:{
				            	    		change: 'onChangeSeleccionarLineaDetalle'
					    				}
				            	    }

				            	]
		    			   
		    		
				}
    	];
    	
    	me.callParent();
    }
    
});
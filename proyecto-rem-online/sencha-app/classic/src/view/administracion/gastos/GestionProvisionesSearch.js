Ext.define('HreRem.view.administracion.gastos.GestionProvisionesSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'gestionprovisionessearch',
    isSearchFormProvisiones: true,
    collapsible: true,
    collapsed: false, 
    layout: 'column',
	defaults: {
        xtype: 'fieldsettable',
        columnWidth: 1,
        cls: 'fieldsetCabecera'
    },
    

    initComponent: function () {
    	
        var me = this;
        me.setTitle(HreRem.i18n("title.agrupacion.gasto.filtro.provisiones"));
        me.removeCls('shadow-panel');
    	me.buttons = [{ text: 'Buscar', handler: 'onClickProvisionesSearch' },{ text: 'Limpiar', handler: 'onCleanFiltersClick'}];
        me.buttonAlign = 'left';
        
        var items = [
        
        {

        		defaultType: 'textfieldbase',
	    		defaults: {							        
					addUxReadOnlyEditFieldPlugin: false
				},
			    items: [
		
						{
							fieldLabel: HreRem.i18n('fieldlabel.agrupacion.gasto.numero'),
						    name: 'numProvision'        	
						},
						{ 
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.gasto.nifProp'),
					        name: 'nifPropietario'
					    },	
					    { 
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.gasto.nomProp'),
					        name: 'nomPropietario'
					    },
		    			{
							xtype: 'comboboxfieldbase',
							name: 'estadoProvisionCodigo',
			              	fieldLabel : HreRem.i18n('fieldlabel.agrupacion.gasto.estado'),
							bind: {
								store: '{comboEstadosProvision}'
							}					
						},
					    {
							xtype: 'comboboxfieldbase',
							name: 'codCartera',
			              	fieldLabel :  HreRem.i18n('fieldlabel.agrupacion.gasto.cartera'),
			              	reference: 'comboCarteraSearch',
							bind: {
								store: '{comboCartera}'
							},
			            	publishes: 'value'					
						},
						{ 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.gasto.subcartera'),
				        	name: 'codSubCartera',
				        	bind: {
			            		store: '{comboSubentidadPropietaria}',
			            		disabled: '{!comboCarteraSearch.selection}',
			                    filters: {
			                        property: 'carteraCodigo',
			                        value: '{comboCarteraSearch.value}'
			                    }
			            	}
		    						
						},
						{ 
							xtype: 'comboboxfieldbase',
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.gasto.gestoriaResponsable'),
					        name: 'idGestoria',
				        	bind: {
			            		store: '{comboGestorias}'
			            	},
			            	displayField: 'descripcion',
							valueField: 'id'
					    },	
					    { 
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.gasto.importeDesde'),
					        name: 'importeDesde'
					    },	
					    { 
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.gasto.importeHasta'),
					        name: 'importeHasta'
					    },	
					    { 
					    	xtype:'datefieldbase',
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.gasto.fechaalta.desde'),
					        name: 'fechaAltaDesde',
					        formatter: 'date("d/m/Y")'				
					    },	
					    { 
					    	xtype:'datefieldbase',
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.gasto.fechaalta.hasta'),
					        name: 'fechaAltaHasta',
					        formatter: 'date("d/m/Y")'				
					        	
					    }
				 ]
        }

        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent();
        
    }
    
});


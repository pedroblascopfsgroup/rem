Ext.define('HreRem.view.trabajos.TrabajosSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'trabajossearch',
    isSearchFormTrabajos: true,
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
    			xtype: 'panel',
    			title: HreRem.i18n('title.busqueda.directa'),
    			layout: 'column',
    			cls: 'panel-busqueda-directa',
    			collapsible: false,
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 25%'
			    },
	    		
		        items: [
		        
		        	{
		        			items: [
		        				{ 
					            	fieldLabel: HreRem.i18n('fieldlabel.numero.trabajo'),
					            	name: 'numTrabajo',
					            	width: 		230,
					            		listeners : {
					            			change: 'onChangeNumTrabajo'
					            		}
					            },
					            { 
					            	fieldLabel: HreRem.i18n('fieldlabel.numero.activo'),
					            	name: 'numActivo',
						        	width: 		230
				           	 	},
				           	 	{ 
					            	fieldLabel: HreRem.i18n('fieldlabel.numero.agrupacion'),
					            	name: 'numAgrupacion',
						        	width: 		230
				           	 	}
					       		
		        			]
		        	},
		        	{
		        		items: [
		        	

				            { 
					        	xtype: 'combo',
					        	fieldLabel: HreRem.i18n('fieldlabel.tipo'),
					        	reference: 'filtroComboTipoTrabajo',
					        	name: 'tipoTrabajoCodigo',
					        	bind: {
				            		store: '{comboTipoTrabajo}',
				            		filters:{
				            			property: 'filtrar',
				            			value: /^(?!(1{1}$)).*$/
				            		}
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo',
	    						publishes: 'value'
						    },
				            { 
					        	xtype: 'combo',
					        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
					        	labelWidth:	150,
					        	width: 		230,
					        	name: 'subtipoTrabajoCodigo',
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
					        	xtype: 'combo',
					        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
					        	labelWidth:	150,
					        	width: 		230,
					        	name: 'estadoTrabajoCodigo',
					        	bind: {
				            		store: '{filtroComboEstadoTrabajo}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
					        }	
					        
					     ]
					},
					{
		        		items: [
		        	

				            { 
				            	fieldLabel: HreRem.i18n('fieldlabel.solicitante'),
				            	name: 'solicitante',
				            	width: 		230
						    },
						    { 
				            	fieldLabel: HreRem.i18n('fieldlabel.proveedor'),
				            	name: 'proveedor',
				            	width: 		230
						    },
				            { 
					        	xtype: 'combo',
					        	fieldLabel:  HreRem.i18n('fieldlabel.trabajo.area.peticionaria'),
					        	labelWidth:	150,
					        	width: 		230,
					        	name: 'areaPeticionaria',
					        	bind: {
				            		store: '{filtroComboAreaPeticionaria}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
					        }
					        
					     ]
					},
					{
	        			items: [
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
			                	xtype:'datefield',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.peticion.hasta'),
						 		width: 		275,
						 		name: 'fechaPeticionHasta',
						 		formatter: 'date("d/m/Y")'
							}
						]
					}
		        ]
            },
	         {
    			xtype: 'panel',
    			collapsed: true,
    			layout: 'column',
    			title: HreRem.i18n('title.busqueda.avanzada'),
    			cls: 'panel-busqueda-avanzada',
    			defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield'
			    },
				items: [
							{
								columnWidth: 1,
								items:[    			

										{    			                
											xtype:'fieldset',
											cls	 : 'fieldsetBase',
											collapsible: true,
											defaultType: 'textfield',
											defaults: {
												anchor: '100%', style: 'width: 33%'},
											layout: 'column',
											items :	[
														{
															fieldLabel: HreRem.i18n('fieldlabel.municipio'),
															labelWidth:	150,
											            	name:		'localidadDescripcion'
														 },
														 {
												        	xtype: 'comboboxfieldbasedd',
												        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
												        	name: 'provinciaCodigo',
												        	addUxReadOnlyEditFieldPlugin: false,
												        	labelWidth:	150,
												        	bind: {
											            		store: '{comboFiltroProvincias}'
											            	},
								    						listeners: {
											                	saveSingleField: 'onSaveSingleField'
											            	}
												         }, 
														 {
															fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
															labelWidth:	150,
											                name:		'codPostal'
														 }
											]
							                
							            },
							            
							            {    			                
											xtype:'fieldset',
											cls	 : 'fieldsetBase',
											collapsible: true,
											defaultType: 'textfield',
											defaults: {
												anchor: '100%', style: 'width: 33%'},
											layout: 'column',
											items :	[
														 {
															fieldLabel: HreRem.i18n('fieldlabel.gestor.activo'),
															labelWidth:	150,
											            	name:		'gestorActivo'
														 },
														 { 
												        	xtype: 'comboboxfieldbase',
					    									addUxReadOnlyEditFieldPlugin: false,
					    									labelWidth:	150,
												        	fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
												        	name: 'carteraCodigo',
												        	bind: {
											            		store: '{comboEntidadPropietaria}'
											            	}
												        },
												        {
															fieldLabel: HreRem.i18n('fieldlabel.usuario.responsable.trabajo'),
															labelWidth:	150,
											            	name:		'responsableTrabajo'
														}
											]
							                
							            },
							            
							            {    			                
											xtype:'fieldset',
											cls	 : 'fieldsetBase',
											collapsible: true,
											defaultType: 'textfield',
											defaults: {
												anchor: '100%', style: 'width: 33%'},
											layout: 'column',
											items :	[
														{
															fieldLabel: HreRem.i18n('fieldlabel.usuario.ultima.edicion'),
															labelWidth:	150,
															name:		'gestorActual'
														},
														{ 
										                	xtype:'datefield',
													 		fieldLabel: HreRem.i18n('fieldlabel.fecha.estado.desde'),
													 		labelWidth:	150,
													 		//width: 		275,
													 		name: 'fechaCambioEstadoDesde',
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
										                	xtype:'datefield',
													 		fieldLabel: HreRem.i18n('fieldlabel.fecha.estado.hasta'),
													 		labelWidth:	150,
													 		//width: 		275,
													 		name: 'fechaCambioEstadoHasta',
													 		formatter: 'date("d/m/Y")'
														}
											]
							                
							            }
	            				]
	            			
	            			}
				]
    		}
	    ];
	   	
	    me.callParent();
	}
});
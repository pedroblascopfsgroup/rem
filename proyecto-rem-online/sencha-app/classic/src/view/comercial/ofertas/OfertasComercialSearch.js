Ext.define('HreRem.view.comercial.ofertas.OfertasComercialSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'ofertascomercialsearch',
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    isSearchFormOfertas: true,
  	layout: {
        type: 'table',
        columns: 4,
        tableAttrs: {
            style: {
                width: '100%'
				}
        }
	},	
	defaults: {
		xtype: 'container',
		layout: 'form',
		style: 'width: 25%'
	},
	listeners: {

		boxready: function(window) {
			var me = this;
			me.primeraCarga= true;
		}
		
	},
	
    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n("title.filtro.ofertas"));
        
        //me.buttons = [{ text: 'Buscar', handler: '' },{ text: 'Limpiar', handler: ''}];
        //me.buttonAlign = 'left';
        
        var items = [
					{
	            	    defaults: {	
					    	xtype: 'textfieldbase',
					    	addUxReadOnlyEditFieldPlugin: false
					    }, 
		            	items: [   

							{
								fieldLabel: HreRem.i18n('fieldlabel.num.oferta'),
							    name: 'numOferta',
							    listeners : {
							    	change: 'onChangeNumOfertaOExpediente'
							    }         	
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.num.expediente'),
							    name: 'numExpediente',
							    listeners : {
							    	change: 'onChangeNumOfertaOExpediente'
							    }          	
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.num.activo'),
							    name: 'numActivo'  ,
							    reference: 'numActivoOfertaComercial',
							    listeners: {
							    	change: 'activarCheckAgrupacionesVinculadas'
							    }
							    
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.num.agrupacion'),
							    name: 'numAgrupacion',
							    reference: 'numAgrupacionOfertaComercial'
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.ofertante'),
								name: 'ofertante'
							},
		            		{ 
								xtype: 'comboboxfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.tipo.fecha'),
								name:	'tipoFecha',
								reference: 'tipoFecha',
								bind: {
									store: '{comboTiposFechaOfertas}'
								}
							},
							{ 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('fieldlabel.check.agrupaciones.vinculadas'),
					        	name: 'agrupacionesVinculadas',
					        	reference: 'agrupacionesVinculadasOfertaComercial', 
					        	disabled: true
					        }
							
						]
		            },
		            {
	            	    defaults: {	
					    	xtype: 'textfieldbase',
					    	addUxReadOnlyEditFieldPlugin: false
					    }, 
		            	items: [
		            		{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.oferta'),
					        	name: 'codigoTipoOferta',
					        	reference: 'tipoOfertaComercial',
				            	listeners: {
							    	change: 'activarComboEstadoExpediente'
							    },
					        	bind: {
				            		store: '{comboTipoOferta}'
				            	}
				        	},
							{
					        	xtype: 'comboboxfieldbase',
					        	multiSelect: true,
					        	fieldLabel:  HreRem.i18n('fieldlabel.estado.expediente.alquiler'),
					        	name: 'estadoExpedienteAlquiler',
					        	reference: 'comboExpedienteAlquiler',
					        	disabled: true,
					        	bind: {
					        		store: '{comboEstadoExpedienteAlquileres}' 
					        	}
							},
				        	{
					        	xtype: 'comboboxfieldbase',
					        	multiSelect: true,
					        	fieldLabel:  HreRem.i18n('fieldlabel.estado.expediente.venta'),
					        	name: 'estadoExpedienteVenta',
					        	reference: 'comboExpedienteVenta',
					        	disabled: true,
					        	bind: {
					        		store: '{comboEstadoExpedienteVentas}'
					        	}
							},
				        	{
					        	xtype: 'comboboxfieldbase',
					        	multiSelect: false,
					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.comercializar'),
					        	name: 'tipoComercializacionCodigo',
					        	bind: {
					        		store: '{comboTiposComercializarActivo}'					        		
					        	}
							},							
							{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.gestor'),
					        	bind: {
				            		store: '{comboTipoGestorOfertas}'		            			
				            	},
								reference: 'tipoGestor',
								name: 'tipoGestor',
	        					chainedStore: 'comboUsuarios',
								chainedReference: 'usuarioGestor',
	    						emptyText: HreRem.i18n('txt.seleccione.tipo.gestor'),
								listeners: {
									select: 'onChangeChainedCombo'
								}
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.num.activo.uvem'),
							    name: 'numActivoUvem',
							    reference: 'numActivoUvemOfertaComercial',
							    listeners: {
							    	change: 'activarCheckAgrupacionesVinculadas'
							    }
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.num.documento'),
						 		name: 'documentoOfertante'										
							},
							{ 
			                	xtype:'datefield',
						 		fieldLabel: HreRem.i18n('fieldlabel.desde'),
						 		bind: {
						 			disabled: '{!tipoFecha.selection}'
						 		},
						 		name: 'fechaDesde'
							}

						]
		            },
		            {
	            	    defaults: {	
					    	xtype: 'textfieldbase',
					    	addUxReadOnlyEditFieldPlugin: false
					    }, 
	            	    items: [   

							{ 
					        	xtype: 'comboboxfieldbase',
					        	multiSelect: true,
					        	fieldLabel:  HreRem.i18n('fieldlabel.estado.oferta'),
					        	name: 'codigoEstadoOferta',
				            	bind: {
				            		store: '{comboEstadoOferta}'
				            	}				            	
							},
				        	{ 
					        	xtype: 'comboboxfieldbase',
					        	multiSelect: false,
					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.clase.activo'),
					        	name: 'claseActivoBancarioCodigo',
					        	bind: {
					        		store: '{comboClaseActivo}'
					        	}
							},
							{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.canal'),
					        	name: 'canalCodigo',
					        	reference: 'canal',
					        	bind: {
				            		store: '{comboCanalOferta}'
				            	}
							},
							{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.gestor'),
					        	reference: 'usuarioGestor',
					        	name: 'usuarioGestor',
								queryMode: 'local',
					        	bind: {
				            		store: '{comboUsuarios}',
				            		disabled: '{!tipoGestor.selection}'			            			
				            	},
				            	displayField: 'apellidoNombre',
	    						valueField: 'id',
	    						filtradoEspecial: true,
	    						emptyText: HreRem.i18n('txt.seleccione.gestor')
						    },
						    {
								fieldLabel: HreRem.i18n('fieldlabel.num.activo.sareb'),
							    name: 'numActivoSareb' ,
							    reference: 'numActivoSarebOfertaComercial',
							    listeners: {
							    	change: 'activarCheckAgrupacionesVinculadas'
							    }
							},
						    {
						    	fieldLabel: HreRem.i18n('fieldlabel.telefono'),
						 		name: 'telefonoOfertante'
						    },
						    { 
			                	xtype:'datefield',
						 		fieldLabel: HreRem.i18n('fieldlabel.hasta'),
						 		bind: {
						 			disabled: '{!tipoFecha.selection}'
						 		},
						 		name: 'fechaHasta'
							}
							
							
						]
		            },
		            {
	            	    defaults: {	
					    	xtype: 'textfieldbase',
					    	addUxReadOnlyEditFieldPlugin: false
					    }, 
	            	    items: [
	            	    	{
	            	    		
    							xtype: 'comboboxfieldbase',
    				        	fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
    				        	name: 'carteraCodigo',
    				        	displayField: 'descripcion',
        						valueField: 'codigo',
    				        	bind: {
    				        		store: '{comboCartera}'
    			            	},
    			            	reference: 'comboCarteraSearch',
    			            	chainedStore: 'comboSubcarteraFiltered',
    							chainedReference: 'comboSubcarteraOfertaSearch',
    							publishes: 'value',
    							listeners: {
    								select: 'onChangeChainedCombo'
    							}
	            	    	},
					        { 
								xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.subcartera'),
					        	name: 'subcarteraCodigo',
					        	bind: {
				            		store: '{comboSubcarteraFiltered}',
//					        		store: '{comboSubcartera}',
					        		disabled: '{!comboCarteraSearch.selection}',
					        		filters: {
					        			property: 'carteraCodigo',
					        			value: '{comboCarteraSearch.value}'
					        		}
				            	},
				            	reference: 'comboSubcarteraOfertaSearch',
				            	valueField: 'codigo',
	    						displayField: 'descripcion'
					        },
	            	    	{ 
					        	fieldLabel:  HreRem.i18n('fieldlabel.nombre.canal'),
					        	name: 'nombreCanal',
					        	bind: {
						 			disabled: '{!canal.selection}'
						 		}
							},
							{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.gestoria'),
					        	emptyText: HreRem.i18n('txt.seleccione.gestoria'),
					        	displayField: 'apellidoNombre',
	    						valueField: 'id',
					        	bind: {
				            		store: '{comboUsuariosGestoria}',
				            		readOnly: $AU.userTipoGestor()=="GIAFORM"
				            	},
								name: 'gestoria'
							},
							{
								fieldLabel:  HreRem.i18n('fieldlabel.email'),
								name: 'emailOfertante'
								
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.num.prinex'),
							    name: 'numPrinex',
							    reference: 'numPrinexOfertaComercial',
							    listeners: {
							    	change: 'activarCheckAgrupacionesVinculadas'
							    }
							},
							{
	            	    		fieldLabel: HreRem.i18n('fieldlabel.activosearch.codigo.promocion'),
					        	name: 'codigoPromocionPrinex'
	            	    	}
	            	    
	            	    ]
		            }
		         ];

        
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent();
        
    }
    
});

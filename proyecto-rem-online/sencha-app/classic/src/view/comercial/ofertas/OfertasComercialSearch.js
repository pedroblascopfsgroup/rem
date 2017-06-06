Ext.define('HreRem.view.comercial.ofertas.OfertasComercialSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'ofertascomercialsearch',
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    isSearchForm: true,
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
							    name: 'numOferta'        	
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.num.expediente'),
							    name: 'numExpediente'        	
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.num.activo'),
							    name: 'numActivo'        	
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
					        	name: 'tipoOferta',
					        	bind: {
				            		store: '{comboTipoOferta}'
				            	}
				        	},
				        	{ 
					        	xtype: 'comboboxfieldbase',
					        	multiSelect: true,
					        	fieldLabel:  HreRem.i18n('fieldlabel.estado.expediente'),
					        	name: 'estadosExpediente',
					        	bind: {
					        		store: '{comboEstadoExpediente}'
					        	}
							},
							{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.gestor'),
					        	bind: {
				            		store: '{comboTipoGestorOfertas}',
				            		value: $AU.userTipoGestor()				            			
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
					        	name: 'estadosOferta',					        	
				            	bind: {
				            		store: '{comboEstadoOferta}'
				            	}				            	
							},
							{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.canal'),
					        	name: 'canal',
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
					        	bind: {
				            		store: '{comboUsuarios}',
				            		disabled: '{!tipoGestor.selection}',
				            		value: $AU.getUser().userId				            			
				            	},
				            	displayField: 'apellidoNombre',
	    						valueField: 'id',
	    						mode: 'local',
	    						emptyText: HreRem.i18n('txt.seleccione.gestor'),
	    						enableKeyEvents:true,
    						    listeners: {
    						     'keyup': function() {
    						    	   this.getStore().clearFilter();
    						    	   this.getStore().filter({
    						        	    property: 'apellidoNombre',
    						        	    value: this.getRawValue(),
    						        	    anyMatch: true,
    						        	    caseSensitive: false
    						        	})
    						     },
    						     'beforequery': function(queryEvent) {
    						           queryEvent.combo.onLoad();
    						     }
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
				            		value: $AU.getUser().userId,
				            	    readOnly: $AU.userTipoGestor()=="GIAFORM"
				            	},
								name: 'gestoria'
							},
							{
								fieldLabel:  HreRem.i18n('fieldlabel.email'),
								name: 'emailOfertante'
								
							}
	            	    
	            	    ]
		            }
		         ];

        
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent();
        
    }
    
});

Ext.define('HreRem.view.comercial.ofertas.OfertasComercialSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'ofertascomercialsearch',
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    isSearchForm: true,
  	layout: {
        type: 'table',
        // The total column count must be specified here
        columns: 1,
        trAttrs: {height: '30px', width: '100%'},
        tdAttrs: {width: '25%'},
        tableAttrs: {
            style: {
                width: '100%'
				}
        }
	}, 

    initComponent: function () {
        var me = this;
        
        me.setTitle(HreRem.i18n("title.filtro.ofertas"));
        
        //me.buttons = [{ text: 'Buscar', handler: '' },{ text: 'Limpiar', handler: ''}];
        //me.buttonAlign = 'left';
        
        var items = [
        
        {
        	    xtype: 'panel',
 				minHeight: 125,
    			layout: 'column',
    			cls: 'panel-busqueda-directa',
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        style: 'width: 25%',
			        addUxReadOnlyEditFieldPlugin: false
			    },
	    		
			    items: [
							{
			            	    defaults: {	
							    	xtype: 'textfieldbase',
							    	addUxReadOnlyEditFieldPlugin: false
							    }, 
				            	items: [   
		
									{
										fieldLabel: HreRem.i18n('header.oferta.numOferta'),
									    name: 'numOferta'        	
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.numero.activo'),
									    name: 'numActivo'        	
									},
									{
							        	xtype: 'combo',
							        	fieldLabel: 'Tipo de gestor:',
							        	bind: {
						            		store: '{comboTipoGestorOfertas}'
						            	},
										reference: 'tipoGestor',
										name: 'tipoGestor',
			        					chainedStore: 'comboUsuarios',
										chainedReference: 'usuarioGestor',
						            	displayField: 'descripcion',
			    						valueField: 'id',
			    						emptyText: 'Introduzca un gestor',
										listeners: {
											select: 'onChangeChainedCombo'
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
										fieldLabel: HreRem.i18n('fieldlabel.numero.agrupacion.rem'),
									    name: 'numAgrupacion'        	
									},
				            		{ 
							        	xtype: 'combo',
							        	//hidden: true,
							        	editable: false,
							        	fieldLabel:  HreRem.i18n('header.oferta.tipoOferta'),
							        	labelWidth:	150,
							        	width: 		230,
							        	name: 'tipoOferta',
							        	bind: {
						            		store: '{comboTipoOferta}'
						            	},
						            	displayField: 'descripcion',
										valueField: 'codigo'
						        	},
						        	{
							        	xtype: 'combo',
							        	fieldLabel: 'Usuario:',
							        	reference: 'usuarioGestor',
							        	name: 'usuarioGestor',
							        	bind: {
						            		store: '{comboUsuarios}',
						            		disabled: '{!tipoGestor.selection}'
						            	},
						            	displayField: 'apellidoNombre',
			    						valueField: 'id',
			    						mode: 'local',
			    						emptyText: 'Introduzca un usuario',
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
								    }
						        	
									
									
								]
				            },
				            {
			            	    items: [   
			            	    	{ 
					                	xtype:'datefield',
								 		fieldLabel: HreRem.i18n('header.oferta.fechaAltaDesde'),
								 		width: 		275,
								 		name: 'fechaAltaDesde'
									},
									{ 
					                	xtype:'datefield',
								 		fieldLabel: HreRem.i18n('header.oferta.fechaAltaHasta'),
								 		width: 		275,
								 		name: 'fechaAltaHasta'
									},
									{ 
							        	xtype: 'combo',
							        	//hidden: true,
							        	editable: false,
							        	fieldLabel:  HreRem.i18n('header.oferta.estadoOferta'),
							        	labelWidth:	150,
							        	width: 		230,
							        	name: 'estadoOferta',
							        	bind: {
						            		store: '{comboEstadoOferta}'
						            	},
						            	displayField: 'descripcion',
										valueField: 'codigo'
									}
									
								]
				            }          
									
				            
		         ]
        }

        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent();
        
    }
    
});

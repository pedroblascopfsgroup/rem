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
 				minHeight: 100,
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
						        	}
						        	
									
									
								]
				            },
				            {
			            	    items: [   
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
						        	},
									{ 
					                	xtype:'datefield',
								 		fieldLabel: HreRem.i18n('header.oferta.fechaAlta'),
								 		width: 		275,
								 		name: 'fechaAlta'
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

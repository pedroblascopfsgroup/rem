Ext.define('HreRem.view.comercial.visitas.VisitasComercialSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'visitascomercialsearch',
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
        
        me.setTitle(HreRem.i18n("title.filtro.visitas"));
        
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
										fieldLabel: HreRem.i18n('header.numero.visita'),
									    name: 'numVisitaRem'        	
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
										fieldLabel: HreRem.i18n('fieldlabel.numero.activo'),
									    name: 'numActivo'        	
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

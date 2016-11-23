Ext.define('HreRem.view.administracion.gastos.GestionProvisionesSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'gestionprovisionessearch',

  	layout: {
        type: 'table',
        // The total column count must be specified here
        columns: 4,
        trAttrs: {height: '30px', width: '100%'},
        tdAttrs: {width: '25%'},
        tableAttrs: {
            style: {
                width: '100%'
				}
        }
	},
    
    defaults: {
		
    	xtype: 'textfieldbase',
    	addUxReadOnlyEditFieldPlugin: false
    },  

    initComponent: function () {
    	
        var me = this;
        
        me.setTitle(HreRem.i18n("title.filtro.provisiones"));
        
        me.buttons = [{ text: 'Buscar', handler: 'onClickProvisionesSearch' },{ text: 'Limpiar', handler: 'onCleanFiltersClick'}];
        me.buttonAlign = 'left';
        
        var items = [
        
        {
        	    xtype: 'panel',
 				minHeight: 100,
    			layout: 'column',
    			cls: 'panel-busqueda-directa',
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        style: 'width: 25%'
			    },
	    		
			    items: [
			    	    
				            {
			            	    defaults: {	
							    	xtype: 'textfieldbase',
							    	addUxReadOnlyEditFieldPlugin: false
							    }, 
				            	items: [   
		
									{
										fieldLabel: HreRem.i18n('fieldlabel.num.provision'),
									    name: 'numProvision'        	
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


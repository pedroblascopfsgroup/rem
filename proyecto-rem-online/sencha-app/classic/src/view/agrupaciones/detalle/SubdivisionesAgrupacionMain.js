Ext.define('HreRem.view.agrupaciones.detalle.SubdivisionesAgrupacionMain', {
    extend: 'Ext.panel.Panel',
    xtype: 'subdivisionesagrupacionmain',
    layout		: 'fit',
    requires: ['HreRem.view.agrupaciones.detalle.SubdivisionesAgrupacion', 'HreRem.view.agrupaciones.detalle.FotosSubdivision'],
    
    initComponent: function () {
    	
    	var me = this;
    	
    	var items = [
    	
    	
			{				
			    xtype		: 'tabpanel',
				cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
			    reference	: 'tabpanelAdmision',
			    layout: 'fit',
			    
			    items: [
			    		
			    		{
			    			xtype: 'subdivisionesagrupacion'    			
			    		},
			    		{
			    			xtype: 'fotossubdivision'
			    		}		    		
			     ]				
			}   	
    	];

    	me.setTitle(HreRem.i18n('title.subdivisiones'));
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false,
		activeTab = me.down('tabpanel').getActiveTab();
		
		if(activeTab.funcionRecargar) {
			activeTab.funcionRecargar();			
		}

    }
    
});
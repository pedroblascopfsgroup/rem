Ext.define('HreRem.view.agrupaciones.detalle.FotosAgrupacion', {
    extend: 'Ext.tab.Panel',
    xtype: 'fotosagrupacion',  
    flex 		: 3,
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    collapsed: false,
    scrollable	: 'y',
    layout		: 'fit',		
    reference: 'fotosagrupacion',
    requires: ['HreRem.view.agrupaciones.detalle.FotosWebAgrupacion'],
    
    defaults: {
        xtype: 'container',
        sytle: 'padding-left: 15px !important',
        defaultType: 'displayfield'
    },
    tabBar: {
		items: [
        		{
        			xtype: 'tbfill'
        		},
        		{
					xtype: 'buttontab',
        			itemId: 'botoneditarfoto',
        		    handler	: 'onClickBotonEditarFoto',
        		    iconCls: 'edit-button-color',
        		    bind: {hidden: '{editingfotos}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botonguardarfoto',
        		    handler	: 'onClickBotonGuardarInfoFoto', 
        		    iconCls: 'save-button-color',
        		    hidden: true,
        		    bind: {hidden: '{!editingfotos}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botoncancelarfoto',
        		    handler	: 'onClickBotonCancelarFoto', 
        		    iconCls: 'cancel-button-color',
        		    hidden: true,
        		    bind: {hidden: '{!editingfotos}'}
        		}
        ]
    },

    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.fotos'));      
        
       /* var items= [

			{				
			    xtype		: 'tabpanel',
			    flex 		: 3,
				cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
			    reference	: 'tabpanelfotosactivo',

			    layout: 'fit',
			    items: [
			    		
			    		{
			    			xtype: 'fotoswebagrupacion'
			    		}

			     ]				
			}

    	];   	
		me.addPlugin({ptype: 'lazyitems', items: items });

    	me.callParent();
    	
    	var me = this;
*/
        me.items = [];
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'fotoswebagrupacion'})}, ['TAB_FOTOS_AGRUPACION']);
       
        me.callParent();
    	
    },
    
     /**
     * Función de utilidad por si es necesario configurar algo de la vista y que no es posible
     * a través del viewModel 
     */
    configCmp: function(data) {
    	    	
    	var me = this;    	

    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabFotos(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    } 
    
});
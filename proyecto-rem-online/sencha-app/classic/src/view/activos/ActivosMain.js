Ext.define('HreRem.view.activos.ActivosMain', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'activosmain',
    cls			: 'tabpanel-base',
    reference	: 'activosMain',
    layout		: 'fit',
   	requires	: ['HreRem.view.activos.ActivosSearch','HreRem.view.activos.ActivosList', 'HreRem.view.activos.detalle.ActivosDetalleMain', 'HreRem.view.expedientes.ExpedienteDetalleMain',
   					'HreRem.view.activos.ActivosController','HreRem.view.activos.ActivosModel','Ext.ux.TabReorderer', 'HreRem.ux.button.BotonTab'],
    controller	: 'activos',
    viewModel	: {
        type: 'activos'
    },
    plugins		: ['tabreorderer'],

    initComponent: function () {
        var me = this;        
        me.callParent();

        var addTabBuscadorActivos = function() {
	        var tabBuscadorActivos = {
				    xtype		: 'container',
				    reference   : 'tabBuscadorActivos',
				    iconCls		: 'x-fa fa-search',
				    title		: 'Filtro Activos',
				    reorderable : false,
				    width		:	20,
					layout 		: {
									type : 'vbox',
									align : 'stretch'
					},
				    closable	: false, 			
					items 		: [			        	
									{xtype: "activossearch", reference: "activossearch" },
									{xtype: "activoslist", reference: "activoslist"}		        	      
				    ],
				    
				    listeners: {
				    	deactivate: function(){this.down("activoslist").closeWindows();},
				    	activate: function(){this.refresh()}
				    },
				    refresh: function() {						
						var me = this;
						if(me.refreshOnActivate)  {
							me.down('activoslist').getStore().load();
							me.refreshOnActivate = false;
						}
					}
	        	
	        	};

	        	me.setActiveTab(tabBuscadorActivos);
        };

       $AU.confirmFunToFunctionExecution(addTabBuscadorActivos,'TAB_BUSQUEDA_ACTIVOS');
    }
});
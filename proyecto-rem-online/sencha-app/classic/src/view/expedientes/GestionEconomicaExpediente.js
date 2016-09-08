Ext.define('HreRem.view.expedientes.GestionEconomicaExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'gestioneconomicaexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'gestionEconomicaExpediente',
    scrollable	: 'y',
    

    initComponent: function () {
        var me = this;
		me.setTitle(HreRem.i18n('title.gestion.economica'));
        var items= [

			{
				
            	xtype: 'fieldset',
            	collapsible: true,
            	title:  HreRem.i18n('title.gastos.soportados.propietario'),
            	items : [
            	
                	{
					    xtype		: 'gridBase',
					    reference: 'listadogastossoportadospropietario',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeGastosSoportadosPropietarios}'
						},									
						
						columns: [
						   {
					            text: HreRem.i18n('fieldlabel.accion'),
					            dataIndex: 'accion',
					            flex: 1
						   },
						    {
						   		text: HreRem.i18n('fieldlabel.codigo'),
					            dataIndex: 'codigo',
					            flex: 1						   
						   },						   
						   {
						   		text: HreRem.i18n('fieldlabel.nombre'),
					            dataIndex: 'nombre',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('header.tipo.calculo'),
					            dataIndex: 'tipoCalculo',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('header.importe.calculo'),
					            dataIndex: 'importeCalculo',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('header.importe.final'),
					            dataIndex: 'importeFinal',
					            flex: 1						   
						   }
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeGastosSoportadosPropietarios}'
					            }
					        }
			    		]
					}
            	]
            },
			{
				
            	xtype: 'fieldset',
            	collapsible: true,
            	title:  HreRem.i18n('title.gastos.soportados.haya'),
            	items : [
            	
                	{
					    xtype		: 'gridBase',
					    reference: 'listadogastossoportadoshaya',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeGastosSoportadosHaya}'
						},									
						
						columns: [
						   {
					            text: HreRem.i18n('fieldlabel.accion'),
					            dataIndex: 'accion',
					            flex: 1
						   },
						    {
						   		text: HreRem.i18n('fieldlabel.codigo'),
					            dataIndex: 'codigo',
					            flex: 1						   
						   },						   
						   {
						   		text: HreRem.i18n('fieldlabel.nombre'),
					            dataIndex: 'nombre',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('header.tipo.calculo'),
					            dataIndex: 'tipoCalculo',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('header.importe.calculo'),
					            dataIndex: 'importeCalculo',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('header.importe.final'),
					            dataIndex: 'importeFinal',
					            flex: 1						   
						   }
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeGastosSoportadosHaya}'
					            }
					        }
			    		]
					}
            	]
            } 
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);		
		
    }
});
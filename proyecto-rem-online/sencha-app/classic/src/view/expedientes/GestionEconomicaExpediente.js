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
            	title:  HreRem.i18n('title.horonarios'),
            	items : [
            	
                	{
					    xtype		: 'gridBase',
					    reference: 'listadohoronarios',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeHoronarios}'
						},									
						
						columns: [
						   {
					            text: HreRem.i18n('fieldlabel.colaborador'),
					            dataIndex: 'colaborador',
					            flex: 1
						   },
						    {
						   		text: HreRem.i18n('fieldlabel.tipo.proveedor'),
					            dataIndex: 'tipoProveedor',
					            flex: 1						   
						   },						   
						   {
						   		text: HreRem.i18n('fieldlabel.proveedor'),
					            dataIndex: 'proveedor',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.domicilio'),
					            dataIndex: 'domicilio',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.id'),
					            dataIndex: 'id',
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
						   		text: HreRem.i18n('fieldlabel.honorarios'),
					            dataIndex: 'horonarios',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.telefono'),
					            dataIndex: 'telefono',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.email'),
					            dataIndex: 'email',
					            flex: 1						   
						   }
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeHoronarios}'
					            }
					        }
			    		]
					}
            	]
            }
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    }
    
  // COMENTAR HASTA QUE SE DEFINA  
//    funcionRecargar: function() {
//    	var me = this; 
//		me.recargar = false;		
//		me.lookupController().cargarTabData(me);		
//		
//    }
});
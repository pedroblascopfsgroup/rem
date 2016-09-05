Ext.define('HreRem.view.activos.detalle.VisitasComercialActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'visitascomercialactivolist',
    bind: {
        store: '{storeVisitasActivo}'
    },
        
    initComponent: function () {
        
        var me = this;  
        
        me.columns= [
        
		         {
		        	
		            dataIndex: 'numVisita',
		            text: HreRem.i18n('header.numero.visita'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaSolicitud',
		            text: HreRem.i18n('header.fecha.solicitud'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'nombre',
		            text: HreRem.i18n('header.nombre'),
		            flex: 1
		        },
		        {
		            dataIndex: 'numDocumento',
		            text: HreRem.i18n('header.numero.documeto'),
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaVisita',
		            text: HreRem.i18n('header.fecha.visita'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'visitasPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeVisitasActivo}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});


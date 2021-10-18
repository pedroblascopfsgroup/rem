Ext.define('HreRem.view.activos.detalle.TestigosOpcionalesGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'testigosopcionalesgrid',
	topBar: false,
	idPrincipal : 'id',
	
    bind: {
        store: '{testigosOpcionales}'
    },
    
    initComponent: function () {
     	
     	var me = this;
		
		me.columns = [
		       
		        {
		            dataIndex: 'fuenteTestigos',
		            text: HreRem.i18n('title.testigos.opcionales.fuente'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'superficie',
		            text: HreRem.i18n('title.testigos.opcionales.superficie'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'tipoActivo',
		            text: HreRem.i18n('title.testigos.opcionales.tipologia'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'subtipoActivo',
		            text: HreRem.i18n('title.testigos.opcionales.subtipologia'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'direccion',
		            text: HreRem.i18n('title.testigos.opcionales.direccion'),
		            flex: 0.5
		        },
		        {
		        	dataIndex: 'lat',
		            text: HreRem.i18n('title.testigos.opcionales.lat'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'lng',
		            text: HreRem.i18n('title.testigos.opcionales.lng'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'eurosPorMetro',
		            text: HreRem.i18n('title.testigos.opcionales.euros.metro'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'precioMercado',
		            text: HreRem.i18n('title.testigos.opcionales.preciomercado'),
		            flex: 0.2
		        },		        
		        {
		        	dataIndex: 'enlace',
		            text: HreRem.i18n('title.testigos.opcionales.link'),
		            renderer: function(value) {
		            	return '<a href="' + value + '" target="_blank">' + value + '</a>'
		        	},
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaTransaccion',
		            text: HreRem.i18n('title.testigos.opcionales.fecha.transaccion'),
		            flex: 0.2
		        }	
		    ];
		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{testigosOpcionales}'
		            }
		        }
		    ];
		    
		    
		    me.callParent();
   }

});
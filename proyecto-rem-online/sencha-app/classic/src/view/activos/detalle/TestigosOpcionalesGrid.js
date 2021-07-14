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
		        	dataIndex: 'idTestigoSF',
		            text: HreRem.i18n('title.testigos.opcionales.idtestigo'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'nombre',
		            text: HreRem.i18n('title.testigos.opcionales.nombre'),
		            flex: 0.2
		        },
		        {
		            dataIndex: 'informesMediadores',
		            text: HreRem.i18n('title.testigos.opcionales.infmediadores'),
		            flex: 0.2
		        },
		        {
		            dataIndex: 'fuenteTestigos',
		            text: HreRem.i18n('title.testigos.opcionales.fuente'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'tipoActivo',
		            text: HreRem.i18n('title.testigos.opcionales.tipologia'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'direccion',
		            text: HreRem.i18n('title.testigos.opcionales.direccion'),
		            flex: 0.5
		        },
		        {
		        	dataIndex: 'superficie',
		            text: HreRem.i18n('title.testigos.opcionales.superficie'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'precio',
		            text: HreRem.i18n('title.testigos.opcionales.precio'),
		            flex: 0.2
		        },
		        {
		        	dataIndex: 'precioMercado',
		            text: HreRem.i18n('title.testigos.opcionales.preciomercado'),
		            flex: 0.2
		        },		        
		        {
		        	dataIndex: 'link',
		            text: HreRem.i18n('title.testigos.opcionales.link'),
		            renderer: function(value) {
		            	return '<a href="' + value + '" target="_blank">' + value + '</a>'
		        	},
		            flex: 0.5
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
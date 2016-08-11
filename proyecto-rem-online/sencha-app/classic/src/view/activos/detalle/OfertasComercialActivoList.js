Ext.define('HreRem.view.activos.detalle.OfertasComercialActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'ofertascomercialactivolist',

    bind: {
        store: '{ofertas}'
    },
        
    initComponent: function () {
        
        var me = this;  
        
        me.columns= [
        
		         {
		        	
		            dataIndex: 'numActivo',
		            text: HreRem.i18n('header.numero.visita'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'tipoActivoDescripcion',
		            text: HreRem.i18n('header.fecha.solicitud'),
		            flex: 1
		        },
		        {
		            dataIndex: 'subtipoActivoDescripcion',
		            text: HreRem.i18n('header.nombre'),
		            flex: 1
		        },
		        {
		            dataIndex: 'entidadPropietariaDescripcion',
		            text: HreRem.i18n('header.numero.documeto'),
		            flex: 1
		        },
		        {
		            dataIndex: 'tipoTituloActivoDescripcion',
		            text: HreRem.i18n('header.fecha.visita'),
		            flex: 1
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'ofertasPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{ofertas}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});
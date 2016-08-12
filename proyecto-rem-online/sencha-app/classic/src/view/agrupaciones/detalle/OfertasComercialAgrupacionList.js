Ext.define('HreRem.view.agrupacion.detalle.OfertasComercialAgrupacionList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'ofertascomercialagrupacionlist',
    bind: {
        store: '{storeOfertasAgrupacion}'
    },
        
    initComponent: function () {
        
        var me = this;  
        
        me.columns= [
        
		          {
		        	dataIndex: 'id',
		            text: HreRem.i18n('header.oferta.numOferta'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaCreacion',
		            text: HreRem.i18n('header.oferta.fechaAlta'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'descripcionTipoOferta',
		            text: HreRem.i18n('header.oferta.tipoOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'numAgrupacionRem',
		            text: HreRem.i18n('header.oferta.numAgrupacion'),
		            flex: 1
		        },
		        {
		            dataIndex: 'ofertante',
		            text: HreRem.i18n('header.oferta.oferante'),
		            flex: 2
		        },
		        {
		            dataIndex: 'comite',
		            text: HreRem.i18n('header.oferta.comite'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'precioPublicado',
		            text: HreRem.i18n('header.oferta.precioPublicado'),
		            flex: 1
		        },
		        {
		            dataIndex: 'importeOferta',
		            text: HreRem.i18n('header.oferta.importeOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'estadoOferta',
		            text: HreRem.i18n('header.oferta.estadoOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'numExpediente',
		            text: HreRem.i18n('header.oferta.expediente'),
		            flex: 1
		        },
		        {
		            dataIndex: 'descripcionEstadoExpediente',
		            text: HreRem.i18n('header.oferta.estadoExpediente'),
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
		                store: '{storeOfertasAgrupacion}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});


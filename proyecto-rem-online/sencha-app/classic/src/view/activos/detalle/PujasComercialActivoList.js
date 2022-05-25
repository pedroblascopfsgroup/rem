Ext.define('HreRem.view.activos.detalle.PujasComercialActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'pujascomercialactivolist',
    requires	: ['HreRem.model.PujasActivo', 'HreRem.view.activos.detalle.PujasComercialDetalle', 
    				'HreRem.model.Pujas', 'HreRem.model.HistoricoConcurrenciaGridModel'],
    reference	: 'pujascomercialactivolistref',
    bind: {
        store: '{storePujasActivo}'
    },
        
    initComponent: function () {
        
        var me = this;  
        
        me.listeners = {	    	
			rowdblclick: 'onPujasListDobleClick',
			rowclick: 'onPujasListClick'
	     }
        
        me.columns= [
        
	        	{
		        	dataIndex: 'numOferta',
		            text: HreRem.i18n('header.oferta.numOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'ofertante',
		            text: HreRem.i18n('header.cliente'),
		            flex: 1
		        },
		        {
		            dataIndex: 'estadoOferta',
		            text: HreRem.i18n('header.oferta.estadoOferta'),
		            reference: 'estadoOfertaRef',
		            flex: 1
		        },
		        {
		            dataIndex: 'estadoDeposito',
		            text: HreRem.i18n('header.pujas.estado.deposito'),
		            reference: 'estadoDepositoRef',
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaCreacion',
		            text: HreRem.i18n('header.oferta.fechaAlta'),
		            formatter: 'date("d/m/Y H:i")',
		            flex: 1
		        },
		        {
		            dataIndex: 'periodoConcurrencia',
		            text: HreRem.i18n('header.periodo.concurrencia'),
		            flex: 1
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'pujasListPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storePujasActivo}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    },
    
    recargarGrid: function() {
    	var me = this;
    	me.getStore().load();
    }
});

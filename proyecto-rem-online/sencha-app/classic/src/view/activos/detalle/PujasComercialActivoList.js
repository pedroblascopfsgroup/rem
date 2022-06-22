Ext.define('HreRem.view.activos.detalle.PujasComercialActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'pujascomercialactivolist',
    requires	: ['HreRem.model.PujasActivo', 'HreRem.view.activos.detalle.PujasComercialDetalle'],
    reference	: 'pujascomercialactivolistref',
    
        
    initComponent: function () {
        
        var me = this;  
        
        me.listeners = {	    	
			rowdblclick: 'onPujasListDobleClick'
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
		            dataIndex: 'descripcionEstadoOferta',
		            text: HreRem.i18n('header.oferta.estadoOferta'),
		            reference: 'estadoOfertaRef',
		            flex: 1
		        },
		        {
		            dataIndex: 'descripcionEstadoDeposito',
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
		            dataIndex: 'diasConcurrencia',
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
		            displayInfo: true
		        }
		];
		    
        me.callParent(); 
        
    },
    
    recargarGrid: function() {
    	var me = this;
    	me.getStore().load();
    }
});

Ext.define('HreRem.view.expedientes.OfertasDependientesExpedienteList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'ofertasdependientesexpedientelist',
    idPrincipal : 'id',
    bind: {
        store: '{storeOfertasAgrupadas}'
    },
        
    initComponent: function () {
        
        var me = this;  
        
        me.columns= [
        		{
		            dataIndex: 'numOfertaDependiente',
		            text: HreRem.i18n('header.oferta.agrupada.numOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'importeOfertaDependiente',
		            text: HreRem.i18n('header.oferta.agrupada.importeOferta'),
		            flex: 1,
		            renderer: function(value) {
		        		return Ext.util.Format.currency(value);
		        	}
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeOfertasAgrupadas}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }
});


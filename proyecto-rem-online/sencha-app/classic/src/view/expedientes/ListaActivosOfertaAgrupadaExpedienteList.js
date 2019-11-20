Ext.define('HreRem.view.expedientes.ListaActivosOfertaAgrupadaExpedienteList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'listaactivosofertaagrupadaexpedientelist',
    idPrincipal : 'id',
    bind: {
        store: '{storeActivosOfertasAgrupadas}'
    },

	initComponent: function () {
        
        var me = this;  
        
        me.columns= [
	        	{
		            dataIndex: 'numActivo',
		            text: HreRem.i18n('header.oferta.agrupada.numActivo'),
		            flex: 1
		        },
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
		        },
		        {
		            dataIndex: 'valorTasacionActivo',
		            text: HreRem.i18n('header.oferta.agrupada.vta'),
		            flex: 1,
		            renderer: function(value) {
		        		return Ext.util.Format.currency(value);
		        	}
		        },
		        {
		            dataIndex: 'valorNetoContable',
		            text: HreRem.i18n('header.oferta.agrupada.vnc'),
		            flex: 1,
		            renderer: function(value) {
		        		return Ext.util.Format.currency(value);
		        	}
		        },
		        {
		            dataIndex: 'valorRazonable',
		            text: HreRem.i18n('header.oferta.agrupada.vr'),
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
		                store: '{storeActivosOfertasAgrupadas}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }
});


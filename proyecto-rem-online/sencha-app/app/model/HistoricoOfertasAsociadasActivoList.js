Ext.define('HreRem.view.activos.detalle.HistoricoOfertasAsociadasActivoList', {
	extend: 'HreRem.view.common.GridBase',
    xtype: 'historicoofertasasociadasactivolist',
    
    store: Ext.create('Ext.data.Store', {
		pageSize: $AC.getDefaultPageSize(),
		model: 'HreRem.model.VisitasActivo',
		proxy: {
			type: 'uxproxy',
			remoteUrl: 'gencat/getHistoricoOfertasAsociadasIdComunicacionHistorico',
			extraParams: {
				idHComunicacion: null
			}
		}
	}),
	
	data: {
        idHComunicacion: -1
    },
        
    initComponent: function () {
        
        var me = this;
        
        me.store.getProxy().setExtraParam('idHComunicacion', me.idHComunicacion);
        me.store.load();
        
        me.columns = [
		        {
		            dataIndex: 'fechaPreBloqueo',
		            text: HreRem.i18n('header.fecha.prebloqueo'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'numOferta',
		            text: HreRem.i18n('header.oferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'importeOferta',
		            text: HreRem.i18n('header.importe'),
		            renderer: function(value) {
		        		return Ext.util.Format.currency(value);
		        	},
		            flex: 1
		        },
		        {
		            dataIndex: 'tipoComprador',
		            text: HreRem.i18n('header.tipo.comprador'),
		            flex: 1
		        },
		        {
		            dataIndex: 'situacionOcupacional',
		            text: HreRem.i18n('header.situacion.ocupacional'),
		            flex: 1
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'ofertasAsociadasPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            store: me.store
		        }
		];
		    
        me.callParent(); 
        
    }


});
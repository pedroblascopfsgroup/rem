Ext.define('HreRem.view.activos.detalle.HistoricoNotificacionesActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'historiconotificacionesactivolist',
    
    store: Ext.create('Ext.data.Store', {
		pageSize: $AC.getDefaultPageSize(),
		model: 'HreRem.model.NotificacionActivo',
		proxy: {
			type: 'uxproxy',
			remoteUrl: 'gencat/getNotificacionesHistoricoByIdComunicacionHistorico',
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
        
        /*me.listeners = {	    	
			rowdblclick: 'onVisitasListDobleClick'
	    }*/
        
        me.store.getProxy().setExtraParam('idHComunicacion', me.idHComunicacion);
        me.store.load();
        
        me.columns= [
		        {
		            dataIndex: 'fechaNotificacion',
		            text: HreRem.i18n('fieldlabel.motivo'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'motivoNotificacion',
		            text: HreRem.i18n('fieldlabel.motivo'),
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaSancionNotificacion',
		            text: HreRem.i18n('fieldlabel.motivo'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'cierreNotificacion',
		            text: HreRem.i18n('fieldlabel.motivo'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'reclamacionesactivolistPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            store: me.store
		        }
		];
		    
        me.callParent(); 
        
    }


});
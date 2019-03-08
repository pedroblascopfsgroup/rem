Ext.define('HreRem.view.activos.detalle.HistoricoReclamacionesActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'historicoreclamacionesactivolist',
    
    store: Ext.create('Ext.data.Store', {
		pageSize: $AC.getDefaultPageSize(),
		model: 'HreRem.model.VisitasActivo',
		proxy: {
			type: 'uxproxy',
			remoteUrl: 'gencat/getHistoricoReclamacionesByIdComunicacionHistorico',
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
        
      /*  me.listeners = {	    	
			rowdblclick: 'onVisitasListDobleClick'
	    }*/
        
        me.columns= [
		        {
		            dataIndex: 'fechaAviso',
		            text: HreRem.i18n('header.fecha.aviso'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaReclamacion',
		            text: HreRem.i18n('header.fecha.reclamacion'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'historicoreclamacionesactivolistPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            store: me.store
		        }
		];
		    
        me.callParent(); 
        
    }


});
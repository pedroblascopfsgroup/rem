Ext.define('HreRem.view.activos.detalle.DocumentosComunicacionHistoricoGencatList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'documentoscomunicacionhistoricogencatlist',
    
    store: Ext.create('Ext.data.Store', {
		pageSize: $AC.getDefaultPageSize(),
		model: 'HreRem.model.DocumentoActivoGencat',
		proxy: {
			type: 'uxproxy',
			remoteUrl: 'gencat/getListAdjuntosComunicacionHistoricoByIdComunicacionHistorico',
			extraParams: {
				idHComunicacion: null
			}
		},
		groupField: 'descripcionTipo' 
	}),
	
	features: [{ftype:'grouping'}],
    topBar		:  true,
    removeButton: false,
	
    data: {
        idHComunicacion: -1
    },
        
    initComponent: function () {
        
        var me = this;  
        
        //me.topBar = $AU.userHasFunction('EDITAR_TAB_ACTIVO_DOCUMENTOS');
        
        /*me.listeners = {	    	
			rowdblclick: 'onVisitasListDobleClick'
	    }*/
        
        me.store.getProxy().setExtraParam('idHComunicacion', me.idHComunicacion);
        me.store.load();
        
        me.columns = [
	    		{
			        xtype: 'actioncolumn',
			        width: 30,	
			        hideable: false,
			        items: [{
			           	iconCls: 'ico-download',
			           	tooltip: HreRem.i18n("tooltip.download"),
			            handler: function(grid, rowIndex, colIndex) {
			            	
			                var record = grid.getRecord(rowIndex);
			                me.fireEvent("download", me, record);
			                
	            		}
			        }]
	    		},
	    		{
		            dataIndex: 'nombre',
		            text: HreRem.i18n('header.nombre.documento'),
		            flex: 1,
		            hidden: true
		        },
		        {   text: HreRem.i18n('header.tipo'),
		        	dataIndex: 'descripcionTipo',
		        	flex: 1,
		        	hidden: true
		        },
		        {
		            dataIndex: 'fechaDocumento',
		            text: HreRem.i18n('header.fecha.subida'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'gestor',
		            text: HreRem.i18n('header.usuario.subida'),
		            flex: 1
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'documentoscomunicacioneshistoricolistPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            store: me.store
		        }
		];
		    
        me.callParent(); 
        
    }


});
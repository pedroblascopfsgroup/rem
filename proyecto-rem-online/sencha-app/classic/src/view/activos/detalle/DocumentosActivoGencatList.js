Ext.define('HreRem.view.activos.detalle.DocumentosActivoGencatList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'documentosactivogencatlist',
    
    bind: {
        store: '{storeDocumentosActivoGencat}'
    },
    features: [{ftype:'grouping'}],
    topBar		:  true,
    removeButton: false,
        
    initComponent: function () {
        
        var me = this;  
        
        //me.topBar = $AU.userHasFunction('EDITAR_TAB_ACTIVO_DOCUMENTOS');
        
        /*me.listeners = {	    	
			rowdblclick: 'onVisitasListDobleClick'
	    }*/
        
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
		            itemId: 'documentosactivolistPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeDocumentosActivoGencat}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});
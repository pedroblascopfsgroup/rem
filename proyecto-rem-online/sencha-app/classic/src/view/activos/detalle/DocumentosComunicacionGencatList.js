Ext.define('HreRem.view.activos.detalle.DocumentosComunicacionGencatList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'documentoscomunicaciongencatlist',
    
    bind: {
        store: '{storeDocumentosActivoGencat}'
    },
    features: [{ftype:'grouping'}],
    topBar		:  true,
    removeButton: true,
        
    initComponent: function () {
        
        var me = this;
        me.topBar = ($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTIAFORM'])|| $AU.userIsRol(CONST.PERFILES['HAYAGESTFORMADM'])); 
        
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
		            flex: 1
		        },
		        {   text: HreRem.i18n('header.tipo'),
		        	dataIndex: 'descripcionTipo',
		        	flex: 1
		        },
		        {
		            dataIndex: 'createDate',
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
		            itemId: 'documentoscomunicacionlistPaginationToolbar',
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
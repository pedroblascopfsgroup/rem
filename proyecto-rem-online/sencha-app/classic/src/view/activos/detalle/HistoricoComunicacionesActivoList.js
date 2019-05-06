Ext.define('HreRem.view.activos.detalle.HistoricoComunicacionesActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'historicocomunicacionesactivolist',
    bind: {
        store: '{storeHistoricoComunicaciones}'
    },
        
    initComponent: function () {
        
        var me = this;  
        
        me.listeners = {	    	
			rowdblclick: 'onHistoricoComunicacionesDoubleClick'
	    };
        
        me.columns= [
	        	{
		        	dataIndex: 'id',
		        	text: HreRem.i18n('header.id'),
		        	flex:0.5,
		        	hidden: true
		        },
		        {
		            dataIndex: 'fechaPreBloqueo',
		            text: HreRem.i18n('header.fecha.prebloqueo'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaComunicacion',
		            text: HreRem.i18n('header.fecha.comunicacion'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaSancion',
		            text: HreRem.i18n('header.fecha.sancion'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'sancion',
		            text: HreRem.i18n('header.resultado.sancion'),
		            flex: 1
		        },
		        {
		            dataIndex: 'estadoComunicacion',
		            text: HreRem.i18n('header.estado.comunicacion'),
		            flex: 1
		        }
        ];
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'historicocomunicacionesactivolistPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeHistoricoComunicaciones}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});
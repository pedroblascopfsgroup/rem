Ext.define('HreRem.view.activos.detalle.HistoricoOcupacionesIlegalesGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'historicoocupacionesilegalesgrid',
    reference	: 'historicoocupacionesilegalesgridref',
	topBar		: false,
    bind: {
        store: '{storeHistoricoOcupacionesIlegales}'
    },
    
    listeners: { 	
    	
    },
    
    initComponent: function () {
     	
     	var me = this;

		me.columns = [
		        {
		        	text: HreRem.i18n('title.numasunto.historico.ocupaciones.ilegales'),
		        	dataIndex: 'numAsunto',
		        	flex:1
		        },
				{
		        	text: HreRem.i18n('title.fechainicioasunto.historico.ocupaciones.ilegales'),
		            dataIndex: 'fechaInicioAsunto',
		        	flex: 1, 
		            formatter: 'date("d/m/Y")'
		        },
		        {
		        	text: HreRem.i18n('title.fechafinasunto.historico.ocupaciones.ilegales'),
		            dataIndex: 'fechaFinAsunto',
		        	flex: 1,
		        	formatter: 'date("d/m/Y")'
		        },
		        {
		        	text: HreRem.i18n('title.fechalanzamiento.historico.ocupaciones.ilegales'),
		            dataIndex: 'fechaLanzamiento',
		        	flex: 1,
		        	formatter: 'date("d/m/Y")'
		        },
		        {
		        	text: HreRem.i18n('title.tipoasunto.historico.ocupaciones.ilegales'),
		            dataIndex: 'tipoAsunto',
		        	flex: 1 
		        },
		        {
		        	text: HreRem.i18n('title.tipoactuacion.historico.ocupaciones.ilegales'),
		            dataIndex: 'tipoActuacion',
		        	flex: 1 
		        }
		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{storeHistoricoOcupacionesIlegales}'
		            }
		        }
		    ];

		    me.callParent();
	    
   }
});
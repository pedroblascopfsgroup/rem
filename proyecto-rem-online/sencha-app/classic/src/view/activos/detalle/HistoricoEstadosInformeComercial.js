Ext.define('HreRem.view.activos.detalle.HistoricoEstadosInformeComercial', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'historicoestadosinformecomercial',
	topBar: false,
	idPrincipal : 'activo.id',
	
    bind: {
        store: '{historicoInformeComercial}'
    },
    
    initComponent: function () {
     	
     	var me = this;
		
		me.columns = [
		        {
		            dataIndex: 'fecha',
		            text: HreRem.i18n('title.publicaciones.condiciones.fecha'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y h:m:s")'
		        },
		        {
		            dataIndex: 'estadoInfoComercial',
		            text: HreRem.i18n('title.publicaciones.condiciones.estado'),
		            flex: 1
		        },
		        {
		        	dataIndex: 'motivo',
		            text: HreRem.i18n('title.publicaciones.condiciones.motivo'),
		            flex: 1
		        },
		        {
		        	dataIndex: 'responsableCambio',
		            text: HreRem.i18n('header.responsable.cambio'),
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
		                store: '{historicoInformeComercial}'
		            }
		        }
		    ];
		    
		    
		    me.callParent();
   },
   
   onGridBaseSelectionChange: function(grid, records) {
	   //Se sobreescribe para que no deje eliminar.
   }

});
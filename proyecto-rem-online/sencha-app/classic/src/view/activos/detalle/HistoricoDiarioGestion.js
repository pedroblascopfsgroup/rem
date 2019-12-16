Ext.define('HreRem.view.activos.detalle.HistoricoGestionGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'historicoDiarioGestionGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,

    bind: {
        store: '{storeHistoricoDiarioDeGestion}'
    },
  
    initComponent: function () {

     	var me = this;

		me.columns = [
			   {
		            dataIndex: 'estadoLocId',
		            hidden:true,
		            flex: 0.5
		        },
		        {
		            dataIndex: 'estadoLocDesc',
		            text: HreRem.i18n('title.historico.diario.gestion.localizacion'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'subEstadoDesc',
		            text: HreRem.i18n('title.historico.diario.gestion.subestado'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'nombreGestorDesc',
		            text: HreRem.i18n('title.historico.diario.gestion.gestor'),
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaCambioEstado',
		            text: HreRem.i18n('title.historico.diario.gestion.fecha.cambio.estado'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
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
		                store: '{storeHistoricoDiarioDeGestion}'
		            }
		        }
		    ];

		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('informecomercialactivo').funcionRecargar();
		    	return true;
		    },

		    me.callParent();
    }
});

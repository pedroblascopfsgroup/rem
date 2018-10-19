Ext.define('HreRem.view.activos.detalle.HistoricoAdecuacionesGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'historicoadecuacionesgrid',
	topBar		: false,
	propagationButton: true,
	targetGrid	: 'adecuacionesactivo',
	idPrincipal : 'activo.id',
	editOnSelect: false,
	disabledDeleteBtn: true,

    bind: {
        store: '{storeHistoricoAdecuacionesAlquiler}'
    },

    initComponent: function () {

     	var me = this;

		me.columns = [
				{
		            dataIndex: 'descripcionAdecuacion',
		            text: HreRem.i18n('title.grid.historico.adecuaciones.descripcionAdecuacion'),
		            flex: 0.2
		        },
		        {
		            xtype: 'booleancolumn',
		        	dataIndex: 'checkPerimetroAlquiler',
		            text: HreRem.i18n('title.grid.historico.adecuaciones.checkPerimetroAlquiler'),
		            flex: 0.2,
		            trueText: 'Si',//properties
		            falseText: 'No'
		        },
		        {
		            dataIndex: 'fechaInicioAdecuacion',
		            text: HreRem.i18n('title.grid.historico.adecuaciones.fechaIniAdecuacion'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaFinAdecuacion',
		            text: HreRem.i18n('title.grid.historico.adecuaciones.fechaFinAdecuacion'),
		            formatter: 'date("d/m/Y")',
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaInicioPerimetroAlquiler',
		            text: HreRem.i18n('title.grid.historico.adecuaciones.fechaIniPerimetroAlquiler'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaFinPerimetroAlquiler',
		            text: HreRem.i18n('title.grid.historico.adecuaciones.fechaFinPerimetroAlquiler'),
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
		                store: '{storeHistoricoAdecuacionesAlquiler}'
		            }
		        }
		    ];

		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('patrimonioactivo').funcionRecargar();
		    	return true;
		    },

		    me.callParent();
   }
});

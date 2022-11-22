Ext.define('HreRem.view.expedientes.FirmaAdendaGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype		: 'firmaadendagrid',
    requires : [ 'HreRem.model.FirmaAdendaGrid'],
    reference : 'firmaAdendaGridRef',
    recordName : "firmaAdendaGrid",
    recordClass : "HreRem.model.FirmaAdendaGrid",
    bind: {
        store: '{storeFirmaAdenda}'
    },

    initComponent: function () {
     	var me = this;
		me.columns = [
				{
					dataIndex: 'firmado',
					text: HreRem.i18n('fieldlabel.firma.adenda.firmado'),
		        	flex: 1
				},
				{
					dataIndex: 'fecha',
					text: HreRem.i18n('fieldlabel.firma.adenda.fecha'),
					editor: {
		        		xtype: 'datefield'
		        	},
		            formatter: 'date("d/m/Y")',
		            flex: 1
				},
				{
					dataIndex: 'motivo',
					text: HreRem.i18n('fieldlabel.firma.adenda.motivo'),
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
		                store: '{storeFirmaAdenda}'
		            }
		        }
		    ];

		    me.callParent();
	        
	        
   }
});

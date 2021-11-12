Ext.define('HreRem.view.activos.DescuentoColectivosGrid', {
    extend: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype: 'descuentocolectivosgrid',
	bind: {
		store: '{storeDescuentoColectivos}'
	},
	requires: ['HreRem.model.DescuentoColectivosGridModel'],
	recordName : "descuentocolectivos",
	reference: 'descuentocolectivosgridref',

	initComponent: function() {

		var me = this;

		me.columns = [
		    {               
                text	 : HreRem.i18n('fieldlabel.tipo.descuento.colectivo'),
                flex	 : 2,
                dataIndex: 'descuentosDesc'
            },
            {               
                text	 : HreRem.i18n('fieldlabel.tipo.precio'),
                flex	 : 2,
                dataIndex: 'preciosDesc'
            }
		];

		me.dockedItems = [
			{
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'descuentoColectivosToolbar',
	            displayInfo: true,
				bind: {
					store: '{storeDescuentoColectivos}'
				}
	
	        }	
		];

		me.callParent();

	}
});

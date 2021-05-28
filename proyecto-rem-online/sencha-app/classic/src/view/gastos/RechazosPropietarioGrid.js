Ext.define('HreRem.view.gastos.RechazosPropietarioGrid', {
    extend: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype: 'rechazopropietariogrid',
	bind: {
		store: '{storeRechazosPropietario}'
	},
	requires: ['HreRem.model.RechazosPropietarioGridModel'],
	recordName : "rechazospropietario",
	reference: 'rechazopropietariogridref',

	initComponent: function() {

		var me = this;

		me.columns = [
            {
            	text	 : HreRem.i18n('fieldlabel.numero.gasto'),
                flex	 : 1,
                dataIndex: 'numeroGasto'
            }, 
		    {               
                text	 : HreRem.i18n('fieldlabel.motivo.rechazo'),
                flex	 : 3,
                dataIndex: 'listadoErroresDesc'
            },
            {
                text	 : HreRem.i18n('fieldlabel.mensaje.rechazo'),
                flex	 : 1,
                dataIndex: 'mensajeError'
            },
            {
            	text	 : HreRem.i18n('fieldlabel.fecha.rechazo'),
            	flex	 : 1,
            	formatter: 'date("d/m/Y")',
                dataIndex: 'fechaProcesado'
            }		 
		];

		me.dockedItems = [
			{
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'rechazosPropietarioToolbar',
	            displayInfo: true,
				bind: {
					store: '{storeRechazosPropietario}'
				}
	
	        }	
		];

		me.callParent();

	}
});

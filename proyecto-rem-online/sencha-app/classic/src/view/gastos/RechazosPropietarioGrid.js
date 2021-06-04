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
                flex	 : 0.5,
                dataIndex: 'numeroGasto'
            },
            {
            	text	 : HreRem.i18n('fieldlabel.numero.linea'),
                flex	 : 0.5,
                dataIndex: 'numeroLinea'
            },
            {
            	text	 : HreRem.i18n('fieldlabel.numero.activo'),
                flex	 : 0.5,
                dataIndex: 'numeroActivo'
            },
		    {               
                text	 : HreRem.i18n('fieldlabel.motivo.rechazo'),
                flex	 : 2,
                dataIndex: 'listadoErroresDesc'
            },
            {
                text	 : HreRem.i18n('fieldlabel.mensaje.rechazo'),
                flex	 : 0.5,
                dataIndex: 'mensajeError'
            },
            {
            	text	 : HreRem.i18n('fieldlabel.fecha.rechazo'),
            	flex	 : 0.5,
            	formatter: 'date("d/m/Y")',
                dataIndex: 'fechaProcesado'
            },
            {
                text	 : HreRem.i18n('fieldlabel.tipo.importe'),
                flex	 : 0.5,
                dataIndex: 'tipoImporte'
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

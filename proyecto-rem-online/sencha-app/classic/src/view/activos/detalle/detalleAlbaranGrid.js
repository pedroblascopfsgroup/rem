Ext.define('HreRem.view.activos.detalle.detalleAlbaranGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'detalleAlbaranGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,
	bind: {
		store: '{detalleAlbaranes}'
	},
	listeners:{
		rowclick: 'onPrefacturaClick',
		deselect: 'deselectPrefactura'
	},
	
    initComponent: function () {

     	var me = this;
     	
     	
		me.columns = [
				{
					dataIndex: 'numPrefactura',
					reference: 'numPrefactura',
					text: HreRem.i18n('fieldlabel.albaran.numPrefacturas')
				},
				{ 
		    		dataIndex: 'propietario',
		    		reference: 'propietario',
		    		text: HreRem.i18n('fieldlabel.albaran.propietario')
	    		},
		        {
		            dataIndex: 'anyo',
		            reference: 'anyo',
		            text: HreRem.i18n('fieldlabel.albaran.anyo')
		        },
		        {
		            dataIndex: 'estadoAlbaran',
		            reference: 'estadoAlbaran',
		            text: HreRem.i18n('fieldlabel.albaran.estadoAlbaran')
		        },
		        {
		            dataIndex: 'numGasto',
		            reference: 'numGasto',
		            text: HreRem.i18n('fieldlabel.albaran.numGasto')
		        },
		        {
		            dataIndex: 'estadoGasto',
		            reference: 'estadoGasto',
		            text: HreRem.i18n('fieldlabel.albaran.estadoGasto')
		        },
		        {
		            dataIndex: 'importeTotalDetalle',
		            reference: 'importeTotalDetalle',
		            text: HreRem.i18n('fieldlabel.albaran.importeTotalDetalle')
		        },
		        {
		            dataIndex: 'importeTotalClienteDetalle',
		            reference: 'importeTotalClienteDetalle',
		            text: HreRem.i18n('fieldlabel.albaran.importeTotalClienteDetalle')
		        }
		    ];
		me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'detalleAlbaranesPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true,
	            bind: {
	            	store: '{detalleAlbaranes}'
	            }
	        }
	    ];
		    me.callParent();
    }
});

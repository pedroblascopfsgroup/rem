Ext.define('HreRem.view.activos.detalle.AlbaranGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'albaranGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,
	bind: {
		store: '{albaranes}'
	},
	listeners:{
		rowclick: 'onAlbaranClick',
		deselect: 'deselectAlbaran'
	},
	
    initComponent: function () {

     	var me = this;
     	
     	
		me.columns = [
				{
					dataIndex: 'numAlbaran',
					reference: 'numAlbaran',
					text: HreRem.i18n('fieldlabel.albaran.numAlbaran')
				},
				{ 
		    		dataIndex: 'fechaAlbaran',
		    		reference: 'fechaAlbaran',
		    		text: HreRem.i18n('fieldlabel.albaran.fechaAlbaran')
	    		},
		        {
		            dataIndex: 'estadoAlbaran',
		            reference: 'estadoAlbaran',
		            text: HreRem.i18n('fieldlabel.albaran.estadoAlbaran')
		        },
		        {
		            dataIndex: 'numPrefacturas',
		            reference: 'numPrefacturas',
		            text: HreRem.i18n('fieldlabel.albaran.numPrefacturas')
		        },
		        {
		            dataIndex: 'numTrabajos',
		            reference: 'numTrabajos',
		            text: HreRem.i18n('fieldlabel.albaran.numTrabajos')
		        },
		        {
		            dataIndex: 'importeTotal',
		            reference: 'importeTotal',
		            text: HreRem.i18n('fieldlabel.albaran.importeTotal')
		        },
		        {
		            dataIndex: 'importeTotalCliente',
		            reference: 'importeTotalCliente',
		            text: HreRem.i18n('fieldlabel.albaran.importeTotalCliente')
		        }
		        
		    ];
		
		me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'albaranesPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true,
	            bind: {
	                store: '{albaranes}'
	            }
	        }
	    ];

		    me.callParent();
    }
});

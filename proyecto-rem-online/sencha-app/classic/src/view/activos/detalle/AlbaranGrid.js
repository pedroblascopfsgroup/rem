Ext.define('HreRem.view.activos.detalle.AlbaranGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'albaranGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,
	layout: 'fit',
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
					flex: 1,
					reference: 'numAlbaran',
					text: HreRem.i18n('fieldlabel.albaran.numAlbaran')
				},
				{ 
		    		dataIndex: 'fechaAlbaran',
		    		flex: 1,
		    		reference: 'fechaAlbaran',
		    		formatter: 'date("d/m/Y")',
		    		text: HreRem.i18n('fieldlabel.albaran.fechaAlbaran')
	    		},
		        {
		            dataIndex: 'estadoAlbaran',
		            flex: 1,
		            reference: 'estadoAlbaran',
		            text: HreRem.i18n('fieldlabel.albaran.estadoAlbaran')
		        },
		        {
		            dataIndex: 'numPrefacturas',
		            flex: 1,
		            reference: 'numPrefacturas',
		            text: HreRem.i18n('fieldlabel.albaran.numPrefacturas')
		        },
		        {
		            dataIndex: 'numTrabajos',
		            flex: 1,
		            reference: 'numTrabajos',
		            text: HreRem.i18n('fieldlabel.albaran.numTrabajos')
		        },
		        {
		            dataIndex: 'importeTotal',
		            flex: 1,
		            reference: 'importeTotal',
		            renderer: Utils.rendererCurrency,
//		            editor: {
//		        		xtype:'currencyfieldbase',
//		        		minValue: 0,
//		        		allowBlank: false
//		        	},
		            text: HreRem.i18n('fieldlabel.albaran.importeTotal')
		        },
		        {
		            dataIndex: 'importeTotalCliente',
		            flex: 1,
		            reference: 'importeTotalCliente',
		            renderer: Utils.rendererCurrency,
//		            editor: {
//		        		xtype:'currencyfieldbase',
//		        		minValue: 0,
//		        		allowBlank: false
//		        	},
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

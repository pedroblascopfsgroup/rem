Ext.define('HreRem.view.activos.detalle.DetallePrefacturasGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'detallePrefacturaGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,
	bind: {
		store: '{detallePrefactrura}'
	},
	
    initComponent: function () {

     	var me = this;
     	
     	
		me.columns = [
				{
					dataIndex: 'numTrabajo',
					reference: 'numTrabajo',
					flex: 1,
					text: HreRem.i18n('fieldlabel.albaran.numTrabajos')
				},
				{
					dataIndex: 'tipologiaTrabajo',
					reference: 'tipologiaTrabajo',
					flex: 1,
					text: HreRem.i18n('fieldlabel.albaran.tipologiaTrabajo')
				},
				{
					dataIndex: 'subtipologiaTrabajo',
					reference: 'subtipologiaTrabajo',
					flex: 1,
					text: HreRem.i18n('fieldlabel.albaran.subtipologiaTrabajo')
				},
				{ 
		    		dataIndex: 'descripcion',
		    		reference: 'descripcion',
		    		flex: 1,
		    		text: HreRem.i18n('fieldlabel.albaran.descripcion')
	    		},
		        {
		            dataIndex: 'fechaAlta',
		            reference: 'fechaAlta',
		            formatter: 'date("d/m/Y")',
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.fechaAlta')
		        },
		        {
		            dataIndex: 'estadoTrabajo',
		            reference: 'estadoTrabajo',
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.estadoTrabajo')
		        },
		        {
		            dataIndex: 'importeTotalPrefactura',
		            reference: 'importeTotalPrefactura',
		            renderer: Utils.rendererCurrency,
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.importeTotalPrefactura')
		        },
		        {
		            dataIndex: 'importeTotalClientePrefactura',
		            reference: 'importeTotalClientePrefactura',
		            renderer: Utils.rendererCurrency,
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.importeTotalClientePrefactura')
		        },
		        {
		        	xtype: 'checkcolumn',
		            dataIndex: 'checkIncluirTrabajo',
		            reference: 'checkIncluirTrabajo',
		            flex: 1,
		            listeners: {
		                checkchange: 'onCheckChangeIncluirTrabajo'
		            },
		            text: HreRem.i18n('fieldlabel.albaran.checkIncluirTrabajo')
		        }
		    ];
		
		me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'detallePrefacturaPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true,
	            bind: {
	                store: '{detallePrefactrura}'
	            }
	        }
	    ];

		    me.callParent();
    }
});

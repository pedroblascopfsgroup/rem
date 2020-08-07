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
					text: HreRem.i18n('fieldlabel.albaran.numTrabajos')
				},
				{
					dataIndex: 'tipologiaTrabajo',
					reference: 'tipologiaTrabajo',
					text: HreRem.i18n('fieldlabel.albaran.tipologiaTrabajo')
				},
				{
					dataIndex: 'subtipologiaTrabajo',
					reference: 'subtipologiaTrabajo',
					text: HreRem.i18n('fieldlabel.albaran.subtipologiaTrabajo')
				},
				{ 
		    		dataIndex: 'descripcion',
		    		reference: 'descripcion',
		    		text: HreRem.i18n('fieldlabel.albaran.descripcion')
	    		},
		        {
		            dataIndex: 'fechaAlta',
		            reference: 'fechaAlta',
		            text: HreRem.i18n('fieldlabel.albaran.fechaAlta')
		        },
		        {
		            dataIndex: 'estadoTrabajo',
		            reference: 'estadoTrabajo',
		            text: HreRem.i18n('fieldlabel.albaran.estadoTrabajo')
		        },
		        {
		            dataIndex: 'importeTotalPrefactura',
		            reference: 'importeTotalPrefactura',
		            text: HreRem.i18n('fieldlabel.albaran.importeTotalPrefactura')
		        },
		        {
		            dataIndex: 'importeTotalClientePrefactura',
		            reference: 'importeTotalClientePrefactura',
		            text: HreRem.i18n('fieldlabel.albaran.importeTotalClientePrefactura')
		        },
		        {
		            dataIndex: 'checkIncluirTrabajo',
		            reference: 'checkIncluirTrabajo',
		            text: HreRem.i18n('fieldlabel.albaran.checkIncluirTrabajo')
		        },
		        {
		            dataIndex: 'totalPrefactura',
		            reference: 'totalPrefactura',
		            text: HreRem.i18n('fieldlabel.albaran.totalPrefactura')
		        },
		        {
		            dataIndex: 'totalAlbaran',
		            reference: 'totalAlbaran',
		            text: HreRem.i18n('fieldlabel.albaran.totalAlbaran')
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

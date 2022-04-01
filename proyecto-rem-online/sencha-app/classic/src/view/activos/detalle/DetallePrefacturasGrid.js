Ext.define('HreRem.view.activos.detalle.DetallePrefacturasGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'detallePrefacturaGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,
	disableSelection: true,
	bind: {
		store: '{detallePrefactrura}'
	},
	listeners: {
		rowdblclick: 'onRowDblClickListadoDetallePrefactura' 
	},
	//NO TOCAR, SIRVE PARA LA PERSISTENCIA DEL CHECKBOX
	data: [
		
	],
	
    initComponent: function () {

     	var me = this;
     	me.data = [];
     	
     	var mostrarTotalProveedor = me.lookupController().mostrarTotalProveedor();
     	
		me.columns = [
				{
					dataIndex: 'idTrabajo', 
					reference: 'idTrabajo',
					flex: 1,
					hidden:true
				},
				{
					dataIndex: 'nombrePropietario', 
					reference: 'nombrePropietario',
					flex: 1,
					text: HreRem.i18n('fieldlabel.albaran.propietario')
				},
				{
					dataIndex: 'numTrabajo',
					reference: 'numTrabajo',
					flex: 1,
					text: HreRem.i18n('fieldlabel.albaran.numTrabajo')
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
		            text: HreRem.i18n('fieldlabel.albaran.importeTotalPrefactura'),
		            hidden: mostrarTotalProveedor
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

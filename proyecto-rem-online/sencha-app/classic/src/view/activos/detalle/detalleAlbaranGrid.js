Ext.define('HreRem.view.activos.detalle.detalleAlbaranGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'detalleAlbaranGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,
	scrollable: true,
	bind: {
		store: '{detalleAlbaranes}'
	},
	listeners:{
		rowclick: 'onPrefacturaClick',
		deselect: 'deselectPrefactura'
	},
	
    initComponent: function () {

     	var me = this;
     	
     	var mostrarTotalProveedor = me.lookupController().mostrarTotalProveedor();
     	
		me.columns = [
				{
					dataIndex: 'numPrefactura',
					reference: 'numPrefactura',
					flex: 1,
					text: HreRem.i18n('fieldlabel.albaran.numPrefactura')
				},
				{
					dataIndex: 'proveedor',
					reference: 'proveedor',
					flex: 1,
					text: HreRem.i18n('fieldlabel.proveedor.trabajo')
				},
				{ 
		    		dataIndex: 'propietario',
		    		reference: 'propietario',
		    		flex: 1,
		    		text: HreRem.i18n('fieldlabel.albaran.propietario')
	    		},
		        {
		            dataIndex: 'anyo',
		            reference: 'anyo',
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.anyo')
		        },
		        {
		            dataIndex: 'estadoAlbaran',
		            reference: 'estadoAlbaran',
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.estadoAlbaran')
		        },
		        {
		            dataIndex: 'numGasto',
		            reference: 'numGasto',
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.numGasto')
		        },
		        {
		            dataIndex: 'estadoGasto',
		            reference: 'estadoGasto',
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.estadoGasto')
		        },
		        {
		            dataIndex: 'numeroTrabajos',
		            reference: 'numeroTrabajos',
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.numTrabajos')
		        },
		        {
		            dataIndex: 'importeTotalDetalle',
		            reference: 'importeTotalDetalle',
		            renderer: Utils.rendererCurrency,
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.importeTotalDetalle'),
		            hidden: mostrarTotalProveedor
		        },
		        {
		            dataIndex: 'importeTotalClienteDetalle',
		            reference: 'importeTotalClienteDetalle',
		            renderer: Utils.rendererCurrency,
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.importeTotalClienteDetalle')
		        },
		        {
		            dataIndex: 'areaPeticionaria',
		            reference: 'areaPeticionaria',
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.trabajo.area.peticionaria')
		        },
		        {
		            dataIndex: 'importaTotalPrefacturas',
		            reference: 'importaTotalPrefacturas',
		            renderer: Utils.rendererCurrency,
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.importe.total.trabajos.prefactura'),
		            hidden: true
		        },
		        {
		            dataIndex: 'cantidadPropietarios',
		            reference: 'cantidadPropietarios',
		            renderer: Utils.rendererCurrency,
		            flex: 1,
		            text: HreRem.i18n('fieldlabel.albaran.cantidad.propietarios.prefactura'),
		            hidden: true
		        }
		    ];
		me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'detalleAlbaranesPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true,
	            listeners: {
	            	beforechange: 'paginacionPrefactura'
	            },
	            bind: {
	            	store: '{detalleAlbaranes}'
	            }
	        }
	    ];
		    me.callParent();
    }
});

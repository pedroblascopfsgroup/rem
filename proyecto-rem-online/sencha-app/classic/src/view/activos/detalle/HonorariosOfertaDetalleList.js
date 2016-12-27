Ext.define('HreRem.view.activos.detalle.HonorariosOfertaDetalleList', {
    extend		: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype		: 'honorariosofertadetallelist',
    reference	: 'honorarioslistdetalleofertaref',
	topBar		: false,
	idPrincipal : 'oferta.id',
    bind		: {
        store: '{storeHonorariosOfertaDetalle}'
    },

    initComponent: function () {

     	var me = this;

		me.columns = [
		        {
		        	dataIndex: 'id',
		        	text: HreRem.i18n('fieldlabel.proveedores.id'),
		        	flex:0.4,
		        	hidden:true
		        },
		        {
		        	dataIndex: 'tipoComision',
		        	text: HreRem.i18n('fieldlabel.tipoComision'),
		        	flex:1
		        },
		        {
		        	dataIndex: 'tipoProveedor',
		        	text: HreRem.i18n('fieldlabel.tipo.proveedor'),
		        	flex:1
		        },
		        {
		        	dataIndex: 'nombre',
		        	text: HreRem.i18n('header.personas.contacto.nombre'),
		        	flex:2
		        },
		        {
		        	dataIndex: 'idProveedor',
		        	text: HreRem.i18n('fieldlabel.proveedores.id'),
		        	flex:0.5
		        },
		        {
		        	dataIndex: 'tipoCalculo',
		        	text: HreRem.i18n('header.oferta.detalle.tipo.calculo'),
		        	flex:1
		        },
		        {
		        	dataIndex: 'importeCalculo',
		        	text: HreRem.i18n('header.oferta.detalle.importe.calculo'),
		        	flex:1
		        },
		        {
		        	dataIndex: 'honorarios',
		        	text: HreRem.i18n('title.horonarios'),
		        	flex:1
		        }
	    ];

	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'activosPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true,
	            bind: {
	                store: '{storeHonorariosOfertaDetalle}'
	            }
	        }
	    ];

	    me.callParent();
   }
});
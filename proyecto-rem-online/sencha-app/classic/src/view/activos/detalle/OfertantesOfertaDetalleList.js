Ext.define('HreRem.view.activos.detalle.OfertantesOfertaDetalleList', {
    extend		: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype		: 'ofertantesofertadetallelist',
    reference	: 'ofertanteslistdetalleofertaref',
	topBar		: false,
	idPrincipal : 'oferta.id',
    bind		: {
        store: '{storeOfertantesOfertaDetalle}'
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
		        	dataIndex: 'tipoDocumento',
		        	text: HreRem.i18n('fieldlabel.tipoDocumento'),
		        	flex:0.5
		        },
		        {
		        	dataIndex: 'numDocumento',
		        	text: HreRem.i18n('header.numero.documento'),
		        	flex:1
		        },
		        {
		        	dataIndex: 'nombre',
		        	text: HreRem.i18n('header.nombre.razon.social'),
		        	flex:2
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
	                store: '{storeOfertantesOfertaDetalle}'
	            }
	        }
	    ];

	    me.callParent();
   }
});
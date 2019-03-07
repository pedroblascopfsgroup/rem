Ext.define('HreRem.view.activos.detalle.CalificacionNegativaGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'calificacionnegativagrid',
	topBar		: true,
	propagationButton: true,
	targetGrid	: 'calificacionNegativa',
	idPrincipal : 'activo.id',
	editOnSelect: false,
	disabledDeleteBtn: true,
    bind: {
        store: '{storeHistoricoMediador}' // TODO hay que hacerse un store y en ese store apuntar a los model
    },

    initComponent: function () {

     	var me = this;

		me.columns = [
		        {
		            dataIndex: 'fechaDesde',
		            text: HreRem.i18n('title.publicaciones.mediador.fechaDesde'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaHasta',
		            text: HreRem.i18n('title.publicaciones.mediador.fechaHasta'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'codigo',
		            text: HreRem.i18n('title.publicaciones.mediador.codigo'),
		            editor: {
		            	xtype: 'numberfield',
		            	allowBlank: false
		            },
		            flex: 0.5
		        },
		        {
		            dataIndex: 'mediador',
		            text: HreRem.i18n('title.publicaciones.mediador.mediador'),
		            flex: 1
		        },
		        {
		            dataIndex: 'telefono',
		            text: HreRem.i18n('title.publicaciones.mediador.telefono'),
		            flex: 1
		        },
		        {
		        	dataIndex: 'email',
		            text: HreRem.i18n('title.publicaciones.mediador.email'),
		            flex: 1
		        },
		        {
		        	dataIndex: 'responsableCambio',
		            text: HreRem.i18n('header.responsable.cambio'),
		            flex: 1
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
		                store: '{storeHistoricoMediador}'
		            }
		        }
		    ];

		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('informecomercialactivo').funcionRecargar();
		    	return true;
		    },

		    me.callParent();
   }
});

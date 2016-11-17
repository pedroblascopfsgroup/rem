Ext.define('HreRem.view.configuracion.mediadores.detalle.OfertasVivasList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertasvivaslist',
    reference: 'ofertasVivasList',
	topBar: false,
	idPrincipal : 'id',
	editOnSelect: false,
	disabledDeleteBtn: true,
	
    bind: {
        store: '{listaOfertasMediadores}'
    },
    
    
    initComponent: function () {
     	var me = this;

		me.setTitle(HreRem.i18n("title.evaluacion.mediadores.detail.ofertasvivas"));
		me.columns = [
			{
				dataIndex: 'id',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.id'),
				flex: 1
			},
			{
				dataIndex: 'idOferta',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.idOferta'),
				flex: 1
			},
			{
				dataIndex: 'numOferta',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.numOferta'),
				flex: 1
			},
			{
				dataIndex: 'idAgrupacion',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.idAgrupacion'),
				flex: 1
			},
			{
				dataIndex: 'idActivo',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.idActivo'),
				flex: 1
			},
			{
				dataIndex: 'desEstadoOferta',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.estadoOferta'),
				flex: 1
			},
			{
				dataIndex: 'desTipoOferta',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.tipoOferta'),
				flex: 1
			},
			{
				dataIndex: 'idExpediente',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.idExpediente'),
				flex: 1
			},
			{
				dataIndex: 'numExpediente',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.numExpediente'),
				flex: 1
			},
			{
				dataIndex: 'desEstadoExpediente',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.estadoExpediente'),
				flex: 1
			},
			{
				dataIndex: 'desSubtipoActivo',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.subtipoActivo'),
				flex: 1
			},
			{
				dataIndex: 'importeAprobadoOferta',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.importeAprobadoOferta'),
	            renderer: function(value) {
		            return Ext.util.Format.currency(value);
		        },
				flex: 1
			},
			{
				dataIndex: 'idOfertante',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.idOfertante'),
				flex: 1
			},
			{
				dataIndex: 'nombreOfertante',
				text: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.nombreOfertante'),
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
	                store: '{listaOfertasMediadores}'
	            }
	        }
	    ];

	    me.callParent();
   }

});
Ext.define('HreRem.view.configuracion.administracion.mediadores.detalle.OfertasVivasList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertasvivaslist',
	topBar: true,
	idPrincipal : 'proveedor.id',
	editOnSelect: false,
	disabledDeleteBtn: true,

// TODO: Create store on ConfigurationModel	
//    bind: {
//        store: '{ofertasvivas}'
//    },
    
    
    initComponent: function () {
     	var me = this;
	
// TODO: Event on click Oferta	
//     	me.listeners = {
//    			rowdblclick: 'abrirOfertaExpediente'
//    	    };
	
//TODO: Grid columns ofertas vivas
		me.setTitle(HreRem.i18n("title.configuracion.mediadores.detail.ofertasvivas"));
		me.columns = [
		
		    ];
		    
//TODO: Grid pagination
//		    me.dockedItems = [
//		        {
//		            xtype: 'pagingtoolbar',
//		            dock: 'bottom',
//		            itemId: 'activosPaginationToolbar',
//		            inputItemWidth: 60,
//		            displayInfo: true,
//		            bind: {
//		                store: '{ofertasvivas}'
//		            }
//		        }
//		    ];

		    me.callParent();
   }

});
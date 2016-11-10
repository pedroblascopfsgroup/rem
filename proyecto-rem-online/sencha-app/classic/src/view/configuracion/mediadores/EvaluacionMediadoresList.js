Ext.define('HreRem.view.configuracion.administracion.mediadores.ConfiguracionMediadoresList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'configuracionmediadoreslist',
	topBar: true,
	idPrincipal : 'proveedor.id',
	editOnSelect: false,
	disabledDeleteBtn: true,
	
// TODO: Bind lista mediadores
//    bind: {
//        store: '{configuracionmediadores}'
//    },
    
    
    initComponent: function () {
     	var me = this;

// TODO: Evento click en fila del grid		
//     	me.listeners = {
//    			rowdblclick: 'cargaDetalleMediador'
//    	    };
	    
// TODO: Grid columns
		me.setTitle(HreRem.i18n("title.configuracion.mediadores.list"));
		me.columns = [
		
		    ];

// TODO: Grid pagination
//		    me.dockedItems = [
//		        {
//		            xtype: 'pagingtoolbar',
//		            dock: 'bottom',
//		            itemId: 'activosPaginationToolbar',
//		            inputItemWidth: 60,
//		            displayInfo: true,
//		            bind: {
//		                store: '{configuracionmediadores}'
//		            }
//		        }
//		    ];
		    
		    
		    me.callParent();
   }

});
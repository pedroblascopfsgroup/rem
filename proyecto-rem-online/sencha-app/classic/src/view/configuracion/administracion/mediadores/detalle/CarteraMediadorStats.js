Ext.define('HreRem.view.configuracion.administracion.mediadores.detalle.CarteraMediadorStats', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'carteramediadorstats',
	topBar: true,
	idPrincipal : 'proveedor.id',
	editOnSelect: false,
	disabledDeleteBtn: true,
	
//TODO: Build stats data store on ConfiguracionModel
//    bind: {
//        store: '{evaluacionesmediador}'
//    },
    
    
    initComponent: function () {
     	var me = this;
		
// TODO: Event on click data stats
//     	me.listeners = {
//    			rowdblclick: 'abrirPestañaProveedor'
//    	    };
	    

//TODO: Data stats grid columns
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
//		                store: '{evaluacionesmediador}'
//		            }
//		        }
//		    ];
		    
		    me.callParent();
   }

});
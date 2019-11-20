Ext.define('HreRem.view.configuracion.administracion.perfiles.detalle.FuncionesPerfil', {
    extend: 'HreRem.view.common.GridBaseEditableRow',
    xtype: 'funcionesperfil',
    cls	: 'panel-base shadow-panel',  
    bind: {
        store: '{getFunciones}'
    }, 

	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('fieldlabel.configuracion.perfiles.funciones'));
    	me.columns = [
	        {
	        	dataIndex: 'funcionDescripcion',
	            text: HreRem.i18n('header.configuracion.perfiles.descripcion'),
	            flex: 1
	        },
	        {
	        	dataIndex: 'funcionDescripcionLarga',
	            text: HreRem.i18n('header.configuracion.perfiles.descripcionLarga'),
	            flex: 1
	        }
	    ];

    	me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'funcionesPaginationToolbar',
	            displayInfo: true,
	            bind: {
	                store: '{getFunciones}' 
	            }
	        }
	    ];

	    me.callParent();
	}
});
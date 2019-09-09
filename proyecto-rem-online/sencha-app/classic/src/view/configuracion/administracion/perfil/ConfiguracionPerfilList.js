Ext.define('HreRem.view.configuracion.administracion.perfiles.ConfiguracionPerfilesList', {
    extend			: 'HreRem.view.common.GridBaseEditableRow',
    xtype			: 'configuracionperfileslist',
	editOnSelect	: false,
	disabledDeleteBtn: true,
	
    bind : {
        store: '{configuracionperfiles}'
    },

    initComponent: function () {
     	var me = this;
     	me.listeners = {
    			rowdblclick: 'abrirPestanyaPerfil'
    	    };
     	//me.topBar = $AU.userHasFunction(['ADD_QUITAR_PERFIL']);

		me.columns = [
		        {
		            dataIndex: 'perfilCodigo',
		            text: HreRem.i18n('header.configuracion.perfiles.codigo'),
		            flex: 1
		        },
		        {
		        	dataIndex: 'perfilDescripcion',
		            text: HreRem.i18n('header.configuracion.perfiles.descripcion'),
		            flex: 1
		        },
		        {
		            dataIndex: 'perfilDescripcionLarga',
		            text: HreRem.i18n('header.configuracion.perfiles.descripcionLarga'),
		            flex: 1
		        }
		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'perfilesPaginationToolbar',
		            displayInfo: true,
		            bind: {
		                store: '{configuracionperfiles}'
		            }
		        }
		    ];

		    me.callParent();
   }
});
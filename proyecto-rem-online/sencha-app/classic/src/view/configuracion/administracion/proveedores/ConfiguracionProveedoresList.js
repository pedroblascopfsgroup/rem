Ext.define('HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedoresList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'configuracionproveedoreslist',
	topBar: true,
	idPrincipal : 'proveedor.id',
	editOnSelect: false,
	
    bind: {
        store: '{configuracionproveedores}'
    },
    
    
    initComponent: function () {
     	var me = this;
		
     	me.listeners = {
    			rowdblclick: 'abrirPestañaProveedor'
    	    };
	    
		me.columns = [
		        {
		            dataIndex: 'id',
		            text: HreRem.i18n('header.proveedorer.id'),
		            flex: 0.5,
		            hidden: true
		        },
		        {
		            dataIndex: 'tipoProveedorDescripcion',
		            text: HreRem.i18n('header.proveedorer.tipo'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'subtipoProveedorDescripcion',
		            text: HreRem.i18n('header.proveedorer.subtipo'),
		            flex: 1
		        },
		        {
		            dataIndex: 'nifProveedor',
		            text: HreRem.i18n('header.proveedorer.NIF'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'nombreProveedor',
		            text: HreRem.i18n('header.proveedorer.nombre'),
		            flex: 1
		        },
		        {
		            dataIndex: 'nombreComercialProveedor',
		            text: HreRem.i18n('header.proveedorer.nomcomercial'),
		            flex: 1
		        },
		        {
		            dataIndex: 'estadoProveedorDescripcion',
		            text: HreRem.i18n('header.proveedorer.estado'),
		            flex: 1
		        },
		        {
		            dataIndex: 'observaciones',
		            text: HreRem.i18n('header.proveedorer.observaciones'),
		            flex: 1,
		            hidden: true
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
		                store: '{configuracionproveedores}'
		            }
		        }
		    ];
		    
		    
		    me.callParent();
   }

});
Ext.define('HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedoresList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'configuracionproveedoreslist',
	topBar: true,
	idPrincipal : 'proveedor.id',
	
    bind: {
        store: '{configuracionproveedores}'
    },
    
    initComponent: function () {
     	
     	var me = this;
		
	    
		me.columns = [
		        {
		            dataIndex: 'id',
		            text: HreRem.i18n('header.proveedorer.id'),
		            flex: 0.5,
		            hidden: true
		        },
		        {
		            dataIndex: 'tipo',
		            text: HreRem.i18n('header.proveedorer.tipo'),
		            flex: 1
		        },
		        {
		            dataIndex: 'subtipo',
		            text: HreRem.i18n('header.proveedorer.subtipo'),
		            flex: 1
		        },
		        {
		            dataIndex: 'nif',
		            text: HreRem.i18n('header.proveedorer.NIF'),
		            flex: 1
		        },
		        {
		            dataIndex: 'nombre',
		            text: HreRem.i18n('header.proveedorer.nombre'),
		            flex: 1
		        },
		        {
		            dataIndex: 'nomcomercial',
		            text: HreRem.i18n('header.proveedorer.nomcomercial'),
		            flex: 1
		        },
		        {
		            dataIndex: 'estado',
		            text: HreRem.i18n('header.proveedorer.estado'),
		            flex: 1
		        },
		        {
		            dataIndex: 'observaciones',
		            text: HreRem.i18n('header.proveedorer.observaciones'),
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
		                store: '{configuracionproveedores}'
		            }
		        }
		    ];
		    
		    
		    me.callParent();
   }

});
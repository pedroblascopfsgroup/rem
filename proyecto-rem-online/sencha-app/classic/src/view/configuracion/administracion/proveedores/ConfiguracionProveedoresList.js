Ext.define('HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedoresList', {
    extend			: 'HreRem.view.common.GridBaseEditableRow',
    xtype			: 'configuracionproveedoreslist',
	
	idPrincipal 	: 'proveedor.id',
	editOnSelect	: false,
	disabledDeleteBtn: true,
    bind			: {
        store: '{configuracionproveedores}'
    },
	loadAfterBind: false,
    initComponent: function () {
     	var me = this;
     	me.listeners = {
    			rowdblclick: 'abrirPestanyaProveedor'
    	    };
    
     	me.topBar = ($AU.userHasFunction(['ADD_QUITAR_PROVEEDORES']) || $AU.userHasFunction(['ADD_PROVEEDORES_HOMOLOGABLES']));
		me.columns = [
		        {
		            dataIndex: 'id',
		            text: HreRem.i18n('header.proveedorer.id'),
		            flex: 0.3,
		            hidden: true
		        },
		        {
		            dataIndex: 'codigo',
		            text: HreRem.i18n('fieldlabel.codigo'),
		            flex: 0.3
		        },
		        {
		        	dataIndex: 'tipoProveedorDescripcion',
		            text: HreRem.i18n('header.proveedorer.tipo'),
		            flex: 0.5,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboTipoProveedor}'
			            },
			            reference: 'cbColTipoProveedor',
			            chainedStore: '{comboNewSubtipoProveedor}',
						chainedReference: 'cbColSubtipoProveedor',
			            listeners: {
			            	select: 'onChangeTipoProveedorChainedCombo'
			            }
			        }
		        },
		        {
		            dataIndex: 'subtipoProveedorDescripcion',
		            text: HreRem.i18n('header.proveedorer.subtipo'),
		            flex: 1,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboNewSubtipoProveedor}'
			            },
			            reference: 'cbColSubtipoProveedor'
			        }
		        },
		        {
		            dataIndex: 'nifProveedor',
		            text: HreRem.i18n('header.proveedorer.NIF'),
		            flex: 0.6,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 20
		            }
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

		    // Abrira la ficha del proveedor al crear uno nuevo desde el listado
		    me.saveSuccessFn = function() {
		    	var nifProveedor = me.getStore().getAt(0).get('nifProveedor');

		    	me.lookupController().openProveedorByNif(nifProveedor);
		    },

		    me.callParent();
   }
});
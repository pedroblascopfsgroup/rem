Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.economicas.ComisionesList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'comisioneslist',
    //minHeight 	: 250,   
	cls	: 'panel-base shadow-panel',
	title: 'Comisiones',
	padding: '0 0 150 0',
    
    bind: {
        store: '{comisiones}'
    },
    
    listeners: {
    	itemdblclick: 'onEditDblClick'
    },

    columns: [
        {
            dataIndex: 'idComision',
            text: 'Id Comisión',
            hidden: true,
            flex: 1
        },
        {
            dataIndex: 'idActivo',
            text: 'Id Activo',
            hidden: true,
            flex: 1
        },
        {
            dataIndex: 'idOferta',
            text: 'Id Oferta',
            hidden: true,
            flex: 1
        },
        {
            dataIndex: 'tipoPersona',
            text: 'Tipo',
            flex: 1
        },
        {
            dataIndex: 'fullName',
            text: 'Nombre',
            flex: 2
        },
        {
            dataIndex: 'porcentajedefecto',
            text: '% Defecto',
            align: 'center',
            flex: 1
        },
        {
        	 dataIndex: 'porcentajenuevo',
             text: '% Nuevo',
             align: 'center',
             flex: 1
        },        
        {
            dataIndex: 'importe',
            text: 'Importe (€)',
            flex: 2
        }
    ],
    dockedItems: [
        {
            xtype: 'pagingtoolbar',
            dock: 'bottom',
            itemId: 'comisionesPaginationToolbar',
            displayInfo: true,
            bind: {
                store: '{comisiones}'
            }
        }
    ],
    
initComponent: function() {
		
		var me = this;
		
		
		
		
			me.tbar = {
    		xtype: 'toolbar',
    		dock: 'top',
    		items: [
    				{iconCls:'x-fa fa-plus', handler: 'onFuncionalidadNoDesarrolladaClick'},//text: 'Nueva'},
    				{iconCls:'x-fa fa-edit', handler: 'onFuncionalidadNoDesarrolladaClick'},//text: 'Editar'},
    				{iconCls:'x-fa fa-minus', handler: 'onFuncionalidadNoDesarrolladaClick'}//text: 'Eliminar'}
    				]
    		}

		
		me.callParent();
		
	}
});
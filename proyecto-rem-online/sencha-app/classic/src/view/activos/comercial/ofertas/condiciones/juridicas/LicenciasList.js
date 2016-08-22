Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.economicas.juridicas.LicenciasList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'licenciaslist',
    //minHeight 	: 250,   
	cls	: 'panel-base shadow-panel',
	title: '¿Es necesaria la obtención de alguna licencia?',
	//padding: '0 0 150 0',
    
    bind: {
        store: '{licencias}'
    },
    
    listeners: {
    	itemdblclick: 'onEditDblClick'
    },

    columns: [

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
        	 dataIndex: 'tipo',
             text: 'Tipo',
             align: 'center',
             flex: 1
        },        
        {
            dataIndex: 'cuenta',
            text: 'Por cuenta de',
            flex: 2
        }
    ],
   /* dockedItems: [
        {
            xtype: 'pagingtoolbar',
            dock: 'bottom',
            itemId: 'comisionesPaginationToolbar',
            displayInfo: true,
            bind: {
                store: '{licencias}'
            }
        }
    ],*/
    
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
Ext.define('HreRem.view.activos.comercial.ofertas.OfertasList', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'ofertaslist',
    reference	: 'ofertaslistref',
	title: 'Ofertas',
	minHeight: 200,   
	topBar: false,
	
	selModel: {
	    selType: 'rowmodel',
	    mode   : 'MULTI'
	}, 
	
    bind: {
        store: '{ofertas}'
    },
    
    listeners : {
		rowdblclick: 'onOfertaDblClick'
     },

    columns: [
		{
			dataIndex: 'idOferta',
			text: 'Id Oferta',
			flex: 1
		},     
        {
            dataIndex: 'idLote',
            text: 'Lote',
            flex: 1
        },
        {
            dataIndex: 'tipoOferta',
            text: 'Tipo',
            flex: 1
        },
        {
            dataIndex: 'fullName',
            text: 'Nombre',
            flex: 3
        },
        {
            dataIndex: 'numDocumento',
            text: 'Nº Documento',
            flex: 1
        },
        {
            dataIndex: 'importe',
            text: 'Importe',
            align: 'center',
            flex: 1
        },
        {
            dataIndex: 'estado',
            text: 'Estado',
            flex: 2
        }
        
    ],
    dockedItems: [
        {
            xtype: 'pagingtoolbar',
            dock: 'bottom',
            reference: 'ofertasPaginationToolbar',
            displayInfo: true,
            bind: {
                store: '{ofertas}'
            }
        }
    ],
    
    initComponent: function() {
	  		
  		var me = this;
  		
  		
  		
  		
  			me.tbar = {
      		xtype: 'toolbar',
      		dock: 'top',
      		items: [
      				{iconCls:'x-fa fa-plus', handler: 'onAddClick'},//text: 'Nueva'},
      				{iconCls:'x-fa fa-edit', handler: 'onFuncionalidadNoDesarrolladaClick'},//text: 'Editar'},
      				{iconCls:'x-fa fa-minus', handler: 'onFuncionalidadNoDesarrolladaClick'}//text: 'Eliminar'}
      				]
      	},

	  		
  		me.callParent();
  		
  	}

    
});
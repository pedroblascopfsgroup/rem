Ext.define('HreRem.view.activos.comercial.ofertas.ofertantes.OfertantesList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'ofertanteslist',
    reference	: 'ofertanteslist',
	title: 'Listado de ofertantes',
    pagBar: false,
    controller: 'ofertas',
	selModel: {
	    selType: 'rowmodel',
	    mode   : 'MULTI'
	},

	bind: {
        store: '{ofertantes}'
    },
    
    // Listener para el doble click en la lista de ofertantes
	/*listeners        : {
		rowdblclick: 'onEditClick'
     },*/

    columns: [
		{
		    dataIndex: 'ofertante',
		    text: 'Ofertante',
		    flex: 1
		},      
        {
            dataIndex: 'docIdentificativo',
            text: 'Doc. Identificativo',
            flex: 1
        },
        {
            dataIndex: 'telefono',
            text: 'Teléfono',
            flex: 1
        },
        {
            dataIndex: 'email',
            text: 'Email',
            flex: 1
        },
        {
            dataIndex: 'fechaVisita',
            text: 'Fecha Visita',
            flex: 1
        },
        {
            dataIndex: 'tipo',
            text: 'Tipo',
            flex: 1
        },
        {
            dataIndex: 'porcentajeCompra',
            text: '% Compra',
            flex: 1
        }
        
    ],
    dockedItems: [
                  {
                      xtype: 'pagingtoolbar',
                      dock: 'bottom',
                      itemId: 'visitasPaginationToolbar',
                      displayInfo: true,
                      bind: {
                          store: '{ofertantes}'
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
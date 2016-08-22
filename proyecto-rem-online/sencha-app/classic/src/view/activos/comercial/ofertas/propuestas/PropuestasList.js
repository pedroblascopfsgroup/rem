Ext.define('HreRem.view.activos.comercial.ofertas.propuestas.PropuestasList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'propuestaslist',
    reference	: 'propuestaslist',
	title: 'Listado de propuestas',
	selModel: {
	    selType: 'rowmodel',
	    mode   : 'MULTI'
	},
	
	viewModel: {
        type: 'propuestas'
    },

	bind: {
        store: '{propuestas}'
    },
    
    // Listener para el doble click en la lista de activos
	listeners        : {
		rowdblclick: 'onEditClick'
     },

    columns: [
		{
		    dataIndex: 'importe',
		    text: 'Importe (€)',
		    flex: 1
		},      
        {
            dataIndex: 'fechaPropuesta',
            text: 'Fecha propuesta',
            flex: 1
        },
        {
            dataIndex: 'fechaResolucion',
            text: 'fechaResolucion',
            flex: 1
        },
        {
            dataIndex: 'estado',
            text: 'Estado',
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
                          store: '{propuestas}'
                      }
                  }
              ],
              
      initComponent: function() {
  		
  		var me = this;

  			me.tbar = {
      		xtype: 'toolbar',
      		dock: 'top',
      		items: [
      				{iconCls:'x-fa fa-plus', handler: 'onFuncionalidadNoDesarrolladaClick'},
      				{iconCls:'x-fa fa-edit', handler: 'onFuncionalidadNoDesarrolladaClick'},
      				{iconCls:'x-fa fa-minus', handler: 'onFuncionalidadNoDesarrolladaClick'},
      				{iconCls:'x-fa fa-file-pdf-o', handler: 'onGeneratePdf'}
      				]
      		}

  		
  		me.callParent();
  		
  	}    
});
Ext.define('HreRem.view.activos.comercial.visitas.VisitasList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'visitaslist',
    reference	: 'visitaslist',
	title: 'Listado de visitas',
	topBar: true,
    pagBar: false,
	selModel: {
	    selType: 'rowmodel',
	    mode   : 'MULTI'
	},

	bind: {
        store: '{visitas}'
    },
    
    // Listener para el doble click en la lista de activos
	listeners        : {
		rowdblclick: 'onEditClick'
     },

    columns: [
		{
		    dataIndex: 'fechaSolicitud',
		    text: 'Fecha Solicitud',
		    flex: 1
		},      
        {
            dataIndex: 'nombre',
            text: 'Nombre',
            flex: 1
        },
        {
            dataIndex: 'numDocumento',
            text: 'Nº Documento',
            flex: 1
        },
        {
            dataIndex: 'estadoSolicitud',
            text: 'Situación',
            flex: 1
        },
        {
            dataIndex: 'fechaVisita',
            text: 'Fecha Visita',
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
                          store: '{visitas}'
                      }
                  }
              ]
    
});
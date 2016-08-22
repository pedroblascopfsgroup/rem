Ext.define('HreRem.view.activos.comercial.solicitudes.SolicitudesList', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'solicitudeslist',
    reference	: 'solicitudesList',
	title: 'Solicitudes',
	topBar: true,
	selModel: {
	    selType: 'rowmodel',
	    mode   : 'MULTI'
	},
    bind: {
        store: '{solicitudes}'
    },
    columns: [
        {
            dataIndex: 'fullName',
            text: 'Nombre',
            flex: 1
        },
        {
            dataIndex: 'numDocumento',
            text: 'Nº Documento',
            flex: 1
        },
        {
            dataIndex: 'tel1',
            text: 'Teléfono 1',
            flex: 1
        },
        {
            dataIndex: 'tel2',
            text: 'Teléfono 2',
            flex: 1
        },
        {
            dataIndex: 'estadoSolicitud',
            text: 'Estado Solicitud',
            flex: 1
        },
        {
            dataIndex: 'fechaSolicitud',
            text: 'Fecha  Solicitud',
            flex: 1
        }
        
    ],
    dockedItems: [
        {
            xtype: 'pagingtoolbar',
            dock: 'bottom',
            reference: 'solicitudesPaginationToolbar',
            displayInfo: true,
            bind: {
                store: '{solicitudes}'
            }
        }
    ],
    
    listeners: {
    	
    	itemdblclick: 'onSolicitudesListDblClick'
    }
    
});
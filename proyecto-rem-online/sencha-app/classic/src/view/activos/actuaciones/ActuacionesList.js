Ext.define('HreRem.view.activos.actuaciones.ActuacionesList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'actuacioneslist',
    minHeight 	: 200,   
	cls	: 'panel-base shadow-panel',
	title: 'Listado de Actuaciones',
    
    bind: {
        store: '{actuaciones}'
    },
    
    listeners: {
    	itemdblclick: 'onActuacionDblClick'
    },

    columns: [
        {
            dataIndex: 'idActuacion',
            text: 'Código',
           // hidden: true,
            flex: 1
        },
        {
            dataIndex: 'idTipoActuacion',
            text: 'Id Tipo Actuación',
            hidden: true,
            flex: 1
        },
        {
            dataIndex: 'tipoActuacion',
            text: 'Tipo Actuación',
            flex: 3
        },
        {
            dataIndex: 'idTipoActuacionPadre',
            text: 'Id Actuación Origen',
            hidden: true,
            align: 'center',
            flex: 1
        },
        {
            dataIndex: 'tipoActuacionPadre',
            text: 'Tipo Actuación Origen',
            hidden: true,
            flex: 2
        },
        {
            dataIndex: 'idActivo',
            text: 'Id Activo',
            hidden: true,
            align: 'center',
            flex: 1
        },
        {
            dataIndex: 'fechaInicio',
            text: 'F. Inicio',
            align: 'center',
            flex: 1
        },
        {
            dataIndex: 'fechaFin',
            text: 'F. Fin',
            align: 'center',
            flex: 1
        },
        {
            dataIndex: 'cliente',
            text: 'Cliente',
            flex: 2
        },
        {
            dataIndex: 'gestor',
            text: 'Gestor',
            flex: 2
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
            itemId: 'actuacionesPaginationToolbar',
            displayInfo: true,
            bind: {
                store: '{actuaciones}'
            }
        }
    ]
});
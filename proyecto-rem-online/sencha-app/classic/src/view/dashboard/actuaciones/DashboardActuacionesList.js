Ext.define('HreRem.view.dashboard.actuaciones.DashboardActuacionesList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'dashboardactuacioneslist',
    minHeight : 240,
    maxHeight : 240,
    //autoScroll: true,
	//cls	: 'panel-base shadow-panel',
	title: 'Listado de Actuaciones',

    bind: {
        store: '{dashboardactuaciones}'
    },

    viewModel: {
    	 type: 'dashboardactuacionesmodel'
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
        /*{
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
        },*/        
        {
            dataIndex: 'estado',
            text: 'Estado',
            flex: 2
        }
    ]
});
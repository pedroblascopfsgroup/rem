Ext.define('HreRem.view.dashboard.visitas.DashboardVisitasList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'dashboardvisitaslist',
    reference	: 'dashboardvisitaslist',
	title: 'Listado de visitas',

	viewModel: {
		type: 'dashboardvisitasmodel'
	},
	
	bind: {
        store: '{visitas}'
    },

    columns: [
		/*{
		    dataIndex: 'fechaSolicitud',
		    text: 'Fecha Solicitud',
		    flex: 1
		},*/      
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
        
    ]
    
});
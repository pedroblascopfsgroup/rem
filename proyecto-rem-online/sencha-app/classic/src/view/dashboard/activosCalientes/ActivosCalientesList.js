Ext.define('HreRem.view.dashboard.activosCalientes.ActivosCalientesList', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'activoscalienteslist',
	title: 'Activos en Curso',
	minHeight: 200,   
	scrollable: 'y',
	
	selModel: {
	    selType: 'rowmodel',
	    mode   : 'MULTI'
	}, 
	
	viewModel: {
        type: 'activoscalientesmodel'
    },
    controller: {
        type: 'activoscalientescontroller'
    },
	
    bind: {
        store: '{activoscalientes}'
    },
    
    /*listeners : {
		rowdblclick: 'onOfertaDblClick'
     },*/

    columns: [
		{
		    xtype: 'actioncolumn',
		    width: 30,
		    handler: 'onEnlaceActivosClick',
		    items: [{
		        tooltip: 'Ver Activo',
		        iconCls: 'x-fa fa-home'
		    }]
		},
		{
			dataIndex: 'idActivo',
			text: 'Activo',
			flex: 1
		},     
        {
            dataIndex: 'tarea',
            text: 'Tarea',
            flex: 1
        },
        {
            dataIndex: 'perfilActual',
            text: 'Usuario Actual',
            flex: 1
        },
        {
            dataIndex: 'perfilFuturo',
            text: 'Próximo Usuario',
            flex: 3
        },
        {
            dataIndex: 'fechaVencimiento',
            text: 'Fecha Vencimiento',
            flex: 1
        }
        
    ]/*,
    dockedItems: [
        {
            xtype: 'pagingtoolbar',
            dock: 'bottom',
            reference: 'activosCalientesPaginationToolbar',
            displayInfo: true,
            bind: {
                store: '{activoscalientes}'
            }
        }
    ]*/
    
});
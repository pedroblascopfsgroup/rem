Ext.define('HreRem.view.dashboard.DashBoardMain', {
	extend		: 'Ext.panel.Panel',
	xtype		: 'dashboardmain',	
	cls			: 'dashboard-main',
	scrollable  : 'y',
	layout: 'column', 
	currentUser:null,
	/*requires: [
	           'HreRem.view.dashboard.buscador.BuscadorGlobalWidget'
	],*/
	       
	initComponent: function() {
		
		
		var me = this;
		
		Ext.create('Ext.data.Store', {
		    storeId: 'vencidas',
		    fields:[ 'tarea', 'fecha', 'dias'],
		    data: [
		        { tarea: 'Verificar Oferta', fecha: '19/08/2015', dias: '-6' },
		        { tarea: 'Verificar Datos Cliente', fecha: '24/08/2015', dias: '-1' }
		    ]
		});
		
		Ext.create('Ext.data.Store', {
		    storeId: 'activas',
		    fields:[ 'tarea', 'fecha', 'dias'],
		    data: [
		        { tarea: 'Verificar resultado visita', fecha: '25/08/2015', dias: '1' },
		        { tarea: 'Verificar oferta', fecha: '26/08/2015', dias: '2' }
		    ]
		});
		
		me.items= [
		
		/*{
			xtype: 'buscadorglobalwidget',
			columnWidth: 1			
		},
		
		{		
			xtype: 'graficasmainwidget',			
			columnWidth: 1
		},
		
		{
			xtype: 'container',
			columnWidth: 0.5,			
			items: [
					{
						xtype: 'taskmeterwidget',
						height: 255
					}
			]
		},

		{		
			xtype: 'calendariomainwidget',
			columnWidth: 0.5,
			height: 255
		},
		
		{
			xtype: 'container',
			columnWidth: 0.50,			
			items: [
					{
						xtype: 'taskmeterwidget'
					}
			]
		},
		
		{
			xtype: 'container',			
			columnWidth: 0.33,
			items: [
					{
						xtype: 'agendalistdash',
						title: 'Tareas en curso',
						
						height: 188 
					}
			]
		},
		
		{
			xtype: 'container',
			
			columnWidth:0.5,
			items: [
					{
						xtype: 'activoscalientespanel',
						height: 236
					}
			]
		},
		
		{		
			xtype: 'graficasmainwidgetgestor',
			
			columnWidth: 0.33
		},

		{
			xtype: 'dashboardvisitaspanel',
			columnWidth: 0.34
		}		
		*/
		
		];
		
		me.callParent();		

	}

});
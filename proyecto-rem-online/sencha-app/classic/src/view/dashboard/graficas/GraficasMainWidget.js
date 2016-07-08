Ext.define('HreRem.view.dashboard.graficas.GraficasMainWidget', {
    extend		: 'HreRem.view.common.PanelBase',
    xtype		: 'graficasmainwidget',
    title		: 'Estadísticas',
	cls			: 'panel-base shadow-panel graficas-widget',
	layout		: 'card', 
	activeItem	: 0,
	
	controller 	: 'graficasmaincontroller',
	
	requires: ['HreRem.view.dashboard.graficas.pieTareasSupervisor.PieTareasSupervisorWidget'

	],
	
	tools: [
        {
	    	xtype: 'combobox',
	    	width: 260,
        	labelWidth : 50,
    		store : new Ext.data.SimpleStore({
				data : [[0, 'Tareas / Gestores'], 
						[1, 'KPIs'],
						[2, 'Tareas abiertas/cerradas']/*, 
				        [3, 'Activos vendidos']*/],
				id : 0,
				fields : ['id', 'descripcion']
			}),
			value: 0,
    		valueField : 'id',
    		displayField : 'descripcion',
    		editable : false,
    		handler: 'onClickButton'
	    }
	],
		
	items: [

	{
	    //id: 'card-0',
	    xtype: 'histogramtareassupervisorwidget'
	},
	{
	    //id: 'card-0',
	    xtype: 'pietareassupervisorwidget'
	},
	{
	    //id: 'card-0',
	    xtype: 'histogramtareaswidget'
	}/*,{
	    //id: 'card-1',
	    xtype: 'histogramactivoswidget'
	}*/]
});
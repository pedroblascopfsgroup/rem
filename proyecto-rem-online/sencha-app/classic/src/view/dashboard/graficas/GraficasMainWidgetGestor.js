Ext.define('HreRem.view.dashboard.graficas.GraficasMainWidgetGestor', {
    extend		: 'HreRem.view.common.PanelBase',
    xtype		: 'graficasmainwidgetgestor',
    title		: 'Estadísticas',
	cls			: 'panel-base shadow-panel graficas-widget',
	layout		: 'card', 
	activeItem	: 0,
	
	controller 	: 'graficasmaincontroller',
	
	tools: [
        {
	    	xtype: 'combobox',
	    	width: 260,
        	labelWidth : 50,
    		store : new Ext.data.SimpleStore({
				data : [
						[0, 'Tareas abiertas/cerradas'], 
				        [1, '% Tareas en plazo']],
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
	    xtype: 'histogramtareaswidget'
	},{
	    //id: 'card-1',
	    xtype: 'histogramactivoswidget'
	}]
});
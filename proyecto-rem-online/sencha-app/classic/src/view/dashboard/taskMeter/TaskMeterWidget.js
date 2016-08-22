Ext.define('HreRem.view.dashboard.taskMeter.TaskMeterWidget', {
    extend		: 'HreRem.view.common.PanelBase',
    xtype		: 'taskmeterwidget',
	title		: 'Seguimientos por Actividad',
	cls			: 'panel-base shadow-panel taskmeter-main',
	
	
	controller 	: 'taskmetercontroller',
	viewModel: {
        type: 'taskmetermodel'
    },
    
    items: [

        {
			xtype: 'dataview',
			cls: 'taskmeter-body',
			itemSelector: 'button.taskmeter-button',
			bind: '{agrupacionTareas}',
		    tpl: new Ext.XTemplate(
		   		 '<tpl for=".">',
		   		 		'<div> <button type="button" name={categoria} id="{categoria}" class="taskmeter-button {categoria}">{estado}</button></div>',
		                '<div class="taskmeter-description">{cantidad} tareas de {total}</div>',
		                '<div class="taskmeter-line">',
		                   '<div class="sparkline-inner sparkline-inner-{categoria}" style="width: {[values.porcentaje * 100]}%;"></div>',
		                '</div>',
		           '</tpl>'
		   	),
			listeners: {
				itemclick: 'onButtonTareasClick'
		    }
		}
    ]
});
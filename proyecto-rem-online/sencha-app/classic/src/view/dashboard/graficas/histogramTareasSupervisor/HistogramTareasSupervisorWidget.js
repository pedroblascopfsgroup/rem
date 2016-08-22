Ext.define('HreRem.view.dashboard.graficas.histogramTareasSupervisor.HistogramTareasSupervisorWidget', {
    extend		: 'HreRem.view.common.PanelBase',
    xtype		: 'histogramtareassupervisorwidget',
    cls			: 'histograms-widget',
	
	requires: ['Ext.chart.CartesianChart',
	           'Ext.chart.axis.Numeric',
	           'Ext.chart.grid.HorizontalGrid',
	           'Ext.chart.axis.Category',
	           'Ext.chart.series.Bar',
	           'Ext.chart.interactions.ItemInfo'
	],
		   
		
	controller 	: 'histogramtareassupervisorcontroller',
	viewModel: {
        type: 'histogramtareassupervisormodel'
    },

    items: [

        {
			xtype: 'cartesian',
			flex: 1,
		    height: 150,
		    animate: true,
		    bind: '{tareasAbiertasCerradas}',
	        axes: [
		        {
		            type: 'numeric',
		            position: 'left',
		            fields: ['abiertas', 'cerradas'],
		            label: {
		                renderer: Ext.util.Format.numberRenderer('0,0')
		            },
		            title: 'Nº Tareas',
		            grid: true,
		            minimum: 0
		        },
		        {
		        	title: 'Gestor',
		            type: 'category',
		            position: 'bottom',
		            fields: ['dia']
		        }
		    ],
		    series: [{
	            type: 'bar',
	            axis: 'left',
	            colors: ['#0B6','#F44'],

	            xField: 'dia',
	            yField: ['abiertas', 'cerradas']
	        }]
       }
       
       
    ]
});
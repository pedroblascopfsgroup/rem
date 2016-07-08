Ext.define('HreRem.view.dashboard.graficas.histogramActivos.HistogramActivosWidget', {
    extend		: 'HreRem.view.common.PanelBase',
    xtype		: 'histogramactivoswidget',
    cls			: 'histograms-widget',
	
	requires: ['Ext.chart.CartesianChart',
	           'Ext.chart.axis.Numeric',
	           'Ext.chart.grid.HorizontalGrid',
	           'Ext.chart.axis.Category',
	           'Ext.chart.series.Bar',
	           'Ext.chart.interactions.ItemInfo'
	],
		   
		
	controller 	: 'histogramactivoscontroller',
	viewModel: {
        type: 'histogramactivosmodel'
    },
    

    items: [

        {
			xtype: 'cartesian',
			flex: 1,
		    height: 150,
		    animate: true,
		    bind: '{activosvendidos}',
	        axes: [
		        {
		            type: 'numeric',
		            position: 'left',
		            fields: 'ventas',
		            label: {
		                renderer: Ext.util.Format.numberRenderer('0,0')
		            },
		            title: '% Tareas',
		            grid: true,
		            minimum: 0
		        },
		        {
		            type: 'category',
		            position: 'bottom',
		            fields: ['dia']
		        }
		    ],
		    series: [{
	            type: 'bar',
	            axis: 'left',
	            colors: ['#0BC'],
	            label: {
		            display: 'insideEnd',
		            field: 'cantidad' * 10,
		            renderer: Ext.util.Format.numberRenderer('0'),
		            orientation: 'vertical',
		            color: '#000'
	            },
	           /* renderer: function (sprite, record, attr, index) {
	            	var color = this.getColors()[0]; 

	                return Ext.apply(attr, {
	                    fill: color
	                });
	            },*/
	            xField: 'dia',
	            yField: 'ventas'
	        }]
        }
    ]
});
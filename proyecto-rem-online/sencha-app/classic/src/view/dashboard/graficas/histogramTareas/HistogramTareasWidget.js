Ext.define('HreRem.view.dashboard.graficas.histogramTareas.HistogramTareasWidget', {
    extend		: 'HreRem.view.common.PanelBase',
    xtype		: 'histogramtareaswidget',
    cls			: 'histograms-widget',
	
	requires: ['Ext.chart.CartesianChart',
	           'Ext.chart.axis.Numeric',
	           'Ext.chart.grid.HorizontalGrid',
	           'Ext.chart.axis.Category',
	           'Ext.chart.series.Bar',
	           'Ext.chart.interactions.ItemInfo'
	],
		   
		
	controller 	: 'histogramtareascontroller',
	viewModel: {
        type: 'histogramtareasmodel'
    },
    
/*	config: {
        activeState: null,
        defaultActiveState: 'abiertas'
    },
    
	tools: [
	        {
		    	xtype: 'button',
		        text: 'Abiertas',
		        filter: 'abiertas',
		        reference: 'abiertas',
		        allowDepress: false,
		        handler: 'onClickButton'
		    },{
		    	xtype: 'button',
		        text: 'Cerradas',
		        filter: 'cerradas',
		        reference: 'cerradas',
		        allowDepress: false,
		        handler: 'onClickButton'
		    }
		],
		*/
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
		            type: 'category',
		            position: 'bottom',
		            fields: ['dia']
		        }
		    ],
		    series: [{
	            type: 'bar',
	            axis: 'left',
	            colors: ['#0B6','#F44'],
/*		            label: {
			            display: 'insideEnd',
			            field: 'cantidad',
			            renderer: Ext.util.Format.numberRenderer('0'),
			            orientation: 'vertical',
			            color: '#000'
		            },*/
	           /* renderer: function (sprite, record, attr, index) {
	            	var color = this.getColors()[0]; 

	                return Ext.apply(attr, {
	                    fill: color
	                });
	            },*/
	            xField: 'dia',
	            yField: ['abiertas', 'cerradas']
	        }]
        }
    ]
});
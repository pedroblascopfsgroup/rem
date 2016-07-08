Ext.define('HreRem.view.dashboard.graficas.pieTareasSupervisor.PieTareasSupervisorWidget', {
    extend		: 'HreRem.view.common.PanelBase',
    xtype		: 'pietareassupervisorwidget',
    cls			: 'histograms-widget',
	
	requires: ['Ext.chart.CartesianChart',
	           'Ext.chart.axis.Numeric',
	           'Ext.chart.grid.HorizontalGrid',
	           'Ext.chart.axis.Category',
	           'Ext.chart.series.Bar',
	           'Ext.chart.interactions.ItemInfo',
	           'Ext.chart.PolarChart',
		        'Ext.chart.series.Pie',
		        'Ext.chart.interactions.Rotate',
		        'Ext.chart.interactions.ItemHighlight'
	],
		   
		
	controller 	: 'pietareassupervisorcontroller',
	viewModel: {
        type: 'pietareassupervisormodel'
    },

	
    items: [

			{
				xtype:'container',
				defaultType: 'displayfield',
				defaults: {
					style: 'width: 100%;'
					},
				layout: 'column',

				items: [
       			
       			
       			{
       				//title: 'Gestiones en plazo',
			        xtype: 'polar',
			        width: 300,
			        bind: '{tareasAbiertasCerradas}',
			        interactions: ['rotate', 'itemhighlight'],
			        colors: ['green','yellow','red'],
				    height: 150,
				    minHeight: 150,
				    animate: true,
			        legend: {
			            position: 'left',
			            verticalWidth: 70,
			            title: 'Leyendaaa',
			            label: 'labelll'
			            
			            
			        },
			        //innerPadding: Ext.os.is.Desktop ? 40 : 10,
			        series: [{
			        	
			            type: 'pie',
			            title: 'Gestiones en plazo',
			            xField: 'abiertas',
			            label: {
			            	//display: 'none',
			                field: 'dia',
			                
			                // Estas líneas son por un bug que hace que el display: none no funcione!!!!
			                 calloutLine: {
						        color: 'rgba(0,0,0,0)' // Transparent to hide callout line
						    },
						    renderer: function(val) {
						        return ''; 
						    }
			            },
			            showMarkers: false,
			            showLegend: false,
			            height: 150,
			           // pie: 150,
			            minHeight: 150,
			            highlightCfg: {
			                margin: 20
			            },
			            style: {
			                stroke: 'white',
			                miterLimit: 10,
			                lineCap: 'miter',
			                lineWidth: 2
			            }
			        }],
			        axes: []
			    },
			    
				
				{
       				//title: 'Gestiones en plazo',
			        xtype: 'polar',
			        width: 300,
			        bind: '{tareasAbiertasCerradas}',
			        interactions: ['rotate', 'itemhighlight'],
			        colors: ['#16b603','#03b4d5','#e44959'],
				    height: 150,
				    minHeight: 150,
				    animate: true,
			        legend: {
			            position: 'left',
			            verticalWidth: 70,
			            title: 'Leyendaaa',
			            label: 'labelll'
			            
			            
			        },
			        //innerPadding: Ext.os.is.Desktop ? 40 : 10,
			        series: [{
			        	
			            type: 'pie',
			            title: 'Gestiones en plazo',
			            xField: 'datosGestor',
			            label: {
			            	//display: 'none',
			                field: 'usuario',
			                
			                // Estas líneas son por un bug que hace que el display: none no funcione!!!!
			                 calloutLine: {
						        color: 'rgba(0,0,0,0)' // Transparent to hide callout line
						    },
						    renderer: function(val) {
						        return ''; 
						    }
			            },
			            showMarkers: false,
			            showLegend: false,
			            height: 150,
			           // pie: 150,
			            minHeight: 150,
			            highlightCfg: {
			                margin: 20
			            },
			            style: {
			                stroke: 'white',
			                miterLimit: 10,
			                lineCap: 'miter',
			                lineWidth: 2
			            }
			        }],
			        axes: []
			    },
			    
			    {
       				//title: 'Gestiones en plazo',
			        xtype: 'polar',
			        width: 300,
			        bind: '{tareasAbiertasCerradas}',
			        interactions: ['rotate', 'itemhighlight'],
			        colors: ['#0a94d6','green','#949495'],
				    height: 150,
				    minHeight: 150,
				    animate: true,
			        legend: {
			            position: 'left',
			            verticalWidth: 70,
			            title: 'Leyendaaa',
			            label: 'labelll'
			            
			            
			        },
			        //innerPadding: Ext.os.is.Desktop ? 40 : 10,
			        series: [{
			        	
			            type: 'pie',
			            title: 'Gestiones en plazo',
			            xField: 'cerradas',
			            label: {
			            	//display: 'none',
			                field: 'mes',
			                
			                // Estas líneas son por un bug que hace que el display: none no funcione!!!!
			                 calloutLine: {
						        color: 'rgba(0,0,0,0)' // Transparent to hide callout line
						    },
						    renderer: function(val) {
						        return ''; 
						    }
			            },
			            showMarkers: false,
			            showLegend: false,
			            height: 150,
			           // pie: 150,
			            minHeight: 150,
			            highlightCfg: {
			                margin: 20
			            },
			            style: {
			                stroke: 'white',
			                miterLimit: 10,
			                lineCap: 'miter',
			                lineWidth: 2
			            }
			        }],
			        axes: []
			    }
		
		
			    
			    ]
			 }
    ]
});
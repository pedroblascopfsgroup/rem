Ext.define('HreRem.view.trabajos.PresupuestoAsignadoActivo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'presupuestoasignadosactivo',
    collapsed	: false,
    reference	: 'presupuestoasignadosactivoref',
    scrollable	: 'y',
    recordName	: "recordPresupuesto",
	recordClass	: "HreRem.model.PresupuestoGrafico",
	requires	: ['HreRem.view.common.FieldSetTable', 'HreRem.model.Presupuesto', 'Ext.chart.CartesianChart', 'Ext.chart.axis.Numeric', 'Ext.chart.axis.Category',
					'Ext.chart.series.Bar', 'Ext.chart.interactions.ItemHighlight', 'HreRem.model.PresupuestoGrafico'],
    listeners	: {
    	beforerender:'cargarTabDataPresupuestoGrafico'
    },

    initComponent: function () {
		var me = this; 

		var storeCreado =  Ext.create('Ext.data.Store', {
		     model: 'HreRem.model.PresupuestoGrafico',
	    	proxy: {
		        type: 'uxproxy',
		        localUrl: '/activos.json',
		        remoteUrl: 'activo/findLastPresupuesto',
	        	extraParams: {
	        			idActivo: '{activo.id}' 
	        		}
	    	},	    		
	    	remoteSort: true,
	    	remoteFilter: true,	    	
	    	autoLoad: false
		});

        me.items= [
        	{
        		xtype: 'fieldset',
        		items: [
        			{ 	xtype: 'container',
        				layout: 'column',
        				items: [
		        			{
					        	xtype: 'currencyfieldbase',
					        	readOnly: true,
					        	reference: 'fieldPresupuesto',
			                	fieldLabel:  'Presupuesto anual asignado',
			                	bind:		'{recordPresupuesto.presupuesto}',
			                	labelWidth: 200,
			                	width: 		280
					        },
					        {
					        	xtype: 'displayfieldbase',
					        	reference: 'fieldAnyo',
			                	fieldLabel:  'Año',
			                	bind:		'{recordPresupuesto.ejercicio}',
			                	width: 		280
					        }
					     ]
					},
			        {
				        xtype: 'cartesian',
				        colors: ['red','yellow','green'],
				        reference: 'chart',
				        width: '100%',
				        height: 200,
				        legend: {
				            docked: 'bottom'
				        },
				        store: storeCreado,
				        insetPadding: 40,
				        flipXY: true,
				        sprites: [
				        	{
					            type: 'text',
					            fontSize: 22,
					            width: 100,
					            height: 30,
					            x: 40, // the sprite x position
					            y: 20  // the sprite y position
					        }
				        ],
				        axes: [
				        	{
					            type: 'numeric',
					            fields: 'gastadoPorcentaje',
					            position: 'bottom',
					            grid: true,
					            minimum: 0,
					            maximum: 100,
					            majorTickSteps: 10,
					            renderer: 'onAxisLabelRender'
				        	}, 
				        	{
					            type: 'category',
					            fields: 'presupuesto',
					            position: 'left',
					            grid: true,
					        	renderer: function(axis, data) {
					        		return Ext.util.Format.currency(data);
					        	}
				       		}
				       	],
				        series: [
				        	{
					            type: 'bar',
					            fullStack: true,
					            title: [ HreRem.i18n('title.grafico.gastado'), HreRem.i18n('title.grafico.pendiente.pago'), HreRem.i18n('title.grafico.disponible') ],
					            xField: 'presupuesto',
					            yField: [ 'gastadoPorcentaje', 'dispuestoPorcentaje', 'disponiblePorcentaje'],
					            axis: 'bottom',
					            stacked: true,
					            style: {
					                opacity: 0.80
					            },
					            highlight: {
					                fillStyle: 'blue'
					            },
					            tooltip: {
					                trackMouse: true,
					                renderer: 'onSeriesTooltipRender'
					            }
					        }
					    ]
				        
			        }
			    ]
			},    

			{
				xtype:'fieldset',
				layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 3,
			        trAttrs: {height: '45px', width: '100%'},
			        tdAttrs: {width: '33%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				items: [
					{
					    xtype		: 'gridBase',
					    title		: HreRem.i18n('title.historico.presupuestos.asignados'),
					    reference: 'historicoPresupuestosActivo',
						layout:'fit',
						minHeight: 200,
						colspan: 2,
						flex:2,
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeHistoricoPresupuestos}'
						},
						columns: [
						   { 	
						   		text: HreRem.i18n('header.anyo'),
					        	dataIndex: 'ejercicioAnyo',
					        	flex: 1
					       },
					       {   
					       		text: HreRem.i18n('header.presupuesto.inicial'),
					        	dataIndex: 'importeInicial',
					        	flex: 1,
					        	renderer: function(value) {
					        		return Ext.util.Format.currency(value);
					        	}
					       },
					       {
					       		text: HreRem.i18n('header.presupuesto.extraordinario.aprobado'),
					        	dataIndex: 'sumaIncrementos',
					        	flex: 1,
					        	renderer: function(value) {
					        		return Ext.util.Format.currency(value);
					        	}
					       },
					       {
					       		text: HreRem.i18n('header.presupuesto.acumulado'),
					        	dataIndex: 'importeInicial',
					        	flex: 1,
					        	renderer: function (value, cell, grid) {
									return Ext.util.Format.currency(value + grid.data.sumaIncrementos);
					        	}
					       },
					       {
					       		text: HreRem.i18n('header.importe.dispuesto'),
					        	dataIndex: 'dispuesto',
					        	flex: 1,
					        	renderer: function(value) {
					        		return Ext.util.Format.currency(value);
					        	}
					       }
					       
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeHistoricoPresupuestos}'
					            }
					        }
					    ],
					    listeners : [
					    	{rowdblclick: 'onHistoricoPresupuestosActivoListDobleClick'}
					    ]
					},
			        {
					    xtype		: 'gridBase',
					    title		: HreRem.i18n('title.relacion.incrementos.presupuesto.extraordinarios'),
					    reference: 'incrementosPresupuesto',
						layout:'fit',
						minHeight: 200,
						maxHeight : 200,
						flex: 1,
						
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeIncrementosPresupuesto}'
						},
						columns: [
		
						   { 	
						   		text: HreRem.i18n('header.importe'),
					        	dataIndex: 'importeIncremento',
					        	flex: 1,
					        	renderer: function(value) {
					        		return Ext.util.Format.currency(value);
					        	}
					       },
					       {   
					       		text: HreRem.i18n('header.fecha'),
					        	dataIndex: 'fechaAprobacion',
					        	formatter: 'date("d/m/Y")',
					        	flex: 1
					       },
					       {
					       		text: HreRem.i18n('header.numero.trabajo'),
					        	dataIndex: 'codigoTrabajo',
					        	flex: 1
					       }
					    ]
					}
				]
			}
     ];

    	me.callParent();
   },

   funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabDataPresupuestoGrafico(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
});
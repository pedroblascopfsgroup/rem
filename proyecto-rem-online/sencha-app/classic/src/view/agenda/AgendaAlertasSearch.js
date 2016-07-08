Ext.define('HreRem.view.agenda.AgendaAlertasSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'agendaalertassearch',
    isSearchFormAlertas : true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    requires: ['HreRem.view.common.ComboTipoActuacion'],

    /*defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield',
        style: 'width: 33%'
    },*/
    
	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.filtro.alertas'));
	    me.items= [

	    {
    			xtype: 'panel',
 				minHeight: 100,
    			layout: 'column',
    			cls: 'panel-busqueda-directa',
    			//title: HreRem.i18n('title.busqueda.directa'),
    			collapsible: false,
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 25%'
			    },
	    		
			    items: [
	    
	    
		            {
		            	  items: [
		  						{ 
		  			            	fieldLabel: HreRem.i18n('fieldlabel.tarea'),
		  			            	name: 'nombreTarea'
		  				        },
		  				        { 
		              	        	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
		              	        	name: 'descripcionTarea'
		              	        }
		  			        ]	
		            },
		            {
		            	items: [
		        		        { 
		        		        	xtype:'datefield',
		            	        	fieldLabel: HreRem.i18n('fieldlabel.fecha.inicio.desde'),
		            	        	name: 'fechaInicioDesde',
		            	        	formatter: 'date("d/m/Y")',
		            	        	listeners : {
						            	change: function () {
						            		//Eliminar la fechaHasta e instaurar
						            		//como minValue a su campo el velor de fechaDesde
						            		var me = this;
						            		me.next().reset();
						            		me.next().setMinValue(me.getValue());
						                }
					            	}
		            	        },
		            	        { 
		            	        	xtype:'datefield',
		            	        	fieldLabel: HreRem.i18n('fieldlabel.fecha.inicio.hasta'),
		            	        	name: 'fechaInicioHasta',
		            	        	formatter: 'date("d/m/Y")'
		            	        }
		            	]	
		            },
		            {
		            	items: [
								{ 
									xtype:'datefield',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.vencimiento.desde'),
									name: 'fechaVencimientoDesde',
		            	        	formatter: 'date("d/m/Y")',
		            	        	listeners : {
						            	change: function () {
						            		//Eliminar la fechaHasta e instaurar
						            		//como minValue a su campo el velor de fechaDesde
						            		var me = this;
						            		me.next().reset();
						            		me.next().setMinValue(me.getValue());
						                }
					            	}
								},
								{ 
									xtype:'datefield',
		            	        	fieldLabel: HreRem.i18n('fieldlabel.fecha.vencimiento.hasta'),
		            	        	name: 'fechaVencimientoHasta',
		            	        	formatter: 'date("d/m/Y")'
		            	        }
		            	]	
		            }
		       ]
	    }
	            
	    ];
  		
    	me.buttonAlign = 'left';
    	me.buttons = [
    		{ text: 'Buscar', handler: 'onSearchAlertasClick' },
    		{ text: 'Limpiar', handler: 'onCleanFiltersClick'}/*,
    		'->',
    		{
				iconCls: 'ico-diary',
				text  : 'Listado', 
				handler: 'onCambiarCalendario', 
				reference: 'botonCambiarCalendario'
	    	}*/
    		
    	];   	
	    		
	    me.callParent();
	}
});
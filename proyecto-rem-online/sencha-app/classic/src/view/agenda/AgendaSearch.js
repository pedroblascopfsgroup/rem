Ext.define('HreRem.view.agenda.AgendaSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'agendasearch',
    isSearchFormTareas : true,
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
    	me.setTitle(HreRem.i18n('title.filtro.agenda'));
    	me.listeners = {
    	  	afterrender: function(cmp) {
    	  		if($AU.getUser().esGestorSustituto == "0"){
    	  			cmp.down("button[reference=btnGestorSustituto]").setVisible(false);
    	  		}
    	  	}
    	};
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
						defaults: {
				    		addUxReadOnlyEditFieldPlugin: false
				    	},
		            	  items: [
//		  						{ 
//		  			            	fieldLabel: HreRem.i18n('fieldlabel.tarea'),
//		  			            	name: 'nombreTarea'
//		  				        }
//		  						,
		  				        { 
						        	xtype: 'comboboxfieldbasedd',
						        	name: 'descripcionTarea',
						        	fieldLabel: 'Tipo trámite',
									reference: 'tipoTramiteRef',
						        	bind: {
					            		store: '{comboTipoTramite}'
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo',
		    						chainedStore: 'comboNombreTarea',
		    						chainedReference: 'nombreTareaRef',
		    						listeners: {
		    							select : 'onChangeChainedCombo'
		    						},
									publishes: 'value'      	
						        },
						        {
						        	xtype: 'comboboxfieldbasedd',
						        	fieldLabel: HreRem.i18n('fieldlabel.tarea'),
						        	reference: 'nombreTareaRef',
						        	name: 'nombreTarea',
						        	bind: {
					            		store: '{comboNombreTarea}',
					            		disabled: '{!tipoTramiteRef.selection}'
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo',
		    						mode: 'local'										
						        }
//		  				        { 
//		              	        	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
//		              	        	name: 'descripcionTarea'
//		              	        }
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
    		{ text: 'Buscar', handler: 'onSearchClick' },
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
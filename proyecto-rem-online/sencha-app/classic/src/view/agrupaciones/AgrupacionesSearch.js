Ext.define('HreRem.view.agrupaciones.AgrupacionesSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'agrupacionessearch',
    isSearchForm: true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
        
   /* defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield'
        //,style: 'width: 50%'
    },
    */
   
	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.filtro.agrupaciones'));
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
			        
			        /*
			         * {
			    			items:[
						        { 
						        	fieldLabel: HreRem.i18n('fieldlabel.id.activo.haya'),
						        	name: 'numActivo'
		
						        },
						        { 
						        	fieldLabel: HreRem.i18n('fieldlabel.propietario'),
						        	name: 'propietario'
						        }
							]
						},
			         */
			        	{
			        			items: [
			        				{ 
						            	fieldLabel: HreRem.i18n('fieldlabel.numero.agrupacion'),
						            	name: 'numAgrupacionRem'
						            },
						       		{ 
							        	xtype: 'combo',
							        	fieldLabel: HreRem.i18n('fieldlabel.tipo'),
							        	name: 'tipoAgrupacion',
							        	bind: {
						            		store: '{comboTipoAgrupacion}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo'
							        }
			        			]
			        	},
			        	{
			        		items: [
			        	
						        { 
					            	fieldLabel: HreRem.i18n('fieldlabel.nombre'),
					            	name: 'nombre',
					            	labelWidth:	150,
						        	width: 		230
					            },
					            { 
						        	xtype: 'combo',
						        	//hidden: true,
						        	editable: false,
						        	disabled: true,
						        	fieldLabel:  HreRem.i18n('fieldlabel.publicada.web'),
						        	labelWidth:	150,
						        	width: 		230,
						        	name: 'publicado',
						        	bind: {
					            		store: '{comboSiNoRem}'
					            	},
					            	displayField: 'descripcion',
									valueField: 'codigo'
						        }
						     ]
						},
							{
			        			items: [
							        { 
					                	xtype:'datefield',
								 		fieldLabel: HreRem.i18n('fieldlabel.fecha.creacion.desde'),
								 		width: 		275,
								 		name: 		'fechaCreacionDesde',
						            	bind:		'{fechaCreacionDesde}',
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
								 		fieldLabel: HreRem.i18n('fieldlabel.fecha.creacion.hasta'),
								 		width: 		275,
								 		name: 'fechaCreacionHasta',
						            	bind:		'{fechaCreacionHasta}'
									}
								]
							}
			        ]
	            }
	    ];
	   	
	    me.callParent();
	}
});
Ext.define('HreRem.view.activos.detalle.CargasActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'cargasactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'cargasactivo',
    scrollable	: 'y',
    listeners: {
		boxready:'cargarTabData'
    },

	recordName: "cargaTab",
	
	recordClass: "HreRem.model.ActivoCargasTab",
	
	requires: ['HreRem.model.ActivoCargasTab'],

    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.cargas')); 
        var items= [

            {
            	xtype: 'fieldset',
                collapsed: false,
                layout: {
                    type: 'table',
                    // The total column count must be specified here
                    columns: 2,
                    trAttrs: {height: '30px', width: '100%'},
                    tdAttrs: {width: '50%'},
                    tableAttrs: {
                        style: {
                            width: '100%'
            			}
                    }
            	},
            	items: [
            	  {
					xtype: 'comboboxfieldbase',
					fieldLabel: HreRem.i18n('fieldlabel.con.cargas'),
					name: 'estadoActivoCodigo',
					bind: {
						store: '{comboSiNoRem}',
						value: '{cargaTab.conCargas}'
					}		
            	  },
            	  {
            		  xtype: 'datefieldbase',
            		  fieldLabel: HreRem.i18n('fieldlabel.fecha.revision.cargas'),
            		  bind: '{cargaTab.fechaRevisionCarga}'
            	  }
            	        
            	]
            },
            //Meter este grid y los dos bloques de abajo dentro de otro form
            //con recordClass ActivoCarga
        	{
					xtype: 'formBase',
					cls	: 'panel-base shadow-panel',
					reference: 'formCargas',
				    collapsed: false,
				    colspan: 3,

					recordName: "carga",
					
					recordClass: "HreRem.model.ActivoCargas",
					
					requires: ['HreRem.view.common.FieldSetTable'],
				    
				    
				    items: [
				    
					{
					    xtype		: 'gridBase',
					    title		: HreRem.i18n('title.listado.cargas'),
					    reference: 'listadoCargasActivo',
						layout:'fit',
						minHeight: 240,
						
						cls	: 'panel-base shadow-panel',
						//height: '100%',
						bind: {
							store: '{storeCargas}'
						},
						columns: [
						    {   text: HreRem.i18n('header.tipo.carga'),
					        	dataIndex: 'tipoCargaDescripcion',
					        	width: 200
					        },
					        {   text: HreRem.i18n('header.subtipo.carga'),
					        	dataIndex: 'subtipoCargaDescripcion',
					        	width: 200 
					        },	
					        {   text: 'Estado carga registral',
					        	dataIndex: 'estadoDescripcion',
					        	width: 200 
					        },	
					        {   text: 'Estado carga econ&oacute;mica',
					        	dataIndex: 'estadoEconomicaDescripcion',
					        	width: 200 
					        },	
							{
					            text: HreRem.i18n('header.titular'),
					            dataIndex: 'titular',
					            width: 200
					        },
					        {	text: 'Importe registral',
					        	dataIndex: 'importeRegistral',
					        	width: 200,
					        	renderer: function(value) {
					        		return Ext.util.Format.currency(value);
					        	}
					        },
					        {   text: 'Importe econ&oacute;mico',
					        	dataIndex: 'importeEconomico',
					        	width: 200,
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
					                store: '{storeCargas}'
					            }
					        }
					    ],
					    listeners : [
					    	{rowdblclick: 'onCargasListDobleClick'}
					    ]
					},
		
					{    
						xtype:'fieldset',
						title:HreRem.i18n('title.carga.registral'),
						hidden: true,
						bind: {
							hidden: '{!carga.isCargaRegistral}',
							disabled: '{!carga.isCargaRegistral}'
						},
						reference:'registral',
						defaultType: 'textfieldbase',
						layout: {
					        type: 'table',
					        columns: 2,
					        trAttrs: {height: '45px', width: '100%'},
					        tableAttrs: {
					            style: {
					                width: '100%'
					            }
					        }
				    	},
						items :
							[
				                { 
							 		fieldLabel: HreRem.i18n('fieldlabel.tipo.carga'),
							 		width:		400,
					            	bind:		'{carga.tipoCargaDesc}'
								}, 
				                { 
							 		fieldLabel: HreRem.i18n('fieldlabel.subtipo.carga'),
							 		width:		400,
					            	bind:		'{carga.subtipoCargaDesc}'
								}, 
								{ 
									
									fieldLabel: HreRem.i18n('fieldlabel.descripcion.carga'),
									width:		450,
				                	bind:		'{carga.descripcionCarga}'
				                },
				                {
				                	maskRe: /^\d*$/, 
							 		fieldLabel: HreRem.i18n('fieldlabel.orden'),
							 		width:		300,
					            	bind:		'{carga.ordenCarga}'
								},
								{ 
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
									fieldLabel: HreRem.i18n('fieldlabel.estado'),
						        	width: 		400,
						        	bind: {
					            		store: '{comboEstadoCarga}',
					            		value: '{carga.situacionCargaCodigo}'
					            	}
						        },
				                { 
							 		fieldLabel: HreRem.i18n('fieldlabel.titular.carga'),
							 		width:		400,
					            	bind:		'{carga.titular}'
								},
								{ 
									xtype:'currencyfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.importe.registral'),
									width:		250,
				                	bind:		'{carga.importeRegistral}'
				                },
				                { 
				                	xtype:'currencyfieldbase',
							 		fieldLabel: HreRem.i18n('fieldlabel.importe.real'),					 		
							 		width:		250,
					            	bind:		'{carga.importeEconomico}'
								},
								{
									xtype:'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.inscripcion.carga.registro'),
							 		width:		280,
					            	bind:		'{carga.fechaInscripcion}'
					            	
								},
								{
									xtype:'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.cancelacion.economica.carga'),
							 		width:		280,
					            	bind:		'{carga.fechaCancelacion}'
					            	
								},
								{
									xtype:'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.presentacion.cancelacion'),
							 		width:		280,
					            	bind:		'{carga.fechaPresentacion}'
					            	
								},
								{
									xtype:'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.cancelacion.registral'),
							 		width:		280,
					            	bind:		'{carga.fechaCancelacionRegistral}'
					            	
								}
								
							 ]
		                
		            },
		            
		            {    
						xtype:'fieldsettable',
						title:HreRem.i18n('title.carga.economica'),
						hidden: true,
						bind: {
							hidden: '{!carga.isCargaEconomica}',
							disabled: '{!carga.isCargaEconomica}'
						},	
						reference:'economica',
						defaultType: 'textfieldbase',
						items :
							[
				                { 
							 		fieldLabel: HreRem.i18n('fieldlabel.tipo.carga'),
							 		width:		400,
					            	bind:		'{carga.tipoCargaDescEconomica}'
								}, 
				                { 
							 		fieldLabel: HreRem.i18n('fieldlabel.subtipo.carga'),
							 		width:		400,
					            	bind:		'{carga.subtipoCargaDescEconomica}'
								}, 
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.descripcion.carga'),
									width:		450,
				                	bind:		'{carga.descripcionCargaEconomica}'
				                },
						        { 
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
							 		fieldLabel: HreRem.i18n('fieldlabel.estado'),
						        	width: 		400,
						        	bind: {
					            		store: '{comboEstadoCarga}',
					            		value: '{carga.situacionCargaCodigoEconomica}'
					            	}
						        },  				        
				                { 
							 		fieldLabel: HreRem.i18n('fieldlabel.titular.carga'),
							 		width:		400,
					            	bind:		'{carga.titularEconomica}'
								},
								{ 
									xtype:'currencyfieldbase',
							 		fieldLabel: HreRem.i18n('fieldlabel.importe'),
							 		width:		250,
					            	bind:		'{carga.importeEconomicoEconomica}'
								},
								{
									xtype:'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.cancelacion.economica.carga'),
							 		width:		280,
				                	bind:		'{carga.fechaCancelacionEconomica}'
								}
		
							 ]
		                 
		            }
		        ]
        	}
            
            
     ];
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
   }


    
});
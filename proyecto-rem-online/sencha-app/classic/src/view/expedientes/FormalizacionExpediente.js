Ext.define('HreRem.view.expedientes.FormalizacionExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'formalizacionexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'formalizacionExpediente',
    scrollable	: 'y',

	recordName: "resolucion",
	
	recordClass: "HreRem.model.ExpedienteFormalizacionResolucion",
    
    requires: ['HreRem.model.ExpedienteFormalizacionResolucion'],
    
    listeners: {
			boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.formalizacion'));
        var items= [

			{   
				xtype:'fieldset',
				collapsible: true,
				defaultType: 'displayfieldbase',
				cls	: 'panel-base shadow-panel',
				title: HreRem.i18n('title.posicionamiento.firma'),
				items : [	
					{
					    xtype		: 'gridBase',
					    title: HreRem.i18n('title.notario'),
					    reference: 'listadoNotarioPosicionamientofirma',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeNotarios}'
						},									
						
						columns: [
						   {    text: HreRem.i18n('fieldlabel.nombre'),
					        	dataIndex: 'nombre',
					        	flex: 1
					       },
						   {
					            text: HreRem.i18n('header.direccion'),
					            dataIndex: 'direccion',
					            flex: 1
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.persona.contacto'),
					            dataIndex: 'personaContacto',
					            flex: 1
						   },						   
						   {
						   		text: HreRem.i18n('fieldlabel.cargo'),
					            dataIndex: 'cargo',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.telefono'),
					            dataIndex: 'telefono',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.email'),
					            dataIndex: 'email',
					            flex: 1						   
						   }
					    ],
					    listeners: {
					    	rowdblclick: 'onNotarioDblClick'
					    }
					},
					{
					    xtype		: 'gridBase',
					    title: HreRem.i18n('title.posicionamiento'),
					    reference: 'listadoposicionamiento',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storePosicionamientos}'
						},									
						
						columns: [
						   {    text: HreRem.i18n('fieldlabel.fecha.aviso'),
						  		 dataIndex: 'fechaAviso',
					            formatter: 'date("d/m/Y")',
					        	flex: 1
					       },
						   {
					            text: HreRem.i18n('fieldlabel.notaria'),
					            dataIndex: 'notaria',
					            flex: 1
						   },
						   {    text: HreRem.i18n('fieldlabel.fecha.posicionamiento'),
						  		dataIndex: 'fechaPosicionamiento',
					            formatter: 'date("d/m/Y")',
					        	flex: 1
					       },						   
						   {
						   		text: HreRem.i18n('fieldlabel.motivo.aplazamiento'),
					            dataIndex: 'motivoAplazamiento',
					            flex: 1						   
						   }	
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storePosicionamientos}'
					            }
					        }
			    		]
					},
//	GRID COMPARECIENTES EN NOMBRE DEL VENDEDOR					
//					{
//					    xtype		: 'gridBaseEditableRow',
//					    title: HreRem.i18n('title.comparecientes.nombre.vendedor'),
//					    reference: 'listadocomparecientesnombrevendedor',
//						cls	: 'panel-base shadow-panel',
//						topBar: true,
//						requires: ['HreRem.view.expedientes.buscarCompareciente'],
//						bind: {
//							store: '{storeComparecientes}'
//						},									
//						
//						columns: [
//						   {    text: HreRem.i18n('fieldlabel.tipo.comparecencia'),
//					        	dataIndex: 'tipoCompareciente',
//					        	flex: 1
//					       },
//						   {    text: HreRem.i18n('fieldlabel.nombre'),
//					        	dataIndex: 'nombre',
//					        	flex: 1
//					       },						   
//						   {
//					            text: HreRem.i18n('header.direccion'),
//					            dataIndex: 'direccion',
//					            flex: 1
//						   },
//						   {
//						   		text: HreRem.i18n('fieldlabel.telefono'),
//					            dataIndex: 'telefono',
//					            flex: 1						   
//						   },
//						   {
//						   		text: HreRem.i18n('fieldlabel.email'),
//					            dataIndex: 'email',
//					            flex: 1						   
//						   }
//					    ],
//					    onAddClick: function (btn) {
//							debugger;
//							var me = this;  	
//							Ext.create('HreRem.view.expedientes.BuscarCompareciente',{}).show();
//							
//						}
//					},
					{
						xtype: 'button',
						text: HreRem.i18n('fieldlabel.generar.hoja.datos'),
					    margin: '10 10 10 10',
//					    handler: 'onClickBotonFavoritos'
					    disabled: true // TODO Comités sin definir
					}
					
	
				]					
								
			},
			{   
				xtype:'fieldset',
				collapsible: true,
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.subsanaciones'),
				items : [
				
					{
					    xtype		: 'gridBase',
					    reference: 'listadosubsanaciones',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeSubsanaciones}'
						},									
						
						columns: [
						   {    text: HreRem.i18n('header.fecha.peticion'),
						  		 dataIndex: 'fechaPeticion',
					            formatter: 'date("d/m/Y")',
					        	flex: 1
					       },
						   {
					            text: HreRem.i18n('fieldlabel.peticionario'),
					            dataIndex: 'peticionario',
					            flex: 1
						   },
						    {
						   		text: HreRem.i18n('fieldlabel.motivo.subsanaciones'),
					            dataIndex: 'motivo',
					            flex: 1						   
						   },						   
						   {
						   		text: HreRem.i18n('fieldlabel.estado'),
					            dataIndex: 'estado',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.tramite.subsanaciones'),
					            dataIndex: 'tramiteSubsanacion',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.gastos.subsanacion'),
					            dataIndex: 'gastosSubsanacion',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.gastos.inscripcion'),
					            dataIndex: 'gastosInscripcion',
					            flex: 1						   
						   }
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeSubsanaciones}'
					            }
					        }
			    		]
					}

				
		        ]
			},
			{   
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.resolucion'),
//				recordName: "resolucion",
//				recordClass: "HreRem.model.ExpedienteFormalizacionResolucion",
				layout: {
			        type: 'hbox',
			       	align: 'stretch'
			    },
				items : [
					{
							xtype: 'container',
							layout: {type: 'vbox'},
							defaultType: 'textfieldbase',
							width: '70%',
							items: [
								{
									xtype:'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.peticionario'),
									bind: '{resolucion.peticionario}'				        						        	
								},						        
								{
									xtype:'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.motivo.resolucion'),
									bind: '{resolucion.motivoResolucion}'				        						        	
								},
				                {
									xtype:'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.gastos.cargo'),
									bind: '{resolucion.gastosCargo}'				        						        	
								},
								{
									xtype:'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.forma.pago'),
									bind: '{resolucion.formaPago}'				        						        	
								}
	            			]
		                
						},
						{
							xtype: 'container',
							layout: {type: 'vbox'},
							defaultType: 'textfieldbase',
							width: '30%',
							items: [
								{
									xtype:'displayfieldbase',
									formatter: 'date("d/m/Y")',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.peticion'),
									bind: '{resolucion.fechaPeticion}'				        						        	
								},						        
								{
									xtype:'displayfieldbase',
									formatter: 'date("d/m/Y")',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.resolucion'),
									bind: '{resolucion.fechaResolucion}'				        						        	
								},
				                {
									xtype:'displayfieldbase',
									fieldLabel: HreRem.i18n('header.importe'),
									symbol: HreRem.i18n("symbol.euro"),
									bind: '{resolucion.importe}'				        						        	
								},
								{
									xtype:'displayfieldbase',
									formatter: 'date("d/m/Y")',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.pago'),
									bind: '{resolucion.fechaPago}'				        						        	
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
    }
});
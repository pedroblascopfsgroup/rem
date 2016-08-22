Ext.define('HreRem.view.activos.tramites.SolicitarProrroga', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'solicitarProrroga',
    reference	: 'windowSolicitarProrroga',
    viewModel	: {
        type: 'solicitarprorroga'
    },
    title 		: "Solicitar prórroga",
    width		: 350,
    

    initComponent: function() {
    	//debugger;
    	var me = this;
    
		me.buttons = [
		              { itemId: 'btnGenerarAutoprorroga', text: 'Solicitar Prórroga', handler: 'generarAutoprorroga'},
		              { itemId: 'btnCancelar', text: 'Cerrar', handler: 'cancelarProrroga'}
		              ];

    	me.items = [
                
            {
			    xtype: 'form',
			    reference: 'formSolicitarProrroga',
			    layout: 'column',    
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 98%'
			    },
			    
			    items: [{

					xtype : 'fieldset',
					collapsible : true,
					defaultType : 'textfield',
					style : 'width: 98%',
//					defaults : {
//						style : 'width: 100%'
//					},
					layout : 'column',
					title : 'Instrucciones',

					items : [
					{
						xtype : 'label',
						cls : 'info-tarea',
						html : 'Rellenando la siguiente información, se creará una prórroga de la tarea seleccionada.</br></br> Las tareas tienen un máximo de dos prórrogas con un máximo de 7 días cada una.</br></br>Una vez hecha la prórroga, cambiará la fecha de vencimiento de la tarea.',
						tipo : 'info'
					} ]

				},{
	        		xtype:'fieldset',
					collapsible: false,
					defaultType: 'textfield',
					layout: 'vbox',
				
					items :
						[
//						 {
//			                	xtype:'container',
//								collapsible: false,
//								defaultType: 'textfield',
//								margin: '0 0 20 0',
//								layout: 'hbox',							
//								items :
//									[
//										{
//								        	xtype: 'combobox',
//								        	fieldLabel: 'Destinatario',
//								        	bind: {
//							            		store: '{storeGestores}'
//							            	},
//							            	valueField: 'id',
//							            	displayField: 'apellidoNombre',
//							            	triggerAction : 'all',
//											name: 'destinatarioNotificacion',
//											itemId: 'destinatarioNotificacion',
//											margin: '0 20 0 0',
//											editable : false,
//									    	allowBlank: false	
//										}			
										
//										,
//										{ 
//											xtype: 'combobox',
//											fieldLabel: 'Destinatorio',
//											store : new Ext.data.SimpleStore({
//												data : [[29626, 'GSUPLI'], 
//												        [29366, 'LETRADO']]/*,
//														[[25053, 'GESTOR'], 
//												        [29359, 'GEST_ADM']]*/,
//												fields : ['id', 'descripcion']
//											}),
//											valueField : 'id',
//											displayField : 'descripcion',
//											triggerAction : 'all',
//											name: 'destinatarioNotificacion',
//											itemId: 'destinatarioNotificacion',
//											margin: '0 20 0 0',
//											editable : false,
//								    		allowBlank: false
//										}
//					                ]
//			                },	
			                {
			                	xtype:'container',
								collapsible: false,
								defaultType: 'textfield',
								margin: '0 0 20 0',
								layout: 'vbox',							
								items :
									[	{
											xtype: 'textfield',
											name: 'idTareaExterna',
											value: me.idTareaExterna,
											hidden: true
										},
										{ 
											xtype: 'textarea',
											fieldLabel: 'Motivo',
											name: 'motivoAutoprorroga',
											itemId: 'motivoAutoprorroga',
											margin: '10 20 10 0',
											maxLength: 50,
											height: 50,
											allowBlank: false,
											msgTarget: 'side'
										},
										{ 
											xtype: 'datefield',
											fieldLabel: 'Nueva Fecha',
											name: 'nuevaFechaProrroga',
											margin: '0 20 0 0',
											maxValue: Ext.Date.add($AC.getCurrentDate(), Ext.Date.DAY,7),
											allowBlank: false
										}
					                ]
			                }
//			                ,			        
//    						{ 
//			                	xtype: 'textarea',
//			                	fieldLabel: 'Descripción',
//		                        name: 'descripcionNotificacion',
//		                        itemId: 'descripcionNotificacion',
//		                        width: Ext.Element.getViewportWidth() /2 -80
//			                }
						 ]
		    		}
			    		
			    ]
					
    	}];
    	
    	me.callParent();
    
    },	
    
    evaluar: function() {},
    
    mostrarValidacionesPre : function() {},
    
    mostrarValidacionesPost : function() {}
});
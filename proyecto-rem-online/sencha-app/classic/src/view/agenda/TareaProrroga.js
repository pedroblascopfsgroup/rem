Ext.define('HreRem.view.agenda.TareaProrroga', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'tareaProrroga',
    reference	: 'windowTareaProrroga',
    controller	: 'tarea',
//    viewModel: {
//        type: 'tareaprorroga'
//    },
    title 		: "Prórroga",
    width		: 350,
    

    initComponent: function() {
    	//debugger;
    	var me = this;
    
		me.buttons = [
		              { itemId: 'btnCancelar', text: 'Cerrar', handler: 'cancelarTarea'}
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
						html : 'La siguiente información, muestra la prórroga realizada en la tarea <b>'+ me.descripcionTareaProrrogada + '</b>. Se indica la anterior fecha de vencimiento de la tarea y la que tiene a partir de la creación de la prórroga.',
						tipo : 'info'
					} ]

				},{
	        		xtype:'fieldset',
					collapsible: false,
					defaultType: 'textfield',
					layout: 'vbox',
				
					items :
						[ 
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
//										{ 
//											xtype: 'textfield',
//											fieldLabel: 'Tarea prorrogada',
//											name: 'tareaprorrogada',
//											itemId: 'tareaprorrogada',
//											margin: '10 20 10 0',
//											editable : false,
//								    		value: me.descripcionTareaProrrogada
//										},
										{ 
											xtype: 'textarea',
											fieldLabel: 'Motivo',
											name: 'motivoAutoprorroga',
											itemId: 'motivoAutoprorroga',
											margin: '10 20 10 0',
											editable : false,
											maxLength: 50,
											height: 50,
								    		value: me.motivoAutoprorroga,
								    		msgTarget : 'side'
										},
										{ 
											xtype: 'textfield',
											fieldLabel: 'Fecha anterior',
											name: 'antiguaFechaProrroga',
											margin: '10 20 10 0',
											editable: false,
											value: me.antiguaFechaProrroga
										},
										{ 
											xtype: 'textfield',
											fieldLabel: 'Fecha nueva',
											name: 'nuevaFechaProrroga',
											margin: '10 20 10 0',
											editable: false,
											value: me.nuevaFechaProrroga
										}
					                ]
			                }

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
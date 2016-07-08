Ext.define('HreRem.view.activos.actuacion.tareas.forms.ContraofertarCliente', {
    extend		: 'HreRem.view.common.TareaBase',
    xtype		: 'contraofertarcliente',
    reference	: 'windowcontraofertarcliente',
    title : "Contraofertar al cliente",
    
    tareaSiguiente: 'sp303',

    initComponent: function() {
    	
    	var me = this;
    
    	me.items = [
                
            {
			    xtype: 'form',
			    reference: 'formcontraofertarcliente',
			    layout: 'column',    
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 98%'
			    },
			    
			    items: [{
        
	        		xtype:'fieldset',
					collapsible: true,
					defaultType: 'textfield',
					defaults: {
						style: 'width: 100%'},
					layout: 'column',
					title: 'Intrucciones',
				
					items :
						[
						 	{ 
								xtype: 'label',
								cls: 'x-fa fa-exclamation-triangle info-tarea warning-tarea',
								text: 'En la presente tarea, tras hacer constar la fecha en que se ha comunicado con el cliente, hay que anotar si el cliente acepta o rechaza la contraoferta.',
								tipo: 'warning',
								hidden: true
						 	},
						 	{
						 		xtype: 'label',
						 		cls: 'x-fa fa-info-circle info-tarea ',
						 		tipo: 'info',
								text: 'Si el cliente ha rechazado la contraoferta, se finalizará el trámite y se descongelarán, en su caso, el resto de ofertas que pudiesen existir sobre el activo.'
						 	},
						 	{
						 		xtype: 'label',
						 		cls: 'x-fa fa-info-circle info-tarea',
						 		tipo: 'info',
								text: 'Si el cliente ha aceptado la contraoferta, el próximo trámite será el de "elaborar y enviar propuesta a Comité".'
							}
						 ]					
						
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
								layout: 'hbox',							
								items :
									[
										{ 
											xtype: 'datefield',
											fieldLabel: 'Fecha notificación al cliente',
											name: 'fechaNotifContraofertaClienteOferta',
											margin: '0 20 0 0',
											allowBlank: false
										},
										{ 
											xtype: 'combobox',
											fieldLabel: 'Respuesta cliente',
											name: 'idRespuestaContraofertaClienteOferta',
											store : new Ext.data.SimpleStore({
												data : [[0, 'Acepta contraoferta'], 
												        [1, 'Rechaza contraoferta']],
												fields : ['id', 'descripcion']
											}),
											valueField : 'id',
											displayField : 'descripcion',
											triggerAction : 'all',
											editable : false,
											listeners: {
								    			change: me.decideFlow,
								    			scope: 'this'
								    		},
								    		allowBlank: false
										}
					                ]
			                },			        
    						{ 
			                	xtype: 'textarea',
			                	fieldLabel: 'Observaciones',
		                        name: 'obsRespuestaClienteOferta',
		                        width: Ext.Element.getViewportWidth() /2 -80
			                }			               
						 ]
		    		}
			    		
			    ]
					
    	}];
    	
    	me.callParent();
    
    },
    
    decideFlow: function( cmp, newValue, oldValue ) {

    	var view = cmp.up('contraofertarcliente');

    	if(newValue == 1){
    		view.tareaSiguiente = 'spFinRechazada';
    	}  	
    },	
    
    evaluar: function() {
    	
    	var me = this;
    	
    	return me.tareaSiguiente;
    	
    }
});
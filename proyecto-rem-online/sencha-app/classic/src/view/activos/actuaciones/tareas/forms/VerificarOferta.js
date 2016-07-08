Ext.define('HreRem.view.activos.actuacion.tareas.forms.VerificarOferta', {
    extend		: 'HreRem.view.common.TareaBase',
    xtype		: 'verificarOferta',
    reference	: 'windowVerificarOferta',
    title : "Verificar Oferta",
    
    tareaSiguiente: 'sp303',

    initComponent: function() {
    	
    	var me = this;
    
    	me.items = [
                
            {
			    xtype: 'form',
			    reference: 'formVerificarOferta',
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
								tipo: 'warning',
								text: 'Antes de dar por completada esta tarea, deberá esperar a que consten los vistos buenos a la comercialización de los Gestores de Admisión, del Activo y de Administración, lo que podrá consultar en la pestaña Cabecera del Activo.',
								hidden: true
						 	},
						 	{
						 		xtype: 'label',
						 		cls: 'x-fa fa-info-circle info-tarea ',
								text: 'Si existiese alguna causa para descartar la oferta, deberá hacerlo constar así en el campo "Tramitar oferta", seleccionando a continuación uno de los motivos en el desplegable correspondiente.',
								tipo: 'info'
						 	},
						 	{
						 		xtype: 'label',
						 		cls: 'x-fa fa-info-circle info-tarea',
								text: 'En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto de la actuación.',
								tipo: 'info'
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
						 		xtype: 'displayfield',
						 		fieldLabel: 'Fecha oferta',
						 		name: 'fechaOferta'
			                },
			                {
			                	xtype:'container',
								collapsible: false,
								defaultType: 'textfield',
								margin: '0 0 20 0',
								layout: 'hbox',							
								items :
									[
										{ 
											xtype: 'combobox',
											fieldLabel: '¿Tramitar Oferta?',
											store : new Ext.data.SimpleStore({
												data : [[0, 'Si'], 
												        [1, 'No']],
												fields : ['id', 'descripcion']
											}),
											valueField : 'id',
											displayField : 'descripcion',
											triggerAction : 'all',
											margin: '0 20 0 0',
											editable : false,
											listeners: {
								    			change: me.showMotivo,
								    			scope: 'this'
								    		},
								    		allowBlank: false
										},
										{ 
											xtype: 'combobox',
											fieldLabel: 'Motivo rechazo oferta',
											itemId: 'motivoRechazoOferta',
											store : new Ext.data.SimpleStore({
												data : [[0, 'No real'], 
												        [1, 'Incompleta'],
												        [2, 'Precio insuficiente'],
												        [3, 'Otros']],
												fields : ['id', 'descripcion']
											}),
											valueField : 'id',
											displayField : 'descripcion',
											triggerAction : 'all',
											hidden: true,
											editable : false
										}
					                ]
			                },			        
    						{ 
			                	xtype: 'textarea',
			                	fieldLabel: 'Observaciones',
		                        name: 'obsVerificarOferta',
		                        itemId: 'obsVerificarOferta',
		                        width: Ext.Element.getViewportWidth() /2 -80
			                }			               
						 ]
		    		}
			    		
			    ]
					
    	}];
    	
    	me.callParent();
    
    },
    
    showMotivo: function( cmp, newValue, oldValue ) {
    	
    	var campo = cmp.up("form").down("[itemId=motivoRechazoOferta]");    	
    	var campoObs = cmp.up("form").down("[itemId=obsVerificarOferta]");
    	
    	if(newValue == 1){
    		campo.setVisible(true);
    		campo.allowBlank = false;
    		campoObs.allowBlank = false;
    	}else{
    		campo.setVisible(false);
    		campo.allowBlank = true;
    		campoObs.allowBlank = true;
    		cmp.up("form").isValid();
    	}
    	
    },	
    
    evaluar: function() {
    	
    	var me = this;
    	
    	return me.tareaSiguiente;
    	
    }
});
Ext.define('HreRem.view.activos.actuacion.tareas.forms.PropuestaComite', {
    extend		: 'HreRem.view.common.TareaBase',
    xtype		: 'propuestacomite',
    reference	: 'windowPropuestaComite',
    title		: 'Elaborar y enviar propuesta a comité',
    
    tareaSiguiente: 'sp304',
    
    initComponent: function() {
    	
    	var me = this;
    
    	me.items = [
                
            {
			    xtype: 'form',
			    reference: 'formPropuestaComite',
			    layout: 'column',    
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 100%'
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
								text: 'Antes de dar por completada esta tarea, deberá verificar el contenido de la oferta en la pestaña ofertas dentro del apartado comercial del activo.'
						 	},
						 	{
						 		xtype: 'label',
						 		cls: 'x-fa fa-info-circle info-tarea',
								text: 'En el campo "Resolución propuesta por el Gestor" deberá seleccionar la resolución que, según su criterio, propondría para su adopción por el Comité, y en el campo "Comentarios del Gestor para el Comité" la motivación de dicha propuesta, consignando la fecha en que se elabora la propuesta y, por último, la fecha en que se envía la misma al Comité.'
						 	},
						 	{
						 		xtype: 'label',
						 		cls: 'x-fa fa-info-circle info-tarea',
								text: 'En el campo ""observaciones"" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto de la actuación.'
							}
						 ]
						
						
		    		},{

        
	        		xtype:'fieldset',
					collapsible: false,
					defaultType: 'textfield',
					//defaults: {style: 'width: 50%'},
					layout: 'vbox',
				
					items :
						[
			                { 
			                	xtype: 'combobox',
			                	fieldLabel: 'Resolución propuesta gestor',
			            		store : new Ext.data.SimpleStore({
			    					data : [[0, 'Aceptar'], 
			    					        [1, 'Rechazar'],
			    					        [2, 'Contraofertar']],
			    					value : 0,
			    					fields : ['id', 'descripcion']
			    				}),
					    		valueField : 'id',
					    		displayField : 'descripcion',
					    		triggerAction : 'all',
					    		editable : false,
					    		allowBlank: false
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
											xtype: 'datefield',
											margin: '0 20 0 0',
											fieldLabel: 'Fecha elaboración propuesta',
											allowBlank: false
										},
										{				                	
											xtype: 'datefield',
											fieldLabel: 'Fecha envío propuesta',
											allowBlank: false
										}
					                ]
					               
			                },		            	
    						{ 
			                	xtype: 'textarea',
			                	fieldLabel: 'Observaciones',
		                        name: 'obsGestorAComiteOferta',
		                        width: Ext.Element.getViewportWidth() /2 -80
		                        
			                }
						 ]
		    		}
			    		
			    ]
					
    	}]; 
    	
    	me.callParent();
    
    },
    
    
    evaluar: function() {
    	
    	var me = this;
    	
    	return me.tareaSiguiente;
    	
    }
});
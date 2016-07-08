Ext.define('HreRem.view.activos.actuacion.tareas.forms.ResolucionComite', {
    extend		: 'HreRem.view.common.TareaBase',
    xtype		: 'resolucioncomite',
    reference	: 'windowResolucionComite',
    title : "Resolución comité",
    
    tareaSiguiente: 'sp305',

    initComponent: function() {
    	
    	var me = this;
    	
        
        
    	me.items = [
                
            {
			    xtype: 'form',
			    reference: 'formResolucionComite',
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
								cls: 'x-fa fa-info-circle info-tarea',
								text: 'En esta tarea deberá cumplimentarse la fecha de resolución por el Comité y el sentido de dicha resolución.'
						 	},
						 	{
						 		xtype: 'label',
						 		cls: 'x-fa fa-info-circle info-tarea',
								text: 'Si se acepta la propuesta, se finalizará el presente trámite y se lanzará el de formalización. Si por el contrario el Comité rechaza la propuesta, se finalizará el trámite y se desongelarán, en su caso, el resto de ofertas que pudiesen existir por el activo. Por último, en el supuesto de que el Comité haya contraofertado al cliente, habrá que hacer constar el importe de dicha contraoferta, y la próxima tarea será la de "contraoferta Comité al cliente".'
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
					 			xtype : 'datefield',
								fieldLabel : 'Fecha resolución',
								name: 'fechaResolucionComite',
								editable: false,
								format: 'd/m/y',
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
						                	xtype: 'combobox',
						                	fieldLabel: 'Contenido resolución',
						            		store : new Ext.data.SimpleStore({
						    					data : [[0, 'Aceptar'], 
						    					        [1, 'Rechazar'],
						    					        [2, 'Contraofertar']],
						    					fields : ['id', 'descripcion']
						    				}),
								    		valueField : 'id',
								    		displayField : 'descripcion',
								    		triggerAction : 'all',
								    		margin: '0 20 0 0',
								    		editable : false,
								    		listeners: {
								    			change: me.showPrecio,
								    			scope: 'this'
								    		},
								    		allowBlank: false
										},
						                { 
									 		fieldLabel: 'Precio',
									 		itemId: 'precioContraofertaComite',
									 		name: 'precioContraofertaComite',
									 		hidden: true
						                }
					                ]
			                },			                
    						{ 
			                	xtype: 'textarea',
			                	fieldLabel: 'Observaciones',
		                        name: 'obsResolucionComite',
		                        width: Ext.Element.getViewportWidth() /2 -80
			                }			               
						 ]
		    		}
			    		
			    ]
					
    	}];
    	
    	me.callParent();
    
    },
    
    showPrecio: function( cmp, newValue, oldValue ) {
    	
    	var me = this;
    	var view = me.up('resolucioncomite');
    	
    	var campo = view.down('[itemId=precioContraofertaComite]');
    	
    	if(newValue == 2){
    		campo.setVisible(true);
    		view.tareaSiguiente = 'sp306';
    		campo.allowBlank = false;
    		
    	}else{
    		campo.setVisible(false);
    		campo.allowBlank = true;
    		if(newValue == 0){
    			view.tareaSiguiente = 'spFinAceptada';
    		}else{
    			view.tareaSiguiente = 'spFinRechazada';
    		}
    		
    	}
    	
    },	
    
    evaluar: function() {
    	
    	var me = this;
    	return me.tareaSiguiente;
    	
    }
});
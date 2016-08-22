Ext.define('HreRem.view.activos.comercial.solicitudes.SolicitudDetalle', {
    extend		: 'Ext.container.Container',
    xtype		: 'solicituddetalle',
    reference	: 'solicitudDetalle',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /2,

    /**
     * Atributo que se utilizará para determinar el título del panel y 
     * los campos que se mostraran en funcón de la operación. (Por defecto true y se sobreescribe al editar)
     * @type Boolean
     */
    isNew: null,
    
    requires: ['HreRem.view.common.FormBase'],  
    
    initComponent: function() {
    	
    	var me = this;
    	
    	me.items = [
    	
    		{
			    xtype: 'formBase',
			    reference: 'formSolicitudDetalle',
			    isSaveForm: true,
			    layout: 'column',    
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield'
			    },
			    scrollable	: 'y',
			    items: [
			    
			    		{
			    			style: 'width: 50%',
			    			items: [
						            { 
						            	fieldLabel: 'Nº Documento',
						            	name: 'numDocumento',
						            	triggers: {
									        triggersearch: {
									            cls: 'trigger-search',
									            weight: -2,
									            handler: function() {
									                console.log('foo trigger clicked');
									            }
									        }
						            	}
						            },
						            { 
						            	fieldLabel: 'Nombre',
						            	name: 'nombre'
						            },						            
									{
					                	xtype: 'comboPaises',
										name: 'pais'
					                },
						         	{ 
						            	fieldLabel: 'Email',
						            	name: 'email'
						            },{ 
						            	fieldLabel: 'Situación',
						            	name: 'situacion',
						            	modoEdicion: true
						            },
						            { 
						            	fieldLabel: 'F.verficación',
						                name: 'fechaVerificacion',
						                modoEdicion: true
						            }
						    ]
		        
		    			}, {
		    				style: 'width: 50%',
					        items: [
					                {
					                	xtype: 'comboTiposDocumento',
					                	name: 'tipoDocumento'
					                },
						        	{ 
						            	fieldLabel: 'Apellidos',
						            	name: 'apellidos'
						            },
						            { 
						            	fieldLabel: 'Teléfono 1',
						            	name: 'tel1'
						            },
						         	{ 
						            	fieldLabel: 'Teléfono 2',
						            	name: 'tel2'
						            },
						            { 
						            	fieldLabel: 'Origen',
						            	name: 'origen',
						            	modoEdicion: true
						            }
					        ]
		    			},{
		    				style: 'width: 100%',
		    				layout: 'fit',
		    				modoEdicion: true,
					        items: [
					        
					        {
					        	xtype: 'textarea',
					        	fieldLabel: 'Observaciones',
					        	name: 'observaciones',
					        	width: Ext.Element.getViewportWidth() /2 -80
					        }		        
					        
					        ]   				
		    				
		    			},{
		    				style: 'width: 20%',
		    				items: [
					    				{
					    					xtype: 'displayfield',
					    					fieldLabel: 'Está interesado en'
					    				}					    				
		    				]
		    			},{
		    				style: 'width: 22%',
		    				items: [
		    							{ 
		    								xtype: 'checkbox',
		    								fieldLabel: 'Solicitar Visita',
		    								name: 'solicitarVisita'/*,
		    								labelAlign: 'right'*/
									    }
							]
		    			},{
		    				style: 'width: 22%',
		    				items: [					    				
									    { 
		    								xtype: 'checkbox',
		    								fieldLabel: 'Presentar Oferta',		    								
		    								name: 'presentarOferta',
		    								listeners: {
		    									change: 'onChangeCheckboxPresentarOferta'
		    								}		    									
									    }
		    				]
		    			},{
		    				style: 'width: 36%',
		    				items: [
										{
									    	xtype: 'numberfield',
									    	reference: 'textfieldOferta',
									    	hideLabel: true,
									    	name: 'oferta',
										    hideTrigger: true,
										    maskRe: /[\d\.]/,
        									regex: /^\d+(\.\d{1,2})?$/
        								}
		    				]
		    			}
		    			
		    			
		   		]
	    	}
	    ],
    	   	
    	me.callParent();
    
    },
    
    actualizarDetalle: function(solicitud) {
    	
    	var me = this;
    	   	
    	me.isNew = Ext.isEmpty(solicitud) || Ext.isEmpty(solicitud.get("id")) ? true : false;

    	var title = "Nueva solicitud";
    	
    	if (!me.isNew) {
    		title = "Editar solicitud";    		
    	}  
    	
    	Ext.Array.each(me.query("[modoEdicion=true]"), function(cmp) {
    		cmp.setVisible(!me.isNew);
    	});    	
    	
    	me.down('form').setTitle(title);
    	
    	me.down('form').reset();
   		
    	me.down('form').loadRecord(solicitud);  
    	
    }
});
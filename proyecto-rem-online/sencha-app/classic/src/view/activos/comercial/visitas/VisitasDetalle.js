Ext.define('HreRem.view.activos.comercial.visitas.VisitasDetalle', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'visitasdetalle',
    reference	: 'windowVisitaDetalle',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /2,
    
    /**
     * Atributo que se utilizará para determinar el título de la ventana y 
     * los campos que se mostraran en funcón de la operación. (Por defecto true y se sobreescribe al editar)
     * @type Boolean
     */
    altaVisita: true,
    
    
    requires: ['HreRem.view.common.FormBase'],
    
    
    initComponent: function() {
    	
    	var me = this;    	
    
    	me.items = [
                
            {
			    xtype: 'formBase',
			    reference: 'formVisitasDetalle',
			    isSaveForm: true,
			    layout: 'column',    
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 100%'
			    },
			    
			    items: [{

        
	        		xtype:'fieldset',
					collapsible: false,
					defaultType: 'textfield',
					defaults: {
						style: 'width: 50%'},
					layout: 'column',
					title: 'Datos del Solicitante',
				
						items :
							[
							 	{ 
									fieldLabel: 'Nombre',
									xtype: 'textfield',
									name: 'nombre'
								},
								{ 
									fieldLabel: 'Apellidos',
									name: 'apellidos'
				                },
				                {
				                	xtype: 'comboTiposDocumento',
				                	name: 'tipoDocumento'
				                },
				                {
				                	fieldLabel: 'Nº Documento:',
				                	name: 'numDocumento'
				                },
				                {
				                	xtype: 'comboPaises',
									name: 'pais'
				                },				                
				                { 
				                	fieldLabel: 'Teléfono 1:',
									name: 'tel1'
				                },
				                { 
				                	fieldLabel: 'Email:',
									name: 'email'
				                },
				                { 
				                	fieldLabel: 'Teléfono 2:',
									name: 'tel2'
				                }
							 ]
			    		},
			    		
			    		
			    		
			    		{

        
	        		xtype:'fieldset',
					collapsible: false,
					defaultType: 'textfield',
					defaults: {
						style: 'width: 100%'},
					layout: 'column',
					title: 'Datos de la visita',
					modoEdicion: true,
					hidden: me.altaVisita,
				
						items :
							[
							 	{ 
									fieldLabel: 'Medio por el que ha conocido el inmueble',
									xtype: 'displayfield',
									labelWidth: 'HackAuto',
									name: 'mediador'
								},
			
	    						{ 
	    							style: 'width: 50%',
									fieldLabel: 'Fecha solicitud',
									xtype: 'displayfield',
									name: 'fechaSolicitud'
				                },
				                {
				                	style: 'width: 50%',
				                	fieldLabel: 'Fecha concertada',
				                	name: 'fechaConcertada',
				                	xtype: 'displayfield'
				                },

								
								
								
				                {
				                	style: 'width: 20%',
				                	fieldLabel: '¿Visita realizada?',
				                	xtype: 'displayfield',
				                	name: 'visitaRealizada'
				                },
				                {
				                	style: 'width: 80%',
				                	fieldLabel: '',
				                	xtype: 'displayfield',
				                	name: 'fechaVisita'
				                },
				                {
				                	xtype: 'displayfield',
				                	fieldLabel: 'Observaciones',
									name: 'observaciones'
				                }
							 ]
			    		}
			    		
			    		
			    		
			    		]
					
    	}];
    

        
    	
    	var title = "Nueva visita";
    	if (!me.altaVisita) {
    		title = "Editar visita";		  		
    	}
    	
    	me.setTitle(title);  
    	
    	me.callParent();
    
    }
});
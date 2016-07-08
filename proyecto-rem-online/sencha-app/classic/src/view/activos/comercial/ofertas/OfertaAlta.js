Ext.define('HreRem.view.activos.comercial.ofertas.OfertaAlta', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'ofertaalta',
    reference	: 'windowOfertaAlta',
    layout	: 'fit',
    title 	: 'Nueva Oferta',
    width	: Ext.Element.getViewportWidth() /2,
        
    requires: ['HreRem.view.common.FormBase'],
    
    
    initComponent: function() {
    	
    	var me = this;    	
    
    	me.items = [
                
            {
			    xtype: 'formBase',
			    reference: 'formOfertaAlta',
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
					title: 'Datos del ofertante',
				
						items :
							[
								{
									xtype: 'comboTiposDocumento',
									name: 'tipoDocumento'
								},
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
									xtype: 'textfield',
									name: 'nombre'
								},
								{ 
									fieldLabel: 'Apellidos',
									name: 'apellidos'
				                },
				                {
				                	xtype: 'comboPaises',
									name: 'pais'
				                },				                
				                { 
				                	fieldLabel: 'Teléfono 1:',
									name: 'telefonoUno'
				                },
				                { 
				                	fieldLabel: 'Email:',
									name: 'email'
				                },
				                { 
				                	fieldLabel: 'Teléfono 2:',
									name: 'telefonoDos'
				                }
							 ]
			    		},
			    		
			    		
			    		
			    		{

        
	        		xtype:'fieldset',
					collapsible: false,
					defaultType: 'textfield',
					defaults: {
						style: 'width: 50%'},
					layout: 'column',
					title: 'Datos de la oferta',
					modoEdicion: true,
					hidden: me.altaVisita,
				
						items :
							[

							 	{ 
									fieldLabel: 'Prescriptor',
									xtype: 'textfield',
									style: 'width: 20%',
									name: 'prescriptorCodigo'
								},
								{ 
									fieldLabel: '',
									xtype: 'textfield',
									style: 'width: 80%',
									name: 'prescriptorDescripcion'
								},
								
				                {
				                	style: 'width: 50%',
				                	fieldLabel: 'Tipo oferta',
				                	xtype: 'textfield',
				                	name: 'tipoOferta'
				                },
				                {
				                	style: 'width: 50%',
				                	fieldLabel: 'Importe',
				                	xtype: 'textfield',
				                	name: 'importe'
				                },
				                
				                {
				                	
			                        xtype      : 'fieldcontainer',
			                        fieldLabel : '¿Ha visitado el activo?',
			                        defaultType: 'radiofield',
			                        name : 	'activoVisitado', 
			                        defaults: {
			                            flex: 1
			                        },
			                        layout: 'hbox',
			                        items: [
			                            {
			                                boxLabel  : 'Si',
			                                name      : 'size',
			                                inputValue: 'Si',
			                                id        : 'radio1'
			                            }, {
			                                boxLabel  : 'No',
			                                name      : 'size',
			                                inputValue: 'No',
			                                id        : 'radio2'
			                            }
			                        ]
			                    
				                		
				                },
				                
				                { 
									fieldLabel: 'Visita',
									name: 'idVisita',
									triggers: {
								        triggersearch: {
								            cls: 'trigger-search',
								            weight: -2,
								            handler: function() {
								                console.log('foo trigger clicked');
								            }
								        }
									}
								}
							 ]
			    		}
			    		
			    		
			    		
			    		]
					
    	}];
    
    	
    	me.callParent();
    
    }
});
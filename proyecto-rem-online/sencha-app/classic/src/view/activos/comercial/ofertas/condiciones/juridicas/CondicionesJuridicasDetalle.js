Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.juridicas.CondicionesJuridicasDetalle', {	
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'condicionesjuridicasdetalle',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'condicionesjuridicasdetalleref',
    layout: 'form',
    //isEditForm: true,
    autoScroll: true,
    
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'displayfield'
    },


    items: [
            
            {
			xtype: 'fieldset',
			defaults:{
				layout:'column',
				width: '100%'
			},
			
			
			items: [
					
					{
						
						xtype:'container',
						flex: 1,
						defaultType: 'textfield',
						defaults: {
							style: 'width: 100%'},
						layout: 'column',
						items: [
							{ 
								xtype: 'textfield',
								fieldLabel: 'Seleccione el activo',
								name: 'activoSeleccionado',
								
								style: 'width: 100%',
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
			
			
			},
            

			
            {
		    	xtype: 'fieldset',
		    	title: 'Inscripción',
		    	defaults:{
		    		layout:'column',
		    		width: '100%'
		    	},
        

		    	items: [
						
						{
							
							xtype:'container',
							flex: 1,
							defaultType: 'textfield',
							defaults: {
								style: 'width: 100%'},
							layout: 'column',
							items: [
									{ 
										style: 'width: 50%',
										xtype: 'comboestadoinscripcion',
										name: 'estadoInscripcion'
										
				                   	},
				                   	{ 
										style: 'width: 50%',
										xtype: 'comboofertantevendedor',
										name: 'cuentaInscripcion'
										
				                   	}
				                   					
							]
						}
						
					
					]
    	
    	
            },
            
            {
		    	xtype: 'fieldset',
		    	title: 'Posesión',
		    	defaults:{
		    		layout:'column',
		    		width: '100%'
		    	},
        

		    	items: [
						
						{
							
							xtype:'container',
							flex: 1,
							defaultType: 'textfield',
							defaults: {
								style: 'width: 100%'},
							layout: 'column',
							items: [
								{ 
									style: 'width: 33%',
									xtype: 'comboestadoposesion',
									name: 'estadoPosesion'
									
									},
									{ 
									style: 'width: 33%',
									xtype: 'combosino',
									labelWidth: 150,
									fieldLabel: 'Necesario lanzamiento',
									name: 'lanzamiento'
									
									},
									{ 
									style: 'width: 33%',
									xtype: 'comboofertantevendedor',
									name: 'cuentaPosesion'
									
								}	
							]
						}
						
					
					]
    	
    	
            },
            
            {
		    	xtype: 'fieldset',
		    	title: 'Evicción y vicios ocultos',
		    	defaults:{
		    		layout:'column',
		    		width: '100%'
		    	},
        

		    	items: [
						
						{
							
							xtype:'container',
							flex: 1,
							defaultType: 'textfield',
							defaults: {
								style: 'width: 100%'},
							layout: 'column',
							items: [
									{ 
										fieldLabel: '¿Renuncia al saneamiento por evicción y vicios ocultos?',
										name: 'eviccion',
										xtype: 'combosino',
										style: 'width: 50%',
										labelWidth: 450

									}
							]
						}
						
					
					]
    	
    	
            }
            
	]
    

});
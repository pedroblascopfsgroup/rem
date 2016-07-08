Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.economicas.CondicionesEconomicasDetalle', {	
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'condicioneseconomicasdetalle',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'condicioneseconomicasdetalleref',
    layout: 'form',
    isEditForm: true,
    autoScroll: true,
    
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'displayfield'
    },


    items: [
	          
            {
		    	xtype: 'fieldset',
		    	title: 'Fiscalidad',
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
										style: 'width: 20%',
										xtype: 'combotiposimpuesto',
										name: 'tipoImpuesto'
										
				                   	},
				                   	{ 
										style: 'width: 50%',
										fieldLabel: '¿Renuncia exención?',
										labelWidth: 140,
										xtype: 'combosino',
										name: 'renunciaExencion'
										
				                   	},
				                   	{
				                   		style: 'width: 30%',
										fieldLabel: 'Plusvalía',
						            	name:		'plusvalia'
				 					}						
							]
						}
						
					
					]
    	
    	
            },
            
            {
		    	xtype: 'fieldset',
		    	title: 'Gastos Operación',
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
				                   		style: 'width: 35%',
										fieldLabel: 'Notaría',
						            	name:		'gastosNotaria'
				 					},
				                   	{ 
										style: 'width: 35%',
										xtype: 'combotiposcargo',
										name: 'cargoNotaria'
										
				                   	},
				                   	{
				                   		style: 'width: 35%',
										fieldLabel: 'Otros',
						            	name:		'gastosOtros'
				 					},
				 					{ 
										style: 'width: 35%',
										xtype: 'combotiposcargo',
										name: 'cargoOtros'
										
				                   	}
							]
						}
						
					
					]
    	
    	
            },
            
            {
		    	xtype: 'fieldset',
		    	title: 'Pendientes',
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
									},
									{
				                   		style: 'width: 50%',
										labelWidth: 200,
										fieldLabel: 'Comunidad de propietarios',
						            	name:		'pendientesComunidad'
				 					},
				                   	{ 
										style: 'width: 50%',
										xtype: 'combotiposcargo',
										name: 'cargoComunidad'
										
				                   	},
				                   	{
				                   		style: 'width: 50%',
										labelWidth: 200,
										fieldLabel: 'Impuestos (IBI, basuras...)',
						            	name:		'pendientesImpuestos'
				 					},
				 					{ 
										style: 'width: 50%',
										xtype: 'combotiposcargo',
										name: 'cargoImpuestos'
										
				                   	},
				                   	{
				                   		style: 'width: 50%',
										fieldLabel: 'Otros',
						            	name:		'pendientesOtros'
				 					},
				 					{ 
										style: 'width: 50%',
										xtype: 'combotiposcargo',
										name: 'cargoOtros'
										
				                   	}
							]
						}
						
					
					]
    	
    	
            }
            
	]
    

});
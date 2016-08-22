Ext.define('HreRem.view.activos.comercial.ofertas.datosEconomicos.DatosEconomicosOferta', {	
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'datoseconomicosoferta',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'datoseconomicosofertaref',
    title: 'Datos Económicos',
    layout: 'form',
    isEditForm: true,


    	    items: [
    	          
    	            {
    			    	xtype: 'fieldset',
    			    	//title: 'Datos de la Oferta',
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
    									style: 'width: 50%'},
    								layout: 'column',
    								items: [
    										{ 
    											xtype: 'displayfield',
    											fieldLabel: 'Prescriptor',
    											name:		'prescriptorCodigo'
    					                   	},
    					                   	{ 
    					                   		xtype: 'displayfield',
    											fieldLabel: '',
    											name:		'prescriptorDescripcion'
    					                   	},
    					                   	{
    					                   		style: 'width: 100%',
    											fieldLabel: 'Tipo oferta',
    							            	name:		'tipoOferta'
    					 					},
    					                   	{
    											fieldLabel: 'Importe',
    							            	name:		'importe'
    					 					},
    					                   	{
    					 						xtype: 'displayfield',
    											fieldLabel: 'Contraoferta',
    							            	name:		'contraoferta'
    					 					},
    					                   	{
    											fieldLabel: 'Precio publicación',
    							            	name:		'precioPublicacion'
    					 					},
    					                   	{
    											fieldLabel: 'Precio mínimo',
    							            	name:		'precioMinimo'
    					 					},
    					                   	{
    											fieldLabel: 'Valor tasación',
    							            	name:		'valorTasacion'
    					 					},
    					                   	{
    											fieldLabel: 'Valor subjetivo',
    							            	name:		'valorSubjetivo'
    					 					}							
    								]
    							}
    							
    						
    						]
    	    	
    	    	
    	            }
    		]
    	    

    	});
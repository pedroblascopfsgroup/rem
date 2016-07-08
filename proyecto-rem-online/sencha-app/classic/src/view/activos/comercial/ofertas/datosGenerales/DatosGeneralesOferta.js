Ext.define('HreRem.view.activos.comercial.ofertas.datosGenerales.DatosGeneralesOferta', {	
    extend		: 'Ext.form.Panel',
    xtype		: 'datosgeneralesoferta',
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    reference: 'datosgeneralesofertaref',
    title: 'Datos Generales',
    layout: 'form',
    

    
    items: [
            
            {
		    	xtype: 'fieldset',
		    	title: 'Datos de la Oferta',
		    	defaults:{
		    		layout:'column',
		    		width: '100%'
		    	},
        

		    	items: [
						
						{
							
							xtype:'container',
							flex: 1,
							defaultType: 'displayfield',
							defaults: {
								style: 'width: 50%'},
							layout: 'column',
							items: [
									{ 
										fieldLabel: 'Código',
										name:		'idOferta'
				                   	},
				                   	{
										fieldLabel: 'Tipo',
						            	name:		'tipoOferta'
				 					},
				                   	{
										fieldLabel: 'Importe',
						            	name:		'importe'
				 					},
				                   	{
										fieldLabel: 'Estado',
						            	name:		'estado'
				 					}								
							]
						}
						
					
					]
    	
    	
            }
	]
    

});
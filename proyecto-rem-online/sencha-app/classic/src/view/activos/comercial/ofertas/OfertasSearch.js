Ext.define('HreRem.view.activos.comercial.ofertas.OfertasSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'ofertasSearch',
    isSearchForm	: true,
    reference: 'ofertasSearchform',
    title: 'Filtro de Ofertas',
    layout: 'column',
    
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield',
        style: 'width: 33%'
    },
    
    
    items: [
    {
        items: [
            { 
            	fieldLabel: 'Oferta',
            	name: 'idOferta'
            	
            },
            { 
            	fieldLabel: 'Ofertante',
            	name: 'fullName'
            		
            }
        ]
    },{
        items: [
        	{ 
            	xtype: 'combobox',
            	fieldLabel: 'Tipo',
            	name: 'idTipoOferta',
        		store : new Ext.data.SimpleStore({
					data : [[0, 'Venta'], 
					        [1, 'Alquiler']],
					id : 0,
					fields : ['id', 'descripcion']
				}),
	    		valueField : 'id',
	    		displayField : 'descripcion',
	    		triggerAction : 'all',
	    		editable : false
            },
            { 
            	xtype: 'combobox',
            	fieldLabel: 'Estado',
        		store : new Ext.data.SimpleStore({
					data : [[0, 'Verficar Datos Oferta'], 
					        [1, 'Verificar Resultado Visita'],
					        [2, 'Elaborar Propuesta a Comité'],
					        [3, 'Resolución Comité'],
					        [4, 'Resolución Oferta'],
					        [5, 'Contraofertar a Cliente']],
					id : 0,
					fields : ['id', 'descripcion']
				}),
	    		valueField : 'id',
	    		displayField : 'descripcion',
	    		triggerAction : 'all',
	    		editable : false
            }
        ]
    },{
        items: [
        	{
        
        		xtype: 'fieldset',
        		cls	 : 'fieldsetBase',
		        title: 'Importe',
		        defaults: {
		            layout: 'hbox'
		        },
		        items: [
		        		{ 
			            	xtype: 'combobox',
			        		store : new Ext.data.SimpleStore({
								data : [[0, '20.000'], 
								        [1, '40.000'],
								        [2, '60.000'],
								        [3, '80.000'],
								        [4, '100.000'],
								        [5, '200.000']],
								id : 0,
								fields : ['id', 'descripcion']
							}),
				    		valueField : 'id',
				    		displayField : 'descripcion',
				    		emptyText : 'Min...',
				    		triggerAction : 'all',
				    		editable : false
			            }, 
			            { 
			            	xtype: 'combobox',
			        		store : new Ext.data.SimpleStore({
								data : [[0, '20.000'], 
								        [1, '40.000'],
								        [2, '60.000'],
								        [3, '80.000'],
								        [4, '100.000'],
								        [5, '200.000']],
								id : 0,
								fields : ['id', 'descripcion']
							}),
				    		valueField : 'id',
				    		displayField : 'descripcion',
				    		emptyText : 'Max...',
				    		triggerAction : 'all',
				    		editable : false
			            }
		        ]
        	}
        ]
    }]
});
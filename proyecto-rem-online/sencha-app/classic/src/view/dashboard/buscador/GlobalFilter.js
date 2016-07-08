Ext.define('HreRem.view.dashboard.buscador.GlobalFilter', {
	extend		: 'Ext.form.Panel',
	xtype		: 'globalfilter',
    cls			: 'global-filter-panel',
    padding		: '20 10 20 10',
    border		: true,
    frame		: true,
    itemId		: 'panelGlobalFilter',
    floating:	true,
    shadow: true,
    reference: 'globalFilter',
    layout: 'column',
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield'
    },
    
   	controller 	: 'buscadorglobal',
    viewModel: {
        type: 'buscadorglobal'
    },
       	
    requires: ['Ext.form.RadioGroup'],
    
    items: [{
    	columnWidth: 0.42,
        items: [         
			{
            	xtype: 'combo',
            	name: 'en',
            	fieldLabel: 'Buscar en:',
				bind: {
					store: '{entidadesBusqueda}'
				},
				queryMode: 'local',
				displayField: 'descripcion',
				valueField: 'id'
            },
           	{
            	xtype: 'combo',
            	name: 'por',
            	fieldLabel: 'Buscar por:',
				bind: {
					store: '{camposBusqueda}'
				},
				queryMode: 'local',
				displayField: 'descripcion',
				valueField: 'id'
            }
           
        ]
    },{
    	    	columnWidth: 0.06,
    	    	height: 20,
    	    	cls: 'line-space'   	
    	
    },{
    	
    	columnWidth: 0.42,
        items: [ 
        	{        
	            xtype: 'radiogroup',
		        fieldLabel: 'Patrones de búsqueda',
		        columns: 1,
		        vertical: true,
		        items: [
		            { boxLabel: 'Igual a', name: 'rb', inputValue: '01' },
		            { boxLabel: 'Mayor que', name: 'rb', inputValue: '02' },
		            { boxLabel: 'Menor que', name: 'rb', inputValue: '03' },
		            { boxLabel: 'Algún valor parecido', name: 'rb', inputValue: '04' }
		        ]
			}
	       	  
                
       	]
    }]
});
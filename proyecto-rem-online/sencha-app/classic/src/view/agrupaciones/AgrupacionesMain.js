Ext.define('HreRem.view.agrupaciones.AgrupacionesMain', {
    extend: 'Ext.container.Container',
   // cls			: 'tabpanel-base',
    xtype: 'agrupacionesmain',
     layout : {
					type : 'vbox',
					align : 'stretch'
	},
    
    
        
    requires: [
        'HreRem.view.agrupaciones.AgrupacionesController',
        'HreRem.view.agrupaciones.AgrupacionesModel',
        'HreRem.view.agrupaciones.AgrupacionesSearch',
        'HreRem.view.agrupaciones.AgrupacionesList',
        'HreRem.view.agrupaciones.detalle.AgrupacionesDetalleMain'
    ],
    

    controller: 'agrupaciones',
    viewModel: {
        type: 'agrupaciones'
    },  



	items : [
			
					{
						xtype : 'agrupacionessearch',
						reference : 'agrupacionessearch'
					},
					{
						xtype : 'agrupacioneslist',
						reference : 'agrupacioneslist',
						flex: 1
					}

	]	

				

});


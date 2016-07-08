Ext.define('HreRem.view.activos.actuaciones.ActuacionTabMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'actuaciontabmain',
	iconCls		: 'x-fa fa-tasks',
	iconAlign	: 'left',
    cls			: 'panel-base tabPanel-segundo-nivel-con-cabecera',
    reference	: 'actuacionDetalle',    
	
	controller: 'actuacion',
    
    items: [
    	
    		{ 
    			xtype: 'cabeceraactivo'
    		},
    		{
    			xtype: 'tabpanel',
    			tabBar: {
            
				        items: [{xtype: 'tbfill'},{
				            xtype: 'button',
				            tipo: 'btnFavoritos',
				            isFavorito: false,
				            cssFavorito: 'fa-tasks',
				            cls: 'boton-favorito',
				            tipoId: 'actuacion',
				            handler: 'onClickBotonFavoritos'
				        }]
				 },
    			
    			items: [	    			
		    				
		    		{
		    			xtype: 'cabeceratabmain'
		    		},
		    		{
		    			xtype: 'tareastabmain',
		    			title: 'Tareas Activas',
		    			isHistorico: false
		    		},
		    		{
		    			xtype: 'tareastabmain',
		    			title: 'Historico de Tareas',
		    			isHistorico: true
		    		}
			    ]
    		}
        ]

});


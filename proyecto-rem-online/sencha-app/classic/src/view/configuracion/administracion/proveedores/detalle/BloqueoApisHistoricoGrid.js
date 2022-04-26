Ext.define('HreRem.view.configuracion.proveedores.detalle.BloqueoApisHistoricoGrid', {
	extend		: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype		: 'bloqueoApisHistoricoGrid',
    reference	: 'bloqueoApisHistoricoGrid',
    topBar		: false,
    addButton	: false,
    editOnSelect: false,
    requires: ['HreRem.model.BloqueoApisHistorico'],
    bind : {
    	store : '{storeBloqueoAPIs}'
    },	
    overflowY: 'scroll',

    initComponent: function () {
    	
    	
    	var me = this;
    	
   
    	
    	me.columns= [
    		 {   
  				text: HreRem.i18n('title.tipo.bloqueo'),
  	        	dataIndex: 'tipoBloqueo',
  	        	flex: 1
  	         },
    		 {   
 				text: HreRem.i18n('title.bloqueos'),
 	        	dataIndex: 'bloqueos',
 	        	flex: 1
 	        },
 	        {   
	        	text: HreRem.i18n('title.motivo.bloqueo'),
	        	dataIndex: 'motivoBloqueo',
	        	flex: 1.5
	        },
		    {   
				text: HreRem.i18n('title.fecha.bloqueo'),
	        	dataIndex: 'fechaBloqueo',
	            formatter: 'date("d/m/Y")',
	        	flex: 0.5
	        },
	        {   
	        	text: HreRem.i18n('title.usuario.bloqueo'),
	        	dataIndex: 'usuarioBloqueo',
	        	flex: 0.5
	        },
	        {   
	        	text: HreRem.i18n('title.motivo.desbloqueo'),
	        	dataIndex: 'motivoDesbloqueo',
	        	flex: 1.5
	        },
		    {   
				text: HreRem.i18n('title.fecha.desbloqueo'),
	        	dataIndex: 'fechaDesbloqueo',
	            formatter: 'date("d/m/Y")',
	        	flex: 0.5
	        },
	        {   
	        	text: HreRem.i18n('title.usuario.desbloqueo'),
	        	dataIndex: 'usuarioDesbloqueo',
	        	flex: 0.5
	        }
	    ],
	    
	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'bloqueoApisPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true,
	            overflowX: 'scroll',
	            bind: {
	            	store: '{storeBloqueoAPIs}'
	            }
	        }
	    ];
    
        me.callParent();

        
    }
    
   

});
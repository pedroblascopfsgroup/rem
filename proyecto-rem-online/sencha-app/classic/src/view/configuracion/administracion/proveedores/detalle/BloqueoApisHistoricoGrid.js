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

    initComponent: function () {
    	
    	
    	var me = this;
    	
   
    	
    	me.columns= [
    		 {   
 				text: HreRem.i18n('title.bloqueos'),
 	        	dataIndex: 'bloqueos',
 	        	flex: 1
 	        },
 	        {   
	        	text: HreRem.i18n('fieldlabel.gasto.motivo'),
	        	dataIndex: 'motivo',
	        	flex: 1.5
	        },
		    {   
				text: HreRem.i18n('header.fecha'),
	        	dataIndex: 'fecha',
	            formatter: 'date("d/m/Y")',
	        	flex: 1
	        },
	        {   
	        	text: HreRem.i18n('header.usuario'),
	        	dataIndex: 'usuario',
	        	flex: 1
	        }
	        
     
	    ]; 	
    
        me.callParent();

        
    }
    
   

});
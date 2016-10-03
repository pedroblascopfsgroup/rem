Ext.define('HreRem.view.gastos.SeleccionTrabajosGastoList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'selecciontrabajosgastolist',
	bind: {
		store: '{seleccionTrabajosGasto}'
	},
	
    initComponent: function () {
     	
     	var me = this;
     	me.setTitle(HreRem.i18n('title.listado.trabajos'));
	     
	    me.columns = [
	    	
	        
  				{
	            	text	 : HreRem.i18n('header.numero.trabajo'),
	                flex	 : 1,
	                dataIndex: 'numTrabajo'
	            },                 
		        {
		           	text: HreRem.i18n('header.subtipo'),
		            flex	 : 1,
		            dataIndex: 'descripcionSubtipo'
		        },
	            {   
	            	text	 : HreRem.i18n('header.fecha.peticion'),
	            	flex: 1,
	                dataIndex: 'fechaSolicitud',
			        formatter: 'date("d/m/Y")'					
			    }

	        ];
	        
	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            displayInfo: true,
	            bind: {
	                store: '{seleccionTrabajosGasto}'
	            }
	        }
	    ];
	    
	    me.callParent();
	    
    }
    
});
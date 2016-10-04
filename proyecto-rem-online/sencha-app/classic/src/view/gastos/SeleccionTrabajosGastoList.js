Ext.define('HreRem.view.gastos.SeleccionTrabajosGastoList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'selecciontrabajosgastolist',
    requires: ['Ext.selection.CheckboxModel'],
	bind: {
		store: '{seleccionTrabajosGasto}'
	},
	scrollable: 'y',
	
	selModel : Ext.create('Ext.selection.CheckboxModel', {
    	checkOnly: true
	}),
	
    initComponent: function () {
     	
     	var me = this;
     	me.setTitle(HreRem.i18n('title.listado.trabajos'));
	    me.removeCls('shadow-panel');
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
	            	text	 : HreRem.i18n('header.fecha.solicitud'),
	            	flex: 1,
	                dataIndex: 'fechaSolicitud',
			        formatter: 'date("d/m/Y")'					
			    },
	            {   
	            	text	 : HreRem.i18n('header.fecha.ejecutado'),
	            	flex: 1,
	                dataIndex: 'fechaEjecutado',
			        formatter: 'date("d/m/Y")'					
			    },
			    {   
	            	text	 : HreRem.i18n('header.fecha.cierre.economico'),
	            	flex: 1,
	                dataIndex: 'fechaCierreEconomico',
			        formatter: 'date("d/m/Y")'					
			    },
			    {
		           	text: HreRem.i18n('header.importe'),
		            flex	 : 1,
		            dataIndex: 'importeTotal',
		            renderer: function(value) {
			            return Ext.util.Format.currency(value);
			        }
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
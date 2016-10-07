Ext.define('HreRem.view.administracion.gastos.ProvisionesList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'provisioneslist',

    bind: {
        store: '{provisiones}'
    },
    listeners : {
    	rowclick: 'onRowClickProvisionesList'
    },
    
    loadAfterBind: false,
    initComponent: function () {
        
        var me = this;        
        me.setTitle(HreRem.i18n("title.listado.provisiones"));
        me.columns= [
        
		        {	        	
		            dataIndex: 'numProvision',
		            text: HreRem.i18n('header.numero.propuesta'),
		            flex: 1		        	
		        },
		        {	        	
		            dataIndex: 'estadoProvisionDescripcion',
		            text: HreRem.i18n('header.estado'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'gestoria',
		            text: HreRem.i18n('header.gestoria'),
		            flex: 1		
		        },
		        {	        	
		        	dataIndex: 'fechaAlta',
		            text: HreRem.i18n('header.fecha.alta'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {	        	
		            dataIndex: 'fechaEnvio',
		            text: HreRem.i18n('header.fecha.envio'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {	        	
		            dataIndex: 'fechaRespuesta',
		            text: HreRem.i18n('header.fecha.respuesta'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{provisiones}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});


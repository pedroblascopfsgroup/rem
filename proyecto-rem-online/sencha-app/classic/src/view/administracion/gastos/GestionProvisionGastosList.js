Ext.define('HreRem.view.administracion.gastos.GestionProvisionGastosList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'gestionprovisiongastoslist',

    bind: {
        store: '{provisionGastos}'
    },
    plugins: 'pagingselectpersist',
    loadAfterBind: false,
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.listado.gastos.provision'));
        
        me.listeners = {	    	
    		rowdblclick: 'onClickAbrirGastoProveedor'
    	};
        
        me.columns= [
	       			{   
						text: HreRem.i18n('header.id.gasto'),
			        	dataIndex: 'id',
			        	flex: 1,
			        	hidden: true,
			        	hideable: false
			       	},
			       	{   
			        	dataIndex: 'numGastoHaya',
			        	flex: 1,
			        	hidden: true,
			        	hideable: false
			       	},
                     {
						text: HreRem.i18n('header.num.factura.liquidacion'),
						dataIndex: 'numFactura',
						flex: 1
				   },
                     
                     {
                    	 text: HreRem.i18n('header.tipo.gasto'),
                    	 flex: 1,
                    	 dataIndex: 'tipo'
                     },
                     {
                    	 text: HreRem.i18n('header.subtipo.gasto'),
                    	 flex: 1,
                    	 dataIndex: 'subtipo'
                     },
                     {
                    	 text: HreRem.i18n('header.concepto.gasto'),
                    	 flex: 1,
                    	 dataIndex: 'concepto'
                     },
                     {
                    	 text: HreRem.i18n('header.proveedor.gasto'),
                    	 flex: 1,
                    	 dataIndex: 'codigoProveedor'
                     },
                     {
                     	text: HreRem.i18n('header.fecha.emision.gasto'),
                     	flex: 1,
                    	dataIndex: 'fechaEmision',
                    	formatter: 'date("d/m/Y")'	
                     },
                     {
                    	 text: HreRem.i18n('header.importe.gasto'),
                    	 flex: 1,
                    	 dataIndex: 'importeTotal'
                     },
                     {
                     	text: HreRem.i18n('header.fecha.tope.pago.gasto'),
                     	flex: 1,
                    	dataIndex: 'fechaTopePago',
                    	formatter: 'date("d/m/Y")'	
                     },
                     {
                     	text: HreRem.i18n('header.fecha.pago.gasto'),
                     	flex: 1,
                    	dataIndex: 'fechaPago',
                    	formatter: 'date("d/m/Y")'	
                     },
                     {
                    	 text: HreRem.i18n('header.periodicidad.gasto'),
                    	 flex: 1,
                    	 dataIndex: 'periodicidad'
                     },
                     {
                    	 text: HreRem.i18n('header.destinatario.gasto'),
                    	 flex: 1,
                    	 dataIndex: 'destinatario'
                     }
        ];
        
       	me.selModel = {
          selType: 'checkboxmodel'
      	}; 
      	
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{provisionGastos}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});


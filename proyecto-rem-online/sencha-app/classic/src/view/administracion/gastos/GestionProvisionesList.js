Ext.define('HreRem.view.administracion.gastos.GestionProvisionesList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'gestionprovisioneslist',
    bind: {
        store: '{provisiones}'
    },
    listeners : {
    	rowclick: 'onRowClickProvisionesList'
    },
    
    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.agrupacion.gasto.listado.provisiones"));
        me.columns= [
        
		        {	        	
		            dataIndex: 'numProvision',
		            text: HreRem.i18n('header.agrupacion.gasto.numero'),
		            flex: 0.5		        	
		        },
		        {	        	
		            dataIndex: 'estadoProvisionDescripcion',
		            text: HreRem.i18n('header.agrupacion.gasto.estado'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'nombreProveedor',
		            text: HreRem.i18n('header.agrupacion.gasto.gestoriaResponsable'),
		            flex: 1		
		        },   
		        {	        	
		            dataIndex: 'nifPropietario',
		            text: HreRem.i18n('header.agrupacion.gasto.nifprop'),
		            flex: 0.5		
		        },
		        {	        	
		            dataIndex: 'nomPropietario',
		            text: HreRem.i18n('header.agrupacion.gasto.nomprop'),
		            flex: 1.5		
		        },
		        {	        	
		            dataIndex: 'descCartera',
		            text: HreRem.i18n('header.agrupacion.gasto.cartera'),
		            flex: 0.5		
		        },
		        {	        	
		            dataIndex: 'importeTotal',
		            text: HreRem.i18n('header.agrupacion.gasto.importeTotal'),
		            flex: 0.5		
		        },
		        {	        	
		        	dataIndex: 'fechaAlta',
		            text: HreRem.i18n('header.agrupacion.gasto.fecha.alta'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {	        	
		            dataIndex: 'fechaEnvio',
		            text: HreRem.i18n('header.agrupacion.gasto.fecha.envio'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {	        	
		            dataIndex: 'fechaRespuesta',
		            text: HreRem.i18n('header.agrupacion.gasto.fecha.respuesta'),
		            flex: 0.5,
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


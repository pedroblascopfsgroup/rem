Ext.define('HreRem.view.administracion.gastos.GestionProvisionesList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'gestionprovisioneslist',
    requires: ['HreRem.view.common.CheckBoxModelBase', 'HreRem.ux.plugin.PagingSelectionPersistence'],
    bind: {
        store: '{provisiones}'
    },
    loadAfterBind: false,    
    plugins: 'pagingselectpersist',
    listeners : {
    	rowclick: 'onRowClickProvisionesList'
    },
    
    
    initComponent: function () {
        
        var me = this;
        var configAutorizarContaAgruGastosBtn = {text: HreRem.i18n('btn.autorizar.contabilidad'), cls:'tbar-grid-button', itemId:'autorizarContAgruGastosBtn', handler: 'onClickAutorizarContabilidadAgrupacion', disabled: true, secFunPermToRender: 'BOTONES_GASTOS_CONTABILIDAD'};
        var separador = {xtype: 'tbfill'};
        
        me.tbar = {
        		xtype: 'toolbar',
        		dock: 'top',
        		items: [separador, configAutorizarContaAgruGastosBtn]
    	};
        
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
		            },
		            items:[
		            	{
		            		xtype: 'tbfill'
		            	},
		                {
		                	xtype: 'displayfieldbase',
		                	itemId: 'displaySelection',
		                	fieldStyle: 'color:#0c364b; padding-top: 4px'
		                }
		            ]
		        }
		];
    	
        //me.selModel = Ext.create('HreRem.view.common.CheckBoxModelBase');  
        
    	me.callParent();   
    	
    	me.getSelectionModel().on({
        	'selectionchange': function(sm,record,e) {
        		me.fireEvent('persistedsselectionchange', sm, record, e, me, me.getPersistedSelection());
        	}

        	/*'selectall': function(sm) {
        		me.getPlugin('pagingselectpersist').selectAll();
        	},

        	'deselectall': function(sm) {
        		me.getPlugin('pagingselectpersist').deselectAll();
        	}*/
        });
    	
    },

    getPersistedSelection: function() {
    	var me = this;
    	return me.getPlugin('pagingselectpersist').getPersistedSelection();
    }
    
});


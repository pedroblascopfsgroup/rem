Ext.define('HreRem.view.administracion.juntas.GestionJuntasList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'gestionjuntaslist',
    requires: ['HreRem.view.common.CheckBoxModelBase', 'HreRem.ux.plugin.PagingSelectionPersistence'],
    bind: {
        store: '{juntas}'
    },
    loadAfterBind: false,    
    plugins: 'pagingselectpersist',
    listeners : {
    	rowdblclick: 'onRowClickJuntasList'
    },
    
    
    initComponent: function () {
        
        var me = this;
        me.setTitle(HreRem.i18n("title.agrupacion.juntas.listado"));       

        me.columns= [
        
		        {	
		        	dataIndex: 'codProveedor',
		            text: HreRem.i18n('header.agrupacion.juntas.proveedor.numero'),
		            flex: 0.5		        	
		        },		        
		        {	
		            dataIndex: 'proveedor',
		            text: HreRem.i18n('header.agrupacion.juntas.proveedor.nombre'),
		            flex: 1.5		
		        },		       
		        {	        	
		        	dataIndex: 'fechaJunta',
		            text: HreRem.i18n('header.agrupacion.juntas.fecha.alta'),
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
		                store: '{juntas}'
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


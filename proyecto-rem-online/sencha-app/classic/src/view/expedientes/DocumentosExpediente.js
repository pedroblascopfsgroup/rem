Ext.define('HreRem.view.expedientes.DocumentosExpediente', {
    extend: 'Ext.form.Panel',
    xtype: 'documentosexpediente',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'documentosexpedienteref',
    scrollable	: 'y',

    initComponent: function () {
    	
        var me = this;
        me.setTitle(HreRem.i18n('title.documentos'));
    	var items= [
    	
	          {			
				    xtype		: 'gridBase',
				    topBar		: true,
				    features: [{ftype:'grouping'}],
				    reference: 'listadoDocumentosExpediente',
					cls	: 'panel-base shadow-panel',
					bind: {
						store: '{storeDocumentosExpediente}'
					},
					/*buttonSecurity: {
						secFunPermToEnable : 'TRABAJO_DOCUMENTOS_ADD'
					},*/
					columns: [
					
						{
					        xtype: 'actioncolumn',
					        width: 30,	
					        hideable: false,
					        items: [{
					           	iconCls: 'ico-download',
					           	tooltip: HreRem.i18n("tooltip.download"),
					            handler: function(grid, rowIndex, colIndex) {
					                var grid = me.down('gridBase'),
					                record = grid.getStore().getAt(rowIndex);
					               
					                grid.fireEvent("download", grid, record);					                
			            		}
					        }]
			    		},
					    {   text: HreRem.i18n('header.nombre'),
				        	dataIndex: 'nombre',
				        	flex: 1
				        },
				        {   text: HreRem.i18n('header.tipo'),
				        	dataIndex: 'descripcionTipo',
				        	flex: 1,
				        	hidden: true
				        },
				        {   text: HreRem.i18n('header.subtipo'),
				        	dataIndex: 'descripcionSubtipo',
				        	flex: 1
				        },
						{
				            text: HreRem.i18n('header.descripcion'),
				            dataIndex: 'descripcion',
				            flex: 1
				        },
				        {   text: HreRem.i18n('header.tamano'),
				        	dataIndex: 'tamanyo',
				        	flex: 1,
				        	renderer: function(value) {
				        		if(Ext.isEmpty(value)) {
				        			return value;
				        		} else {
				        			return value + " bytes";
				        		}
				        		return
				        	}
				        },
				        {   text: HreRem.i18n('header.tipo.archivo'),
				        	dataIndex: 'contentType',
				        	flex: 1,
				        	hidden: true
				        },
				        {   text: HreRem.i18n('header.fecha.subida'),
				        	dataIndex: 'fechaDocumento',
				        	flex: 1,
				        	formatter: 'date("d/m/Y")'
				        },
				        {	
				        	text: HreRem.i18n('header.gestor'),
				        	dataIndex: 'gestor',
				        	flex: 1					        	
				        },
				        {   text: HreRem.i18n('header.entidad.aplica'),
				        	dataIndex: 'entidad',
				        	flex: 1,
				        	hidden: true,
				        	hideable: false
				        }
				       	        
				    ]
				
	          }
    	];
    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }

});
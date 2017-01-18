Ext.define('HreRem.view.activos.detalle.DocumentosActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'documentosactivo',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'documentosactivoref',
    scrollable	: 'y',
    requires	: ['HreRem.model.AdjuntoActivo', 'Ext.data.Store'],
	listeners	: { 	
    	boxready: function (tabPanel) { 
    		tabPanel.evaluarEdicion();
    	}
    },

    initComponent: function () {
    	 var me = this;
        me.setTitle(HreRem.i18n('title.documentos'));

    	var items= [
    	         {
				    xtype		: 'gridBase',
				    topBar		: true,
				    features: [{ftype:'grouping'}],
				    reference: 'listadoDocumentosActivo',
					cls	: 'panel-base shadow-panel',
					bind: { 
						store: '{storeDocumentosActivo}'
					},
					loadCallbackFunction: {
					    callback: function(records, operation, success) {
					        try {
					    		var response = Ext.JSON.decode(operation.getResponse().responseText);    				    		
					    		if (response.success == "false")  {
					    			if(!Ext.isEmpty(response.errorMessage)) {
					    				me.fireEvent("errorToast", response.errorMessage);
					    			} else {
					    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					    			}
					    		}
					    	}catch(err) {}
					    },
					    scope: this
					},
					buttonSecurity: {
						secFunPermToEnable : 'ACTIVO_DOCUMENTOS_ADD'
					},
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
					    {   text: HreRem.i18n('header.nombre.documento'),
				        	dataIndex: 'nombre',
				        	flex: 1
				        },
				        {   text: HreRem.i18n('header.tipo'),
				        	dataIndex: 'descripcionTipo',
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
				        {   
				        	text: HreRem.i18n('header.tipo.archivo'),
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
  			grid.getStore().load(grid.loadCallbackFunction);
  		});
    },

    //HREOS-846 Si NO esta dentro del perimetro, ocultamos los botones de agregar/eliminar
    evaluarEdicion: function() {    	
		var me = this;

		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false") {
			me.down('[xtype=toolbar]').hide();
		}
    }
});
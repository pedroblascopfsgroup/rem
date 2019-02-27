Ext.define('HreRem.view.activos.detalle.DocumentosActivoPromocion', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'documentosactivopromocion', 
    reference	: 'documentosactivopromocionref',
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    scrollable	: 'y',

    initComponent: function () {
    	 var me = this;
        me.setTitle(HreRem.i18n('fieldlabel.documentacion.promocion'));

    	var items= [
    	         {
				    xtype		: 'gridBase',
				    topBar		:  true,
				    removeButton: false,
				    features: [{ftype:'grouping'}],
				    reference: 'listadoDocumentosPromocion',
					cls	: 'panel-base shadow-panel',
					bind: { 
						store: '{storeDocumentosActivoPromocion}'
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
					columns: [
					
						{
					        xtype: 'actioncolumn',
					        width: 30,	
					        hideable: false,
					        items: [{
					           	iconCls: 'ico-download',
					           	tooltip: HreRem.i18n("tooltip.download"),
					            handler: function(grid, rowIndex, colIndex) {
					            	var url= $AC.getRemoteUrl('activo/getLimiteArchivo');
					        		var data;
					        		Ext.Ajax.request({
					        		     url: url,
					        		     success: function(response, opts) {
					        		    	 data = Ext.decode(response.responseText);
					        		    	 if(data.sucess == "true"){
					        		    		 var grid = me.down('gridBase');
					        		    		 var limite = data.limite;
					        		    		 var record = grid.getStore().getAt(rowIndex);
					        		    		 
					        		    		 if(record.get('tamanyo')/1024/1024 <= limite){
					        		    			 grid.fireEvent("download", grid, record);
					        		    		 }else{
					        		    			 grid.fireEvent("errorToast", "No se puede descargar ficheros mayores de "+limite+"Mb.");
					        		    		 }
					        		    	 }					        		         
					        		     },
					        		     failure: function(response) {
					        		    	 grid.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					        		     }
					        		 });					                
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
    }

 
});
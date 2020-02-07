Ext.define('HreRem.view.activos.detalle.DocumentosTributosGrid', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'documentostributosgrid',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'documentostributosgridref',
    scrollable	: 'y',
	listeners	: { 	
    	boxready: function (tabPanel) {
    		var me = this;
    		me.down('[xtype=toolbar]').items.items[0].setDisabled(true);
    	}
    },
    idTributo: null,
    idActivo: null,

    initComponent: function () {
    	 var me = this;
    	 me.setTitle(HreRem.i18n('fieldlabel.documentacion.tributos'));

    	var items= [
    	         {
				    xtype		: 'gridBase',
				    topBar		: true,//$AU.userHasFunction('EDITAR_TAB_ACTIVO_DOCUMENTOS'),
				    features: [{ftype:'grouping'}],
				    reference: 'listadoDocumentosTributo',
					cls	: 'panel-base shadow-panel',
					bind: { 
						store: '{storeDocumentosTributos}'
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
					},/*
					buttonSecurity: {
						secFunPermToEnable : 'ACTIVO_DOCUMENTOS_ADD'
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
					            	var url= $AC.getRemoteUrl('activo/getLimiteArchivo');
					        		var data;
					        		Ext.Ajax.request({
					        		     url: url,
					        		     success: function(response, opts) {
					        		    	 data = Ext.decode(response.responseText);
					        		    	 if(data.sucess == "true"){
					        		    		 var grid = me.down('gridBase');
					        		    		 var limite = data.limite;
					        		    		 var record = grid.getView().lastFocused.record;
					        		    		 
					        		    		 if(!Ext.isDefined(record.get('tamanyo')) || record.get('tamanyo') == null || limite == 0 || record.get('tamanyo')/1024/1024 <= limite){
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
				        	}
				        },
				        {   text: HreRem.i18n('header.fecha.subida'),
				        	dataIndex: 'createDate',
				        	flex: 1,
				        	formatter: 'date("d/m/Y")'
				        },
				        {	
				        	text: HreRem.i18n('header.gestor'),
				        	dataIndex: 'gestor',
				        	flex: 1					        	
				        }
				        
				    ],
				    dockedItems: [
				        {
				            xtype: 'pagingtoolbar',
				            dock: 'bottom',
				            displayInfo: true,
				            bind: {
				                store: '{storeDocumentosTributos}'
				            }
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
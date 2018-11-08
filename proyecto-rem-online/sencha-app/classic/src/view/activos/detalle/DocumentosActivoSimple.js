Ext.define('HreRem.view.activos.detalle.DocumentosActivoSimple', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'documentosactivosimple',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'documentosactivosimpleref',
    scrollable	: 'y',
	listeners	: { 	
    	boxready: function (tabPanel) {
    		tabPanel.evaluarEdicion();
    	}
    },

    initComponent: function () {
    	 var me = this;
    	 me.setTitle(HreRem.i18n('fieldlabel.documentacion.activos'));

    	var items= [
    	         {
				    xtype		: 'gridBase',
				    topBar		: $AU.userHasFunction('EDITAR_TAB_ACTIVO_DOCUMENTOS'),
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

					                var record = grid.getRecord(rowIndex);
					                var grid = me.down('gridBase');
					                
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
		var allow = true;
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false") {
			//me.down('[xtype=toolbar]').hide();
			allow = false;
		}
		//HREOS-1964: Restringir los activos financieros (asistidos) para que solo puedan ser editables por los perfiles de IT y Gestoria PDV
		if(allow){
			if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
				allow = (($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
					 && $AU.userHasFunction('EDITAR_TAB_ACTIVO_DOCUMENTOS'));
			}else{
				allow = $AU.userHasFunction('EDITAR_TAB_ACTIVO_DOCUMENTOS');
			}
		}
		if(!allow){
			me.down('[xtype=toolbar]').hide();
		}
    }
    
    
});
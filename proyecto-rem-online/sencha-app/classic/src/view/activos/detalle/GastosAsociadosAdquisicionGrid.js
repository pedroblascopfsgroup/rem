Ext.define('HreRem.view.activos.detalle.GastosAsociadosAdquisicionGrid', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'gastosasociadosadquisiciongrid',
    reference	: 'gastosasociadosadquisiciongridref',
    topBar		: true,
    addButton	: true,
    requires	: ['HreRem.model.GastoAsociadoAdquisicionModel'],    
    editOnSelect: true,	
    listeners: {
    	boxready: function() {
    		var me = this;
    		me.setStore(Ext.create('Ext.data.Store', {
				model: 'HreRem.model.GastoAsociadoAdquisicionModel',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'activo/getListGastosAsociadosAdquisicion',
					extraParams: {
						id: me.lookupViewModel('activodetalle').get('activo.id')
					}
				},
				listeners:{
    		          load:function(){
    		        	  	me.relayEvents(this,['storeloadsuccess']);
    		               this.fireEvent('storeloadsuccess');
    		          }
    		     }
			}).load());
    		
    	},
    	storeloadsuccess: function() {
    		var me = this;
            me.lookupController().cargarCamposCalculados(me);
       }
    	
    },
    bind: {
    	store: '{storeGastosAsociadosAdquisicion}'
    },
    
    initComponent: function () {
    	
    	var me = this;
    	if(!Ext.isEmpty(me.getStore()))
        	me.getStore().load();
    	
     	me.deleteSuccessFn = function(){
    		this.getStore().load()
    		this.setSelection(0);
    	};
     	
     	me.deleteFailureFn = function(){
    		this.getStore().load()
    	};
     	
    	
    	me.topBar = ($AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['GESTORIA_ADMISION']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']));
    	me.editOnSelect = ($AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['GESTORIA_ADMISION']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']));

		
        me.columns = [
        		/*{
	        		iconCls: 'ico-download'
					//tooltip: HreRem.i18n("tooltip.download")
        		},*/
        		{
                    text : 'activoid',
                    dataIndex : 'activoId',
                    hidden: true,
                    flex : 1
                 },{
                    text : 'ID',
                    dataIndex : 'id',
                    hidden: true,
                    flex : 1
                 },{
                    text : HreRem.i18n('header.fecha.alta'),
                    dataIndex : 'fechaAltaGastoAsociado',
                    flex : 1,
					formatter: 'date("d/m/Y")',
					readOnly: true
                 }, {
                    text : HreRem.i18n('fieldlabel.gastos.asociados.gestor.alta'),
                    dataIndex : 'usuarioGestordeAlta',
                    flex : 1,
                    readOnly: true
                 }, {
                    text : HreRem.i18n('header.gastos.asociados.adquisicion.tipo.gasto'),
                    flex : 1,
                    dataIndex : 'gastoAsociado',
                    editor: {		        		
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'tipoGastoAsociado'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo',
    					allowBlank: false					
		        	}
		        	},{
                	text : HreRem.i18n('fieldlabel.gastos.asociados.fecha.solicitud'),
                    flex : 1,
                    dataIndex : 'fechaSolicitudGastoAsociado',
					formatter: 'date("d/m/Y")',
					editor: {
		        		xtype: 'datefield'
		        	}
                 }, {
                    text : HreRem.i18n('fieldlabel.fecha.pago'),
                    flex : 1,
                    dataIndex : 'fechaPagoGastoAsociado',
					formatter: 'date("d/m/Y")',
					editor: {
		        		xtype: 'datefield'					
		        	}
                 }, {
                    text : HreRem.i18n('fieldlabel.gastos.asociados.importe'),
                    flex : 1,
                    dataIndex : 'importe'
                 }, {
                    text : HreRem.i18n('fieldlabel.gastos.asociados.factura'),
                    flex : 3,
                    align: 'right',
                    dataIndex : 'factura',
                    xtype: 'actioncolumn',
                    items: [							
							{
                 				xtype: 'button',
                  				handler: 'onClickDescargarFacturaGastoAsociado',
                  				isDisabled: function(view, rowIndex, colIndex, item, record ) {
					            	if (!Ext.isEmpty(record.get("factura"))) {
					            		return false;
					            	}
					            	return true;		            	
			            		},
			            		getClass: function(v, metadata, record ) {					            	
					            	return 'margen-derecha ico-download';					            
					            }
              		 		},
              		 		{
                 				xtype: 'button',                  				
                  				handler: 'onClickCargarFacturaGastoAsociado',
                  				isDisabled: function(view, rowIndex, colIndex, item, record ) {
					            	if (Ext.isEmpty(record.get("factura"))) {
					            		return false;
					            	}
					            	return true;		            	
			            		},
			            		getClass: function(v, metadata, record ) {					            	
					            	return 'margen-derecha ico-upload-documento';					            
					            }
              		 		},
              		 		{
                 				xtype: 'button',
                  				handler: 'onClickBorrarFacturaGastoAsociado',
                  				isDisabled: function(view, rowIndex, colIndex, item, record ) {
					            	if (!Ext.isEmpty(record.get("factura"))) {
					            		return false;
					            	}
					            	return true;		            	
			            		},
			            		getClass: function(v, metadata, record ) {					            	
					            	return 'ico-delete-documento';					            
					            }
              		 		}
          		 	],
          		 	renderer: function(value, metadata, record) {
          		 		var tipo = null;
          		 		if(!Ext.isEmpty(record.get("tipoFactura"))){
          		 			tipo = record.get("tipoFactura");
          		 		}
          		 		if(Ext.isEmpty(record.get("factura"))) {
			        		return '<div style="float:left; margin:3px; font-size: 11px; line-height: 1em;"></div>'
			        	} else {
			        		return '<div style="float:left; margin:3px; font-size: 11px; line-height: 1em;"><strong>'+value+'</strong> ('+tipo+')</div>'
			        	}
		        		
		        	}
			        
				},
				{
                    text : HreRem.i18n('fieldlabel.gastos.asociados.Observaciones'),
                    flex : 1,
                    dataIndex : 'observaciones',
                    editor: {
		        		xtype: 'textareafield'
		        	}
             	}

        ];
    
        me.dockedItems = [
        	{
        		xtype : 'pagingtoolbar',
                dock : 'bottom',
                displayInfo : true,
                bind: {
                	store: '{storeGastosAsociadosAdquisicion}'
                }
        	}
        ];
        

        me.callParent();
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load(grid.loadCallbackFunction);
  		});
    },
    
    
    onAddClick: function(btn){
    	
		var me = this;

		var idActivo = me.lookupViewModel('activodetalle').get('activo.id');
 		Ext.create("HreRem.view.activos.detalle.AnyadirGastoAsociadoAdquisicion", {idActivo: idActivo}).show();

   },
    
    editFuncion: function(editor, context){
 		var me= this;
 		var id = context.record.data.id;
		var activoId = context.record.data.activoId;
		me.mask(HreRem.i18n("msg.mask.espere"));
		
		
			if (me.isValidRecord(context.record) ) {		
			
      		context.record.save({
      				
                  params : {
							id: id, activoId: activoId
						},
						
                  success: function (a, operation, c) {
				
                      if (context.store.load) {
                      	context.store.load();
                      }
                      me.unmask();
                      me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));																			
						me.saveSuccessFn();											
                  },
                  
				failure: function (a, operation) {
                  	try {
                  		
                  		var response = Ext.JSON.decode(operation.getResponse().responseText)
                  		
                  	}catch(err) {}
                  	
                  	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msgError)) {
                  		me.fireEvent("errorToast", response.msgError);
                  	} else {
                  		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                  	}
                  	//grid.getStore().load();
                  	me.up('saneamientoactivo').funcionRecargar();
					me.unmask();
						
                  }
               });                            
      		me.disablePagingToolBar(false);
      		me.getSelectionModel().deselectAll();
      		editor.isNew = false;
			}
      
   },
    
       onDeleteClick : function() {
		var me = this;
		var grid = me;
		
		var id = me.getSelection()[0].getData().id;
		var activoId = me.getSelection()[0].getData().activoId;
		Ext.Msg.show({
			title : HreRem.i18n('title.mensaje.confirmacion'),
			msg : HreRem.i18n('msg.desea.eliminar'),
			buttons : Ext.MessageBox.YESNO,
			fn : function(buttonId) {
				if (buttonId == 'yes') {
					grid.mask(HreRem.i18n("msg.mask.loading"));
					var url = $AC.getRemoteUrl('activo/deleteGastoAsociadoAdquisicion');
					Ext.Ajax.request({
						url : url,
						method : 'POST',
						params : {
							id: id, activoId: activoId
						},

						success : function(response, opts) {
							grid.getStore().load();
							me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
							grid.unmask();
							
						},
						failure : function(record, operation) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
							grid.unmask();
						},
						callback : function(record, operation) {
							grid.unmask();
						}
					});
				}
			}
		});

	}

});
Ext.define('HreRem.view.activos.detalle.HistoricoTramitacionTituloGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'historicotramitaciontitulogrid',
	topBar		: true,
	targetGrid	: 'historicoTramitacionTitulo',
	editOnSelect: true,
	disabledDeleteBtn: false,
	sortableColumns: false,
	requires	: ['HreRem.model.HistoricoTramtitacionTituloModel'],
    bind: {
        store: '{storeHistoricoTramitacionTitulo}'
    },
    listeners:{
    	beforeEdit: 'validarEdicionHistoricoTitulo',
    	containermouseover: function () {
    		var me = this;
    		me.evaluarBotonAdd();
    	},
    	itemmouseenter: function () {
    		var me = this;
    		me.evaluarBotonAdd();
    	} 
    },

    initComponent: function () {
     	var me = this;
		me.columns = [
				{
					dataIndex: 'idHistorico',
					text: 'idHistorico',
					editor: {
		        		xtype: 'textareafield'
		        	},
					hidden: true
				},
		        {
		            dataIndex: 'fechaPresentacionRegistro',
		            text: HreRem.i18n('fieldlabel.historico.tramitacion.titulo.fechapresentacion'),
		            editor: {
		        		xtype: 'datefield',
		        		reference: 'fechaPresentacionRegistro',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		maxValue: new Date()
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {	
		            dataIndex: 'fechaCalificacion',
		            text: HreRem.i18n('fieldlabel.historico.tramitacion.titulo.fechacalificacion'), 
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		onTriggerClick: function (){
		        			var me = this;
		        			me.lookupController().checkDateInterval(me);
		        		},
		        		maxValue: new Date() 
		        		
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaInscripcion',
		            text: HreRem.i18n('fieldlabel.historico.tramitacion.titulo.fechainscripcion'),
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		reference: 'fechaInscripcion',
		        		onTriggerClick: function (){
		        			var me = this;
		        			me.lookupController().checkDateInterval(me);
		        		},
		        		listeners:{
		        			afterrender: 'usuarioLogadoPuedeEditar'
		        		},
		        		maxValue: new Date()
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        
		        {
		            dataIndex: 'estadoPresentacion',
		            text: HreRem.i18n('fieldlabel.historico.tramitacion.titulo.estado'), 
		            editor: {
						xtype: 'combobox',
						allowBlank: false,
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'EstadoPresentacion'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo',
    					listeners:{
    						change: 'onChangeEstadoHistoricoTramitacionTitulo'
    					}
					},
		            flex: 1
		            
		        },		        
		        {
		            dataIndex: 'observaciones',
		            text: HreRem.i18n('fieldlabel.historico.tramitacion.titulo.observaciones'), 
		            editor: {
		        		xtype: 'textareafield'
		        	},
		            flex: 1
		         
		        }
		    ];
		

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{storeHistoricoTramitacionTitulo}'
		            }
		        }
		    ];
		    

		    me.callParent();
		    me.addListener('afterbind', function(grid) {
					me.evaluarBotonAdd();
			});
		    me.addListener('selectionchange', function(grid, records) {
	        	me.onGridBaseSelectionChange(grid, records);
	        	me.evaluarBotonRemove(grid, records);
	        	me.evaluarBotonAdd();
	        });
		    
		    me.addListener('canceledit', function(editor){
				me.disableAddButton(false);
				me.disablePagingToolBar(false);
	        	me.getSelectionModel().deselectAll();
	        	if(editor.isNew) {
	        		me.getStore().remove(me.getStore().getAt(me.editPosition));
	        		editor.isNew = false;
	        	}
	        	me.evaluarBotonAdd();
	        });
	        
	        me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('saneamientoactivo').funcionRecargar();
		    	return true;
		    };
   },
   
   editFuncion: function(editor, context){
 		var me= this;
		me.mask(HreRem.i18n("msg.mask.espere"));
		
			if (me.isValidRecord(context.record) ) {		

			
      		context.record.save({
      				
                  params: {
                      idActivo: me.lookupController().getViewModel().data.activo.id,
                      idHistorico: context.record.data.idHistorico
                      
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
                  		me.up('saneamientoactivo').funcionRecargar();
						me.unmask();
                  }
               });                            
      		me.disablePagingToolBar(false);
      		me.getSelectionModel().deselectAll();
      		editor.isNew = false;
      		me.evaluarBotonAdd();
			}
      
   },
   
   onDeleteClick: function(btn, context){
   	var me = this;
       Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.eliminacion'),
			   msg: HreRem.i18n('msg.desea.eliminar'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	me.mask(HreRem.i18n("msg.mask.espere"));
			    		me.rowEditing.cancelEdit();
			            var sm = me.getSelectionModel();
			            sm.getSelection()[0].erase({
			            	params: {
			                      idHistorico: sm.selected.items[0].data.idHistorico
			                  },
			            	success: function (a, operation, c) {
                               me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                               me.up('saneamientoactivo').funcionRecargar();
							   me.unmask();
							   me.deleteSuccessFn();
                           },
                           
                           failure: function (a, operation) {
                           	var data = {};
                           	try {
                           		data = Ext.decode(operation._response.responseText);
                           	}
                           	catch (e){ };
                           	if (!Ext.isEmpty(data.msg)) {
                           		me.fireEvent("errorToast", data.msg);
                           	} else {
                           		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                           	}
								me.unmask();
								me.deleteFailureFn();
                           }
                       }
			            	
			            	
			            );
			            if (me.getStore().getCount() > 0) {
			                sm.select(0);
			            }
			        }
			   }
		});

   },

   evaluarBotonAdd: function(){
	   var me =this;
	   me.down("[itemId=addButton]").setDisabled(me.isDeshabilitarAddButton());
   },
   evaluarBotonRemove: function(grid, records){
	   var me =this;
	   me.down("[itemId=removeButton]").setDisabled(me.isDeshabilitarRemoveButton(grid, records));
   },
   
   isDeshabilitarAddButton: function(){
   	var me = this;
   	var tieneDatosStore = me.store.data.length > 0; 
   	var isBankia = me.lookupController().getViewModel().get('activo.isCarteraBankia'); 
   	if (isBankia)	return true;
	if (tieneDatosStore) {
		var codigoUltimoRegistro = me.getUltimoRegistro().data.codigoEstadoPresentacion;
		if (codigoUltimoRegistro == CONST.DD_ESP_ESTADO_PRESENTACION['NULO'] || codigoUltimoRegistro == CONST.DD_ESP_ESTADO_PRESENTACION['INMATRICULADOS']
				|| codigoUltimoRegistro == CONST.DD_ESP_ESTADO_PRESENTACION['DESCONOCIDO']){
			return false;
		} else if (codigoUltimoRegistro != CONST.DD_ESP_ESTADO_PRESENTACION['CALIFICADO_NEGATIVAMENTE']) {
			return true;
		} else if (codigoUltimoRegistro === CONST.DD_ESP_ESTADO_PRESENTACION['CALIFICADO_NEGATIVAMENTE']
					&& me.getUltimoRegistro().data.tieneCalificacionNoSubsanada == 1) {
				return true;
			} else {
				return false;
			}
		}else{ 
			return false;
		}
   },
   
   isDeshabilitarRemoveButton:function(grid, records){
	   var me = this;
	   var isBankia = me.lookupController().getViewModel().get('activo.isCarteraBankia');
	   if(records[0] && !isBankia){
		   return records[0].data.codigoEstadoPresentacion != "01";
	   	}
	   return true;
   },
   
   getUltimoRegistro: function(){
	   var me = this;
	   return me.store.data.items[0];
   }
});

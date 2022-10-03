Ext.define('HreRem.view.activos.detalle.HistoricoAntiguoDeudorGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'historicoantiguodeudorgrid',
    reference   : 'historicoantiguodeudorref',
	topBar		: true,
	targetGrid	: 'historicoAntiguoDeudor',
	editOnSelect: true,
	disabledDeleteBtn: false,
	sortableColumns: false,
	requires	: ['HreRem.model.HistoricoAntiguoDeudorModel'],
    bind: {
        store: '{storeHistoricoAntiguoDeudor}'
    },
    listeners:{
    	/*afterrender: function() {
    		var me = this;
    		me.getStore().load();
    		me.evaluarBotonAdd();
    	}*/
    	//beforeEdit: 'validarEdicionHistoricoTitulo',
    	/*containermouseover: function () {
    		var me = this;
    		me.evaluarBotonAdd();
    	},
    	itemmouseenter: function () {
    		var me = this;
    		me.evaluarBotonAdd();
    	}*/
    },

    initComponent: function () {
     	var me = this;
     	
     	/*me.getStore().load();
		me.evaluarBotonAdd();*/
		
		me.columns = [
				{
					dataIndex: 'idHistorico',
					text: 'idHistoricoAntiguoDeudor',
					hidden: true
				},
				/*{
                    text : HreRem.i18n('fieldlabel.historico.antiguo.deudor.localizable'), 
                    flex : 1,
                    dataIndex : 'codigoLocalizable',
                    reference: 'comboLocalizableRef',
                    editor: {
		        		xtype: 'textfield',
		        		disabled: true,
						allowBlank: false
		        	},
                    renderer : function(value) {
		        		if(value == true){
		        			return "Si";
		        		} else if(value == false) {
		        			return "No";
		        		} else {
		        			return "";
		        		}
	                }
				},*/
				{
		            dataIndex: 'codigoLocalizable',
		            text: HreRem.i18n('fieldlabel.historico.antiguo.deudor.localizable'), 
		            reference: 'comboLocalizableRef',
		            editor: {
						xtype: 'combobox',
						allowBlank: false,
						reference: 'comboLocalizableRefEditor',
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {
									diccionario: 'DDSiNo'
								}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
					renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {	
		        		var me = this,
		        		comboEditor =  me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null;
		        		
		        		if(!Ext.isEmpty(comboEditor)) {
			        		store = comboEditor.getStore(),							        		
			        		record = store.findRecord("codigo", value);
			        		if(!Ext.isEmpty(record)) {								        			
			        			return record.get("descripcion");								        		
			        		} else {
			        			comboEditor.setValue(value);								        			
			        		}
		        		}
					},
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaIlocalizable',
		            text: HreRem.i18n('fieldlabel.historico.antiguo.deudor.fecha.ilocalizabale'),
		            reference: 'fechaIlocalizableRef',
		            editor: {
		        		xtype: 'datefield',
		        		allowBlank: false,
		        		cls: 'grid-no-seleccionable-field-editor',
		        		maxValue: new Date()
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaLocalizado',
		            text: HreRem.i18n('fieldlabel.historico.antiguo.deudor.fecha.localizado'),
		            reference: 'fechaLocalizadoRef',
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		maxValue: new Date()
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },        
		        {
		            dataIndex: 'motivo',
		            text: HreRem.i18n('fieldlabel.historico.antiguo.deudor.motivo'), 
		            reference: 'motivoRef',
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
		                store: '{storeHistoricoAntiguoDeudor}'
		            }
		        }
		    ];
		    

		    me.callParent();
		    
		    me.addListener ('beforeedit', function(editor, context) {
		    	var me = this, 
		    	allowEdit = false;
		    	
		    	var comboLocalizableEditor = me.down('[reference="comboLocalizableRef"]').getEditor(),
		    	fechaIlocalizableEditor = me.down('[reference="fechaIlocalizableRef"]').getEditor(),
		    	fechaLocalizadoEditor = me.down('[reference="fechaLocalizadoRef"]').getEditor(),
		    	motivoEditor = me.down('[reference="motivoRef"]').getEditor();
		    	
		    	if(me.getUltimoRegistro().data.idHistorico == context.record.data.idHistorico) {
		    		allowEdit = true;
		    	} else {
		    		this.editOnSelect = allowEdit;
		    		return allowEdit;
		    	}      

		    	store = comboLocalizableEditor.getStore();
		    	store.load();
		    	
		    	if(editor.isNew) {						        		
	        		record = store.findRecord("codigo", CONST.COMBO_SIN_SINO['NO']);
	        		comboLocalizableEditor.value = record;
	        		comboLocalizableEditor.emptyText = record.get("descripcion");
		    		
		    		comboLocalizableEditor.allowBlank = false;
		    		comboLocalizableEditor.disabled = true;
		    		
		    		fechaIlocalizableEditor.allowBlank = false;
		    		fechaIlocalizableEditor.disabled = false;
		    		
		    		fechaLocalizadoEditor.allowBlank = true;
		    		fechaLocalizadoEditor.disabled = true;
		    		
		    		motivoEditor.allowBlank = true;
		    		motivoEditor.disabled = true;

		    	} else {
		    		record = store.findRecord("codigo", CONST.COMBO_SIN_SINO['SI']);
	        		comboLocalizableEditor.value = record;
	        		comboLocalizableEditor.emptyText = record.get("descripcion");
	        		
		    		comboLocalizableEditor.allowBlank = false;
		    		comboLocalizableEditor.disabled = true;
		    		
		    		fechaIlocalizableEditor.allowBlank = true;
		    		fechaIlocalizableEditor.disabled = false;
		    		
		    		fechaLocalizadoEditor.allowBlank = false;
		    		fechaLocalizadoEditor.disabled = false;
		    		
		    		motivoEditor.allowBlank = true;
		    		motivoEditor.disabled = false;
		    		
		    	}
		    	
		    	this.editOnSelect = allowEdit;
		    	
		    	return allowEdit;
	        });
		    
		    /*me.addListener('afterbind', function(grid) {
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
		    };*/
   },
   
   editFuncion: function(editor, context){
 		var me= this;

		/*me.mask(HreRem.i18n("msg.mask.espere"));
		
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
						var grid = me.lookupController().lookupReference('calificacionnegativagridad');
						if(a.data.estadoPresentacion === CONST.DD_ESP_ESTADO_PRESENTACION['CALIFICADO_NEGATIVAMENTE']){
							grid.setDisabledAddBtn(true)
						}else{
							grid.setDisabledAddBtn(true);
						}
						
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
			}*/
      
   },
   
   onDeleteClick: function(btn, context){
   	var me = this;

       /*Ext.Msg.show({
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
		});*/

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
	   	if (tieneDatosStore && me.getUltimoRegistro().data.codigoLocalizable == CONST.COMBO_SIN_SINO['NO']) {
	   		return true;
	   	}
		
	   	return false;
   },
   
   isDeshabilitarRemoveButton:function(grid, records){
	   var me = this;
	   /*var isBankia = me.lookupController().getViewModel().get('activo.isCarteraBankia');
	   if(records[0] && !isBankia){
		   return records[0].data.codigoEstadoPresentacion != "01";
	   	}
	   return true;*/
   },
   
   getUltimoRegistro: function(){
	   var me = this;
	   return me.store.data.items[0];
   }
});
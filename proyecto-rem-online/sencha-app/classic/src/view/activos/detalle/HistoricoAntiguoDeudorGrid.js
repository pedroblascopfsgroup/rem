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
    listeners: {
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
					text: 'idHistoricoAntiguoDeudor',
					hidden: true
				},
				{
		            dataIndex: 'codigoLocalizable',
		            text: HreRem.i18n('fieldlabel.historico.antiguo.deudor.localizable'), 
		            reference: 'comboLocalizableRef',
		            editor: {
						xtype: 'combobox',
						allowBlank: false,
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
		        			record.data.codigoLocalizableOldValue = record.data.codigoLocalizable;
		        		}
		        		
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
		    	
		    	if(!Ext.isEmpty(me.getUltimoRegistro()) && me.getUltimoRegistro().data.idHistorico != context.record.data.idHistorico) {
		    		me.disableAddButton(true);
		    		return allowEdit;
		    	} else {
		    		allowEdit = true;
		    	}   

		    	store = comboLocalizableEditor.getStore();
		    	
		    	if(editor.isNew) {						        		
	        		record = store.findRecord("codigo", CONST.COMBO_SIN_SINO['NO']);
	        		context.record.data.codigoLocalizable = record.get("codigo");
	        		comboLocalizableEditor.setDisplayTpl(Ext.create('Ext.XTemplate', '<tpl for=".">', record.get("descripcion"), '</tpl>'));
		    		
		    		comboLocalizableEditor.allowBlank = false;
		    		comboLocalizableEditor.disabled = true;
		    		
		    		fechaIlocalizableEditor.allowBlank = false;
		    		fechaIlocalizableEditor.disabled = false;
		    		
		    		fechaLocalizadoEditor.allowBlank = true;
		    		fechaLocalizadoEditor.readOnly = true;
		    		fechaLocalizadoEditor.disabled = true;
		    		
		    		motivoEditor.allowBlank = true;
		    		motivoEditor.readOnly = true;
		    		motivoEditor.disabled = true;

		    	} else {
		    		record = store.findRecord("codigo", CONST.COMBO_SIN_SINO['SI']);
		    		context.record.data.codigoLocalizableOldValue = context.record.data.codigoLocalizable;
	        		context.record.data.codigoLocalizable = record.get("codigo");
	        		comboLocalizableEditor.setDisplayTpl(Ext.create('Ext.XTemplate', '<tpl for=".">', record.get("descripcion"), '</tpl>'));
	        		
		    		comboLocalizableEditor.allowBlank = false;
		    		comboLocalizableEditor.disabled = true;
		    		
		    		fechaIlocalizableEditor.allowBlank = true;
		    		fechaIlocalizableEditor.disabled = false;
		    		
		    		fechaLocalizadoEditor.allowBlank = false;
		    		fechaLocalizadoEditor.readOnly = false;
		    		fechaLocalizadoEditor.disabled = false;
		    		
		    		motivoEditor.allowBlank = true;
		    		motivoEditor.readOnly = false;
		    		motivoEditor.disabled = false;
		    		
		    	}
		    	
		    	return allowEdit;
		    	
	        });
		    
		    me.addListener('canceledit', function(editor) {
		    	if(!Ext.isEmpty(me.getUltimoRegistro()) && me.getUltimoRegistro().data.codigoLocalizableOldValue != undefined) {
		    		me.getUltimoRegistro().data.codigoLocalizable = me.getUltimoRegistro().data.codigoLocalizableOldValue;
		    	}
				me.disablePagingToolBar(false);
	        	me.getSelectionModel().deselectAll();
	        	if(editor.isNew) {
	        		me.getStore().remove(me.getStore().getAt(me.editPosition));
	        		editor.isNew = false;
	        	}
	        	me.evaluarBotonAdd();
	        });

   },
   
   editFuncion: function(editor, context){
 		var me = this;
 		
		me.mask(HreRem.i18n("msg.mask.espere"));
		
			if (me.isValidRecord(context.record) ) {		

			context.record.modified.codigoLocalizable = context.record.data.codigoLocalizable;
			if(context.record.data.idHistorico != null && context.record.data.idHistorico != undefined) {
				context.record.modified.idHistorico = context.record.data.idHistorico;
			}
			
      		context.record.save({
      				
      			params: {
      				idOferta: me.lookupController().getViewModel().get("datosbasicosoferta.idOferta")
      			},
  
      			success: function (a, operation, c) {
				     if (context.store.load) {
				     	context.store.load();
				     }
				     me.unmask();
				     me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));					
      			},
                  
				failure: function (a, operation) {
                  	try {
                  		var response = Ext.JSON.decode(operation.getResponse().responseText)
                  	} catch(err) {}
                  	
                  	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msgError)) {
                  		me.fireEvent("errorToast", response.msgError);
                  	} else {
                  		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                  	}     
              		if (context.store.load) {
              			context.store.load();
              		}
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
           						me.unmask();
                           },
                           
                           failure: function (a, operation) {
	                           	var data = {};
	                           	try {
	                           		data = Ext.decode(operation._response.responseText);
	                           	} catch (e){ };
	                           	if (!Ext.isEmpty(data.msg)) {
	                           		me.fireEvent("errorToast", data.msg);
	                           	} else {
	                           		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                           	}
	        					me.unmask();
                           }
			            });
			            
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
   
   isDeshabilitarAddButton: function(){
	   	var me = this;
	   	
	   	if(!Ext.isEmpty(me.store.data)) {
	   		var tieneDatosStore = me.store.data.length > 0;
		   	if (tieneDatosStore && me.getUltimoRegistro().data.codigoLocalizableOldValue == CONST.COMBO_SIN_SINO['NO']) {
		   		return true;
		   	}
	   	}
		
	   	return false;
   },
   
   getUltimoRegistro: function(){
	   var me = this;
	   
	   if(!Ext.isEmpty(me.store.data)) {
		   return me.store.data.items[0];
	   }
	   
	   return null;
   }
});
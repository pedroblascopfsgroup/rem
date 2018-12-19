Ext.define('HreRem.view.expedientes.HistoricoCondicionesExpediente', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'historicoCondicones',
	topBar		: true,
	propagationButton: false,
	//targetGrid	: 'impuestoactivo',
	idPrincipal : 'expediente.id',
	idSecundaria: 'condiciones.insertarHistorico',
	removeButton: false,
	//editable: true,
	editOnSelect: false,
	//disabledDeleteBtn: true,
	//addButton: false,

    bind: {
        store: '{storeHistoricoCondiciones}'
    },
    
    /*listeners: {
    	boxready: function() {
    		var me = this;
    		//me.evaluarEdicion();
    		//grid.up().disableRemoveButton(true);
    	},
    	rowclick: 'onGridImpuestosActivoRowClick',
    	rowdblclick: 'onImpuestosActivoDobleClick'
    },*/

    initComponent: function () {

     	var me = this;
     	
     	/*me.deleteSuccessFn = function(){
    		this.getStore().load()
    		this.setSelection(0);
    	}
     	
     	me.deleteFailureFn = function(){
    		this.getStore().load()
    	},*/

		me.columns = [
				{
					text: 'Id',
					dataIndex: 'id',
					hidden: true,
					hideable: false
				},
				{
					text: 'IdCoe',
					dataIndex: 'condicionante',
					hidden: true,
					hideable: false
				},
				{   text: HreRem.i18n('fieldlabel.fecha'),
					dataIndex: 'fecha',
		        	formatter: 'date("d/m/Y")',
		        	editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		allowBlank: false,
		        		bind: {
		        			minValue: '{fechaMinima}'
		        		}
		        	},
		        	flex: 1
				},
				{   text: HreRem.i18n('fieldlabel.incremento.renta'),
		        	dataIndex: 'incrementoRenta',
		        	flex: 1,
		        	editor: {
		            	xtype: 'numberfield',
		            	allowBlank: false
		            }
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
		                store: '{storeHistoricoCondiciones}'
		            }
		        }
		    ];
		    
		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.getView().refresh() 
		    	return true;
		    },

		    me.callParent();
   },
   saveFunction: function(editor, context){
	   var me = this;
		me.mask(HreRem.i18n("msg.mask.espere"));
		if (me.isValidRecord(context.record)) {				
		
    		context.record.save({

                params: {
                    idEntidad: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal),
                    idEntidadPk: Ext.isEmpty(me.idSecundaria) ? "" : this.up('{viewModel}').getViewModel().get(me.idSecundaria)	
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
                	
                	context.store.load();
                	try {
                		var response = Ext.JSON.decode(operation.getResponse().responseText)
                		
                	}catch(err) {}
                	
                	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msg)) {
                		me.fireEvent("errorToast", response.msg);
                	} else {
                		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                	}                        	
					me.unmask();
                }
            });	                            
    		me.disableAddButton(false);
    		me.disablePagingToolBar(false);
    		me.getSelectionModel().deselectAll();
    		editor.isNew = false;
		}
   }

});

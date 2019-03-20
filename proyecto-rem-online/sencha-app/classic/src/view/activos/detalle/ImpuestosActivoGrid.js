Ext.define('HreRem.view.activos.detalle.ImpuestosActivoGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'impuestosactivogrid',
	topBar		: true,
	propagationButton: false,
	targetGrid	: 'impuestoactivo',
	idPrincipal : 'id',
	idSecundaria : 'activo.id',
	//editable: true,
	editOnSelect: true,
	//disabledDeleteBtn: true,

    bind: {
        store: '{storeImpuestosActivo}'
    },
    
    listeners: {
    	boxready: function() {
    		var me = this;
    		//me.evaluarEdicion();
    		//grid.up().disableRemoveButton(true);
    	},
    	rowclick: 'onGridImpuestosActivoRowClick',
    	rowdblclick: 'onImpuestosActivoDobleClick'
    },

    initComponent: function () {

     	var me = this;
     	
     	me.deleteSuccessFn = function(){
    		this.getStore().load()
    		this.setSelection(0);
    	}
     	
     	me.deleteFailureFn = function(){
    		this.getStore().load()
    	},

		me.columns = [
				{
					text: 'Id Impuesto',
					dataIndex: 'id',
					hidden: true,
					hideable: false
				},
				{
					text: 'Id Activo',
					dataIndex: 'idActivo',
					hidden: true,
					hideable: false
				},
				{	  
		            text: HreRem.i18n('title.activo.administracion.tipoImpuesto'),				            
		            dataIndex: 'tipoImpuesto',
		            editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionarioDeGastos',
								extraParams: {diccionario: 'subtiposGasto'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 1
				},
				{   text: HreRem.i18n('title.activo.administracion.fechaInicio'),
					dataIndex: 'fechaInicio',
		        	formatter: 'date("d/m/Y")',
		        	editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor'
		        	},
		        	flex: 1
				},
				{   text: HreRem.i18n('title.activo.administracion.fechaFin'),
		        	dataIndex: 'fechaFin',
		        	formatter: 'date("d/m/Y")',
		        	editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor'
		        	},
		        	flex: 1
				},
				{   text: HreRem.i18n('title.activo.administracion.periodicidad'),
		        	dataIndex: 'periodicidad',
		        	editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'tipoPeriocidad'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		        	flex: 1
				},
				{
					text: HreRem.i18n('title.activo.administracion.calculo'),
					dataIndex: 'calculo',
					editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'calculoImpuesto'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
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
		                store: '{storeImpuestosActivo}'
		            }
		        }
		    ];
		    
		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('administracionactivo').funcionRecargar();
		    	return true;
		    },
		    
		    me.saveFailureFn = function() {
		    	var me = this;
		    	me.up('administracionactivo').funcionRecargar();
		    	return true;
		    },

		    me.callParent();
   },
	
	onAddClick: function(btn){
		
		var me = this;
		var rec = Ext.create(me.getStore().config.model);
		me.getStore().sorters.clear();
		me.editPosition = 0;
		rec.setId(null);
	    me.getStore().insert(me.editPosition, rec);
	    me.rowEditing.isNew = true;
	    me.rowEditing.startEdit(me.editPosition, 0);
	    me.disableAddButton(true);
	    me.disablePagingToolBar(true);
	    me.disableRemoveButton(true);

   },
   
   editFuncion: function(editor, context){
  		var me= this;
		me.mask(HreRem.i18n("msg.mask.espere"));

			if (me.isValidRecord(context.record)) {				
			
       		context.record.save({
       				
                   params: {
                       id: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal),
                       idActivo: Ext.isEmpty(me.idSecundaria) ? "" : me.lookupController().getViewModel().data.activo.id	
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

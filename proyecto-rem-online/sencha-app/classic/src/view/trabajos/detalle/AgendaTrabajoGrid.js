Ext.define('HreRem.view.trabajos.detalle.AgendaTrabajoGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'agendatrabajogrid',
	topBar		: true,
	targetGrid	: 'agendaTrabajo',
	editOnSelect: false,
	disabledDeleteBtn: false,
	sortableColumns: false,
	idTrabajo: null,
	controller: 'trabajodetalle',
    viewModel: {
        type: 'trabajodetalle'
    },
    bind: {
        store: '{storeAgendaTrabajo}'
    },
    requires: ['HreRem.view.trabajos.detalle.TrabajoDetalleController', 'HreRem.model.AgendaTrabajoModel'],

    initComponent: function () {
    	
     	var me = this;
     	
     	
     	me.columns = [
				{
					text: 'Id Trabajo',
					dataIndex: 'idTrabajo',
					hidden: true,
					editor: {
		        		xtype: 'textareafield'
	        			}
				},
		        {
		            dataIndex: 'gestorAgenda',
		            reference: 'gestorAgenda',
		            text: HreRem.i18n('header.gestor'),
		            editor: 
		            	{
							xtype: 'textfield',
							cls: 'grid-no-seleccionable-field-editor',
							readOnly: true,
							value: $AU.getUser().userName
						},
					
		            flex: 1
		        },
		        {
		            dataIndex: 'proveedorAgenda',
		            reference: 'proveedorAgenda',
		            text: HreRem.i18n('header.proveedor'),
		            editor: 
		            	{
							xtype: 'textfield',
							cls: 'grid-no-seleccionable-field-editor',
							readOnly: true,
							value: $AU.getUser().userName
						},
					
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaAgenda',
		            text: HreRem.i18n('fieldlabel.fecha'),
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		readOnly: true,
						value: new Date()
		        	},
		        	
		            flex: 1,
		            formatter: 'date("d/m/y")'
		        },
		        {
		            dataIndex: 'tipoGestion',
		            reference: 'tipoGestion',
		            text: HreRem.i18n('fieldlabel.tipoGestion'),
		            editor: 
		            	{
		            	xtype: 'combobox',
						allowBlank: false,
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'tipoApunte'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
						valueField: 'codigo'													        		
						},
						renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {								        		
			        		var me = this,
			        		comboEditor = me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null,
			        		store, record;
			        		
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
		            dataIndex: 'observacionesAgenda',
		            reference: 'observacionesAgenda',
		            text: HreRem.i18n('fieldlabel.observaciones'),
		            editor: 
		            	{
							xtype: 'textareafield'								        		
						},
		            flex: 1
		        }
		    ];

		
		
		     me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{storeAgendaTrabajo}' 
		            }
		        }
		    ];	

			
		    me.callParent(); 
	
   },
   onAddClick: function(btn){
	   		
	   		var me = this;
	    	var idTrabajo = me.idTrabajo;
	    	Ext.create("HreRem.view.trabajos.detalle.AnyadirAgendaTrabajo", {idTrabajo: idTrabajo}).show();
	   
   },
   onDeleteClick : function() {
	   		var me = this;
	   		var grid = me;
	   		
	   		var id = me.getSelection()[0].getData().idAgenda;
	   		Ext.Msg.show({
	   			title : HreRem.i18n('title.mensaje.confirmacion'),
	   			msg : HreRem.i18n('msg.desea.eliminar'),
	   			buttons : Ext.MessageBox.YESNO,
	   			fn : function(buttonId) {
	   				if (buttonId == 'yes') {
	   					grid.mask(HreRem.i18n("msg.mask.loading"));
	   					var url = $AC.getRemoteUrl('trabajo/deleteAgendaTrabajo');
	   					Ext.Ajax.request({
	   						url : url,
	   						method : 'POST',
	   						params : {
	   							id: id
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

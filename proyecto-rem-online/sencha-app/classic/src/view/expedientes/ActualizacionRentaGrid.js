Ext.define('HreRem.view.expediente.ActualizacionRentaGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'actualizacionRentaGrid',
	topBar		: true,
	addButton	: true,
	requires	: ['HreRem.model.ActualizacionRentaModel', 'HreRem.view.expedientes.CondicionesExpediente'],
	reference	: 'actualizacionRentaGrid',
	editOnSelect: true, 
	bind: { 
		store: '{storeActualizacionRenta}'
	},

    initComponent: function () {
    	var me = this;
  	
     	me.columns = [
				{ 
		    		dataIndex: 'id',
		    		reference: 'idActualizacionRenta',
		    		name: 'idActualizacionRenta',
		    		hidden: true
	    		},
	    		{
		            dataIndex: 'fechaActualizacion',
		            reference: 'fechaActualizacion',
		            name:'fechaAplicacion',
		            text: HreRem.i18n('fieldlabel.fecha.aplicacion'),
		            flex: 1,
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		allowBlank:false
		        	},
		        	formatter: 'date("d/m/Y")'
		            
		        }, 
	    		{
		            dataIndex: 'tipoActualizacionCodigo',
		            reference: 'tipoActualizacionCodigo',
		            name:'tipoActualizacionCodigo',
		            text: HreRem.i18n('fieldlabel.tipo.actualizacion'),
		            flex: 1 ,
		            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
		            	var foundedRecord = this.lookupController().getViewModel().getStore('storeMetodoActualizacionRenta').findRecord('codigo', value);
		            	var descripcion;
		            	
		        		if(!Ext.isEmpty(foundedRecord)) {
		        			descripcion = foundedRecord.getData().descripcion;
		        		}
		            	return descripcion;
		        	},
		        	editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'metodoActualizacionRenta'} 
							},
							autoLoad: true
						}),
						allowBlank:false,
						displayField: 'descripcion',
    					valueField: 'codigo'
					}
		        },
		        {
		            dataIndex: 'importeActualizacion',
		            reference: 'importeActualizacion',
		            name:'meses',
		            text: HreRem.i18n('fieldlabel.incremento.renta'),
		            flex: 1 ,
		            editor: {
		        		xtype: 'numberfield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		allowBlank:false
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
 	                store: '{storeActualizacionRenta}'
 	            }
 	        }
 	    ];
     	 	
 		me.callParent();

    },
        
  
    
    onDeleteClick: function(){
    	var me = this;
    	var grid = me;
    	var selection =  me.getSelection();
    	var id = selection[0].get('id');
    	
    	grid.mask(HreRem.i18n("msg.mask.loading"));
    	
    	var url = $AC.getRemoteUrl('expedientecomercial/deleteActualizacionRenta');
    	Ext.Ajax.request({
    		url: url,
    		method : 'GET',
    		params: {
    			id:id
    		},
    		success: function(response, opts){
    			grid.getStore().load();
    			me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok")); 
    			grid.unmask();
    		},failure: function(record, operation) {
		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		 		grid.unmask();
		    },
		    callback: function(record, operation) {
		    	grid.unmask();
		    }
    	});
    },
    
    editFuncion: function(editor, context){
    	var me = this;
    	var grid = me;
    	var data = context.record.getData();
    	var url = $AC.getRemoteUrl('expedientecomercial/updateActualizacionRenta');
    	var id = data.id;
    	
    	if(me.isValidRecord(context.record)) {	
    		grid.mask(HreRem.i18n("msg.mask.loading"));
        	
        	if(editor.isNew){
            	url = $AC.getRemoteUrl('expedientecomercial/addActualizacionRenta');
            	id = null;
        	}
        	    
        	Ext.Ajax.request({
        		url: url,
        		method: 'POST',
        		params: {
        			id:id,
        			idExpediente: me.lookupController().getView().getViewModel().get('expediente.id'),
        			fechaActualizacion: data.fechaActualizacion,
        			importeActualizacion: data.importeActualizacion,
        			tipoActualizacionCodigo: data.tipoActualizacionCodigo
        		},
        		success: function(response, opts){
        			grid.getStore().load();
        			me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok")); 
        			grid.unmask();
        		},failure: function(record, operation) {
    		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
    		 		grid.unmask();
    		    },
    		    callback: function(record, operation) {
    		    	grid.unmask();
    		    }
        	});
    	}
    	
    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load(grid.loadCallbackFunction);
  		});
    }
    
});

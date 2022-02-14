Ext.define('HreRem.view.activos.detalle.OrganismosGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'organismosGrid',
	topBar		: true,
	targetGrid	: 'organismosGrid',
	idPrincipal : 'activo.id',
	editOnSelect: true,
	requires	: ['HreRem.model.Organismos'],
    bind: {
        store: '{storeOrganismos}'
    },

    initComponent: function () {
    	
     	var me = this;

		me.columns = [
			{   text: 'idOrganismo',
	        	dataIndex: 'idOrganismo',
	        	hidden: true,
	        	flex: 0.5
	        },
	        {	 
	            text: HreRem.i18n('title.historico.comunicacion.organismo.organismo'),		            
	            dataIndex: 'organismo',
	            flex: 1,
	            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
	            	var nameStore = 'comboTipoOrganismo';
	            	var nameRawValue =  'organismoDesc';
	            	//return me.loadStoreFunction(nameStore, nameRawValue, record, value);
	        	},
        		editor: {
        			xtype: 'comboboxfieldbasedd',
        			addUxReadOnlyEditFieldPlugin: false,
        			allowBlank: false,
	        		bind: {
	            		store: '{comboTipoOrganismo}',
	            		value: '{organismo}',
	            		rawValue: '{organismoDesc}'
	            	},
	            	displayField: 'descripcion',
					valueField: 'codigo'
        		}
		   	},
		    {	 
	            text: HreRem.i18n('fieldlabel.comunidad.autonoma'),		            
	            dataIndex: 'comunidadAutonoma',
	            flex: 1,
	            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
	            	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboComunidadAutonoma').findRecord('codigo', value);
	            	var descripcion;
	        		if(!Ext.isEmpty(foundedRecord)) {
	        			descripcion = foundedRecord.getData().descripcion;
	        		}
	            	return descripcion;
	        	},
	        	
	        	editor: {
        			xxtype: 'combobox',
        			allowBlank: false,
	        		bind: {
	            		store: '{comboComunidadAutonoma}',
	            		value: '{comunidadAutonoma}'
	            	},
	            	displayField: 'descripcion',
					valueField: 'codigo'
        		}
        		
		   	},
	    	{	  
	            text: HreRem.i18n('title.historico.comunicacion.organismo.fecha'),				            
	            dataIndex: 'fechaOrganismo',
	            flex: 1,
	            formatter: 'date("d/m/Y")',
        		editor: {
               	 xtype: 'datefield',
             	 allowBlank: false
            	}
		   	},
		    {	 
	            text: HreRem.i18n('fieldlabel.tipo.actuacion'),		            
	            dataIndex: 'tipoActuacion',
	            flex: 1,
	            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
	            	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboTipoActuacion').findRecord('codigo', value);
	            	var descripcion;
	        		if(!Ext.isEmpty(foundedRecord)) {
	        			descripcion = foundedRecord.getData().descripcion;
	        		}
	            	return descripcion;
	        	},
        		editor: {
        			xtype: 'combobox',
        			allowBlank: false,
	        		bind: {
	            		store: '{comboTipoActuacion}',
	            		value: '{actuacion}'
	            	},
	            	displayField: 'descripcion',
					valueField: 'codigo'
        		}
		   	},
		   	{	  
	            text: HreRem.i18n('header.gestor'),		            
	            dataIndex: 'gestorOrganismo',
	            flex: 1
		   	}
		 ];
		

		me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'organismosPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true, 
	            bind: {
	            	store: '{storeOrganismos}'
	            }
	        }
	    ];
		
		me.saveSuccessFn = function() {
	    	var me = this;
	    	me.up('datosbasicosactivo').funcionRecargar();
	    	return true;
	    };
	
	    me.callParent();

   },
   
   funcionRecargar: function() {
		var me = this; 
		me.getStore().load();
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
			           url = $AC.getRemoteUrl('activo/deleteOrganismoById');
			           Ext.Ajax.request({
							url : url,
							method : 'GET',
							params: {
			                      idOrganismo: sm.selected.items[0].data.idOrganismo
			                },
							success : function(response, opts) {
						          me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						      },
							  failure: function (a, operation) {
								  me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
						      },
						      callback : function(record, operation) {
						  		 me.getStore().load();
						    	 me.unmask();
							  }
						});	             
			        } 
			   	}
			});
	   },
	   
	   editFuncion: function(editor, context){
			var me= this;
			me.mask(HreRem.i18n("msg.mask.espere"));
			if (me.isValidRecord(context.record)) {		
				context.record.data.idActivo=me.lookupController().getView().getViewModel().get('activo.id');	
				if(!Ext.isNumeric(context.record.data.idOrganismo)){
					context.record.data.idOrganismo = null;
				}
				var params = context.record.data;

				url = $AC.getRemoteUrl('activo/saveOrganismo');
				Ext.Ajax.request({
					url : url,
					method : 'POST',
					params : params,
					success : function(response, opts) {
			          me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			      },
				  failure: function (a, operation) {
					  me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			      },
			  	  callback : function(record, operation) {
			  		 me.getStore().load();
			    	 me.unmask();
				}
			});	                            
		}
	 },
	 
	 loadStoreFunction: function(nameStore, nameRawValue, record, value){
		var store = this.up('activosdetallemain').getViewModel().getStore(nameStore);
		var descripcion;
		 
     	if(store.isLoaded()){
	     	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore(nameStore).findRecord('codigo', value);
	     	
	 		if(!Ext.isEmpty(foundedRecord)) {
	 			descripcion = foundedRecord.getData().descripcion;
	 		}
     	}else{
     		descripcion = recod.get(nameRawValue);
     	}
     	return descripcion;
	 }
   
});

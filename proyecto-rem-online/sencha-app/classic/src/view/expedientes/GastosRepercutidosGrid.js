Ext.define('HreRem.view.expedientes.GastosRepercutidosGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'gastosRepercutidosGrid',
	topBar		: true,
	addButton	: true,
	requires	: ['HreRem.model.GastosRepercutidosModel'],
	reference	: 'gastosRepercutidosGrid',
	editOnSelect: false, 
	bind: { 
		store: '{storeGastosRepercutidos}'
	},
	
    initComponent: function () {
    	var me = this;
    	    	
     	me.columns = [
				{ 
		    		dataIndex: 'id',
		    		reference: 'idGastoRepercutido',
		    		name: 'idGastoRepercutido',
		    		hidden: true
	    		},
	    		  {
		            dataIndex: 'tipoGastoCodigo',
		            reference: 'tipoGastoCodigo',
		            name:'tipoGastoCodigo',
		            text: HreRem.i18n('fieldlabel.gasto.tipo'),
		            flex: 1 ,
		            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
		            	var foundedRecord = this.lookupController().getViewModel().getStore('storeTipoGastoRepercutido').findRecord('codigo', value);
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
								extraParams: {diccionario: 'tipoGastoRepercutido'} 
							},
							autoLoad: true
						}),
		        		allowBlank: false,
						displayField: 'descripcion',
    					valueField: 'codigo'
					}
		        },  
		        {
		            dataIndex: 'importe',
		            reference: 'importe',
		            name:'importe',
		            text: HreRem.i18n('header.importe'),
		            flex: 1,
		            editor: {
		        		xtype: 'numberfield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		allowBlank: true
		        	}
		        },  
		        {
		            dataIndex: 'meses',
		            reference: 'meses',
		            name:'meses',
		            text: HreRem.i18n('fieldlabel.meses'),
		            flex: 1 ,
		            editor: {
		        		xtype: 'numberfield',
		        		cls: 'grid-no-seleccionable-field-editor'
		        	}
		        },
		        {
		            dataIndex: 'fechaAlta',
		            reference: 'fechaAlta',
		            name:'fechaAlta',
		            text: HreRem.i18n('fieldlabel.fecha.alta'),
		            flex: 1 ,
		            formatter: 'date("d/m/Y")',
		            hidden: true,
		            editor: {
		        		xtype: 'datefield',
		        		allowBlank: true
		        	}
		        }
		    ];
			
			me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'gastosRepercutidosPaginationToolbar',
		            inputItemWidth: 5,
		            displayInfo: true,
		            overflowX: 'scroll',
		            bind: {
		            	store: '{storeGastosRepercutidos}'
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
    
    editFuncion: function(editor, context){
    	var me = this;
		var url =  $AC.getRemoteUrl('expedientecomercial/createGastoRepercutido'); 
		var idExpediente = me.up('expedientedetallemain').getViewModel().get('expediente.id');
		var tipoGastoCodigo = context.newValues.tipoGastoCodigo;
		var importe = context.newValues.importe;
		var meses = context.newValues.meses;
		var fechaAlta = context.newValues.fechaAlta;
		var id = null;
		
		Ext.Ajax.request({
		     url: url,
		     method: 'POST',
		     params: {idExpediente: idExpediente, tipoGastoCodigo:tipoGastoCodigo, importe:importe,id:id, meses:meses, fechaAlta:fechaAlta},
		     success: function(response, opts) {
		    	 var data = Ext.decode(response.responseText);
		    	 if(data.success === "false"){
		    		 me.fireEvent("errorToast", data.msg);
		    	 }else{
			    	 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		    	 }
		    },
		    failure: function (a, operation) {
		    	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		 	},callback: function(record, operation) {
		 		me.getStore().load();
		    }
		});

    }
    
});

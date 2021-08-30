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
		            	var foundedRecord = this.lookupController().getViewModel().getStore('storeClasificacion').findRecord('codigo', value);
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
								extraParams: {diccionario: 'motivosCalificacionNegativa'} 
							},
							autoLoad: true
						}),
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
		        		cls: 'grid-no-seleccionable-field-editor'
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
    }
    
});

Ext.define('HreRem.view.gastos.GastosRepercutidosGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'actualizacionRentaGrid',
	topBar		: true,
	addButton	: true,
	requires	: ['HreRem.model.ActualizacionRentaModel'],
	reference	: 'actualizacionRentaGrid',
	editOnSelect: false, 
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
		            dataIndex: 'fechaAplicacion',
		            reference: 'fechaAplicacion',
		            name:'fechaAplicacion',
		            text: HreRem.i18n('fieldlabel.fecha.aplicacion'),
		            flex: 1,
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor'
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
		            dataIndex: 'incrementoRenta',
		            reference: 'incrementoRenta',
		            name:'meses',
		            text: HreRem.i18n('fieldlabel.incremento.renta'),
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
		            	store: '{actualizacionRentaGrid}'
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

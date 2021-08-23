Ext.define('HreRem.view.expedientes.SancionesGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'sancionesBkGrid',
	topBar		: false,
	addButton	: false,
	requires	: ['HreRem.model.SancionesModel'],
	reference	: 'sancionesGrid',
	editOnSelect: false, 
	bind: { 
		store: '{storeSancionesBk}'
	},
	
    initComponent: function () {
    	var me = this;
    	
     	me.columns = [
				{ 
		    		dataIndex: 'id',
		    		reference: 'idSancion',
		    		name: 'idSancion',
		    		hidden: true
	    		},
	    		  {
		            dataIndex: 'comite',
		            reference: 'comite',
		            name:'comite',
		            text: HreRem.i18n('header.oferta.comite'),
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
		            dataIndex: 'fecha',
		            reference: 'fecha',
		            name:'fecha',
		            text: HreRem.i18n('header.fecha'),
		            flex: 1,
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor'
		        	},
		        	  formatter: 'date("d/m/Y")'
		            
		        }, 
		        {
		            dataIndex: 'observaciones',
		            reference: 'observaciones',
		            name:'observaciones',
		            text: HreRem.i18n('title.observaciones'),
		            flex: 1 ,
		            editor: {
		        		xtype: 'textfield',
		        		cls: 'grid-no-seleccionable-field-editor'
		        	}
		        }
		    ];
			
			me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'sancionesPaginationToolbar',
		            inputItemWidth: 5,
		            displayInfo: true,
		            overflowX: 'scroll',
		            bind: {
		            	store: '{storeSancionesBk}'
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

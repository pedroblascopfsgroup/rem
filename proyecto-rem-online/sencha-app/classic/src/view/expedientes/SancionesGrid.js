Ext.define('HreRem.view.expedientes.SancionesGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'sancionesBkGrid',
	topBar		: false,
	addButton	: false,
	requires	: ['HreRem.model.SancionesModel'],
	reference	: 'sancionesGrid',
	editOnSelect: false, 
	minHeight: 200,
	
	bind: { 
		store: '{storeSancionesBk}'
	},
	
    initComponent: function () {
    	var me = this;
    	
     	me.columns = [
	    		  {
		            dataIndex: 'comite',
		            reference: 'comite',
		            name:'comite',
		            text: HreRem.i18n('header.oferta.comite'),
		            flex: 1
		        },  
		        {
		            dataIndex: 'fechaRespuestaBC',
		            reference: 'fechaRespuestaBC',
		            name:'fechaRespuestaBC',
		            text: HreRem.i18n('header.fecha'),
		            flex: 1,
		        	formatter: 'date("d/m/Y")'  
		        }, 
		        {
		            dataIndex: 'respuestaBC',
		            reference: 'respuestaBC',
		            name:'respuestaBC',
		            text: HreRem.i18n('title.publicaciones.condiciones.estado'),
		            flex: 1,
		            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
		            	var foundedRecord = this.lookupController().getViewModel().getStore('comboResolucionComite').findRecord('codigo', value);
		            	var descripcion;
		            	
		        		if(!Ext.isEmpty(foundedRecord)) {
		        			descripcion = foundedRecord.getData().descripcion;
		        		}
		            	return descripcion;
		        	},
		        },
		        {
		            dataIndex: 'observacionesBC',
		            reference: 'observacionesBC',
		            name:'observacionesBC',
		            text: HreRem.i18n('title.observaciones'),
		            flex: 3 
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

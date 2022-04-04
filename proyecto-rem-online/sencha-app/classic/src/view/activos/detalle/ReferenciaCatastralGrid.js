Ext.define('HreRem.view.activos.detalle.ReferenciaCatastralGrid', {
    extend: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype: 'referenciacatastralgrid',
 	reference:'referenciacatastralgridref',
	idActivo: null,
	minHeight: 20,
	
	bind:{
		store: '{storeReferenciaCatastral}'
	},

	initComponent: function() {

		var me = this;

		var coloredRender = function (value, metaData, record, rowIndex, colIndex, view) {
			metaData.style = "white-space: normal;";
    		if(value){	    		
    			return value;
    		} else {
	    		return '-';
	    	}
    	};

    	var dateColoredRender = function (value, meta, record) {
    		var valor = dateRenderer(value);
    		return coloredRender(valor, meta, record);
    	};

        var dateRenderer = function(value, rec) {
			if(!Ext.isEmpty(value)) {
				var newDate = new Date(value);
				var formattedDate = Ext.Date.format(newDate, 'd/m/Y');
				return formattedDate;
			} else {
				return value;
			}
		};

		me.columns = [ 
            {            	
                flex	 : 1,
                text	 : HreRem.i18n('publicacion.referencia.catastral.referencia.catastral'),
                dataIndex: 'refCatastral',
                renderer: coloredRender
            },
            {
            	xtype: 'actioncolumn',
            	text	 : HreRem.i18n('publicacion.calidad.datos.correcto'),
                flex	 : 0.5,
                dataIndex: 'correcto',
                renderer: coloredRender,
                items: [{
			            getClass: function(v, metadata, record ) {

			            	var catCorrecto = record.get('correcto');
			
							if(catCorrecto == "true")  {
	     						return 'app-tbfiedset-ico icono-tickok no-pointer';
     						}else if(catCorrecto == "false"){
	     						return 'app-tbfiedset-ico icono-tickko no-pointer';
     						}			            	
			            }
			        }]
                		
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
	                store: '{storeReferenciaCatastral}'
	            }
	        }
	    ];
		
		me.callParent();

	}
});
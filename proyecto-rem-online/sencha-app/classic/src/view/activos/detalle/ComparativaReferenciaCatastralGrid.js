Ext.define('HreRem.view.activos.detalle.ComparativaReferenciaCatastralGrid', {
    extend: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype: 'comparativareferenciacatastralgrid',
 	reference:'comparativareferenciacatastralgridref',
	idActivo: null,
	refCatastral: null,
	minHeight: 20,
	
	bind:{
		store:'{storeComparativaRefCatastral}'
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
                text	 : HreRem.i18n('fieldlabel.nombre'),
                flex	 : 1,
                dataIndex: 'nombre',
                renderer: coloredRender
            },
            {
            	text	 : HreRem.i18n('publicacion.referencia.catastral.dato.rem'),
                flex	 : 1,
                dataIndex: 'datoRem', 
                renderer: coloredRender
            },
            {
            	text	 : HreRem.i18n('publicacion.referencia.catastral.dato.catastro'),
                flex	 : 1,
                dataIndex: 'datoCatastro', 
                renderer: coloredRender
            },
            {
            	xtype: 'actioncolumn',
            	text	 : HreRem.i18n('publicacion.referencia.catastral.coincidencia'),
                flex	 : 0.5,
                dataIndex: 'coincidencia',
                renderer: coloredRender,
                items: [{
			            getClass: function(v, metadata, record ) {

			            	var catCorrecto = record.get('coincidencia');
							if(catCorrecto === "true")  {
	     						return 'app-tbfiedset-ico icono-tickok no-pointer';
     						}else if(catCorrecto === "false"){
	     						return 'app-tbfiedset-ico icono-tickko no-pointer';
     						}else {
	     						return 'app-tbfiedset-ico icono-tickinterrogante no-pointer';
	     					}			            	
			            }
			        }]
                		
            },  
            {
            	text	 : HreRem.i18n('publicacion.referencia.catastral.probabilidad'),
                flex	 : 1,
                dataIndex: 'probabilidad', 
                renderer: coloredRender
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
	                store: '{storeComparativaRefCatastral}'
	            }
	        }
	    ];
		
		me.callParent();

	}
});
Ext.define('HreRem.view.activos.detalle.CalidadDatoFasesGrid', {
    extend: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype: 'calidaddatofases',
 	reference:'calidaddatofaseswindow',
	requires: ['HreRem.model.CalidadDatoFasesGridModel'],
	recordName : "calidaddatofases",
	recordClass : "HreRem.model.CalidadDatoFasesGridModel",
	idActivo: null,
	codigoGrid: null,
	minHeight: 20,

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

		me.store = Ext.create('Ext.data.Store',{
			model: 'HreRem.model.CalidadDatoFasesGridModel', 
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getCalidadDelDatoFiltered', 
				extraParams: {id: me.idActivo} 
			},
			autoLoad: false,
			session: false		
			}
			
		).load();
		
		me.store.filterBy( 
			function (record, id) {
				return record.get('codigoGrid') == me.codigoGrid;
			}
		);

		me.columns = [ 
            {            	
                flex	 : 1,
                dataIndex: 'nombreCampoWeb',
                renderer: coloredRender
            },
            {
            	text	 : HreRem.i18n('publicacion.calidad.datos.informacion.rem'),
                flex	 : 2,
                dataIndex: 'valorRem', 
                renderer: coloredRender
            },
            {
            	text	 : HreRem.i18n('publicacion.calidad.datos.informacion.dq'),
                flex	 : 2,
                dataIndex: 'valorDq', 
                renderer: coloredRender
            },
            {
            	xtype: 'actioncolumn',
            	text	 : HreRem.i18n('publicacion.calidad.datos.indicador.correcto'),
                flex	 : 1,
                dataIndex: 'indicadorCorrecto',
                renderer: coloredRender,
                items: [{
			            getClass: function(v, metadata, record ) {

			            	var correctoFase = record.get('indicadorCorrecto');
			
							if(correctoFase == 1)  {
	     						return 'app-tbfiedset-ico icono-tickok no-pointer';
     						}else if(correctoFase == 0){
	     						return 'app-tbfiedset-ico icono-tickko no-pointer';
	     					}else {
	     						return 'app-tbfiedset-ico icono-tickinterrogante no-pointer';
	     					}			            	
			            }
			        }]
                		
            }            
		 
		];		
		
		me.callParent();

	}
});
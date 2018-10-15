Ext.define('HreRem.view.activos.gestores.GestoresList', {
    extend: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype: 'gestoreslist',
	bind: {
		store: '{storeGestoresActivos}'
	},
	reference: 'listadoGestores',

	initComponent: function() {

		var me = this;

		var coloredRender = function (value, meta, record) {
    		var fechaHasta = record.get('fechaHasta');
    		if(value){
	    		if (fechaHasta) {
	    			return '<span style="color: #DF0101;">'+value+'</span>';
	    		} else {
	    			return value;
	    		}
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
		}

		me.columns = [
            {
            	text	 : HreRem.i18n('gestores.gestoresList.grid.column.descripcion'),
                flex	 : 2,
                dataIndex: 'descripcion',
                renderer: coloredRender
            }, 
		    {               
                text	 : HreRem.i18n('gestores.gestoresList.grid.column.usuario'),
                flex	 : 3,
                dataIndex: 'apellidoNombre',
                renderer: coloredRender
            },
            {
                text	 : HreRem.i18n('gestores.gestoresList.grid.column.desde'),
                flex	 : 1,
                dataIndex: 'fechaDesde',
                renderer: dateColoredRender
            },
            {
            	text	 : HreRem.i18n('gestores.gestoresList.grid.column.hasta'),
            	flex	 : 1,
                dataIndex: 'fechaHasta',
                align	 : 'center',
                renderer: dateColoredRender
            },     
            {
                text     : HreRem.i18n('gestores.gestoresList.grid.column.telefono'),
                flex     : 1,
                dataIndex: 'telefono',
                renderer: coloredRender
            }, 
            {
            	text	 : HreRem.i18n('gestores.gestoresList.grid.column.email'),
                flex	 : 1,
                dataIndex: 'email',
                renderer: coloredRender
            }
		 
		];

		me.dockedItems = [
			{
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'gestoresPaginationToolbar',
	            displayInfo: true,
				bind: {
					store: '{storeGestoresActivos}'
				}
	
	        }	
		];

		me.callParent();

	}
});
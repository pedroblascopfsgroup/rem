Ext.define('HreRem.view.activos.gestores.GestoresList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'gestoreslist',
	bind: {
		store: '{storeGestores}'
	},
	reference: 'listadoGestores',
	
	initComponent: function() {
		
		var me = this;
		
		var coloredRender = function (value, meta, record) {
    		var fechaHasta = record.get('fechaHasta');
    		if(value){
	    		if (fechaHasta){
	    			//return '<span style="color: #DF0101; font-weight: bold;">'+value+'</span>';
	    			return '<span style="color: #DF0101;">'+value+'</span>';
	    		}
	    		else {
	    			return '<span style="color: #000000;">'+value+'</span>';
	    		}
    		}else{
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
            	text	 : 'Descripcion',
                flex	 : 2,
                dataIndex: 'descripcion',
                renderer: coloredRender
            }, 
		    {               
                text	 : 'Usuario',
                flex	 : 3,
                dataIndex: 'apellidoNombre',
                renderer: coloredRender
            },
            {
                text	 : 'Desde',               
                flex	 : 1,
                dataIndex: 'fechaDesde',
                renderer: dateColoredRender
            },
            {
            	text	 : 'Hasta',
            	flex	 : 1,
                dataIndex: 'fechaHasta',
                align	 : 'center',
                renderer: dateColoredRender
            },     
            {
                text     : 'Teléfono',
                flex     : 1,
                dataIndex: 'telefono',
                renderer: coloredRender
            }, 
            {
            	text	 : 'Email',
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
					store: '{storeGestores}'
				}
	
	        }	
		];
		
		 
		
		me.callParent();
		
		
	}

    
});
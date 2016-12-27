Ext.define('HreRem.view.trabajos.HistoricoPeticionesActivo', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'historicopeticionesactivo',
	bind: {
		store: '{historicoTrabajos}'
	},

    initComponent: function () {
     	var me = this;
     	me.setTitle(HreRem.i18n('title.historico.peticiones'));

	    me.listeners = {
			rowdblclick: 'onHistoricoPeticionesActivoDobleClick'
	    };

	    me.columns = [
  				{
	            	text	 : HreRem.i18n('header.numero.trabajo'),
	                flex	 : 1,
	                dataIndex: 'numTrabajo'
	            },
	            {   
	            	text	 : HreRem.i18n('header.fecha.solicitud'),
	            	flex: 1,
	                dataIndex: 'fechaSolicitud',
			        formatter: 'date("d/m/Y")'					
			    },
	            {
		            text: HreRem.i18n('header.tipo'),
		           	flex	 : 1,
		           	dataIndex: 'descripcionTipo'
	            },		            
		        {
		           	text: HreRem.i18n('header.subtipo'),
		            flex	 : 1,
		            dataIndex: 'descripcionSubtipo'
		        },
	            {
	            	text	 : HreRem.i18n('header.estado'),
	                flex	 : 1,
	                dataIndex: 'descripcionEstado'
	            },
	            {
	            	text	 : HreRem.i18n('header.solicitante'),
	                flex	 : 1,
	                dataIndex: 'solicitante'
	            },
	            {
		            text: HreRem.i18n('header.proveedor'),
		            flex	 : 1,
		            dataIndex: 'proveedor'
	            
		        },
	            {
		            text: HreRem.i18n('header.numero.activos.afectados'),
		            flex	 : 1,
		            dataIndex: 'numeroAfectados'
	            
		        }
	        ];

	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'trabajosPaginationToolbar',
	            displayInfo: true,
	            bind: {
	                store: '{historicoTrabajos}'
	            }
	        }
	    ];

	    me.callParent();
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.getStore().load();
    }
});
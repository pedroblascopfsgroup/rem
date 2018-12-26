Ext.define('HreRem.view.activos.detalle.HistoricoDestinoComercialActivo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'historicodestinocomercialactivoform',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'historicodestinocomercialactivoformref',
    layout		: 'fit',
	requires	: ['HreRem.view.common.FieldSetTable'],	

    initComponent: function () {
        var me = this;

        var items= [
			{
			    xtype		: 'gridBase',
			    reference: 'historicoDestinoComercialActivoGrid',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeHistoricoDestinoComercial}'
				},
				columns: [
		  				{
			            	text	 : HreRem.i18n('header.tipo.comercializacion'),
			                flex	 : 2,
			                dataIndex: 'tipoComercializacion'
			            },
			            {
			            	text	 : HreRem.i18n('header.fecha.inicio'),
			                flex	 : 1,
			                formatter: 'date("d/m/Y")',
			                dataIndex: 'fechaInicio'
			            },
			            {
				            text: HreRem.i18n('header.fecha.fin'),
				            formatter: 'date("d/m/Y")',
				            dataIndex: 'fechaFin',
							flex	: 1
				            
				        },
			            {
				            text: HreRem.i18n('header.gestor.actualizacion'),
				            dataIndex: 'gestorActualizacion',
							flex	: 3
				            
				        }
			    ],

			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeHistoricoDestinoComercial}'
			            }
			        }
			    ]
			}
        ];

		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
});
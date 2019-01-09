Ext.define('HreRem.view.activos.detalle.OfertasAsociadasActivoList', {
	extend: 'HreRem.view.common.GridBase',
    xtype: 'ofertasasociadasactivolist',
    
    cls: 'panel-base shadow-panel',
    bind: {
        store: '{storeOfertasAsociadasActivo}'
    },
        
    initComponent: function () {
        
        var me = this;
        
        me.columns = [
		        {
		            dataIndex: 'fechaPreBloqueo',
		            text: HreRem.i18n('header.fecha.prebloqueo'),
		            formatter: 'date("d/m/Y")',
		            width: 320
		        },
		        {
		            dataIndex: 'numOferta',
		            text: HreRem.i18n('header.oferta'),
		            width: 320
		        },
		        {
		            dataIndex: 'importeOferta',
		            text: HreRem.i18n('header.importe'),
		            renderer: function(value) {
		        		return Ext.util.Format.currency(value);
		        	},
		        	width: 320
		        },
		        {
		            dataIndex: 'tipoComprador',
		            text: HreRem.i18n('header.tipo.comprador'),
		            width: 320
		        },
		        {
		            dataIndex: 'situacionOcupacional',
		            text: HreRem.i18n('header.situacion.ocupacional'),
		            width: 320
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'ofertasAsociadasPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeOfertasAsociadasActivo}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});
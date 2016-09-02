Ext.define('HreRem.view.activos.detalle.HistoricoMediadorGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'historicomediadorgrid',
	topBar: false,
	idPrincipal : 'activo.id',
	
    bind: {
        store: '{historicoMediador}'
    },
    
    initComponent: function () {
     	
     	var me = this;
		
		me.columns = [
		        {
		            dataIndex: 'fechaDesde',
		            text: HreRem.i18n('title.publicaciones.mediador.fechaDesde'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaHasta',
		            text: HreRem.i18n('title.publicaciones.mediador.fechaHasta'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'codigo',
		            text: HreRem.i18n('title.publicaciones.mediador.codigo'),
		            flex: 1
		        },
		        {
		            dataIndex: 'mediador',
		            text: HreRem.i18n('title.publicaciones.mediador.mediador'),
		            flex: 1
		        },
		        {
		            dataIndex: 'telefono',
		            text: HreRem.i18n('title.publicaciones.mediador.telefono'),
		            flex: 1
		        },
		        {
		        	dataIndex: 'email',
		            text: HreRem.i18n('title.publicaciones.mediador.email'),
		            flex: 1
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
		                store: '{historicoMediador}'
		            }
		        }
		    ];
		    
		    
		    me.callParent();
   },
   
   onGridBaseSelectionChange: function(grid, records) {
	   //Se sobreescribe para que no deje eliminar.
   }

});
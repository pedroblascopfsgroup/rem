Ext.define('HreRem.view.activos.detalle.HistoricoConcurrenciaGrid', {
	extend: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype: 'historicoconcurrenciagrid',
    idPrincipal: 'id',
    topBar: false,
    requires	: ['HreRem.model.HistoricoConcurrenciaGridModel'],
	reference	: 'historicoConcurrenciaref',
    bind: {
        store: '{storeHistoricoConcurrencia}'
    },  
    initComponent: function () {
        
        var me = this;
        
        me.columns = [
	        	{
		        	dataIndex: 'numActivo',
		            text: HreRem.i18n('header.numero.activo'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'numAgrupacion',
		            text: HreRem.i18n('fieldlabel.num.agrupacion'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'importeMinOferta',
		            text: HreRem.i18n('header.importe.minimo.oferta'),
		            renderer: function(value) {
		        		return Ext.util.Format.currency(value);
		        	},
		            flex: 0.5
		        },
		        {
		            dataIndex: 'importeDeposito',
		            text: HreRem.i18n('header.importe.deposito'),
		            renderer: function(value) {
		        		return Ext.util.Format.currency(value);
		        	},
		            flex: 0.5
		        },
		        {   
			    	text	 : HreRem.i18n('header.fecha.inicio'), 
		        	dataIndex: 'fechaInicio',
		        	formatter: 'date("d/m/Y")',
		        	flex: 0.5
		        },
		        {   
			    	text	 : HreRem.i18n('header.fecha.fin'), 
		        	dataIndex: 'fechaFin',
		        	formatter: 'date("d/m/Y")',
		        	flex: 0.5
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'pujasPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeHistoricoConcurrencia}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    },
    
    recargarGrid: function() {
    	var me = this;
    	me.getStore().load();
    } 
});
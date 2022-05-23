Ext.define('HreRem.view.activos.detalle.PujaDetalleOfertaGrid', {
	extend: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype: 'pujadetalleofertagrid',
    idPrincipal: 'id',
    topBar: false,
    requires	: ['HreRem.model.Pujas'],
	reference	: 'pujaDetalleOfertaGridref',
    bind: {
        store: '{storePuja}'
    },  
    initComponent: function () {
        
        var me = this;
        
        me.columns = [
		        {   
			    	text	 : HreRem.i18n('header.pujas.fecha.historico'), 
		        	dataIndex: 'fechaCrear',
		        	formatter: 'date("d/m/Y")',
		        	flex:1
		        },
		        {   
		        	text	 : HreRem.i18n('header.pujas.importe.historico'), 
		        	dataIndex: 'importePuja',
		        	renderer: function(value) {
		        		return Ext.util.Format.currency(value);
		        	},
		        	flex:1 
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
		                store: '{storePuja}'
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
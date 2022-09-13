Ext.define('HreRem.view.activos.detalle.CambiosConcurrenciaComercialActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'cambiosconcurrenciacomercialactivolist',
    require		: ['HreRem.model.CambioPeriodoConcurrenciaActivoModel'],
    reference	: 'cambiosconcurrenciacomercialactivolistref',
    
        
    initComponent: function () {
        
        var me = this;  
        
        me.columns= [
        
	        	{
		        	dataIndex: 'accionConcurrencia',
		            text: HreRem.i18n('title.lista.cambios.periodo.concurrencia.accion'),
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaInicio',
		            text: HreRem.i18n('title.lista.cambios.periodo.concurrencia.fecha.inicio'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaFin',
		            text: HreRem.i18n('title.lista.cambios.periodo.concurrencia.fecha.fin'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'cambiosConcurrenciaPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true
		        }
		];
		    
        me.callParent(); 
        
    },
    
    recargarGrid: function() {
    	var me = this;
    	me.getStore().load();
    }
});

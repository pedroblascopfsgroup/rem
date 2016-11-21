Ext.define('HreRem.view.configuracion.mediadores.detalle.CarteraMediadorStats', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'carteramediadorstats',
    reference: 'carteraMediadorStats',
	topBar: false,
	idPrincipal : 'id',
	editOnSelect: false,
	disabledDeleteBtn: true,
	
    bind: {
        store: '{listaStatsCarteraMediadores}'
    },
    
    
    initComponent: function () {
     	var me = this;
		
// TODO: Event on click data stats
//     	me.listeners = {
//    			rowdblclick: ''
//    	    };

		me.columns = [
				{
					dataIndex: 'id',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.id'),
					flex: 0.3,
					hidden: true
				},
				{
					dataIndex: 'numActivos',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.numActivos'),
					flex: 0.3
				},
				{
					dataIndex: 'numVisitas',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.numVisitas'),
					flex: 0.3
				},
				{
					dataIndex: 'numOfertas',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.numOfertas'),
					flex: 0.3
				},
				{
					dataIndex: 'numReservas',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.numReservas'),
					flex: 0.5
				},
				{
					dataIndex: 'numVentas',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.numVentas'),
					flex: 0.3
				},
				{
					dataIndex: 'descripcionCalificacion',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.Calificacion'),
					flex: 1
				},
				{
					dataIndex: 'esTop',
					text: HreRem.i18n('header.evaluacion.mediadores.detail.esTop'),
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
		                store: '{listaStatsCarteraMediadores}'
		            }
		        }
		    ];
		    
		    me.callParent();
   }

});
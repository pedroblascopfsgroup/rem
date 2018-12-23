Ext.define('HreRem.view.activos.detalle.NotificacionesActivoList', {
	extend: 'HreRem.view.common.GridBase',
    xtype: 'notificacionesactivolist',
    
    bind: {
        store: '{storeNotificacionesActivo}'
    },
    topBar:  true,
    removeButton: false,
    
    estaComunicado: false,
        
    initComponent: function () {
        
        var me = this; 
        
        //me.estaComunicado = me.up("gencatcomercialactivoform").estaComunicado;
        //debugger;
        //TODO: Evitar que se muestre o esté activado este botón dependiendo del estado de la comunicación
        //me.addButton = '{!gencat.estaComunicado}'; 
        
        me.columns= [
		        {
		            dataIndex: 'fechaNotificacion',
		            text: HreRem.i18n('fieldlabel.motivo'), 
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'motivoNotificacion',
		            text: HreRem.i18n('fieldlabel.motivo'),
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaSancionNotificacion',
		            text: HreRem.i18n('fieldlabel.motivo'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'cierreNotificacion',
		            text: HreRem.i18n('fieldlabel.motivo'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'reclamacionesactivolistPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeNotificacionesActivo}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});
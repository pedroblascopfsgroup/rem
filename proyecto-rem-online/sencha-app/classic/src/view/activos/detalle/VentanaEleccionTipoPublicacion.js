Ext.define('HreRem.view.activos.detalle.VentanaEleccionTipoPublicacion', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'ventanaEleccionTipoPublicacion',
    reference	: 'ventanaEleccionTipoPublicacion',
    controller	: 'tarea',
    controller: 'activodetalle',
    width		: 350,

    initComponent: function() {
    	var me = this;

    	me.title = HreRem.i18n('window.tipo.publicacion.alquiler.title');
    
		me.buttons = [
			{itemId: 'btnForzado', text: HreRem.i18n('window.tipo.publicacion.alquiler.btn.prepublicar'), codigo: '0', handler: 'establecerTipoPublicacionAlquiler'},
			{itemId: 'btnPrepublicado', text: HreRem.i18n('window.tipo.publicacion.alquiler.btn.forzado'), codigo: '1', handler: 'establecerTipoPublicacionAlquiler'},
			{itemId: 'btnCancelar', text: HreRem.i18n('btn.cancelBtnText'), handler: 'cancelarEstablecerTipoPublicacionAlquiler'}
		];

    	me.items = [
            {
			    xtype: 'form',
			    layout: 'fit',
			    items: [
			        {
			            xtype: 'displayfield',
			            style: 'width: 100%;',
						fieldLabel: HreRem.i18n('window.tipo.publicacion.alquiler.text')
					}
			    ]
    	    }
    	];

    	me.callParent();
    }
});
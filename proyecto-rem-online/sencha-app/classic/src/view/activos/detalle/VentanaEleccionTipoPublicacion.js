Ext.define('HreRem.view.activos.detalle.VentanaEleccionTipoPublicacion', {
	extend		: 'HreRem.view.common.WindowBase',
	xtype		: 'ventanaEleccionTipoPublicacion',
	reference	: 'ventanaEleccionTipoPublicacionref',
	controller	: 'tarea',
	controller  : 'activodetalle',
	width		: 350,

	initComponent: function() {
		var me = this;

		me.title = HreRem.i18n('window.tipo.publicacion.alquiler.title');

		me.buttons = [
		    {itemId: 'btnPrepublicado', text: HreRem.i18n('window.tipo.publicacion.alquiler.btn.prepublicar'), codigo: CONST.MODO_PUBLICACION_ALQUILER['PRE_PUBLICAR'], handler: 'establecerTipoPublicacionAlquiler'},
			{itemId: 'btnForzado', text: HreRem.i18n('window.tipo.publicacion.alquiler.btn.forzado'), codigo: CONST.MODO_PUBLICACION_ALQUILER['FORZADO'], handler: 'establecerTipoPublicacionAlquiler'},			
			{itemId: 'btnCancelar', text: HreRem.i18n('btn.cancelBtnText'), handler: 'cancelarEstablecerTipoPublicacionAlquiler'}
		];

		me.items = [
			{
				xtype: 'container',
				layout: 'fit',
				items: [
					{
						xtype: 'displayfield',
						value: HreRem.i18n('window.tipo.publicacion.alquiler.text')
					}
				]
			}
		];

		me.callParent();
	}
});
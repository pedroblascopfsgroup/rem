Ext.define('HreRem.view.activos.detalle.HistoricoFasesDePublicacionGrid', {
	extend:'HreRem.view.common.GridBaseEditableRow',
	xtype:'historicofasesdepublicaciongrid',
	topbar:true,
	editOnSelect:false,
	disabledDeletedBtn:true,
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
			{
				text:HreRem.i18n('fieldlabel.fases.de.publicacion.fase.de.publicacion'),
				flex:0.5
			},
			{
				text:HreRem.i18n('fieldlabel.fases.de.publicacion.subfase.de.publicacion'),
				flex:0.5
			},
			{
				text:HreRem.i18n('title.fases.de.publicacion.usuario'),
				flex:0.5
			},
			{
				text:HreRem.i18n('title.fases.de.publicacion.fecha.inicio'),
				flex:0.5
			},
			{
				text:HreRem.i18n('title.fases.de.publicacion.fecha.fin'),
				flex:0.5
			},
			{
				text:HreRem.i18n('fieldlabel.fases.de.publicacion.comentario'),
				flex:0.5
			}
		];
		
		me.dockedItems = [
			{
				xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'activosPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true
			}
		];
		
		me.callParent();
	}
});
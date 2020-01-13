Ext.define('HreRem.view.activos.detalle.HistoricoFasesDePublicacionGrid', {
	extend:'HreRem.view.common.GridBaseEditableRow',
	xtype:'historicofasesdepublicaciongrid',
	topbar:true,
	editOnSelect:false,
	disabledDeletedBtn:true,
	
	bind: {
		store: '{storeHistoricoFesesDePublicacion}'
	},
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
			{
				text:HreRem.i18n('fieldlabel.fases.de.publicacion.fase.de.publicacion'),
				dataIndex: 'fasePublicacion',
				flex:0.5
			},
			{
				text:HreRem.i18n('fieldlabel.fases.de.publicacion.subfase.de.publicacion'),
				dataIndex: 'subfasePublicacion',
				flex:0.5
			},
			{
				text:HreRem.i18n('title.fases.de.publicacion.usuario'),
				dataIndex: 'usuario',
				flex:0.5
			},
			{
				text:HreRem.i18n('title.fases.de.publicacion.fecha.inicio'),
				dataIndex: 'fechaInicio',
				flex:0.5,
				formatter: 'date("d/m/Y")'
			},
			{
				text:HreRem.i18n('title.fases.de.publicacion.fecha.fin'),
				dataIndex: 'fechaFin',
				flex:0.5,
				formatter: 'date("d/m/Y")'
			},
			{
				text:HreRem.i18n('fieldlabel.fases.de.publicacion.comentario'),
				dataIndex: 'comentario',
				flex:0.5
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
	                store: '{storeHistoricoFesesDePublicacion}'
	            }
	        }
	    ];
		
		me.callParent();
	}
});
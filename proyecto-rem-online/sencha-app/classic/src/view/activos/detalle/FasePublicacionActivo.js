Ext.define('HreRem.view.activos.detalle.FasePublicacionActivo', {
	extend		:'HreRem.view.common.FormBase',
	xtype		:'fasepublicacionactivo',
	reference	:'fasepublicacionactivoref',
	cls			:'panel-base shadow-panel',
	collapsed	:false,
	scrollable	:'y',
	saveMultiple:true,
	refreshAfterSave:true,
	disableValidation: false,
	records		:['fasepublicacionactivo'],
	recordsClass:['HreRem.model.FasePublicacionActivo'],
	requires	:['HreRem.view.common.FieldSetTable', 'HreRem.view.activos.detalle.HistoricoFasesDePublicacionGrid',
				  'HreRem.model.FasePublicacionActivo'],
				  
	listeners	: {
					boxready:'cargarTabData'
				  },
	
	initComponent: function () {
		var me = this;
		me.setTitle(HreRem.i18n('fieldlabel.fases.de.publicacion'));
		
		me.items = [
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.datos.generales'),
				defaultType:'textfieldbase',
				items:[
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.fases.de.publicacion.fase.de.publicacion'),
						reference: 'chkbxFase',
						bind: {
							store: '{storeFasesDePublicacion}',
							value: '{fasepublicacionactivo.fasePublicacionCodigo}'
						},
						allowBlank: false,
						listeners: {
							select: 'onChangeChainedCombo',
							change: 'onChkbxFaseChange'
						},
						chainedStore: 'storeSubfasesDePublicacionFiltered',
						chainedReference: 'chkbxSubfase'
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.fases.de.publicacion.subfase.de.publicacion'),
						reference: 'chkbxSubfase',
						bind: {
							store: '{storeSubfasesDePublicacion}',
							value: '{fasepublicacionactivo.subfasePublicacionCodigo}'
						},
						listeners: {
							change: 'onChkbxSubfaseChange'
						}
					},
					{
						xtype:'textareafieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.fases.de.publicacion.comentario'),
						reference: 'faseComentario',
						bind: {
							value: '{fasepublicacionactivo.comentario}'
						}
					}
				]
			},
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('fases.de.publicacion.grid.historico'),
				defualtType:'textfieldbase',
				items:[
					{
						xtype: 'historicofasesdepublicaciongrid',
						reference: 'historicofasesdepublicaciongrid',
						bind: {
							store: '{storeHistoricoFesesDePublicacion}'
						}
					}
				]
			}
		];
		
		me.callParent();
		
	},
	
	funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
			grid.getStore().load();
		});
		var comboFase = me.lookupController().getView().lookupReference('chkbxFase');
		var storeFasesDePublicacion = me.lookupController().getViewModel().get("storeFasesDePublicacion");
		comboFase.bindStore(storeFasesDePublicacion);
		storeFasesDePublicacion.load({
			scope: this,
			callback: function(records, operation, success) {
				var codFase = me.lookupController().getViewModel().get('fasepublicacionactivo.fasePublicacionCodigo');
				comboFase.setValue(codFase);
			}
		});
		var comboSubfase = me.lookupController().getView().lookupReference('chkbxSubfase');
		comboSubfase.setDisabled(false);
		var storeSubfasesDePublicacion = me.lookupController().getViewModel().get("storeSubfasesDePublicacion");
		comboSubfase.bindStore(storeSubfasesDePublicacion);
		storeSubfasesDePublicacion.load();
    }
});
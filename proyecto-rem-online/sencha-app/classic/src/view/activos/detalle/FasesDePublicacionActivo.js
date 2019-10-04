Ext.define('HreRem.view.activos.detalle.FasesDePublicacionActivo', {
	extend		:'HreRem.view.common.FormBase',
	xtype		:'fasesdepublicacionactivo',
	reference	:'fasesdepublicacionactivoref',
	cls			:'panel-base shadow-panel',
	collapsed	:false,
	scrollable	:'y',
	saveMultiple:true,
	refreshAfterSave:true,
	disableValidation: false,
	requires	:['HreRem.view.common.FieldSetTable', 'HreRem.view.activos.detalle.HistoricoFasesDePublicacionGrid'],
	
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
						fieldLabel: HreRem.i18n('fieldlabel.fases.de.publicacion.fase.de.publicacion')
					},
					{
						xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.fases.de.publicacion.subfase.de.publicacion')
					},
					{
						xtype:'textareafieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.fases.de.publicacion.comentario')
					}
				]
			},
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('fases.de.publicacion.grid.historico'),
				defualtType:'textfieldbase',
				items:[
					{
						xtype:'historicofasesdepublicaciongrid',
						reference:'historicofasesdepublicaciongrid'
					}
				]
			}
		];
		
		me.callParent();
		
	}
});
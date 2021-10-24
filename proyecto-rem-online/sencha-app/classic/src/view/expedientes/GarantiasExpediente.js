Ext.define('HreRem.view.expedientes.GarantiasExpediente', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'garantiasexpediente',
	cls : 'panel-base shadow-panel',
	collapsed : false,
	disableValidation : false,
	reference : 'garantiasExpediente',
	scrollable : 'y',
	recordName : "garantias",
	recordClass : "HreRem.model.GarantiasExpedienteModel",
	requires : [ 'HreRem.model.GarantiasExpedienteModel'],
	refreshAfterSave: true, 
	listeners : {
		boxready : 'cargarTabData' //TODO lo necesito¿?
	},
	initComponent : function() {
		var me = this;
		me.setTitle(HreRem.i18n('title.garantias'));
		var isBK = me.lookupController().getViewModel().get('expediente.esBankia');
		var items = [
			{
				xtype : 'fieldset',
				collapsible : true,
				defaultType : 'displayfieldbase',
				title : HreRem.i18n('title.garantias.adicionales'),
				reference: 'garantiasAdicionalesRef',
				/*layout : {
					type : 'table',
					columns : 4
				},*/
				/*bind : {
					hidden : '{!esOfertaVenta}'
				},*/
				items : [
							{
								xtype : 'fieldset',
								collapsible : true,
								defaultType : 'displayfieldbase',
								title : HreRem.i18n('title.bloque.scoring'),
								reference: 'bloqueScoringRef',
								editable: '{garantias.scoringEditable}',
								colspan:4,
								layout : {
									type : 'table',
									columns : 3
								},
								bind : {
									disabled: '{!garantias.scoringEditable}'
								},
								items : [
											{
												xtype : 'checkboxfieldbase',
												reference : 'chckboxScoringRef',
												fieldLabel : HreRem.i18n('title.scoring'),
												colspan:3,
												bind : {
													value : '{garantias.scoring}'
												},
												handler:'onClickCheckboxScoring'
											},
											{
												xtype : 'comboboxfieldbase',
												fieldLabel : HreRem.i18n('fieldlabel.resultado.haya'),
												bind : {
													store : '{comboResultadoHaya}',
													value : '{garantias.resultadoHayaCod}'
												},
												displayField : 'descripcion',
												valueField : 'codigo',
												reference : 'resultadoHayaRef',
												listeners:{
													select: 'onChangeComboResultadoHaya'
												},
												disabled: true
											},
											{
												xtype : 'datefieldbase',
												reference : 'fechaSancionRef',
												fieldLabel : HreRem.i18n('fieldlabel.fecha.sancion'),
												maxValue: null,
												bind : {
													value : '{garantias.fechaSancion}'
												},
												disabled: true
											},
											{
												xtype : 'numberfieldbase',
												reference : 'numeroExpedienteRef',
												fieldLabel : HreRem.i18n('fieldlabel.num.expediente'),												
												bind : {
													value : '{garantias.numeroExpediente}'
												},
												disabled: true
											},
											{
												xtype : 'comboboxfieldbase',
												fieldLabel : HreRem.i18n('fieldlabel.resultado.propiedad'),
												bind : {
													store : '{comboResultadoPropiedad}', 
													value : '{garantias.resultadoPropiedadCod}'
												},
												displayField : 'descripcion',
												valueField : 'codigo',
												reference : 'resultadoPropiedadRef',
												disabled: true,
												readOnly: true
											},
											{
												xtype : 'textfieldbase',
												fieldLabel : HreRem.i18n('fieldlabel.motivo.rechazo'),
												bind : {													
													value : '{garantias.motivoRechazo}'
												},
												reference : 'motivoRechazoRef',
												disabled: true
											},
											{
												xtype : 'comboboxfieldbase',
												fieldLabel : HreRem.i18n('fieldlabel.rating.haya'),
												bind : {
													store : '{comboResultadoRatingScoring}',
													value : '{garantias.ratingHayaCod}'
												},
												displayField : 'descripcion',
												valueField : 'codigo',
												reference : 'ratingHayaRef',
												disabled: true
											}
										]
							},{
								xtype : 'fieldset',
								collapsible : true,
								defaultType : 'displayfieldbase',
								title : HreRem.i18n('title.bloque.aval'),
								reference: 'bloqueAvalRef',
								colspan:4,
								layout : {
									type : 'table',
									columns : 3
								},
								bind : {
									disabled: '{!garantias.bloqueEditable}'
								},
								items : [
											{
												xtype : 'checkboxfieldbase',
												reference : 'chckboxAvalRef',
												fieldLabel : HreRem.i18n('title.bloque.aval'),
												colspan:3,
												bind : {
													value : '{garantias.aval}'
												},
												handler:'onClickCheckboxAval'
											},
											{
												xtype : 'textfieldbase',
												reference : 'avalistaRef',
												fieldLabel : HreRem.i18n('fieldlabel.avalista'),
												bind : {
													value : '{garantias.avalista}'
												},
												disabled: true
											},
											{
												xtype : 'textfieldbase',
												reference : 'documentoRef',
												fieldLabel : HreRem.i18n('header.documento'),
												bind : {
													value : '{garantias.documento}'
												},
												disabled: true
											},
											{
												xtype : 'comboboxfieldbase',
												reference : 'entidadBancariaRef',
												fieldLabel : HreRem.i18n('fieldlabel.entidad.bancaria'),
												bind : {
													store : '{comboEntidadBancariaAvalista}',
													value : '{garantias.entidadBancariaCod}'
												},
												displayField : 'descripcion',
												valueField : 'codigo',
												disabled: true
											},
											{
												xtype : 'numberfieldbase',
												reference : 'mesesAvalRef',
												symbol : HreRem.i18n('symbol.meses'),
												fieldLabel : HreRem.i18n('fieldlabel.meses'),
												bind : '{garantias.mesesAval}',
												maxLength: 2,
												maxValue: 12,
												disabled: true
											}, 											
											{
												xtype : 'numberfieldbase',
												reference : 'importeAvalRef',
												symbol : HreRem.i18n("symbol.euro"),
												fieldLabel : HreRem.i18n('fieldlabel.importe'),
												bind : '{garantias.importeAval}',
												disabled: true
											},
											{
												xtype : 'datefieldbase',
												reference : 'fechaVencimientoRef',
												fieldLabel : HreRem.i18n('fieldlabel.fechaVencimiento'),
												maxValue: null,
												bind : {
													value : '{garantias.fechaVencimiento}'
												},
												disabled: true
											}
										]
							},{
								xtype : 'fieldset',
								collapsible : true,
								defaultType : 'displayfieldbase',
								title : HreRem.i18n('title.bloque.seguro.rentas'),
								reference: 'bloqueSeguroRentasRef',
								colspan:4,
								layout : {
									type : 'table',
									columns : 3
								},
								bind : {
									disabled: '{!garantias.bloqueEditable}'
								},
								items : [
								
											{
												xtype : 'checkboxfieldbase',
												reference : 'chckboxseguroRentasRef',
												fieldLabel : HreRem.i18n('title.seguro.rentas'),
												colspan:3,
												bind : {
													value : '{garantias.seguroRentas}'
												},
												handler:'onClickCheckBoxSeguroRentas'
											},
											{
												xtype : 'comboboxfieldbase',
												reference : 'aseguradoraRef',
												fieldLabel : HreRem.i18n('fieldlabel.aseguradora'),
												bind : {
													store : '{comboTiposPorCuenta}',
													value : '{garantias.aseguradoraCod}'
												},
												displayField : 'descripcion',
												valueField : 'codigo',
												disabled: true
											},
											{
												xtype : 'datefieldbase',
												reference : 'fechaSancionRentasRef',
												colspan:2,
												fieldLabel : HreRem.i18n('fieldlabel.fecha.sancion'),
												maxValue: null,
												bind : {
													value : '{garantias.fechaSancionRentas}'
												},
												disabled: true
											},
											{
												xtype : 'numberfieldbase',
												reference : 'mesesRentasRef',
												symbol : HreRem.i18n('symbol.meses'),
												fieldLabel : HreRem.i18n('fieldlabel.meses'),
												bind : '{garantias.mesesRentas}',
												maxLength: 2,
												maxValue: 12,
												disabled: true
											}, 											
											{
												xtype : 'numberfieldbase',
												reference : 'importeRentasRef',
												symbol : HreRem.i18n("symbol.euro"),
												fieldLabel : HreRem.i18n('fieldlabel.importe'),
												bind : '{garantias.importeRentas}',
												disabled: true
											}
										]
							},
							{
								xtype : 'fieldset',
								height : 100,
								layout : {
									type : 'table',
									columns : 2
								},
								defaultType : 'textfieldbase',
								title : HreRem.i18n("fieldlabel.deposito"),
								bind:{
									disabled: '{!garantias.bloqueDepositoEditable}'
								},
								items : [
									{
										xtype : 'numberfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.meses'),
										bind : {
											value : '{garantias.mesesDeposito}'
										},
										readOnly : false
									},
									{
										xtype : 'checkboxfieldbase',
										reference : 'chekboxReservaConImpuesto',
										fieldLabel : HreRem.i18n('fieldlabel.deposito.actualizable'),
										bind : {
											value : '{garantias.depositoActualizable}'
										},
										readOnly : false
									},
									{
										xtype : 'numberfieldbase',
										reference : 'importeDeposito',
										fieldLabel : HreRem.i18n('fieldlabel.importe'),
										bind : '{garantias.importeDeposito}',
										symbol : HreRem.i18n('symbol.euro'),
										readOnly : false
									} 
								]
							} 
				
				
						]
			}
		];
		me.addPlugin({
			ptype : 'lazyitems',
			items : items
		});
		me.callParent();
	},

	funcionRecargar : function() {
		var me = this;

		me.recargar = false;
		me.lookupController().cargarTabData(me);
		//me.down('[reference=actualizacionRentaGridRef]').getStore().load();
		//me.down('[reference=gastosRepercutidosGridRef]').getStore().load();

	}
});
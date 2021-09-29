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
//		var isAlquiler = me.lookupController().getViewModel().get('expediente.tipoExpedienteCodigo') == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"];
//		var tamanyo1 = 100;
//		
//		if(isBK && isAlquiler){
//			 tamanyo1 = 130;
//		}		

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
								
								colspan:4,
								//height : 145,
								//margin : '0 10 10 0',
								layout : {
									type : 'table',
									columns : 3
								},
								bind : {
									//hidden : '{!esOfertaVenta}'
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
												}
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
												reference : 'resultadoHayaRef'
											},
											{
												xtype : 'datefieldbase',
												reference : 'fechaSancionRef',
												fieldLabel : HreRem.i18n('fieldlabel.fecha.sancion'),
												maxValue: null,
												bind : {
													value : '{garantias.fechaSancion}'
												}
											},
											{
												xtype : 'numberfieldbase',
												reference : 'numeroExpedienteRef',
												//symbol : HreRem.i18n("symbol.porcentaje"),
												fieldLabel : HreRem.i18n('fieldlabel.num.expediente'),												
												bind : {
													value : '{garantias.numeroExpediente}'
												}
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
												reference : 'resultadoPropiedadRef'
											},
											{
												xtype : 'textfieldbase',
												fieldLabel : HreRem.i18n('fieldlabel.motivo.rechazo'),
												bind : {													
													value : '{garantias.motivoRechazo}'
												},
												reference : 'motivoRechazoRef'
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
												reference : 'ratingHayaRef'
											}
										]
							},{
								xtype : 'fieldset',
								collapsible : true,
								defaultType : 'displayfieldbase',
								title : HreRem.i18n('title.bloque.aval'),
								reference: 'bloqueAvalRef',
								colspan:4,
								disabled: '{!garantias.bloqueEditable}',
								layout : {
									type : 'table',
									columns : 3
								},
								bind : {
									//hidden : '{!esOfertaVenta}'
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
												}
											},
											{
												xtype : 'textfieldbase',
												reference : 'avalistaRef',
												//symbol : HreRem.i18n("symbol.porcentaje"),
												fieldLabel : HreRem.i18n('fieldlabel.avalista'),
												bind : {
													value : '{garantias.avalista}'
												}
											},
											{
												xtype : 'numberfieldbase',
												reference : 'documentoRef',
												//symbol : HreRem.i18n("symbol.porcentaje"),
												fieldLabel : HreRem.i18n('header.documento'),
												bind : {
													value : '{garantias.documento}'
												}
											},
											{
												xtype : 'comboboxfieldbase',
												reference : 'entidadBancariaRef',
												//symbol : HreRem.i18n("symbol.porcentaje"),
												fieldLabel : HreRem.i18n('fieldlabel.entidad.bancaria'),
												bind : {
													store : '{comboEntidadBancariaAvalista}',
													value : '{garantias.entidadBancariaCod}'
												},
												displayField : 'descripcion',
												valueField : 'codigo'
											},
											{
												xtype : 'numberfieldbase',
												reference : 'mesesAvalRef',
												symbol : HreRem.i18n('symbol.meses'),
												fieldLabel : HreRem.i18n('fieldlabel.meses'),
												bind : '{garantias.mesesAval}',
												maxLength: 2,
												maxValue: 12
											}, 											
											{
												xtype : 'numberfieldbase',
												reference : 'importeAvalRef',
												symbol : HreRem.i18n("symbol.euro"),
												fieldLabel : HreRem.i18n('fieldlabel.importe'),
												bind : '{garantias.importeAval}'
											},
											{
												xtype : 'datefieldbase',
												reference : 'fechaVencimientoRef',
												fieldLabel : HreRem.i18n('fieldlabel.fechaVencimiento'),
												maxValue: null,
												bind : {
													value : '{garantias.fechaVencimiento}'
												}
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
									//hidden : '{!esOfertaVenta}'
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
												}
											},
											{
												xtype : 'comboboxfieldbase',
												reference : 'aseguradoraRef',
												//symbol : HreRem.i18n("symbol.porcentaje"),
												fieldLabel : HreRem.i18n('fieldlabel.aseguradora'),
												bind : {
													store : '{comboTiposPorCuenta}',
													value : '{garantias.aseguradoraCod}'
												},
												displayField : 'descripcion',
												valueField : 'codigo'
											},
											{
												xtype : 'datefieldbase',
												reference : 'fechaSancionRentasRef',
												colspan:2,
												fieldLabel : HreRem.i18n('fieldlabel.fecha.sancion'),
												maxValue: null,
												bind : {
													value : '{garantias.fechaSancionRentas}'
												}
											},
											{
												xtype : 'numberfieldbase',
												reference : 'mesesRentasRef',
												symbol : HreRem.i18n('symbol.meses'),
												fieldLabel : HreRem.i18n('fieldlabel.meses'),
												bind : '{garantias.mesesRentas}',
												maxLength: 2,
												maxValue: 12
											}, 											
											{
												xtype : 'numberfieldbase',
												reference : 'importeRentasRef',
												symbol : HreRem.i18n("symbol.euro"),
												fieldLabel : HreRem.i18n('fieldlabel.importe'),
												bind : '{garantias.importeRentas}'
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
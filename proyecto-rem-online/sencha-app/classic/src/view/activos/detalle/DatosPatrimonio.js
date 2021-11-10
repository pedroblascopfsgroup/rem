Ext.define('HreRem.view.activos.detalle.DatosPatrimonio', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'datospatrimonio',   
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'datospatrimonio',
    refreshaftersave: true,
	scrollable	: 'y',
	recordName	: 'patrimonio',
	recordClass : 'HreRem.model.ActivoPatrimonio',
	requires: ['HreRem.model.ActivoPatrimonio','HreRem.view.activos.detalle.HistoricoAdecuacionesGrid'],

	listeners: {
    	boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    	},
    	activate :'onActivateTabPatrimonioActivo'
    },
    
    initComponent: function () {
        var me = this;
        
        var items= [
        	{
				xtype:'fieldsettable',
				title: HreRem.i18n('title.patrimonio.datos.patrimonio.activo'),
				defaultType: 'textfieldbase',
				items :
					[
					// Fila 1
						{ 	
							xtype: 'checkboxfieldbase',
							fieldLabel: HreRem.i18n('title.patrimonio.perimetroAlquiler'),
							reference: 'chkPerimetroAlquilerRef',
							//disabled: true,
							bind: {
								value: '{patrimonio.chkPerimetroAlquiler}',
								//disabled: '{disableCheckHpm}',
								readOnly: '{enableEdicionCheckHpm}'								
							},
							listeners: {
								change:'onChangeCheckPerimetroAlquiler'
							},
							onBoxClick: function() {
						    	var me = this;
						    	if(me.lookupController().getViewModel().get("editing")  != true && me.lookupController().getViewModel().get("editingFirstLevel") != true){
						    		me.fireEvent('viewonly');
									me.lookupController().getViewModel().set("editingFirstLevel", false);
									me.lookupController().getViewModel().set("editing", false);
									me.lookupController().getViewModel().notify();
						    	} else {
							    	if (!me.disabled && !me.readOnly) {
	            						me.setValue(!me.checked);
	        						}
        						}
						    } 
						},
						{
							xtype: 'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('fieldlabel.perimetro.tipo.alquiler'),
							reference: 'comboTipoAlquilerRef',
							bind: {
								store: '{comboTipoAlquiler}',
								disabled: '{enableComboTipoAlquiler}',
								value: '{patrimonio.tipoAlquilerCodigo}',
								rawValue: '{patrimonio.tipoAlquilerDescripcion}'
							},
							listeners: {
								change: 'comboTipoAlquilerOnChange'
							}
							
						},
						{
							xtype: 'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('title.patrimonio.adecuacion'),
							reference: 'comboAdecuacionRef',
							bind: {
								store: '{comboAdecuacionAlquiler}',
								disabled: '{enableComboAdecuacion}',
								value: '{patrimonio.codigoAdecuacion}',
								rawValue: '{patrimonio.descripcionAdecuacion}'
							},
							colspan:1
						}
						,
						{
							xtype: 'checkboxfieldbase',
							fieldLabel: HreRem.i18n('checkboxfieldbase.patrimonio.subrogado'),
							reference: 'subrogadoCheckbox',
							//disabled: true,
							//readOnly: true,
							bind: {
								//disabled: '{enableSubrogado}',
								readOnly: '{enableSubrogado}',
								value: '{patrimonio.chkSubrogado}'// Es posible que se vea discordancia con Base de datos. Esto se debe a que este valor cambia en java. En TabActivoPatrimonio.getTabData()
							},
							onBoxClick: function() {
						    	var me = this;
						    	if(me.lookupController().getViewModel().get("editing")  != true && me.lookupController().getViewModel().get("editingFirstLevel") != true){
						    		me.fireEvent('viewonly');
									me.lookupController().getViewModel().set("editingFirstLevel", false);
									me.lookupController().getViewModel().set("editing", false);
									me.lookupController().getViewModel().notify();
						    	} else {
							    	if (!me.disabled && !me.readOnly) {
	            						me.setValue(!me.checked);
	        						}
        						}
						    } 
						},
						{
							xtype: 'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('combolabel.patrimonio.combo.tipo.inquilino'),
							reference: 'comboTipoInquilinoRef',
							bind: {
								store: '{comboTipoInquilino}',
								value: '{patrimonio.tipoInquilino}',
								disabled: '{enableComboTipoInquilino}',
								rawValue: '{patrimonio.tipoInquilinoDescripcion}'
							}
						},
						{
							xtype: 'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('combolabel.patrimonio.combo.estado.alquiler'),
							reference: 'comboEstadoAlquilerRef',							
							bind: {
								store: '{comboEstadoAlquiler}',
								value: '{patrimonio.estadoAlquiler}',
								disabled: false,
								rawValue: '{patrimonio.estadoAlquilerDescripcion}'
							},
							listeners: {
								change:'esEditableChkYcombo'
							}
						},
						//Fila 2
						{
							xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('title.patrimonio.rentaAntigua'),
									bind: {
								disabled: '{enableComboRentaAntigua}',
									store: '{comboSiNoRem}',
										value: '{patrimonio.comboRentaAntigua}'
							},
							colspan: 1
						},
						{
							xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('combolabel.patrimonio.combo.tramite.alquiler.social'),
									reference: 'tramiteAlquilerSocialRef',
										colspan: 1,
											bind: {
								readOnly: '{!isCesionUsoEditable}',
									store: '{comboSinSino}',
										value: '{patrimonio.tramiteAlquilerSocial}'
							}
						},
						{
							xtype : 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.paz.social'),
							readOnly: true,
							colspan: 1,
							bind: {
								store: '{comboSinSino}',
								value: '{patrimonio.pazSocial}',
								hidden: '{!patrimonio.isCarteraCerberusDivarian}'	
							}
						},		
						{
							xtype: 'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('combolabel.patrimonio.combo.cesion.de.uso'),
							reference: 'cesionDeUsoRef',
							colspan: 3,
							bind: {
								readOnly: '{!isCesionUsoEditable}',
								store: '{comboCesionUso}',
								value: '{patrimonio.cesionUso}',
								hidden: '{!patrimonio.isCarteraCerberusDivarianOBBVA}',
								rawValue: '{patrimonio.cesionUsoDescripcion}'
							},
							listeners: {
								change: 'comboCesionUsoOnChage'
							}
						},
						{
							xtype : 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.acuerdo.pago'),
							colspan: 1,
							bind: {
								store: '{comboSinSino}',
								value: '{patrimonio.acuerdoPago}',
								hidden: '{!patrimonio.isCarteraTitulizada}'	
							}
						},	
						{
							xtype : 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.moroso'),
							colspan: 1,
							bind: {
								store: '{comboSinSino}',
								value: '{patrimonio.moroso}',
								hidden: '{!patrimonio.isCarteraTitulizada}'	
							}
						},	
						{
							xtype : 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.activo.estrategico'),
							colspan: 1,
							bind: {
								store: '{comboSinSino}',
								value: '{patrimonio.activoPromoEstrategico}',
								hidden: '{!patrimonio.isCarteraTitulizada}'	
							}
						},	
						{
							xtype: 'displayfieldbase',
							colspan: 3,
							readOnly:true,
							bind: {
								hidden: '{patrimonio.isCarteraCerberusDivarian}'
							}
						},			
						{
							xtype:'fieldsettable',
							title:HreRem.i18n('title.grid.historico.adecuaciones'),
							defaultType: 'textfieldbase',
							colspan: 3,
							items :
								[
									{xtype: 'historicoadecuacionesgrid', reference: 'historicoadecuacionesgrid', colspan: 3}
								]
						}
				]
			}
			
        ];

		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
		me.lookupController().cargarTabData(me);
    }
});
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
							bind: {
								value: '{patrimonio.chkPerimetroAlquiler}'
							},
							listeners: {
								change:'onChangeCheckPerimetroAlquiler',
								render: 'onRenderCheckPerimetroAlquiler'
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.perimetro.tipo.alquiler'),
							reference: 'comboTipoAlquilerRef',
							bind: {
								store: '{comboTipoAlquiler}',
								disabled: '{enableComboTipoAlquiler}',
								value: '{patrimonio.tipoAlquilerCodigo}'
							},
							listeners: {
								change: 'comboTipoAlquilerOnChange'
							}
							
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('title.patrimonio.adecuacion'),
							reference: 'comboAdecuacionRef',
							bind: {
								store: '{comboAdecuacionAlquiler}',
								disabled: '{enableComboAdecuacion}',
								value: '{patrimonio.codigoAdecuacion}'
							},
							colspan:1
						}
						,
						{
							xtype: 'checkboxfieldbase',
							fieldLabel: HreRem.i18n('checkboxfieldbase.patrimonio.subrogado'),
							reference: 'subrogadoCheckbox',
							bind: {
								value: '{patrimonio.chkSubrogado}',// Es posible que se vea discordancia con Base de datos. Esto se debe a que este valor cambia en java. En TabActivoPatrimonio.getTabData()
								readOnly: '{patrimonio.pazSocial}'
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('combolabel.patrimonio.combo.tipo.inquilino'),
							reference: 'comboTipoInquilinoRef',
							bind: {
								store: '{comboTipoInquilino}',
								value: '{patrimonio.tipoInquilino}',
								disabled: '{enableComboTipoInquilino}'
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('combolabel.patrimonio.combo.estado.alquiler'),
							reference: 'comboEstadoAlquilerRef',							
							bind: {
								store: '{comboEstadoAlquiler}',
								value: '{patrimonio.estadoAlquiler}',
								disabled: false
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
							xtype : 'checkboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.paz.social'),
							readOnly: true,
							colspan: 1,
							bind: {
								value: '{patrimonio.pazSocial}',
								hidden: '{!patrimonio.isCarteraCerberusDivarian}'	
							}
						},		
						{
							xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('combolabel.patrimonio.combo.cesion.de.uso'),
									reference: 'cesionDeUsoRef',
										colspan: 3,
											bind: {
								readOnly: '{!isCesionUsoEditable}',
									store: '{comboCesionUso}',
										value: '{patrimonio.cesionUso}'
							},
							listeners: {
								change: 'comboCesionUsoOnChage'
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
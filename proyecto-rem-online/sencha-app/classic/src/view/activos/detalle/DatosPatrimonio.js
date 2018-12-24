Ext.define('HreRem.view.activos.detalle.DatosPatrimonio', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'datospatrimonio',   
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'datospatrimonio',
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
        
        me.setTitle(HreRem.i18n('title.fieldset.datos.basicos'));

        var items= [
        	{
				xtype:'fieldsettable',
				title: HreRem.i18n('title.fieldset.patrimonio'),
				defaultType: 'textfieldbase',
				items :
					[
					// Fila 1
						{ 	
							xtype: 'checkboxfieldbase',
							fieldLabel: HreRem.i18n('title.patrimonio.perimetroAlquiler'),
							reference: 'chkPerimetroAlquilerRef',
							bind: {
								readOnly: '{enableChkPerimetroAlquiler}',
								value: '{patrimonio.chkPerimetroAlquiler}'
							},
							listeners: {
								change:'onChangeCheckPerimetroAlquiler'
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
							}
						}
						,
						{
							xtype: 'checkboxfieldbase',
							fieldLabel: HreRem.i18n('checkboxfieldbase.patrimonio.subrogado'),
							bind: {
								value: '{patrimonio.chkSubrogado}'								
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
							colspan: 3
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
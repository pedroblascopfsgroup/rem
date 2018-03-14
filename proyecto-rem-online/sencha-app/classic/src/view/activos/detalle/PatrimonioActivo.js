Ext.define('HreRem.view.activos.detalle.PatrimonioActivo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'patrimonioactivo',   
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'patrimonioactivoref',
	scrollable	: 'y',
	
	recordName: "patrimonio",

	recordClass: ['HreRem.model.ActivoPatrimonio'],
	
	requires: ['HreRem.model.ActivoPatrimonio','HreRem.view.activos.detalle.HistoricoAdecuacionesGrid'],
	
	listeners: {
    	/*boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    	}*/
    },
    

    initComponent: function () {
        var me = this;
        
        me.setTitle(HreRem.i18n('title.patrimonio.activo'));

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
							bind: '{patrimonio.chkPerimetroAlquiler}'
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.perimetro.tipo.alquiler'),
							bind: {
								store: '{comboTipoAlquiler}',
								disabled: '{enableComboTipoAlquiler}',
								value: '{activo.tipoAlquilerCodigo}'
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('title.patrimonio.adecuacion'),
							bind: {
								store: '{comboAdecuacionAlquiler}',
								disabled: '{!patrimonio.chkPerimetroAlquiler}',
								value: '{patrimonio.descripcionAdecuacion}'
							}
						},
						//Fila 2
						{
							xtype:'fieldsettable',
							title:HreRem.i18n('title.grid.historico.adecuaciones'),
							defaultType: 'textfieldbase',
							colspan: 3,
							items :
								[
									{xtype: "historicoadecuacionesgrid", reference: "historicoadecuacionesgrid", colspan: 3}
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
Ext.define('HreRem.view.activos.detalle.PatrimonioActivo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'patrimonioactivo',   
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'patrimonioactivo',
	scrollable	: 'y',
	recordName	: 'patrimonio',
	recordClass : 'HreRem.model.ActivoPatrimonio',
	requires: ['HreRem.model.ActivoPatrimonio','HreRem.view.activos.detalle.HistoricoAdecuacionesGrid'],

	listeners: {
    	boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    	}
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
							bind: '{patrimonio.chkPerimetroAlquiler}',
							listeners:{
									change: function(me){
										var padre = me.up();
										if(!me.checked){
											padre.down('comboboxfieldbase[reference=comboTipoAlquilerRef]').reset();
											padre.down('comboboxfieldbase[reference=comboAdecuacionRef]').reset();
										}
									}
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
						},
						//Fila 2
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
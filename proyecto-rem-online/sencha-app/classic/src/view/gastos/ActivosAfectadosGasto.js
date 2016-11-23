Ext.define('HreRem.view.gastos.ActivosAfectadosGasto', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'activosafectadosgasto',
	cls : 'panel-base shadow-panel',
	collapsed : false,
	disableValidation : true,
	reference : 'activosafectadosgastoref',
	scrollable : 'y',
	
	recordName: "gasto",
		
	recordClass: "HreRem.model.GastoProveedor",
    
    requires: ['HreRem.model.GastoProveedor', 'HreRem.view.gastos.ActivosAfectadosGastoList'],

	initComponent : function() {

		var me = this;
		
		me.setTitle(HreRem.i18n('title.gasto.activos.afectados'));
		var items = [
				
				{   
					xtype:'fieldset',
					padding: 10,
					layout: 'hbox',
					collapsible: false,
					bind: {
						hidden: '{gasto.asignadoAActivos}'
					},
					items :	[
				                {
				                	xtype: 'checkboxfieldbase',
				                	bind:	{
				                		value:	'{gasto.gastoSinActivos}'
				                	},
				                	width: 30
				                	
				                }, 
				                {
				                	xtype: 'label',
				                	padding: '4 0 0 0',
				                	text: HreRem.i18n('fieldlabel.permite.gasto.sin.activos')
				                }
				     ]
				},
				{
					xtype : 'activosafectadosgastolist',
					reference : 'listadoActivosAfectadosRef'					

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
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
  		me.lookupController().refrescarGasto(false);

	}
});
Ext.define('HreRem.view.gastos.ActivosAfectadosGasto', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'activosafectadosgasto',
	cls : 'panel-base shadow-panel',
	collapsed : false,
	disableValidation : true,
	reference : 'activosafectadosgastoref',
	scrollable : 'y',
 
	requires: ['HreRem.view.gastos.ActivosAfectadosGastoList'],
	
	recordClass: "HreRem.model.GastoProveedor",
    
    requires: ['HreRem.model.GastoProveedor'],

	initComponent : function() {

		var me = this;
		
		me.setTitle(HreRem.i18n('title.gasto.activos.afectados'));
		var items = [

				
				{   
					xtype:'fieldset',
					padding: 10,
					layout: 'hbox',
					collapsible: false,
					items :	[
				                {
				                	xtype: 'checkboxfieldbase',
				                	bind:		'{gasto.gastoSinActivos}',
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
		me.lookupController().refrescarGasto(false);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});	

	}
});
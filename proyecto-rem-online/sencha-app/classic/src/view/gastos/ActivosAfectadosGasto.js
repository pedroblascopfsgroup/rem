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

    listeners: {
		activate: function(me, eOpts) {
			var estadoGasto= me.lookupController().getViewModel().get('gasto').get('estadoGastoCodigo');
			var autorizado = me.lookupController().getViewModel().get('gasto').get('autorizado');
	    	var rechazado = me.lookupController().getViewModel().get('gasto').get('rechazado');
	    	var agrupado = me.lookupController().getViewModel().get('gasto').get('esGastoAgrupado');
	    	var gestoria = me.lookupController().getViewModel().get('gasto').get('nombreGestoria')!=null;
			if(this.lookupController().botonesEdicionGasto(estadoGasto,autorizado,rechazado,agrupado,gestoria, this)){
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').setVisible(true);
			}
			else{
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').setVisible(false);
			}
		}
	},
    
	initComponent : function() {

		var me = this;
		
		me.setTitle(HreRem.i18n('title.gasto.elementos.afectados'));
		var items = [
				
				{   
					xtype:'fieldset',
					padding: 10,
					layout: 'hbox',
					collapsible: false,
					bind: {
						hidden: '{asignadoAActivosPropietarioSareb}'
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
  		me.lookupController().cargarTabData(me);
  		//me.lookupController().refrescarGasto(false);

	}
});
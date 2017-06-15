Ext.define('HreRem.view.expedientes.ActivoExpedienteJuridico', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'activoexpedientejuridico',
	cls : 'panel-base shadow-panel',
	collapsed : false,
	saveMultiple: true,
    disableValidation: true,
	reference : 'activoexpedientejuridico',
	scrollable : 'y',
    records				: ['informeJuridico'],
    recordsClass		: ['HreRem.model.ExpedienteInformeJuridico'],
    requires			: ['HreRem.model.ExpedienteInformeJuridico'],

	initComponent : function() {

		var me = this;
		me.setTitle(HreRem.i18n('title.informe.juridico'));
		me.items = [
		     {   
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',				
				title: HreRem.i18n('title.situacion.activo.comunicada.comprador'),
				items :
					[
		                {
		                	xtype: 'datefieldbase', 
		                	formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('label.fecha.emision'),
		                	maxValue: null,
		                	minValue: new Date(),
		                	bind:		'{informeJuridico.fechaEmision}'

		                },						
						{
							xtype: 'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.proveedor.resultado'),
							bind:		'{informeJuridico.resultadoBloqueo}'
						}
					]
			}
		     ,
			{
			    xtype: 'bloqueosformalizacionlist',
				reference: 'bloqueosformalizacionlistref'
			}
		];

		/*me.addPlugin({
			ptype : 'lazyitems',
			items : me.items
		});*/

		me.callParent();
	},

	funcionRecargar : function() {debugger;
		var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabDataInformeJuridico(me);		
	}
});
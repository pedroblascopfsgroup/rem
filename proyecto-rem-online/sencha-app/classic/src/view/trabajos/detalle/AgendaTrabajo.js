Ext.define('HreRem.view.trabajos.detalle.AgendaTrabajo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'agendatrabajo',    
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    scrollable	: 'y',
    reference   : 'agendatrabajo',
    //recordName	: "agendaTrabajo",
	//recordClass	: "HreRem.model.AgendaTrabajo",
    requires	: ['HreRem.view.trabajos.detalle.AgendaTrabajoGrid', 'HreRem.view.trabajos.detalle.HistorificacionDeCamposGrid'],

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.agenda'));
             me.items= [
					{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						colspan: 3,
						
						reference:'historificacionCampos',
						hidden: false, 
						title: HreRem.i18n("title.agenda"),
						
						items :
						[
							{
								xtype: "agendatrabajogrid", 
								reference: "agendatrabajogrid", 
								colspan: 3,
								idTrabajo: this.lookupController().getViewModel().get('trabajo').get('id')
							}
						]
	           		},
					{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							colspan: 3,
							
							reference:'historificacionCampos',
							hidden: false, 
							title: HreRem.i18n("title.historificacion.campos"),
							
							items :
							[
								{
									xtype: "historificacioncamposgrid", 
									reference: "historificacioncamposgrid", 
									colspan: 3,
									idTrabajo: this.lookupController().getViewModel().get('trabajo').get('id'),
									codigoPestanya: null
								}
							]
		           		}
        ];

    	me.callParent();
    },

    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
		  grid.getStore().load();
		  });
    }
});
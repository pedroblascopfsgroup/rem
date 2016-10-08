Ext.define('HreRem.view.gastos.ImpugnacionGasto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'impugnaciongasto',   
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'impugnaciongastoref',
    scrollable	: 'y',
	recordName: "impugnacion",
	
	recordClass: "HreRem.model.ImpugnacionGasto",
    
    requires: ['HreRem.model.ImpugnacionGasto'],
    
    listeners: {
		boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.gasto.impugnacion'));
        var items= [
       
	    	{   
				xtype:'fieldsettable',
				collapsible: false,
				items :
					[
						{
							xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
							reference: 'fechaTopeImpugnacion',
							fieldLabel: HreRem.i18n('fieldlabel.gasto.impugnacion.fecha.tope.impugnacion'),
							bind: '{impugnacion.fechaTope}',
							maxValue: null
						},
						{
							xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
							reference: 'fechaPresentacionImpugnacion',
							fieldLabel: HreRem.i18n('fieldlabel.gasto.impugnacion.fecha.presentacion.impugnacion'),
							bind: '{impugnacion.fechaPresentacion}',
							maxValue: null
						},
						{
							xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
							reference: 'fechaResolucionImpugnacion',
							fieldLabel: HreRem.i18n('fieldlabel.gasto.impugnacion.fecha.resolucion.impugnacion'),
							bind: '{impugnacion.fechaResolucion}',
							maxValue: null
						},
						{ 
							xtype:'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.gasto.impugnacion.resultado'),
							bind: {
								store: '{comboResultadoImpugnacion}',
								value: '{impugnacion.resultadoCodigo}'
							}
						},
						{ 
		                	xtype: 'textareafieldbase',
//		                	labelWidth: 200,
//		                	rowspan: 4,
//		                	height: 160,
//		                	labelAlign: 'top',
		                	fieldLabel: HreRem.i18n('fieldlabel.gasto.impugnacion.observaciones'),
		                	bind:		'{impugnacion.observaciones}'
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
		me.lookupController().cargarTabData(me);
    	
    }
});
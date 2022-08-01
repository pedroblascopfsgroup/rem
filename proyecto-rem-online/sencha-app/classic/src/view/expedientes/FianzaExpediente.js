Ext.define('HreRem.view.expedientes.FianzaExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'fianzaexpediente',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'fianzaexpedienteref',
    scrollable	: 'y',
	refreshAfterSave: true,
	recordName: "fianza",
	recordClass: "HreRem.model.Fianza",
    requires: ['HreRem.model.Fianza','HreRem.view.activos.detalle.ActivoDetalleModel', 'HreRem.view.expedientes.HistoricoReagendacionesGrid'],
    
    listeners: {
		boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;

		me.setTitle(HreRem.i18n('title.fieldlabel.fianza'));
		var items = [

		{
			xtype : 'fieldsettable',
			defaultType : 'displayfieldbase',
			collapsible: false,
			border: false,
			colspan: 3,
			layout: {
		        type: 'table',
		        columns: 3,
		        tdAttrs: {
		        	width: '33%',
		        	style: 'vertical-align: top'
		        },
		        tableAttrs: {
		            style: {
		            	width: '100%'
					}
		        }
			},
			
			items : [
				{
					xtype : 'datefieldbase',
					formatter : 'date("d/m/Y")',
					fieldLabel : HreRem.i18n('fianza.fieldlabel.agendacion.ingreso'),
					bind : '{fianza.agendacionIngreso}'
				},
				{
					xtype : 'currencyfieldbase',
					fieldLabel : HreRem.i18n('fianza.fieldlabel.importe.fianza'),
					bind : '{fianza.importeFianza}'
				},
				{
					xtype : 'datefieldbase',
					formatter : 'date("d/m/Y")',
					fieldLabel : HreRem.i18n('fianza.fieldlabel.fecha.ingreso'),
					bind : '{fianza.fechaIngreso}'
				}, 	
				{
					xtype : 'textfieldbase',
					fieldLabel : HreRem.i18n('fianza.fieldlabel.cuenta.virtual'),
					bind : {
						value : '{fianza.cuentaVirtual}'
					},
					readOnly : true
				},
				{
					xtype: 'textfieldbase',
					fieldLabel: HreRem.i18n('fieldlabel.iban.devolucion'),
        	    	name: 'ibanDevolucion',
					bind: {
						value: '{fianza.ibanDevolucion}'
					},
					listeners: {
					 	'focusleave': 'checkIbanDevolucion'
					}						
        	    },
        	    {
                	xtype: 'comboboxfieldbase',
                	fieldLabel:  HreRem.i18n('fieldlabel.entrega.fianza.aapp'),
                	name: 'comboentregafianzaaapp',
                	reference: 'comboentregafianzaaappRef',
                	bind: {	
	                	readOnly : true,
                		store: '{comboSiNoBoolean}',
						value: '{fianza.entregaFianzaAapp}'
                	}
                
                }
			]},
			{
				xtype:'fieldsettable',
				cls: 'fieldset-historico-asignaciones',
				title: HreRem.i18n('title.historico.Reagendaciones'),
				reference: 'historicoResignacionesRef',
				items :	[
					{
						xtype: 'historicoReagendacionesGrid',
						reference : 'historicoReagendacionesGridRef'
					}
				]
			}
		]

		me.addPlugin({
					ptype : 'lazyitems',
					items : items
				});

		me.callParent(); 
    },

    funcionRecargar: function() {
    var me = this;
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
					grid.getStore().load();
  		});	

    }
});

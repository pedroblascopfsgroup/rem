Ext.define('HreRem.view.expedientes.OfertaTanteoYRetracto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'ofertatanteoyretracto',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'ofertatanteoyretracto',
    scrollable	: 'y',

	recordName: "ofertatanteoyretracto",
	
	recordClass: "HreRem.model.OfertaTanteoYRetracto",
    
    requires: ['HreRem.model.OfertaTanteoYRetracto'],
    
    listeners: {
			boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.oferta.tanteo.retracto'));
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.oferta.tanteo.retracto.detalle'),
				items :
					[
		                {
		                	xtype: 'textfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.condiciones'),
		                	colspan: 3,
		                	defaultMaxWidth: '100%',
		                	maxLength: 1999,
		                	bind: {
								value: '{ofertatanteoyretracto.condicionesTransmision}'
							}
		                },
		                {
		                	xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.fecha.comunicacion'),
		                	bind:		'{ofertatanteoyretracto.fechaComunicacionReg}'
		                },
		                {
		                	xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.fecha.contestacion'),
		                	colspan: 2,
		                	bind:		'{ofertatanteoyretracto.fechaContestacion}'
		                },
		                {
		                	xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.fecha.solicitud.visita'),
		                	bind:		'{ofertatanteoyretracto.fechaSolicitudVisita}'
		                },
		                {
		                	xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.fecha.realizacion.visita'),
		                	colspan: 2,
		                	bind:		'{ofertatanteoyretracto.fechaRealizacionVisita}'
		                },
		                {
		                	xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.fecha.fin.tanteo'),
		                	bind:		'{ofertatanteoyretracto.fechaFinTanteo}'
		                },
		                {
		                	xtype: 'comboboxfieldbase',
		                	bind: {
								store: '{comboResultadoTanteo}',
								value: '{ofertatanteoyretracto.resultadoTanteoCodigo}'
							},
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.resultado.tanteo')
		                },
		                {
		                	xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.fecha.max.formalizacion'),
		                	bind:		'{ofertatanteoyretracto.plazoMaxFormalizacion}'
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
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});		
		
    }
});
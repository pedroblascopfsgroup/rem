Ext.define('HreRem.view.activos.detalle.OfertasComercialActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'ofertascomercialactivo',
    requires	: ['HreRem.view.activos.detalle.OfertasComercialActivoList', 'HreRem.view.activos.detalle.OfertantesOfertaDetalleList',
    				'HreRem.view.activos.detalle.HonorariosOfertaDetalleList', 'HreRem.model.DetalleOfertaModel', 'HreRem.model.OfertantesOfertaDetalleModel',
    				'HreRem.model.HonorariosOfertaDetalleModel'],
    scrollable	: 'y',
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {        
        var me = this;

        me.setTitle(HreRem.i18n("title.activos.listado.ofertas"));

        var items = [
       // Listado ofertas
        	{
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.comercial.list.ofertas'),
				collapsible: true,
				items :
					[
		    			{
		    				xtype: 'ofertascomercialactivolist',
		    				reference: 'ofertascomercialactivolistref'
		    			}
		    		]
        	},
       // Detalle Oferta
        	{
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.comercial.detalle.oferta'),
				reference: 'detalleOfertaFieldsetref',
				collapsible: true,
				items :
					[
					// Fila 0
		    			{
		    				xtype: "textfield",
		    				fieldLabel: HreRem.i18n('header.evaluacion.mediadores.detail.ofertasvivas.numOferta'),
							bind: {
								value: '{detalleOfertaModel.numOferta}'
							},
							readOnly: true,
							width: 410,
		    				reference: 'numofertadetalleofertaref'
		    			},
		    			{
		    				xtype: "textfield",
		    				fieldLabel: HreRem.i18n('fieldlabel.oferta.detalle.intencion.financiar'),
							bind: {
								value: '{detalleOfertaModel.intencionFinanciar}'
							},
							readOnly: true,
							width: 410,
		    				reference: 'intencionfinanciardetalleofertaref',
		    				colspan: 2
		    			},
		    		// Fila 1
		    			{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							collapsible: false,
							border: false,
							colspan: 1,
							padding: '0 0 0 0',
							items :
								[
									{
										xtype: "textfield",
										fieldLabel: HreRem.i18n('fieldlabel.oferta.detalle.visita.num'),
										bind: {
											value: '{detalleOfertaModel.numVisitaRem}'
										},
					    				reference: 'idvisitadetalleofertaref',
					    				readOnly: true,
					    				width: 410,
					    				colspan: 2,
					    				publishes: 'value'
					    			},
									{
					                	xtype: 'button',
					                	width: 30,
					                	height: 30,
					                	cls: 'boton-ver',
					                	iconCls: 'ico-ver-visita',
					                	reference: 'botonMostrarVisita',
					                	handler: 'onClickMostrarVisita',
					                	margin: '0 0 6 -80',
					                	bind: {disabled: '{!idvisitadetalleofertaref.value}'}
					                }
								]
						},
		    			{
							xtype: "textfield",
							fieldLabel: HreRem.i18n('fieldlabel.detalle.oferta.procedencia.visita'),
							bind: {
								value: '{detalleOfertaModel.procedenciaVisita}'
							},
							width: 410,
							readOnly: true,
		    				reference: 'procedenciavisitadetalleofertaref',
		    				colspan: 2
		    			},
		    		// Lista ofertantes
		    			{
			    			xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title: HreRem.i18n('title.detalle.oferta.ofertantes'),
							collapsible: true,
							colspan: 3,
							items :
								[
									{
					    				xtype: 'ofertantesofertadetallelist'
					    			}
								]
		    			},
		    		// Honorarios
		    			{
		    				xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title: HreRem.i18n('title.horonarios'),
							collapsible: true,
							colspan: 3,
							items :
								[
									{
					    				xtype: 'honorariosofertadetallelist'
					    			}
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
  			grid.getStore().loadPage(1);
  		});
    }
});
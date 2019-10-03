Ext.define('HreRem.view.agrupacion.detalle.ComercialAgrupacion', {
	extend: 'HreRem.view.common.FormBase',
    cls: 'panel-base shadow-panel',
    xtype: 'comercialagrupacion',
    mixins		: ['HreRem.ux.tab.TabBase'],
    reference: 'comercialagrupacionref',
    scrollable: 'y',
    requires: ['HreRem.view.agrupacion.detalle.ComercialAgrupacionTabs', 'HreRem.ux.tab.TabBase','HreRem.model.AgrupacionFicha'], 
	recordClass	: "HreRem.model.ComercialAgrupacion",
	recordName : "comercialagrupacion",
	listeners	: {
		boxready: function(){
			var me = this;
			me.lookupController().cargarTabData(me);
			me.evaluarBotonesEdicion();
		}
	},
//	bind		: {
//		ocultarBotonesEdicion: '{!usuarioTieneFuncionTramitarOferta}'
//    },
    initComponent: function () {
    	
    	var me = this;
    	
    	var items = [
    		{
    			xtype: 'label',
    			cls:'x-form-item',
    			html: HreRem.i18n('msg.oferta.agrupacion.no.tramitable'),
    			style: 'color: red; font-weight: bold; font-size: small;',
    			readOnly: true,
    			hidden: true,
    			bind : {
    				hidden: '{comercialagrupacion.tramitable}'
    			}
    		},
    		{
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				collapsible: true,
				reference: 'autorizacionTramOfertasAgrupacion',
				hidden: true,
				bind:{
					hidden: '{usuarioTieneFuncionTramitarOferta}'
				},
				title: HreRem.i18n('title.autorizacion.tramitacion.ofertas'),
				items :
					[{
						xtype : 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.motivo.autorizacion'),
			        	reference: 'motivoAutorizacionTramitacionCodigoAgrupacion',
			        	editable: true,
			        	bind : {
						      store : '{comboMotivoAutorizacionTramitacion}',
						      value : '{comercialagrupacion.motivoAutorizacionTramitacionCodigo}'
						      
			        	},
			        	displayField: 'descripcion',
			        	valueField: 'codigo'
					},
					{
						xtype: 'textareafieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.observaciones'),
			        	reference: 'observacionesAutorizacionTramiteAgrupacion',
						maxLength: 250,
						bind:{
							value: '{comercialagrupacion.observacionesAutoTram}',
							disabled: '{!esOtrosotivoAutorizacionTramitacion}'
						}

					},
					{
						xtype: 'button',
						text: HreRem.i18n('btn.autorizar.tramitacion.ofertas'),
						reference: 'insertarAutoTramOferAgrupacion',
						handler: 'onInsertarAutorizacionTramOfertasAgrupacion',
						bind: {
							disabled: '{!esSelecionadoAutorizacionTramitacion}'	
						}
					}
				]
			},
			{
				xtype: 'comercialagrupaciontabs'
			}
    	];
    	
    	

    	me.setTitle(HreRem.i18n('title.comercial'));
    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		me.up('agrupacionesdetallemain').lookupReference('comercialagrupaciontabsref').funcionRecargar();
    },
    
    evaluarBotonesEdicion: function(tab) {  
		var me = this;
		var detalleMain = me.up('agrupacionesdetallemain');
		var esTramitable = detalleMain.getViewModel().get('comercialagrupacion.tramitable');
		if(esTramitable == null){
			esTramitable = detalleMain.getViewModel().get('agrupacionficha.tramitable');
		}
		var funcion = $AU.userHasFunction('AUTORIZAR_TRAMITACION_OFERTA');

		if(!esTramitable && funcion){
			me.up('agrupacionesdetallemain').down("[itemId=botoneditar]").setVisible(true);
		}else{
			me.up('agrupacionesdetallemain').down("[itemId=botoneditar]").setVisible(false);
			
		}
	}
//    bloquearExpediente: function(tab) {    	
//		var me = this;
//		me.bloqueado = bloqueado;
//		me.down("[itemId=botoneditar]").setVisible(false);
//		var editionEnabled = function() {
//			me.down("[itemId=botoneditar]").setVisible(true);
//		}
//		
//		if(!bloqueado){
//			// Si la pestaña recibida no tiene asignados roles de edicion
//			if(Ext.isEmpty(tab.funPermEdition)) {
//				editionEnabled();
//			} else {
//				$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
//			}
//		}else{
//			me.down("[itemId=botoneditar]").setVisible(false);
//		}
//	}
    
});
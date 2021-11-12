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
		}
	},
    
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
    			},
    			listeners:{
    				
    				afterrender: function(){
    					var me = this;
    					me.lookupController().usuarioTieneFuncionTramitarOferta();
    					
    				}
				}
    		},
    		{
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				collapsible: true,
				reference: 'autorizacionTramOfertasAgrupacion',
				hidden: true,
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
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				collapsible: true,
				reference: 'informacionBC',
				title: HreRem.i18n('title.informacion.BC'),
				colspan:3,
				bind:{
					hidden: '{!esAgrupacionCaixaComercial}'
				},
				items :
					[
						{
							xtype: 'displayfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.necesidad.arras'),
				        	reference: 'necesidadArrasRef',
							//maxLength: 250,
							bind:{
								value: '{comercialagrupacion.necesidadArras}'
							}
						},
						{
							xtype: 'displayfieldbase',
				        	fieldLabel:	HreRem.i18n('fieldlabel.canal.venta.bc'),
				        	reference: 'necesidadArrasRef',
							//maxLength: 250,
							bind:{
								value: '{comercialagrupacion.canalVentaBc}'
							}
						},
						{
							xtype: 'displayfieldbase',
				        	fieldLabel:	HreRem.i18n('fieldlabel.canal.alquiler.bc'),
				        	reference: 'necesidadArrasRef',
							//maxLength: 250,
							bind:{
								value: '{comercialagrupacion.canalAlquilerBc}'
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
		if(me.up('agrupacionesdetallemain').lookupReference('ofertascomercialagrupacionlistref')){
			me.up('agrupacionesdetallemain').lookupReference('ofertascomercialagrupacionlistref').calcularMostrarBotonClonarExpediente();
		}

		me.up('agrupacionesdetallemain').lookupReference('ofertascomercialagrupacionref').funcionRecargar();
		me.lookupController().cargarTabData(me);
		me.lookupController().usuarioTieneFuncionTramitarOferta();
    },
    
    evaluarBotonesEdicion: function(tab) {  
		var me = this;
		var detalleMain = me.up('agrupacionesdetallemain');
		var esTramitable = detalleMain.getViewModel().get('comercialagrupacion.tramitable');
		if(esTramitable == null){
			esTramitable = detalleMain.getViewModel().get('agrupacionficha.tramitable');
		}
		var funcion = $AU.userHasFunction('AUTORIZAR_TRAMITACION_OFERTA');
		var usuariosValidos = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['AUTOTRAMOFR'])
	    		
		if(!esTramitable && funcion && usuariosValidos){
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
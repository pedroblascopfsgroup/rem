Ext.define('HreRem.view.administracion.juntas.DatosJunta', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'datosjuntaswindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /1.6,    
    height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50,
	reference: 'datosjuntaswindowref',
	y:Ext.Element.getViewportHeight()*(10/150),
    controller: 'administracion',
    viewModel: {
        type: 'administracion'
    },
    cls: '',//panel-base shadow-panel
    collapsed: false,
    modal	: true,
    juntaactual	: null,
    modoEdicion: true, // Inicializado para evitar errores.
    
    listeners: {

		show: function() {
			var me = this;
			me.resetWindow();			
		}
	},

    initComponent: function() {
    	var me = this;
    	
    	me.buttons = [{ itemId: 'btnCerrar', text: HreRem.i18n('btn.cerrarBtnText'), handler: 'onClickBotonCerrar'}];
    	try{
    		
    		var juntaactual = me.juntaactual.data;
    		
    		juntaactual.fechaJunta = new Date(juntaactual.fechaJunta);
    		
    		var title = 'Junta comunidad C/' + juntaactual.localizacion + ' - ' + juntaactual.fechaJunta.toLocaleDateString();
    		
			me.setTitle(title);

	    	me.buttonAlign = 'right';
	    	
	    	me.items = [
	    				{
		    				xtype: 'formBase',
		   			 		scrollable	: 'y',
		    				/*defaults: {
		    					addUxReadOnlyEditFieldPlugin: false
		    				},*/

	    					items: [
							           	{
											xtype:'fieldsettable',
											collapsible: false,
											defaultType: 'textfieldbase',
											cls: 'panel-base shadow-panel',
											margin: '10 10 10 10',
											layout: {
										        type: 'table',
										        columns: 2,
										        tdAttrs: {width: '55%'}
											},
											title: HreRem.i18n('fieldlabel.juntas.datosidentificativos'),
											items :
												[
													{
														xtype: 'datefieldbase',
											        	fieldLabel: HreRem.i18n('fieldlabel.juntas.fecha.junta'),
														reference: 'fechajunta',
														name: 'fechajunta',
														bind: '{juntaactual.fechaJunta}'
											        },
											        {
											        	fieldLabel: HreRem.i18n('title.comunidad'),
														reference: 'comunidad',
														name: 'comunidad',
											        	bind: '{juntaactual.comunidad}'
							                		},
													{
											        	fieldLabel:  HreRem.i18n('fieldlabel.entidad.propietaria'),
											        	reference: 'cartera',
											        	name: 'cartera',
											        	bind: '{juntaactual.cartera}'
											        },
											        {
											        	fieldLabel:  HreRem.i18n('header.numero.activo.haya'),
											        	reference: 'numactivo',
											        	name: 'numactivo',
											        	bind: '{juntaactual.numActivo}'
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
											        	reference: 'direccion',
											        	name: 'direccion',
											        	bind: '{juntaactual.localizacion}'
											        },
											        {
											        	xtype: 'numberfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.juntas.porcetnaje.participacion'),
														reference: 'pparticipacion',
														symbol: HreRem.i18n("symbol.porcentaje"),
														name: 'pparticipacion',
														bind: '{juntaactual.porcentaje}'
													}
												]
											        
							           },
							           {
							           		xtype:'fieldsettable',
											collapsible: false,
											defaultType: 'textfieldbase',
											cls: 'panel-base shadow-panel',
											margin: '10 10 10 10',
											layout: {
										        type: 'table',
										        columns: 2,
										        tdAttrs: {width: '55%'}
											},
											title: HreRem.i18n('fieldlabel.juntas.promociones'),
											items :
												[
													{
														xtype: 'comboboxfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.promocion'),
														reference: 'promocion',
														name: 'promocion',
														bind: {
															store: '{comboSiNoJuntas}',
															value: '{juntaactual.promoMayor50}'
														}
													},
													{
														xtype: 'comboboxfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.promocion.perjuicio'),
														reference: 'perjuicio',
														name: 'perjuicio',
														bind: {
															store: '{comboSiNoJuntas}',
															value: '{juntaactual.promo20a50}'
														}
													}
												]
							           },
							           {
							           		xtype:'fieldsettable',
											collapsible: false,
											defaultType: 'textfieldbase',
											cls: 'panel-base shadow-panel',
											margin: '10 10 10 10',
											layout: {
										        type: 'table',
										        columns: 2,
										        tdAttrs: {width: '55%'}
											},
											title: HreRem.i18n('fieldlabel.juntas.puntos'),
											items :
												[
													{
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.jgo.je'),
														reference: 'jgoje',
														name: 'jgoje',
														bind: '{juntaactual.junta}'
													},
													{
														xtype: 'comboboxfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.act.judic'),
														reference: 'judicial',
														name: 'judicial',
														bind: {
															store: '{comboSiNoJuntas}',
															value: '{juntaactual.judicial}'
														}
													},
													{
														xtype: 'comboboxfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.derrama'),
														reference: 'derrama',
														name: 'codTipoDocumento',
														bind: {
															store: '{comboSiNoJuntas}',
															value: '{juntaactual.derrama}'
														}
													},
													{
														xtype: 'comboboxfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.mod.estatutos'),
														reference: 'estatutos',
														name: 'estatutos',
														bind: {
															store: '{comboSiNoJuntas}',
															value: '{juntaactual.estatutos}'
														}
													},
													{
														xtype: 'comboboxfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.ite'),
														reference: 'ite',
														name: 'ite',
														bind: {
															store: '{comboSiNoJuntas}',
															value: '{juntaactual.ite}'
														}
													},
													{
														xtype: 'comboboxfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.morosos'),
														reference: 'morosos',
														name: 'morosos',														
														bind: {
															store: '{comboSiNoJuntas}',
															value: '{juntaactual.morosos}'
														}
													},
													{
														xtype: 'comboboxfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.cuota'),
														reference: 'cuota',
														name: 'cuota',
														bind: {
															store: '{comboSiNoJuntas}',
															value: '{juntaactual.cuota}'
														}
													},
													{
												        fieldLabel: HreRem.i18n('fieldlabel.otros'),
														reference: 'otros',
														name: 'otros',
														bind: '{juntaactual.otros}'
													},
													{
														xtype: 'currencyfieldbase',
												        fieldLabel: HreRem.i18n('header.importe'),
														reference: 'importe',
														name: 'importe',
														bind: '{juntaactual.importe}'
													}
												]
							           },
							           {
							           		xtype:'fieldsettable',
											collapsible: false,
											defaultType: 'textfieldbase',
											cls: 'panel-base shadow-panel',
											margin: '10 10 10 10',
											layout: {
										        type: 'table',
										        columns: 2,
										        tdAttrs: {width: '55%'}
											},
											title: HreRem.i18n('fieldlabel.juntas.pago.programado'),
											items :
												[
													{
														xtype: 'currencyfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.cuota.ordinaria'),
														reference: 'ordinaria',
														name: 'ordinaria',
														bind: '{juntaactual.ordinaria}'
													},
													{
														xtype: 'currencyfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.cuota.extra'),
														reference: 'extra',
														name: 'extra',
														bind: '{juntaactual.extra}'
													},
													{
														xtype: 'currencyfieldbase',
												        fieldLabel: HreRem.i18n('fieldlabel.juntas.suministros'),
														reference: 'suministros',
														name: 'suministros',
														bind: '{juntaactual.suministros}'
													}
												]
							           },
							           {
											xtype:'fieldsettable',
											collapsible: false,
											defaultType: 'textfieldbase',
											cls: 'panel-base shadow-panel',
											margin: '10 10 10 10',
											layout: {
										        type: 'table',
										        columns: 2,
										        tdAttrs: {width: '55%'}
											},
											items: [
												{
											        fieldLabel: HreRem.i18n('btn.propuesta.oferta'),
													reference: 'oferta',
													name: 'oferta',
													bind: '{juntaactual.propuesta}'
												},
												{
											        fieldLabel: HreRem.i18n('fieldlabel.juntas.guion.voto'),
													reference: 'voto',
													name: 'voto',
													bind: '{juntaactual.voto}'
												},
												{
											        fieldLabel: HreRem.i18n('fieldlabel.juntas.indicaciones'),
													reference: 'indicaciones',
													name: 'indicaciones',
													bind: '{juntaactual.indicaciones}'
												}
											]
							           }
						    			
	        				]
	    			}
	    	]

    	}catch(err) {
			Ext.global.console.log(err);
		}
		me.callParent();
    },
    
    resetWindow: function() {
		var me = this;
    	me.getViewModel().set('juntaactual', me.juntaactual.data);
    }
});
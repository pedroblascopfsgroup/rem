Ext.define('HreRem.view.gastos.GestionGasto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'gestiongasto',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'gestiongastoref',
    scrollable	: 'y',
	recordName: "gestion",
	refreshAfterSave: true,	
	recordClass: "HreRem.model.GestionGasto",
    
    requires: ['HreRem.model.GestionGasto'],
    
    listeners: {
		boxready:'cargarTabData',
		
		activate: function(me, eOpts) {
			var estadoGasto= me.lookupController().getViewModel().get('gasto').get('estadoGastoCodigo');
			if(this.lookupController().botonesEdicionGasto(estadoGasto,this)){
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').setVisible(true);
			}
			else{
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').setVisible(false);
			}
			
			var soloAnulacion= me.editableSoloAnulacion();
			this.down("[reference=gestionNecesarioAutorizacion]").setReadOnly(me.editableSoloAnulacion());
			this.down("[reference=gestionAutorizacionPropietario]").setReadOnly(me.editableSoloAnulacion());
			this.down("[reference=gestionObservaciones]").setReadOnly(me.editableSoloAnulacion());
			
		}
	},
	
	editableSoloAnulacion: function(){
		var me= this;
		var estadoGasto= me.lookupController().getViewModel().get('gasto').get('estadoGastoCodigo');
		if(CONST.ESTADOS_GASTO['PAGADO']==estadoGasto || CONST.ESTADOS_GASTO['PAGADO_SIN_JUSTIFICANTE']==estadoGasto || 
			CONST.ESTADOS_GASTO['AUTORIZADO']==estadoGasto || CONST.ESTADOS_GASTO['AUTORIZADO_PROPIETARIO']==estadoGasto || CONST.ESTADOS_GASTO['CONTABILIZADO']==estadoGasto){
			return true;
		}
		return false;
	},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.gasto.gestion'));
        var items= [
       
	    	{   
				xtype:'fieldsettable',
//				border: false,
//				collapsible: false,
				items :
					[
						{   
							xtype:'fieldset',
							height: 110,
							margin: '10 10 10 0',
							layout: {
								type: 'table',
						        columns: 1
						    },
							title: HreRem.i18n('title.gasto.gestion.necesidad.autorizacion.propietario'),
							items :
								[
									{ 
										xtype:'comboboxfieldbase',
										reference: 'gestionNecesarioAutorizacion',
										fieldLabel:  HreRem.i18n('fieldlabel.gasto.gestion.necesaria.autorizacion'),
										readOnly: me.editableSoloAnulacion(),
									    bind: {
								        	store: '{comboSiNoRem}',
								            value: '{gestion.necesariaAutorizacionPropietario}'
								        }
									},
									{ 
										xtype:'comboboxfieldbase',
										reference: 'gestionAutorizacionPropietario',
										fieldLabel:  HreRem.i18n('fieldlabel.gasto.gestion.motivo.autorizacion.propietario'),
										readOnly: me.editableSoloAnulacion(),
									    bind: {
								        	store: '{comboMotivoAutorizacion}',
								            value: '{gestion.comboMotivoAutorizacionPropietario}'
								        }
									}
								]
						},
						{   
							xtype:'fieldset',
							title: HreRem.i18n('title.gasto.gestion.tramitacion.mediante.provision.fondos'),
							height: 110,
							margin: '10 10 10 0',
							layout: {
								type: 'table',
						        columns: 1
						    },
							items :
								[
									{
										xtype: 'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.gasto.gestion.gestoria'),
										bind:		'{gestion.gestoria}',
										readOnly: true
									},
									{
										xtype: 'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.gasto.gestion.id.provision'),
										bind:		'{gestion.numProvision}',
										readOnly: true
									}
								]
						},
						{   
							xtype:'fieldset',
							height: 110,
							margin: '10 10 10 0',
							border:false,
							layout: {
								type: 'table',
						        columns: 1
						    },
							items :
								[
									{ 
					                	xtype: 'textareafieldbase',
					                	labelAlign: 'top',
					                	reference: 'gestionObservaciones',
					                	readOnly: me.editableSoloAnulacion(),
					                	height: 110,
					                	fieldLabel: HreRem.i18n('fieldlabel.gasto.gestion.observaciones'),
					                	bind:		'{gestion.observaciones}'
					                }
								]
						}
					]
			},
			{   
				xtype:'fieldsettable',
				title: HreRem.i18n('title.gasto.gestion.gestion'),
//				bind:{
//					disabled: '{!esGastoAnulado}'
//				},
				items :
					[
						{
							xtype:'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.gasto.alta.rem'),
							bind: {
								value: '{gestion.fechaYGestorAltaRem}'
							},
							colspan: 3
						},
			            { 
							xtype: 'comboboxfieldbase',
							readOnly: true,
			              	fieldLabel : 'Estado Autorización Haya',			              	
							bind: {
								store: '{comboEstadoAutorizacionHaya}',
								value: '{gestion.comboEstadoAutorizacionHaya}'
							}
						},
			           	{
							xtype:'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.gasto.fecha.gestor'),
							bind: '{gestion.fechaYGestorAutorizacionHaya}'
						},
						
						{ 
							xtype: 'comboboxfieldbase',
							readOnly: true,
							fieldLabel:  HreRem.i18n('fieldlabel.motivo.rechazo'),
							bind: {
								store: '{comboMotivoRechazoHaya}',
								value: '{gestion.comboMotivoRechazoHaya}'
							}
						},
						
						////////////////////////
						
						{ 
							xtype: 'comboboxfieldbase',
							
			              	fieldLabel : 'Estado Autorización Propietario',
							bind: {
								store: '{comboEstadoAutorizacionPropietario}',
								value: '{gestion.comboEstadoAutorizacionPropietario}'
							},
							readOnly: true
						},
			           	{
							xtype:'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.gasto.fecha.gestor'),
							bind: '{gestion.fechaYGestorAutorizacionPropietario}'
						},
						
						{
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.motivo.rechazo'),
							bind:		{
								value: '{gestion.motivoRechazoAutorizacionPropietario}',
								readOnly: '{esGastoAnulado}'
							}
							
						},
						
						
						
						////////////////////////////////
						{
							xtype:'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.gasto.anulado')
						},
						
						{
							xtype:'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.gasto.fecha.gestor'),
							bind: '{gestion.fechaYGestorAnulado}'
						},
						
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.gasto.motivo'),
							bind: {
								store: '{comboMotivoAnulado}',
								value: '{gestion.comboMotivoAnulado}',
								readOnly: '{esGastoAnulado}'
							}
						},
						///////////////////////////////
						
						{
							xtype:'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.gasto.retener.pago')
						},
						
						{
							xtype:'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.gasto.fecha.gestor'),
							bind: '{gestion.fechaYGestorRetenerPago}'
						},
						
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.gasto.motivo'),
							bind: {
								store: '{comboMotivoRetenerPago}',
								value: '{gestion.comboMotivoRetenerPago}',
								readOnly: '{esGastoAnulado}'
							},
							editable: true
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
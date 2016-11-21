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
		boxready:'cargarTabData'
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
										fieldLabel:  HreRem.i18n('fieldlabel.gasto.gestion.necesaria.autorizacion'),
										//readOnly:true,
									    bind: {
								        	store: '{comboSiNoRem}',
								            value: '{gestion.necesariaAutorizacionPropietario}'
								        }
									},
									{ 
										xtype:'comboboxfieldbase',
										fieldLabel:  HreRem.i18n('fieldlabel.gasto.gestion.motivo.autorizacion.propietario'),
										editable: true,
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
										xtype: 'textfieldbase',
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
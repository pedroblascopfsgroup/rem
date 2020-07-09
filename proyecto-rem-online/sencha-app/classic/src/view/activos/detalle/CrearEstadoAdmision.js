Ext.define('HreRem.view.activos.detalle.CrearEstadoAdmision', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'crearestadoadmisionwindow',
    layout	: 'fit',
    width	: 500,    
    height	: 400,
	reference: 'crearestadoadmisionwindowref',
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    requires: ['HreRem.model.Activo', 'HreRem.view.activos.detalle.ActivoDetalleModel'],
    
    idActivo: null,
    
    codCartera: null,
    codEstadoAdmision: null,
    codSubestadoAdmision: null,
    estadoAdmisionDesc: null,
    subestadoAdmisionDesc: null,
    
    
	listeners: {

		boxready: function(window) {
			
			var me = this;
			
			Ext.Array.each(window.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
					}
			);
			
		},
		
		show: function() {	
			var me = this;
			me.resetWindow();			
		}

	},
	
    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n("title.estado.admision.activo"));
    	
    	me.buttonAlign = 'left'; 
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickCrearEstadoAdmision'},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'hideWindowCrearActivoAdmision'}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				collapsed: false,
	    				reference: 'formEstadoAdmision',
	   			 		scrollable	: 'y',
	    				cls:'',	    				
					    recordName: "activo",
						
						recordClass: "HreRem.model.Activo",
						defaults: {
									padding: 10
								},
    					items: [
    						{ 
					        	xtype: 'textfieldbase',
					        	readOnly: true,
					        	fieldLabel: HreRem.i18n('fieldlabel.estado.admision.estado.actual'),
								reference: 'estadoAdmisionRef',
								width: 		'100%',
								colspan: 1,
					        	bind: {
				            		value: me.estadoAdmisionDesc
				            	}
					        },
					        { 
					        	xtype: 'textfieldbase',
					        	readOnly: true,
					        	fieldLabel: HreRem.i18n('fieldlabel.estado.admision.subestado.actual'),
								reference: 'subestadoAdmisionRef',
								width: 		'100%',
								colspan: 1,
					        	bind: {
				            		value: me.subestadoAdmisionDesc
				            	}
					        },
					        { 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.estado.admision.estado.nuevo'),
								reference: 'estadoAdmisionNuevo',
								width: 		'100%',
								colspan: 1,
					        	bind: {
				            		store: '{comboEstadoAdmision}',
				            		value: '{activo.estadoAdmisionCodigoNuevo}'
				            	},
	    						listeners: {
				                	select: 'setSubestadoAdmisionAllowBlank'
				                	
				            	},
				            	chainedStore: 'comboSubestadoAdmisionNuevoFiltrado',
								chainedReference: 'subestadoAdmisionNuevo',
								allowBlank: false
					        },
					        { 
					        	xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.estado.admision.subestado.nuevo'),
								reference: 'subestadoAdmisionNuevo',
								   bind : {
								     store : '{comboSubestadoAdmisionNuevoFiltrado}',
								     value: '{activo.subestadoAdmisionCodigoNuevo}'//,
								   }


							}
							,{
			                	xtype: 'textareafieldbase',
			                	fieldLabel: HreRem.i18n('fieldlabel.estado.admision.observaciones'),
			                	name: 'observacionesAdmision',
			                	reference: 'observacionesEstadoAdmisionNuevo',
			                	bind: {
			                		value: '{activo.observacionesAdmision}'
			                	},
			                	width:'100%',
			                	colspan: 1,
			                	maxLength: 256
        	                }
					        
					]
    			}
    	]


    	
    	
    	
    	me.callParent();
    	
    },
    
    resetWindow: function() {

    	var me = this,    	
    	form = me.down('formBase');     	

		form.setBindRecord(form.getModelInstance());
		form.reset();
		me.lookupReference('estadoAdmisionActual').setValue(me.estadoAdmisionDesc),
		me.lookupReference('subestadoAdmisionActual').setValue(me.subestadoAdmisionDesc)
		/*
		me.idProceso = null;
		me.getViewModel().set('idActivo', me.idActivo);
    	me.getViewModel().set('idAgrupacion', me.idAgrupacion);
	
		    	
    	me.down("[reference=checkFechaConcreta]").setValue(false);
    	me.down("[reference=checkFechaTope]").setValue(false);
    	me.down("[reference=checkFechaContinuado]").setValue(false);
    	
    	me.lookupReference('listaActivosSubidaRef').getStore().getProxy().extraParams = {'idProceso':null};
    	me.lookupReference('listaActivosSubidaRef').getStore().loadPage(1);
    	me.lookupReference('listaActivosSubidaRef').getColumnManager().getHeaderByDataIndex("activoEnPropuestaEnTramitacion").setVisible(false);

    	if(!Ext.isEmpty(me.idAgrupacion)) {
    		me.lookupReference('activosagrupaciontrabajo').getStore().load();
    		me.down('[reference=fieldsetListaActivos]').setVisible(true);
    		me.down('[reference=supervisorActivoCombo]').setValue(me.idSupervisor);
    		me.down('[reference=gestorActivoResponsableCombo]').setValue(me.idGestor);
     	} else {
     		me.down('[reference=fieldsetListaActivos]').setVisible(false);
     		me.down('[reference=fieldsetListaActivosSubida]').setVisible(false);
     	}
    	
    	if(!Ext.isEmpty(me.idActivo)){
    		me.down('[reference=supervisorActivoCombo]').setDisabled(true);
    		me.down('[reference=supervisorActivoCombo]').allowBlank=true;
     		me.down('[reference=gestorActivoResponsableCombo]').setDisabled(true);
    		me.down('[reference=gestorActivoResponsableCombo]').allowBlank=true;
    		
    	}
    	else{
    		me.down('[reference=gestorActivoResponsableCombo]').setDisabled(false);
    		me.down('[reference=gestorActivoResponsableCombo]').allowBlank=false;
    		me.down('[reference=supervisorActivoCombo]').setDisabled(false);
    		me.down('[reference=supervisorActivoCombo]').allowBlank=false;
    	}
     	
    	if(Ext.isEmpty(me.idAgrupacion) && Ext.isEmpty(me.idActivo)){
    		me.down('[reference=filefieldActivosRef]').allowBlank=false;
     		me.down('[reference=fieldSetSubirFichero]').setVisible(true);
     		me.down('[reference=fieldsetListaActivosSubida]').setVisible(true);
     		me.down('[reference=supervisorActivoCombo]').setValue(me.idSupervisor);
     		//me.down('[reference=supervisorActivoCombo]').readOnly= true;    		
     		me.down('[reference=textAdvertenciaCrearTrabajo]').setVisible(false);
     		me.down('[reference=codigoPromocionPrinex]').setVisible(true);
     		me.down('[reference=codigoPromocionPrinex]').reset();
     		me.down('[reference=codigoPromocionPrinex]').setDisabled(true);
     	} else {
     		me.down('[reference=filefieldActivosRef]').allowBlank=true;
     		me.down('[reference=fieldSetSubirFichero]').setVisible(false);
     		me.down('[reference=fieldsetListaActivosSubida]').setVisible(false);
     		me.down('[reference=supervisorActivoCombo]').readOnly= false; 
     		me.down('[reference=textAdvertenciaCrearTrabajo]').setVisible(true);
     		me.down('[reference=codigoPromocionPrinex]').setVisible(false);
     	}
    	
    	// Recarga las advertencias del trabajo
    	if(!Ext.isEmpty(me.down("[reference=textAdvertenciaCrearTrabajo]"))) {
    		me.down("[reference=textAdvertenciaCrearTrabajo]").setText("");	
    	}
    	
    	// Recarga el combo de tipos de trabajo
    	me.down("[reference=tipoTrabajo]").reset();
		me.down("[reference=tipoTrabajo]").getStore().removeAll();
		if (!Ext.isEmpty(me.down("[reference=tipoTrabajo]").getStore().getProxy())) {
			me.down("[reference=tipoTrabajo]").getStore().getProxy().extraParams.idAgrupacion = me.idAgrupacion;
		}
    	me.down("[reference=tipoTrabajo]").getStore().load();
    	
    	me.down("[reference=checkEnglobaTodosActivosRef]").setValue(true);
    	
    	if(!Ext.isEmpty(me.tipoAgrupacionCodigo) && (me.tipoAgrupacionCodigo!='01' && me.tipoAgrupacionCodigo != '02')){
    		me.down("[reference=checkEnglobaTodosActivosAgrRef]").setValue(false);
    		me.down("[reference=checkEnglobaTodosActivosAgrRef]").setVisible(false);
    		me.down("[reference=checkEnglobaTodosActivosAgrRef]").setDisabled(true);
    	}else{
    		me.down("[reference=checkEnglobaTodosActivosAgrRef]").setValue(true);
    		me.down("[reference=checkEnglobaTodosActivosAgrRef]").setVisible(true);
    		me.down("[reference=checkEnglobaTodosActivosAgrRef]").setDisabled(false);
    	}  */	

    }


});
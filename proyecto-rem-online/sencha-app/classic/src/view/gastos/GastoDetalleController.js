Ext.define('HreRem.view.gastos.GastoDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.gastodetalle',  
//    requires: ['HreRem.view.expedientes.NotarioSeleccionado', 'HreRem.view.expedientes.DatosComprador'],
	
	
	cargarTabData: function (form) {
		var me = this,
		id = me.getViewModel().get("gasto.id"),
		model = form.getModelInstance();
		
		form.up("tabpanel").mask(HreRem.i18n("msg.mask.loading"));	
		
		model.setId(id);
		model.load({
		    success: function(record) {
		    	
		    	form.setBindRecord(record);
		    	
		    	form.up("tabpanel").unmask();
		    }
		});
	},
	
	cargarTabDataMultiple: function (form,index, models, nameModels) {
		var me = this,
		id = me.getViewModel().get("gasto.id");
		
		models[index].setId(id);
		
		if(Ext.isDefined(models[index].getProxy().getApi().read)) {
			// Si la API tiene metodo de lectura (read).
			models[index].load({
			    success: function(record) {		    	
			    	me.getViewModel().set(nameModels[index], record);
			    	index++;
							
					if (index < models.length) {							
						me.cargarTabDataMultiple(form, index, models, nameModels);
					} else {	
						form.unmask();				
					}
			    },			            
				failure: function (a, operation) {
					 form.unmask();
				}
			});
		} else {
			// Si la API no contiene metodo de lectura (read).
			me.getViewModel().set(nameModels[index], models[index]);
	    	index++;
					
			if (index < models.length) {							
				me.cargarTabDataMultiple(form, index, models, nameModels);
			} else {	
				form.unmask();				
			}
		}
	
	},

	onSaveFormularioCompleto: function(btn, form) {
		var me = this;
		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones
		if(form.isFormValid() && form.disableValidation) {

			Ext.Array.each(form.query('field[isReadOnlyEdit]'),
				function (field, index){field.fireEvent('update'); field.fireEvent('save');}
			);
					
			btn.hide();
			btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
			btn.up('tabbar').down('button[itemId=botoneditar]').show();
			me.getViewModel().set("editing", false);
			
			if (!form.saveMultiple) {
				if(Ext.isDefined(form.getBindRecord().getProxy().getApi().create) || Ext.isDefined(form.getBindRecord().getProxy().getApi().update)) {
					// Si la API tiene metodo de escritura (create or update).
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
					
					form.getBindRecord().save({
						success: function (a, operation, c) {
							me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
							me.getView().unmask();
							me.refrescarGasto(form.refreshAfterSave);
			            },
				            
			            failure: function (a, operation) {
			            	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
							 me.getView().unmask();
			            }
					});
				}
			//Guardamos múltiples records	
			} else {
				var records = form.getBindRecords();
				var contador = 0;
				me.saveMultipleRecords(contador, records);
			}
		} else {
		
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
		
	},
	
	saveMultipleRecords: function(contador, records) {
		var me = this;
		if(Ext.isDefined(records[contador].getProxy().getApi().create) || Ext.isDefined(records[contador].getProxy().getApi().update)) {
			// Si la API tiene metodo de escritura (create or update).
			
			records[contador].save({
				success: function (a, operation, c) {
						contador++;
						
						if (contador < records.length) {
							me.saveMultipleRecords(contador, records);
						} else {
							 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));						
							 me.getView().unmask();
							 me.refrescarExpediente(false);							 
						}
	            },
	            failure: function (a, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					me.getView().unmask();
	            }
			});		
		}
	},

	onClickBotonEditar: function(btn) {
		
		var me = this;
		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').show();
		btn.up('tabbar').down('button[itemId=botoncancelar]').show();
		me.getViewModel().set("editing", true);		

		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('edit');});
								
		btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]')[0].focus();
		
	},
    
	onClickBotonGuardar: function(btn) {
		var me = this;	
		me.onSaveFormularioCompleto(btn, btn.up('tabpanel').getActiveTab());				
	},
	
	onClickBotonCancelar: function(btn) {
		var me = this,
		activeTab = btn.up('tabpanel').getActiveTab();

		if (!activeTab.saveMultiple) {
			if(activeTab && activeTab.getBindRecord && activeTab.getBindRecord()) {
				/*activeTab.getForm().clearInvalid();
				activeTab.getBindRecord().reject();*/
				me.onClickBotonRefrescar();
				
			}
		} else {
			
			var records = activeTab.getBindRecords();
			
			for (i=0; i<records.length; i++) {
				//records[i].reject();
				me.onClickBotonRefrescar();
			}

		}	

		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').hide();
		btn.up('tabbar').down('button[itemId=botoneditar]').show();
		me.getViewModel().set("editing", false);
		
		Ext.Array.each(activeTab.query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('save');
								field.fireEvent('update');});
	},
	
	 /**
     * Función que refresca la pestaña activa, y marca el resto de componentes para referescar.
     * Para que un componente sea marcado para refrescar, es necesario que implemente la función 
     * funciónRecargar con el código necesario para refrescar los datos.
     */
	onClickBotonRefrescar: function (btn) {
		var me = this;
		me.refrescarGasto(true);

	},
	
	refrescarGasto: function(refrescarPestañaActiva) {
		var me = this,
		
		refrescarPestañaActiva = Ext.isEmpty(refrescarPestañaActiva) ? false: refrescarPestañaActiva,
		activeTab = me.getView().down("tabpanel").getActiveTab();		
  		var buscadorNifEmisor= me.lookupReference('buscadorNifEmisorField').getValue();
  		var buscadorNifPropietario= me.lookupReference('buscadorNifPropietarioField').getValue();
    	if(!Ext.isEmpty(buscadorNifEmisor)){
    		me.lookupReference('buscadorNifEmisorField').setHidden(true);
    		me.lookupReference('nifEmisorGasto').setHidden(false);
    		me.lookupReference('nifEmisorGasto').setEditable(false);
    	}
    	if(!Ext.isEmpty(buscadorNifPropietario)){
    		me.lookupReference('buscadorNifPropietarioField').setHidden(true);
    		me.lookupReference('nifPropietarioRef').setHidden(false);
    		me.lookupReference('nifPropietarioRef').setEditable(false);
    	}
		// Marcamos todas los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});
  		
  		// Actualizamos la pestaña actual si tiene función de recargar 
		if(refrescarPestañaActiva && activeTab.funcionRecargar) {
  			activeTab.funcionRecargar();
		}
		
		me.getView().fireEvent("refrescarGasto", me.getView());
		
	},
	
	onSpecialKeyProveedor: function(field, e){
		var me= this;
		if(!Ext.isEmpty(field.getValue())){
			if (e.getKey() === e.ENTER || e.id== 'foo') {
				var url =  $AC.getRemoteUrl('gastosproveedor/searchProveedorNif');
				var nifProveedor= field.getValue();
				var data;
				Ext.Ajax.request({
		    			
		    		     url: url,
		    		     params: {nifProveedor : nifProveedor},
		    		
		    		     success: function(response, opts) {
		    		    	 data = Ext.decode(response.responseText);
		    		    	 if(!isEmptyJSON(data.data)){
		    		    	 	var id= data.data.id;
		    		    	 	var nombreEmisor= data.data.nombre;
		    		    	 	var codigoEmisor= data.data.codProveedorUvem;
		    		    	 	
		    		    	 	me.lookupReference('nifEmisorGasto').setValue(nifProveedor);
		    		    	 	me.lookupReference('buscadorNifEmisorField').setValue(nifProveedor);
		    		    	 	me.lookupReference('nombreEmisorGasto').setValue(nombreEmisor);
		    		    	 	me.lookupReference('codigoEmisorGasto').setValue(codigoEmisor);
		
		    		    	 }
		    		    	 else{
		    		    	 	me.lookupReference('nombreEmisorGasto').setValue('');
		    		    	 	me.lookupReference('codigoEmisorGasto').setValue('');
		    		    	 	me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.proveedor"));
		    		    	 }
		    		    	 
		    		     },
		    		     failure: function(response) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    		     },
		    		     callback: function(options, success, response){
		    		     }
		    		     
		    		 });
			}
            
        }
	},
	
	buscarProveedorBoton: function(field, e){
		if(!Ext.isEmpty(field.getValue())){
			var me= this;
			var url =  $AC.getRemoteUrl('gastosproveedor/searchProveedorNif');
				var nifProveedor= field.getValue();
				var data;
				Ext.Ajax.request({
		    			
		    		     url: url,
		    		     params: {nifProveedor : nifProveedor},
		    		
		    		     success: function(response, opts) {
		    		    	 data = Ext.decode(response.responseText);
		    		    	 if(!isEmptyJSON(data.data)){
		    		    	 	var id= data.data.id;
		    		    	 	var nombreEmisor= data.data.nombre;
		    		    	 	var codigoEmisor= data.data.codProveedorUvem;
		    		    	 	
		    		    	 	me.lookupReference('nifEmisorGasto').setValue(nifProveedor);
		    		    	 	me.lookupReference('buscadorNifEmisorField').setValue(nifProveedor);
		    		    	 	me.lookupReference('nombreEmisorGasto').setValue(nombreEmisor);
		    		    	 	me.lookupReference('codigoEmisorGasto').setValue(codigoEmisor);
		
		    		    	 }
		    		    	 else{
		    		    	 	me.lookupReference('nombreEmisorGasto').setValue('');
		    		    	 	me.lookupReference('codigoEmisorGasto').setValue('');
		    		    	 	me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.proveedor"));
		    		    	 }
		    		    	 
		    		     },
		    		     failure: function(response) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    		     },
		    		     callback: function(options, success, response){
		    		     }
		    		     
		    		 });
		}
	},
	
		onSpecialKeyPropietario: function(field, e){
		var me= this;
		if(!Ext.isEmpty(field.getValue())){
			if (e.getKey() === e.ENTER || e.id== 'foo') {
				var url =  $AC.getRemoteUrl('gastosproveedor/searchPropietarioNif');
				var nifPropietario= field.getValue();
				var data;
				Ext.Ajax.request({
		    			
		    		     url: url,
		    		     params: {nifPropietario : nifPropietario},
		    		
		    		     success: function(response, opts) {
		    		    	 data = Ext.decode(response.responseText);
		    		    	 if(!isEmptyJSON(data.data)){
		    		    	 	var id= data.data.id;
		    		    	 	var nombrePropietario= data.data.nombre;
//		    		    	 	
		    		    	 	me.lookupReference('nifPropietarioRef').setValue(nifPropietario);
		    		    	 	me.lookupReference('buscadorNifPropietarioField').setValue(nifPropietario);
		    		    	 	me.lookupReference('nombrePropietarioRef').setValue(nombrePropietario);
		
		    		    	 }
		    		    	 else{
		    		    	 	me.lookupReference('nombrePropietarioRef').setValue('');
		    		    	 	me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.propietario"));
		    		    	 }
		    		    	 
		    		     },
		    		     failure: function(response) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    		     },
		    		     callback: function(options, success, response){
		    		     }
		    		     
		    		 });
			}
            
        }
	},
	
	buscarPropietarioBoton: function(field, e){
		if(!Ext.isEmpty(field.getValue())){
		var me= this;
		var url =  $AC.getRemoteUrl('gastosproveedor/searchPropietarioNif');
			var nifPropietario= field.getValue();
			var data;
			Ext.Ajax.request({
		    			
		 		url: url,
		   		params: {nifPropietario : nifPropietario},
		    		
		    	success: function(response, opts) {
			    	data = Ext.decode(response.responseText);
			    	if(!isEmptyJSON(data.data)){
						var id= data.data.id;
		    		    var nombrePropietario= data.data.nombre;
		    		    	 	
		    		    me.lookupReference('nifPropietarioRef').setValue(nifPropietario);
		    		    me.lookupReference('buscadorNifPropietarioField').setValue(nifPropietario);
		    		    me.lookupReference('nombrePropietarioRef').setValue(nombrePropietario);
			    	}
			    	else{
			    		me.lookupReference('nombrePropietarioRef').setValue('');
			    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.propietario"));
			    	}
		    		    	 
		    	},
		    	failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	},
		    	callback: function(options, success, response){
				}
		    		     
		    });
		}
	}

});

function isEmptyJSON(obj) {
 	for(var i in obj) { return false; }
 	return true;
}
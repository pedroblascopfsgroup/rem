Ext.define('HreRem.view.trabajos.detalle.TrabajoDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.trabajodetalle',    
    
    control: {
    	
         'documentostrabajo gridBase': {
             abrirFormulario: 'abrirFormularioAdjuntarDocumentos',
             onClickRemove: 'borrarDocumentoAdjunto',
             download: 'downloadDocumentoAdjunto',
             afterupload: function(grid) {
             	grid.getStore().load();
             },
             afterdelete: function(grid) {
             	grid.getStore().load();
             }
         },
         
         'fotostrabajosolicitante': {
         	updateOrdenFotos: 'updateOrdenFotos'
         },
         
          'fotostrabajoproveedor': {
         	updateOrdenFotos: 'updateOrdenFotos'
         },
         
         'tramitestareastrabajo gridBase': {
             aftersaveTarea: function(grid) {
             	grid.getStore().load();
             }
         }
     },
    
	cargarTabData: function (form) {

		var me = this,
		model = form.getModelInstance(),
		id = me.getViewModel().get("trabajo.id");
		
		form.up("tabpanel").mask(HreRem.i18n('msg.mask.loading'));	
		model.setId(id);
		model.load({
		    success: function(record) {
		    	
		    	form.setBindRecord(record);		    	
		    	form.up("tabpanel").unmask();
		    	if(Ext.isFunction(form.afterLoad)) {
		    		form.afterLoad();
		    	}
		    },
		    failure: function(operation) {		    	
		    	form.up("tabpanel").unmask();
		    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    }
		});
	},
	
	onClickGasto: function(){
		var me = this;
		var numGasto = me.getViewModel().get('trabajo.numGasto');
		if(!Ext.isEmpty(numGasto)){
		  	var url= $AC.getRemoteUrl('gastosproveedor/getIdGasto');
        	var data;
    		Ext.Ajax.request({
    		     url: url,
    		     params: {numGasto : numGasto},
    		     success: function(response, opts) {
    		    	 data = Ext.decode(response.responseText);
    		    	 if(data.success == "true"){
    		    		 var titulo = "Gasto " + numGasto;
        		    	 me.getView().fireEvent('abrirDetalleGastoById', data.data, titulo); 
    		    	 }else{
        		    	 me.fireEvent("errorToast", data.error);
    		    	 }
    		
    		     },
    		     failure: function(response) {
    		    	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    		     }
    		 });    
		}
	},
	
	
	onChangeChainedCombo: function(combo) {
		var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);    	
    	me.getViewModel().notify();
		chainedCombo.clearValue("");
		chainedCombo.getStore().load({ 			
			callback: function(records, operation, success) {
   				if(records.length > 0) {
   					chainedCombo.setDisabled(false);
   				} else {
   					chainedCombo.setDisabled(true);
   				}
			}
		});
		/*if(combo.getValue() == "02"){
//			me.lookupReference("checkEnglobaTodosActivosAgrRef").setDisabled(true);
//			me.lookupReference('checkEnglobaTodosActivosAgrRef').setValue(false);
			me.lookupReference("checkEnglobaTodosActivosRef").setDisabled(true);
			me.lookupReference('checkEnglobaTodosActivosRef').setValue(false);
		}else{
//			me.lookupReference("checkEnglobaTodosActivosAgrRef").setDisabled(false);
//			me.lookupReference('checkEnglobaTodosActivosAgrRef').setValue(true);
			me.lookupReference("checkEnglobaTodosActivosRef").setDisabled(false);
			me.lookupReference('checkEnglobaTodosActivosRef').setValue(true);
		}
		
		if(combo.getValue() == "04" || combo.getValue() == "05"){
			me.lookupReference("gestorActivoResponsableCombo").allowBlank= true;
			me.lookupReference("supervisorActivoCombo").allowBlank= true;
		}
		else{
			me.lookupReference("gestorActivoResponsableCombo").allowBlank= false;
			me.lookupReference("supervisorActivoCombo").allowBlank= false;
		}
		
		if(combo.getValue() != "02" && combo.getValue() != "03") {
			me.lookupReference("fieldSetMomentoRealizacionRef").setVisible(false);
		} 
		else {
			me.lookupReference("fieldSetMomentoRealizacionRef").setVisible(true);
		}
		
		if(combo.getValue() == CONST.TIPOS_TRABAJO.ACTUACION_TECNICA) {
			me.lookupReference("codigoPromocionPrinex").setDisabled(false);
		} else {
			me.lookupReference("codigoPromocionPrinex").setDisabled(true);
			me.lookupReference("codigoPromocionPrinex").setValue(null);
		}*/
		
		if (!Ext.isEmpty(me.lookupReference("listaActivosSubidaRef")) && 
			!Ext.isEmpty(me.lookupReference("listaActivosSubidaRef").getColumnManager().getHeaderByDataIndex("activoEnPropuestaEnTramitacion"))  ){
			me.lookupReference("listaActivosSubidaRef").getColumnManager().getHeaderByDataIndex("activoEnPropuestaEnTramitacion").setVisible(false);
		}

		  	
		
    },
    
    refreshStoreSeleccionTarifas: function(combo) {
    	
    	var gridSeleccionTarifas = combo.up("window").down("grid");
	    gridSeleccionTarifas.getStore().load();
	    
    },
    
    getPlazoComiteProveedor: function(){
    	var me = this;
    	var urlCfg = $AC.getRemoteUrl('trabajo/getPlazoEjecucion');
    	var urlComite = $AC.getRemoteUrl('trabajo/getAplicaComiteParametrizado');
    	var comboProveedor = me.lookupReference('comboProveedorGestionEconomica2');
    	var gridActivos = me.lookupReference('listaActivosSubidaRef');
    	var gridActivosAgrupacion = me.lookupReference('activosagrupaciontrabajo');
    	var codigoSubtipoTrabajo = me.lookupReference('subtipoTrabajoCombo').getValue();
    	var codigoTrabajo = me.lookupReference('tipoTrabajo').getValue();
    	var codCartera = null;
    	var codSubcartera = me.getView().codSubcartera;
		comboProveedor.disable();
    	if (gridActivos.getStore().getData().items[0] != null && gridActivos.getStore().getData().items[0] != undefined){
    		codCartera = gridActivos.getStore().getData().items[0].data.codigoCartera;
    	} else if (gridActivosAgrupacion.getStore().getData().items[0] != null && gridActivosAgrupacion.getStore().getData().items[0] != undefined){
    		codCartera = gridActivosAgrupacion.getStore().getData().items[0].data.codigoCartera;
    	}
    	if (codigoSubtipoTrabajo != null && codigoTrabajo != null && codCartera != null){
	    	Ext.Ajax.request({
				  url:urlCfg,
				  params:  {tipoTrabajo : codigoTrabajo, 
					  		subtipoTrabajo : codigoSubtipoTrabajo,
					  		cartera: codCartera,
					  		subCartera: codSubcartera},
				  success: function(response,opts){
					  var decode = Ext.JSON.decode(response.responseText);
					  var fecha = decode["data"];
					  var prehora = fecha.split('T');
					  fecha = new Date(fecha);
					 				 
					  if(me.lookupReference("tipoTrabajo").getValue() == CONST.TIPOS_TRABAJO['ACTUACION_TECNICA'] && 
					  ( me.getViewModel().get("trabajo.subtipoTrabajoCodigo") == CONST.SUBTIPOS_TRABAJO['PAQUETES'])
					  ||  me.getViewModel().get("trabajo.subtipoTrabajoCodigo") == CONST.SUBTIPOS_TRABAJO['TOMA_POSESION']){
					  	 me.lookupReference('fechaConcretaTrabajo').setValue(fecha);
					  	 var hora = prehora[1];
					  	 me.lookupReference('fechaConcretaTrabajo').setAllowBlank(false);
					  	 me.lookupReference('horaConcretaTrabajo').setAllowBlank(false);
					  	 
							  prehora = hora.split(':');
							  if(prehora[1] >= 30){
								  me.lookupReference('horaConcretaTrabajo').setSelection(prehora[0]*2 + 1);
							  }else{
								  me.lookupReference('horaConcretaTrabajo').setSelection(prehora[0]*2);
							  }
						 }else{
						 	 me.lookupReference('fechaConcretaTrabajo').setAllowBlank(true);
					 		 me.lookupReference('horaConcretaTrabajo').setAllowBlank(true);
						 }
					 
					  me.lookupReference('fechaTopeTrabajo').setValue(fecha);
					
				  }
	      	});
	      	
	      	Ext.Ajax.request({
				  url:urlComite,
				  params:  {tipoTrabajo : codigoTrabajo, 
					  		subtipoTrabajo : codigoSubtipoTrabajo,
					  		cartera: codCartera,
					  		subCartera: codSubcartera},
				  success: function(response,opts){
					  var decode = Ext.JSON.decode(response.responseText);
					  var result = decode["data"];
					  if(result == "true"){
						  me.lookupReference('checkAplicaComite').setValue(true);
						  me.onCheckChangeAplicaComite(null,null,false,null);
					  }else{
						me.lookupReference('checkAplicaComite').setValue(false);
						me.onCheckChangeAplicaComite(null,null,true,null);
					  }
				  }
	        	});
	      	comboProveedor.setSelection(null);
	      	me.lookupReference('proveedorContactoCombo2').setSelection(null);			
			
			me.onAfterLoadProveedor();
	    }
    },
	
	validaGrid: function(){
		var me = this;
		var comboTipoTrabajo = me.lookupReference('tipoTrabajo');
		
		if (me.getView().idActivo != null || me.getView().idAgrupacion != null){
			comboTipoTrabajo.enable();			
		}else{
			comboTipoTrabajo.disable();			
		}
	},
	
	onChangeSubtipoTrabajoCombo: function(combo) {
		var me = this;
    	var idActivo = combo.up("window").idActivo;
    	var idAgrupacion = combo.up("window").idAgrupacion
    	var codigoSubtipoTrabajo = combo.getValue();
    	var advertencia;
    	var codCartera = null;
    	var codSubcartera = null;
    	var parametrico=false;
		var comboProveedor = me.lookupReference('comboProveedorGestionEconomica2');
		comboProveedor.enable();
		comboProveedor.validate();
    	if ((Ext.isDefined(idActivo) && idActivo != null) || Ext.isDefined(idAgrupacion) && idAgrupacion != null){
		    var url = $AC.getRemoteUrl('trabajo/getAdvertenciaCrearTrabajo');
		    Ext.Ajax.request({
			  url:url,
			  params:  {
				  		idActivo : idActivo,
				  		idAgrupacion : idAgrupacion, 
			  			codigoSubtipoTrabajo : codigoSubtipoTrabajo
			  			},
			  success: function(response,opts){
				  advertencia = Ext.JSON.decode(response.responseText).advertencia;
				  me.lookupReference("textAdvertenciaCrearTrabajo").setText(advertencia);
			  }
		    });
		}
    	if(me.getView().codCartera != null){
    		codCartera = me.getView().codCartera;
    		codSubcartera = me.getView().codSubcartera;
    		parametrico = true;
    	}else{
    		if(me.lookupReference('listaActivosSubidaRef').getStore().getData() != null 
    				&& me.lookupReference('listaActivosSubidaRef').getStore().getData().length > 0){
    			codCartera = me.lookupReference('listaActivosSubidaRef').getStore().getData().items[0].data.codigoCartera;
    			parametrico = true;
    		}
		}
		me.getView().codCartera = codCartera;
		me.getView().codSubcartera = codSubcartera;
		
    	if(parametrico){
    		me.getPlazoComiteProveedor();
    	}
    	
    	if(codigoSubtipoTrabajo == CONST.SUBTIPOS_TRABAJO['TRAMITAR_PROPUESTA_PRECIOS'] 
    		|| codigoSubtipoTrabajo == CONST.SUBTIPOS_TRABAJO['TRAMITAR_PROPUESTA_DESCUENTO']) {
    		me.lookupReference("checkEnglobaTodosActivosRef").setValue(true);
    		me.lookupReference("checkEnglobaTodosActivosRef").setDisabled(true);
    		
    		me.lookupReference("listaActivosSubidaRef").getColumnManager().getHeaderByDataIndex("activoEnPropuestaEnTramitacion").setVisible(true);	
    		
    	}
    	else {
    		
    		me.lookupReference("listaActivosSubidaRef").getColumnManager().getHeaderByDataIndex("activoEnPropuestaEnTramitacion").setVisible(false);
    		
    		if(me.lookupReference("tipoTrabajo").getValue() != CONST.TIPOS_TRABAJO['OBTENCION_DOCUMENTACION']){
    			me.lookupReference("checkEnglobaTodosActivosRef").setDisabled(false);
    		}
    	}
	    
    },
    	
	onClickBotonFavoritos: function(btn) {
		
		var me = this,
		textoFavorito = "Trabajo " + me.getViewModel().get("trabajo.numTrabajo");
		
		btn.updateFavorito(textoFavorito);
			
	},
	
   	onSaveFormularioCompleto: function(form, success) {
		var me = this,
		record = form.getBindRecord();
		success = success || function() {me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));};  
		
		var checkTarifaPlana = form.getValues().checkTarifaPlana == "on";
		var checkSiniestro = form.getValues().checkSiniestro == "on";

		if(form.isFormValid()) {

			form.mask(HreRem.i18n("msg.mask.espere"));
   
			record.save({
				params:{
					fechaConcretaString: form.getValues().fechaConcreta,
					horaConcretaString: form.getValues().horaConcreta,
					tarifaPlana: checkTarifaPlana,
					riesgoSiniestro: checkSiniestro
				},
			    success: success,
			 	failure: function(record, operation) {
			 		var response = Ext.decode(operation.getResponse().responseText);
			 		if(response.success === "false" && Ext.isDefined(response.error)) {
						me.fireEvent("errorToast", Ext.decode(operation.getResponse().responseText).error);
						if(me.getView().down("[reference=activosagrupaciontrabajo]") != null){
			 				me.getView().down("[reference=activosagrupaciontrabajo]").deselectAll();
			 			}
			 		}else{
			 			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			 			if(me.getView().down("[reference=activosagrupaciontrabajo]") != null){
			 				me.getView().down("[reference=activosagrupaciontrabajo]").deselectAll();
			 			}
			 		}
			    },
			    callback: function(record, operation) {
			    	form.unmask();
			    }
			    		    
			});
			
		} else {
		
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
	
	},
	
	onClickBotonEditar: function(btn) {
		var me =this;
		
		me.getViewModel().set("editing", true);
		/*btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').show();
		btn.up('tabbar').down('button[itemId=botoncancelar]').show();*/

		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
			function (field, index) 
				{ 								
					field.fireEvent('edit');
					if(index == 0) field.focus();
				}
		);
		
	},
    
	onClickBotonGuardar: function(btn) {
		
		var me = this;
		
		var success = function() {
			me.getViewModel().set("editing", false);
			
			Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
							function (field, index) 
								{ 
									field.fireEvent('save');
									field.fireEvent('update');});
									
			me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	me.getView().fireEvent("refreshComponentOnActivate", "trabajosmain");
	    	me.getView().fireEvent("refreshComponentOnActivate", "agendamain");
			me.onClickBotonRefrescar();
			
		}
		
		
		
		me.onSaveFormularioCompleto(btn.up('tabpanel').getActiveTab(), success);				
	},
	
	onClickBotonCancelar: function(btn) {

		var me = this,
		activeTab = btn.up('tabpanel').getActiveTab();
		
		if(activeTab && activeTab.getBindRecord && activeTab.getBindRecord()) {
			activeTab.getBindRecord().reject();
		}		
		me.getViewModel().set("editing", false);
		Ext.Array.each(activeTab.query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('cancel');
							});
	},
	
	//Este método habrá que codificarlo en la parte de la funcionalidad
	onClickBotonCrearPeticionTrabajo: function(btn){
		var me = this;
		var storeListaActivosTrabajo = null;
		var activo= null;
		var arraySelection= [];
		var codPromo;
		var idTarea = me.lookupReference('idTarea').getValue();
		var campoIdTareaInformado = (idTarea != null && idTarea.length > 0);
		var existeTarea = null;
		
		if(!Ext.isEmpty(me.getView().idAgrupacion)){
			arraySelection = me.lookupReference('activosagrupaciontrabajo').getActivoIDPersistedSelection();
			var datosComprobarPerimetro = me.lookupReference('activosagrupaciontrabajo').getStore().getData().items;
            
            if(arraySelection.length > 0){
            	datosComprobarPerimetro = me.lookupReference('activosagrupaciontrabajo').getSelection();   
            }
            for(var i = 0; i < datosComprobarPerimetro.length; i++){
	            if(datosComprobarPerimetro[i].data.tienePerimetroGestion != "1"){
	            	Ext.MessageBox.alert(HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"), HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.mensaje.todos.agrupacion"));
	                return false;
	            }
            }
		}
		
		if(!Ext.isEmpty(me.getView().idActivo)){
			activo = btn.lookupViewModel().getView().idActivo;
			codPromo = me.lookupReference('activosagrupaciontrabajo').getStore().getData().items[0].get('codigoPromocionPrinex');
		}else{
			storeListaActivosTrabajo = me.lookupReference('listaActivosSubidaRef').getStore();
		}
		//Casuistica de lista de activos por Excel
		if(!Ext.isEmpty(storeListaActivosTrabajo) && storeListaActivosTrabajo.data.length > 0){
			var actuacionTecnica = (me.lookupReference('tipoTrabajo').getValue() == CONST.TIPOS_TRABAJO.ACTUACION_TECNICA ? true : false);
			var propietario = storeListaActivosTrabajo.data.items[0].data.propietarioId;
			for (var i=0; i < storeListaActivosTrabajo.data.length; i++){
				var propietarioAux = storeListaActivosTrabajo.data.items[i].data.propietarioId;
				if(propietarioAux != propietario && me.lookupReference('checkEnglobaTodosActivosRef').checked != false)
				{
					Ext.MessageBox.alert(
							HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
							HreRem.i18n("msgbox.multiples.trabajos.seleccionado.diferente.propietario.mensaje")
					);
					return false;
				}
				if (storeListaActivosTrabajo.data.items[i].data.tienePerimetroGestion != "1"){
					Ext.MessageBox.alert(
							HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
							HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.mensaje.todos")
					);
					return false;
		        }
				//No existe codPromo, por tanto jamas sera diferente de vacio, por tanto esta logica queda descartada. 
				//Preguntar de todas formas
				
				if (actuacionTecnica && !Ext.isEmpty(codPromo)){
					if (storeListaActivosTrabajo.data.items[i].data.codigoCartera == CONST.CARTERA.LIBERBANK) {
						if (!Ext.isEmpty(codPromo) && storeListaActivosTrabajo.data.items[i].data.codigoPromocionPrinex != codPromo){
							Ext.MessageBox.alert(
									HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
									HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinCodPromo.mensaje.todos")
							);
							return false;
				        }
					} else {
						Ext.MessageBox.alert(
								HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
								HreRem.i18n("msgbox.multiples.trabajos.seleccionado.todosCarteraLiberbank.mensaje.todos")
						);
						return false;
					}
				}
				arraySelection.push(storeListaActivosTrabajo.data.items[i].data.idActivo);
			}
		}
		

		var titleConfirm = HreRem.i18n("msgbox.multiples.trabajos.title");
		var textConfirm = HreRem.i18n("msgbox.multiples.trabajos.seleccionados.check.mensaje");
		if(!btn.up().up().down("[reference='checkEnglobaTodosActivosRef']").value){
			textConfirm = HreRem.i18n("msgbox.multiples.trabajos.seleccionados.check.mensaje.multiples");
		}
		
		if(Ext.isEmpty(me.getView().idAgrupacion) && Ext.isEmpty(me.getView().idActivo) && (Ext.isEmpty(storeListaActivosTrabajo) || storeListaActivosTrabajo.data.length == 0)){
			Ext.MessageBox.alert(
					HreRem.i18n("msgbox.multiples.trabajos.seleccionado.activo.no.seleccionado.titulo"),
					HreRem.i18n("msgbox.multiples.trabajos.seleccionado.activo.no.seleccionado.mensaje")
			);
			return false;
			
		}
		
		if ( campoIdTareaInformado ) {
			var isDev = false;
			var url = $AC.getRemoteUrl('trabajo/getExisteTareaWebServiceHaya');
		    	Ext.Ajax.request({
					  url:     url,
					  async:   false,
					  method:  'GET',
					  params: {
						  idTareaHaya: idTarea  
					  },
					  success: function(response, opts) {
						  var decode = Ext.JSON.decode(response.responseText);
						  if ( "DEV" === decode['response']){
							  isDev = true;
						  } else {
							  response = decode['response']
							  existeTarea = 'true' == response['tareaExistente'];
						  }
						  
					  },
					  failure: function () {
						  existeTarea = false;
						  me.fireEvent("errorToast", HreRem.i18n("msg.error.conection.haya"));
					  }
		      	});
		    	
		    	if ( isDev ){
		    		me.fireEvent("errorToast", HreRem.i18n("msg.error.conection.haya"));
		    		return false;
		    	}
		    	if ( !existeTarea ) {
		    		me.fireEvent("errorToast", HreRem.i18n("msg.no.existe.tarea"));
		    		return false;
		    	}
		}

		
		if(me.getView().trabajoDesdeActivo){
			me.crearTrabajo(btn,arraySelection,null);
		}else{
		//
			Ext.MessageBox.confirm(
					titleConfirm,
					textConfirm,
					function(result) {
			        	if(result === 'yes'){
			        		me.crearTrabajo(btn,arraySelection,null);
			        	}
			    	}
			);
		}
	},
	
	// Este método es llamado cuando se pulsa el botón de 'crear' en la ventana pop-up
	// de crear trabajo. Comprueba si se ha seleccionado el checkbox de agrupar activos
	// en un sólo trabajo. Si no se ha seleccionado informa al usuario de que se va a
	// generar un trabajo por cada activo.
	onClickBotonCrearTrabajo: function(btn) {
		var me =this;
		var arraySelection = me.lookupReference('activosagrupaciontrabajo').getActivoIDPersistedSelection();
		// Comprobar el estado del checkbox para agrupar los activos en un trabajo.
		var check = me.lookupReference('checkEnglobaTodosActivosRef').getValue();	
		var codPromo;
		//Si no se ha seleccionado ning�n activo
		if(Ext.isEmpty(arraySelection)){
			var storeListaActivosTrabajo = me.lookupReference('listaActivosSubidaRef').getStore();
			if(!Ext.isEmpty(storeListaActivosTrabajo) && storeListaActivosTrabajo.data.length != 0){
				codPromo = me.lookupReference('codigoPromocionPrinex').getValue();
				var actuacionTecnica = (me.lookupReference('tipoTrabajo').getValue() == CONST.TIPOS_TRABAJO.ACTUACION_TECNICA ? true : false);
				var propietario = storeListaActivosTrabajo.data.items[0].data.propietarioId;
				for (var i=0; i < storeListaActivosTrabajo.data.length; i++) {
					var propietarioAux = storeListaActivosTrabajo.data.items[i].data.propietarioId;
					if(propietarioAux != propietario && me.lookupReference('checkEnglobaTodosActivosRef').checked != false){
						Ext.MessageBox.alert(
								HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
								HreRem.i18n("msgbox.multiples.trabajos.seleccionado.diferente.propietario.mensaje")
						);
						return false;
					}
					if (storeListaActivosTrabajo.data.items[i].data.tienePerimetroGestion != "1"){
						Ext.MessageBox.alert(
								HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
								HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.mensaje.todos")
						);
						return false;
			        }
					if (actuacionTecnica && !Ext.isEmpty(codPromo)) {
						if (storeListaActivosTrabajo.data.items[i].data.codigoCartera == CONST.CARTERA.LIBERBANK) {
							if (!Ext.isEmpty(codPromo) && storeListaActivosTrabajo.data.items[i].data.codigoPromocionPrinex != codPromo){
								Ext.MessageBox.alert(
										HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
										HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinCodPromo.mensaje.todos")
								);
								return false;
					        }
						} else {
							Ext.MessageBox.alert(
									HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
									HreRem.i18n("msgbox.multiples.trabajos.seleccionado.todosCarteraLiberbank.mensaje.todos")
							);
							return false;
						}
					}
					arraySelection.push(storeListaActivosTrabajo.data.items[i].data.idActivo);
				}
			}
			//Si se marca el check y se esta creando desde agrupaciones
			if(check && Ext.isEmpty(me.getView().idActivo)){
				Ext.MessageBox.confirm(
						HreRem.i18n("msgbox.multiples.trabajos.title"),
						HreRem.i18n("msgbox.multiples.trabajos.seleccionado.check.mensaje"),
						function(result) {
			        		if(result === 'yes'){
			        			me.crearTrabajo(btn,arraySelection,codPromo);
			        		}
			    		}
				);
			}
			else if(Ext.isEmpty(me.getView().idActivo)){
				Ext.MessageBox.confirm(
						HreRem.i18n("msgbox.multiples.trabajos.title"),
						HreRem.i18n("msgbox.multiples.trabajos.check.mensaje"),
						function(result) {
			        		if(result === 'yes'){
			        			me.crearTrabajo(btn,arraySelection,codPromo);
			        		}
			    		}
				);
			}else{
				me.crearTrabajo(btn,arraySelection,codPromo);
			}
		}
		else{
			if(check && Ext.isEmpty(me.getView().idActivo)){
				Ext.MessageBox.confirm(
						HreRem.i18n("msgbox.multiples.trabajos.title"),
						HreRem.i18n("msgbox.multiples.trabajos.seleccionados.check.mensaje"),
						function(result) {
			        		if(result === 'yes'){
			        			me.crearTrabajo(btn,arraySelection,codPromo);
			        		}
			    		}
				);
			}
			else{
				Ext.MessageBox.confirm(
						HreRem.i18n("msgbox.multiples.trabajos.title"),
						HreRem.i18n("msgbox.multiples.trabajos.checks.mensaje"),
						function(result) {
			        		if(result === 'yes'){
			        			me.crearTrabajo(btn,arraySelection,codPromo);
			        		}
			    		}
				);
			}
			
		}
		
	},
	
	hideWindowCrearPeticionTrabajo: function(btn) {
    	var me = this;
    	me.getView().mask(HreRem.i18n("msg.mask.loading"));
    	btn.up('window').cerrar();
    },
	
	hideWindowPeticionTrabajo: function(btn) {
    	var me = this;
    	me.getView().down("[reference=activosagrupaciontrabajo]").deselectAll();
    	btn.up('window').hide();   	
    },
	
	// Este método crea el trabajo especificado en la ventana pop-up de crear trabajo.
	crearTrabajo: function(btn,arraySelection, codigoPromocionPrinex) {
		var me =this,
		window = btn.up("window"),
		form = window.down("form"),
		idAgrupacion = window.idAgrupacion,
		idActivo = window.idActivo,
		idProceso = window.idProceso;
		codCartera = window.codCartera;
		codSubcartera = window.codSubcartera;
		
		if(form.isValid()){
			var idTarifas = me.obtenerIdTarifas(me.lookupReference('gridListaTarifas').getStore().getData());
			//Nuevos Valores
			
//			form.getBindRecord().set("idMediador",me.lookupReference('comboProveedorGestionEconomica2').getSelection().get('id'))
			if(me.lookupReference('checkAplicaComite').getValue()){
				form.getBindRecord().set("resolucionComiteId",me.lookupReference('resolComiteId').getValue());
				form.getBindRecord().set("fechaResolucionComite",me.lookupReference('fechaResolComite').getValue());
				form.getBindRecord().set("resolucionComiteCodigo",me.lookupReference('comboResolucionComite').getSelectedRecord().get('codigo'));
				form.getBindRecord().set("aplicaComite",me.lookupReference('checkAplicaComite').getValue());
			}else{
				form.getBindRecord().set("resolucionComiteId",null);
				form.getBindRecord().set("fechaResolucionComite",null);
				form.getBindRecord().set("resolucionComiteCodigo",null);
				form.getBindRecord().set("aplicaComite",me.lookupReference('checkAplicaComite').getValue());
			}
			
			form.getBindRecord().set("idTarea",me.lookupReference('idTarea').getValue());
			form.getBindRecord().set("fechaConcreta",me.lookupReference('fechaConcretaTrabajo').getValue());
			form.getBindRecord().set("horaConcreta",me.lookupReference('horaConcretaTrabajo').getValue());
			form.getBindRecord().set("fechaTope",me.lookupReference('fechaTopeTrabajo').getValue());
			form.getBindRecord().set("importePresupuesto",me.lookupReference('importePresupuesto').getValue());
			form.getBindRecord().set("refImportePresupueso",me.lookupReference('referenciaImportePresupuesto').getValue());
			form.getBindRecord().set("esTarifaPlanaEditable",me.lookupReference('tarifaPlana').getValue());
			form.getBindRecord().set("riesgosTerceros",me.lookupReference('riesgosTerceros').getValue());
			form.getBindRecord().set("urgente",me.lookupReference('urgente').getValue());
			form.getBindRecord().set("esSiniestroEditable",me.lookupReference('siniestro').getValue());
			form.getBindRecord().set("idTarifas",idTarifas);
			form.getBindRecord().set("esSolicitudConjunta",me.lookupReference('checkEnglobaTodosActivosRef').getValue());
			form.getBindRecord().set("proveedorContact",me.lookupReference('proveedorContactoCombo2').selection.data.id);
			
			form.getBindRecord().set("idActivo", idActivo);
			form.getBindRecord().set("idAgrupacion", idAgrupacion);
			form.getBindRecord().set("idProceso", idProceso);
			form.getBindRecord().set("idsActivos", arraySelection);
			form.getBindRecord().set("codigoPromocionPrinex", codigoPromocionPrinex);
			form.getBindRecord().set("codCartera", codCartera);
			form.getBindRecord().set("codSubcartera", codSubcartera);
			form.getBindRecord().set("fechaEjecucionTrabajo", null);
			form.getBindRecord().set("fechaEntregaLlaves", null);
			
			window.getViewModel().getView().mask(HreRem.i18n("msg.mask.espere"));
					
			var success = function(record, operation) {
				me.getView().unmask();
				window.getViewModel().getView().unmask();
				var response = Ext.decode(operation.getResponse().responseText);
				if(response.success === "true" && Ext.isDefined(response.warn)) {
					me.fireEvent("warnToast", response.warn);
				}else{
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				}
		    	me.getView().fireEvent("refreshComponentOnActivate", "trabajosmain");
		    	me.getView().fireEvent("refreshComponentOnActivate", "agendamain");
		    	me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['ACTIVO'], idActivo);
	//	    	me.getView().down("[reference=activosagrupaciontrabajo]").deselectAll();
		    	window.hide();
			};
		}
		

		me.onSaveFormularioCompleto(form, success);
	},
	
	obtenerIdTarifas: function(data){
		if(data.length < 1){
			return null;
		}
		var aux= "";
		var ultimo = data.length-1;
		for(var i = 0; i < data.length; i++){
			aux = aux.concat(data.items[i].data.id);
			if(i<ultimo){
				aux = aux.concat(',');
			}
		}
		return aux;
	},	
	
	onClickBotonCancelarTrabajo: function(btn) {		
		btn.up('window').hide();		
	},
	
	onClickBotonCancelarPresupuesto: function(btn) {		
		var me = this,
		window = btn.up('window');
		
		window.parent.down("[reference=gridpresupuestostrabajo]").getStore().load();
    	window.close();
	},
	
	abrirFormularioAdjuntarDocumentos: function(grid) {
		var me = this,
		idTrabajo = me.getViewModel().get("trabajo.id");
		tipoTrabajoCodigo = me.getViewModel().get("trabajo.tipoTrabajoCodigo");
		var viewPortWidth = Ext.Element.getViewportWidth();
	    var viewPortHeight = Ext.Element.getViewportHeight();
		var wizard = Ext.create('HreRem.view.common.WizardBase',
				{
					slides: [
						'adjuntardocumentowizard1',
						'adjuntardocumentowizard2'
					],
					title: 'Adjuntar Documento',
					padre : me,
					idEntidad: idTrabajo,
					entidad:'trabajo', 
					modoEdicion: true,
					width: viewPortWidth > 1370 ? viewPortWidth / 2.5 : viewPortWidth / 3.5,
					height: viewPortHeight > 500 ? 350 : viewPortHeight - 100,
					x: viewPortWidth / 2 - ((viewPortWidth > 1370 ? viewPortWidth / 2 : viewPortWidth /1.5) / 2),
	    			y: viewPortHeight / 2 - ((viewPortHeight > 500 ? 500 : viewPortHeight - 100) / 2)
				}
			).show();

	},
	
	borrarDocumentoAdjunto: function(grid, record) {
		var me = this;
		idTrabajo = me.getViewModel().get("trabajo.id");

		record.erase({
			params: {idEntidad: idTrabajo},
            success: function(record, operation) {
           		 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
           		 grid.fireEvent("afterdelete", grid);
            },
            failure: function(record, operation) {
                  me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                  grid.fireEvent("afterdelete", grid);
            }
            
        });	
	},
	
	downloadDocumentoAdjunto: function(grid, record) {
		
		var me = this,
		config = {};
		
		config.url=$AC.getWebPath()+"trabajo/bajarAdjuntoTrabajo."+$AC.getUrlPattern();
		config.params = {};
		config.params.id=record.get('id');
		config.params.idTrabajo=record.get("idTrabajo");
		config.params.nombreDocumento=record.get("nombre").replace(/,/g, "");
		me.fireEvent("downloadFile", config);
	},
	
    onClickBotonCerrarPestanya: function(btn) {
    	var me = this;
    	me.getView().destroy();
    },
    
    onClickBotonCerrarTodas: function(btn) {
    	var me = this;
    	me.getView().up("tabpanel").fireEvent("cerrarTodas", me.getView().up("tabpanel"));    	

    },
    
    /**
     * Funcióhn que refresca la pestaña activa, y marca el resto de componentes para referescar.
     * Para que un componente sea marcado para refrescar, es necesario que implemente la función 
     * funciónRecargar con el código necesario para refrescar los datos.
     */
    onClickBotonRefrescar: function () {
		var me = this,
		activeTab = me.getView().down("tabpanel").getActiveTab();
  		
		// Marcamos todos los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});
  		
  		// Actualizamos la pestaña actual si tiene función de recargar
		if(activeTab.funcionRecargar) {
  			activeTab.funcionRecargar();
		}
		
		me.getView().fireEvent("refrescarTrabajo", me.getView());

	},
	
	cargarTabFotos: function (form) {
		var me = this,
		idTrabajo = me.getViewModel().get("trabajo.id");
		
		me.getViewModel().data.storeFotosTrabajoProveedor.getProxy().setExtraParams({'id':idTrabajo, solicitanteProveedor: true}); 
		me.getViewModel().data.storeFotosTrabajoSolicitante.getProxy().setExtraParams({'id':idTrabajo, solicitanteProveedor: false}); 
		
		me.getViewModel().data.storeFotosTrabajoProveedor.load();
		me.getViewModel().data.storeFotosTrabajoSolicitante.load();

	},
	
	onAddFotoClick: function(grid) {
		var me = this,
		idTrabajo = me.getViewModel().get("trabajo.id");
    	
    	//Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumento", {entidad: 'activo', idEntidad: idActivo, parent: grid}).show();
		Ext.create("HreRem.view.common.adjuntos.AdjuntarFotoTrabajo", {idEntidad: idTrabajo, parent: grid, parentDos: true}).show();
		
	},
	
	updateOrdenFotos: function(data, record, store) {

		var me = this;
		me.storeGuardado = store;
		me.ordenGuardado = 0;
		me.refrescarGuardado = true;
		var orden = 1;
		var modificados = new Array();
		var contadorModificados = 0;
		for (i=0; i<record.store.getData().items.length;i++) {
			
			if (store.getData().items[i].data.orden != orden) {
				store.getAt(i).data.orden = orden;
				//FIXME: ¿Poner máscara?
				//me.getView().mask(HreRem.i18n("msg.mask.loading"));
				var url =  $AC.getRemoteUrl('trabajo/updateFotosById');
    			Ext.Ajax.request({
    			
	    		     url: url,
	    		     params: {
	    		     			id: store.getAt(i).data.id,
	    		     			orden: store.getAt(i).data.orden 	
	    		     		}
	    			
	    		    ,success: function (a, operation, context) {

	                	//me.getStore().load();
	                    //context.store.load();
	                    if (me.ordenGuardado >= me.storeGuardado.getData().items.length && me.refrescarGuardado) {
	                    	me.storeGuardado.load();
	                    	me.refrescarGuardado = false;
	                    	/* //FIXME: ¿Poner máscara?
	                    	Ext.toast({
							     html: 'LA OPERACIÓN SE HA REALIZADO CORRECTAMENTE',
							     width: 360,
							     height: 100,
							     align: 't'
							});*/
							//me.getView().unmask();
	                    }
	                    
	                    
	                    
	                },
	                
	                failure: function (a, operation, context) {
	                	//context.store.load();
	                	  Ext.toast({
						     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
						     width: 360,
						     height: 100,
						     align: 't'									     
						 });
						 me.unmask();
	                }
    		     
				});
				
				
			}
			orden++;
			me.ordenGuardado++;
		}
		
	},
	
	onReloadFotoClick: function(btn) {
		var me = this,
		idTrabajo = me.getViewModel().get("trabajo.id");
		var storeTemp = btn.up('form').down('dataview').getStore();
		var url =  $AC.getRemoteUrl('trabajo/refreshCacheFotos');
		Ext.Ajax.request({
			url: url,
			params: {id : idTrabajo},
				 success: function (a, operation, context) {
               		storeTemp.load();
               	 	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                 },
                 failure: function (a, operation, context) {
	               	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    	         }		     
		});
	},
	
	onDeleteFotoClick: function(btn) {
		
		var me = this;

		Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.eliminacion'),
			   msg: HreRem.i18n('msg.desea.eliminar'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	
			        	var nodos = btn.up('form').down('dataview').getSelectedNodes();
						var storeTemp = btn.up('form').down('dataview').getStore();
						var idSeleccionados = [];
						for (var i=0; i<nodos.length; i++) {
				
							idSeleccionados[i] = storeTemp.getAt(nodos[i].getAttribute('data-recordindex')).getId();
							
						}
			    		
			        	var url =  $AC.getRemoteUrl('trabajo/deleteFotosTrabajoById');
			    		Ext.Ajax.request({
			    			
			    		     url: url,
			    		     params: {id : idSeleccionados},
			    		
			    		     success: function (a, operation, context) {
                                	
                                	storeTemp.load();

                                    Ext.toast({
									     html: 'LA OPERACIÓN SE HA REALIZADO CORRECTAMENTE',
									     width: 360,
									     height: 100,
									     align: 't'
									 });
                                },
                                
                                failure: function (a, operation, context) {

                                	  Ext.toast({
									     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
									     width: 360,
									     height: 100,
									     align: 't'									     
									 });
                                }
			    		     
			    		 });

			        }
			   }
		});
		
	},
	
	onDownloadFotoClick: function(btn) {
		var me = this,
		config = {};
		
		var nodos = btn.up('form').down('dataview').getSelectedNodes();
		if (nodos.length != 0) {
		
			var storeTemp = btn.up('form').down('dataview').getStore();
			
			config.url=$AC.getWebPath()+"trabajo/getFotoTrabajoById."+$AC.getUrlPattern();
			config.params = {};

			config.params.idFoto=storeTemp.getAt(nodos[0].getAttribute('data-recordindex')).getId();
			
			me.fireEvent("downloadFile", config);
		}
	},

	addParamAgrupacion: function(store, operation, opts){
		
		var me = this;
		
		var idAgrupacion = Ext.ComponentQuery.query("crearpeticiontrabajowin")[0].idAgrupacion;
		store.getProxy().extraParams = {id: idAgrupacion};	
		return true;		
	},
	

	
	addParamProveedores: function(store, operation, opts) {
		var me = this;
		
		
	},

	onChangeProveedor: function(combo, value) {
		var me = this;
		me.getViewModel().set('proveedor', combo.getSelection());
	},
	
	onChangeProveedorGestionEconomica: function(combo, value){
		var me = this;		
		if (combo.store != null && combo.store.data != null && combo.store.data.items.length == 0) {
			me.fireEvent("errorToastLong", HreRem.i18n("msg.combo.sin.contacto.proveedor"));
		}
	},

	onChangeComboProveedorLlave: function(combo, newValue, oldValue) {
		var me = this;
		var comboReceptor = me.lookupReference('comboReceptorLlave');
		if(!Ext.isEmpty(comboReceptor)){
			if(newValue != null && newValue !== ''){
				comboReceptor.setAllowBlank(false);
				comboReceptor.enable();
				if(!Ext.isEmpty(comboReceptor.getStore())){					
					comboReceptor.getStore().getProxy().setExtraParams({
						idProveedor: newValue
					});
					comboReceptor.getStore().load(1);
					if(!Ext.isEmpty(comboReceptor.getValue()) && newValue != me.getViewModel().get("trabajo.idProveedorLlave"))
						comboReceptor.clearValue();
				}
			} else {
				comboReceptor.setAllowBlank(true);
				comboReceptor.disable();
				comboReceptor.clearValue();
				comboReceptor.getStore().removeAll();
			}
			comboReceptor.validate();
		}
	},

	onListadoTramitesTareasTrabajoDobleClick : function(gridView,record) {
		var me = this;
		
		if(Ext.isEmpty(record.get("fechaFin"))) { // Si la tarea está activa
			me.getView().fireEvent('abrirDetalleTramiteTarea',gridView,record);
		} else {
			me.getView().fireEvent('abrirDetalleTramiteHistoricoTarea',gridView,record);
		}
	},

	addParamsTrabajo: function(store, operation, opts){
		var me = this;
		//Acceder as� a los tres atributos que le hemos pasado a la openModalWindow
		//de selecci�n de tarifa: tipo de trabajo, subtipo de trabajo y cartera

		var idTrabajo = me.getViewModel().get("trabajo.id");
		//REMVIP-558 - Se añaden dos campos mas, descpripcion y codigo del trabajo
		var carteraCodigo = me.getViewModel().get("trabajo.carteraCodigo"),
		tipoTrabajoCodigo = me.getViewModel().get("trabajo.tipoTrabajoCodigo"),
		subtipoTrabajoCodigo = me.getViewModel().get("trabajo.subtipoTrabajoCodigo"),
		codigoTarifaTrabajo = me.getViewModel().get('trabajo.codigoTarifaTrabajo'),
		descripcionTarifaTrabajo = me.getViewModel().get('trabajo.descripcionTarifaTrabajo'),
		subcarteraCodigo = me.getViewModel().get('trabajo.subcarteraCodigo');
		
		store.getProxy().extraParams = {idTrabajo: idTrabajo, cartera: carteraCodigo, tipoTrabajo: tipoTrabajoCodigo, subtipoTrabajo: subtipoTrabajoCodigo
			, codigoTarifa: codigoTarifaTrabajo, descripcionTarifa: descripcionTarifaTrabajo, subcarteraCodigo: subcarteraCodigo};	
		
		return true;		

	},
	
	addParamIdTrabajo: function(store, operation, opts){
		var me = this;
		var idTrabajo = me.getViewModel().get("trabajo.id");
		store.getProxy().extraParams = {idTrabajo: idTrabajo};
		return true;
		
	},
	
    onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna) {
    	
    	var me = this;
    	var grid = tableView.up('grid');

    	var record = grid.store.getAt(indiceFila);

    	grid.setSelection(record);
    	
    	//grid.fireEvent("abriractivo", record);
    	me.getView().fireEvent('abrirDetalleActivo', record.get('idActivo'));

    	
    },
    
    onSeleccionTarifasListDobleClick: function(grid, record) {
    	var me = this,
    	windowSeleccionTarifas = grid.up('window'),
    	idTrabajo = windowSeleccionTarifas.idTrabajo,
    	newRecord = Ext.create('HreRem.model.TarifasTrabajo', {idConfigTarifa: record.getData().id, codigoTarifa: record.getData().codigoTarifa, precioUnitario: record.getData().precioUnitario, precioUnitarioCliente: record.getData().precioUnitarioCliente, unidadMedida: record.getData().unidadmedida, idTrabajo: idTrabajo});
		//Ahora hacer el save en el store para que se llame al controller java
    	newRecord.save({
    		success: function() {
    			me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
    		},
		 	failure: function(record, operation) {
		 		var response = Ext.decode(operation.getResponse().responseText);
		 		if(response.success === "false" && Ext.isDefined(response.error)) {
					me.fireEvent("errorToast", Ext.decode(operation.getResponse().responseText).error);
		 		}else{
		 			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		 		}
		    },
    		callback: function() {
    			windowSeleccionTarifas.parent.funcionRecargar();
    			windowSeleccionTarifas.hide();
    		}
    		
    	});
    },
    
    setBindStoreGrid: function(grid){
    	var me = this;
    	var storeIdActivo = Ext.create('Ext.data.Store',{
			pageSize: 12,
        	model: 'HreRem.model.ActivoTrabajoSubida',
			 proxy: {
			    type: 'uxproxy',
				remoteUrl: 'trabajo/getListActivosByID',
				extraParams: {idActivo: me.getView().idActivo, idAgrupacion: me.getView().idAgrupacion}
			 },
			 listeners:{
		          load:function(){
		        	  	me.relayEvents(this,['storeloadsuccess']);
		               this.fireEvent('storeloadsuccess');
		          }
		     }
           
		});
		grid.setBind({store: storeIdActivo});
		grid.setStore(storeIdActivo);
		grid.getStore().load();
    },
    
    onSelectedTarifaReturnGridVentana: function(grid,record){
    	var me = this;
    	ventanaCrearTarifa = grid.lookupViewModel().getView();
    	ventanaCrearTrabajo = ventanaCrearTarifa.up();
    	gridTarifas = ventanaCrearTrabajo.lookupReference('gridListaTarifas');
    	gridTarifas.getStore().add(record);
    	ventanaCrearTarifa.closeWindow();
    },
    
    onPresupuestosListDobleClick: function(grid, record) {
    	var me = this,
    	parent = grid.up("gestioneconomicatrabajo"),    	
    	idTrabajo = parent.getBindRecord().get('idTrabajo'),
    	tipoTrabajoDescripcion = parent.getBindRecord().get('tipoTrabajoDescripcion'),
    	subtipoTrabajoDescripcion = parent.getBindRecord().get('subtipoTrabajoDescripcion'),
    	//codigoTipoProveedor = parent.getBindRecord().get('codigoTipoProveedor'),
    	idProveedor = parent.getBindRecord().get('idProveedor'),
    	idProveedorContacto = parent.getBindRecord().get('idProveedorContacto');
    	emailProveedorContacto = parent.getBindRecord().get('emailProveedorContacto');
    	nombreProveedorContacto = parent.getBindRecord().get('nombreProveedorContacto');
    	usuarioProveedorContacto = parent.getBindRecord().get('usuarioProveedorContacto');

    	var window=Ext.create("HreRem.view.trabajos.detalle.ModificarPresupuesto", {idTrabajo: idTrabajo, tipoTrabajoDescripcion: tipoTrabajoDescripcion, subtipoTrabajoDescripcion: subtipoTrabajoDescripcion, /*codigoTipoProveedor: codigoTipoProveedor,*/ idProveedor: idProveedor, idProveedorContacto: idProveedorContacto, emailProveedorContacto: emailProveedorContacto, nombreProveedorContacto: nombreProveedorContacto, usuarioProveedorContacto: usuarioProveedorContacto, parent: parent, modoEdicion: true, presupuesto: record}).show();
    	window.getViewModel().set('trabajo',me.getViewModel().get('trabajo'));
    },
    
    onPresupuestosListClick: function(grid, record) {
    	var form = grid.up('form');
    	
    	if (grid.getSelectionModel().getCount() != 0)
    	{
    		//Cuando la selecci�n no es 0: Rellenar el form de presupuesto con los campos correspondientes
	    	model = Ext.create('HreRem.model.PresupuestoTrabajo'),
	    	idPresupuesto = record.get("id"),
	    	fieldset = grid.up('form').down('[reference=detallepresupuesto]');
			fieldset.mask(HreRem.i18n("msg.mask.loading"));

			model.setId(idPresupuesto);
			model.load({			
			    success: function(record) {	

			    	form.setBindRecord(record);
			    	fieldset.unmask();
			    }
			});
    	}
    	else
    	{
    		//Cuando la selecci�n es 0: Resetear el form (no hay nada seleccionado) 
    		form.getForm().reset();
    	}
    	//me.getViewModel().set('proveedor', record);
    },
    
    onClickBotonGuardarPresupuesto: function(btn) {
		var me =this,
		window = btn.up("window"),
		form = window.down("form"),
		idTrabajo = window.idTrabajo;
		form.getBindRecord().set("idTrabajo", idTrabajo);
		data = form.getBindRecord();
		
		var grid = window.parent.down("[reference=gridpresupuestostrabajo]");
		
		if ((data.data.importeCliente != null && data.data.importeCliente >= data.data.importe) ||
				(data.data.importeCliente == null && data.data.importe == null)){
			me.successAndSave(window, form);
		} else {
			Ext.Msg.show({
			    title: HreRem.i18n("msg.aviso.importe.cliente"),
			    message: HreRem.i18n("msg.confirmacion.importe.cliente"), 
			    buttons: Ext.Msg.OKCANCEL,
			    icon: Ext.Msg.INFO,
			    fn: function(btn) {
			        if (btn === 'ok') {
			        	me.successAndSave(window, form);
			        }
			    }
			});  
		
		}    	
    },
    
    successAndSave: function(window, form){
    	me = this;
    	
    	var success = function(record, operation) {
			me.getView().unmask();
	    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	window.parent.funcionRecargar();
	    	window.hide();	    	
		};
		
		me.onSaveFormularioCompleto(form, success);
    	
    },
    
    onClickBotonActualizarPresupuesto: function(btn) {
		var me = this,
		window = btn.up("window"),
		form = window.down("form"),
		combo = me.lookupReference('labelEmailContacto');
		data = form.getBindRecord();
		
		combo.validate();
		form.recordName = "presupuesto";
		form.recordClass = "HreRem.model.PresupuestosTrabajo";
		
		if ((data.data.importeCliente != null && data.data.importeCliente >= data.data.importe) ||
				(data.data.importeCliente == null && data.data.importe == null)){
			me.successAndSave(window, form);
		} else {
			Ext.Msg.show({
			    title: HreRem.i18n("msg.aviso.importe.cliente"),
			    message: HreRem.i18n("msg.confirmacion.importe.cliente"),
			    buttons: Ext.Msg.OKCANCEL,
			    icon: Ext.Msg.INFO,
			    fn: function(btn) {
			        if (btn === 'ok') {
						me.successAndSave(window, form);
			        }
			    }
			}); 
		}
    },
    
     onClickUploadListaActivos: function(btn) {
       	var me = this,
       	form = me.getView().lookupReference("formSubirListaActivos");
       	var params = form.getValues(false,false,false,true);
		var enTramite = false;
       	params.idTipoOperacion = "141";
       	if(form.isValid()){
			me.getView().lookupReference('listaActivosSubidaRef').mask(HreRem.i18n('msg.mask.loading'));
        	form.submit({
        		waitMsg: HreRem.i18n('msg.mask.loading'),
        		params: params,
    	   		success: function(fp, o){
					var window = btn.up('windowBase');
    	   			var data = Ext.JSON.decode(o.response.responseText).data;
					var storeActivos = new Ext.data.Store({
							pageSize: 10,
						  	model: 'HreRem.model.ActivoTrabajoSubida',
						    data: data
					  });
					window.idProceso = 1;
					window.lookupReference('listaActivosSubidaRef').unmask();
					window.lookupReference('listaActivosSubidaRef').setStore(storeActivos);    
    	   			//Si carga correctametne desde listado, ya no sera obligatorio insertar archivo
    	   			window.lookupReference('filefieldActivosRef').allowBlank=true;
					var comboTipoTrabajo = me.lookupReference('tipoTrabajo');					
										
					if(!Ext.isEmpty(storeActivos) && storeActivos.data.length != 0){
						comboTipoTrabajo.enable();
						comboTipoTrabajo.setReadOnly(false);						
						Ext.Array.each(storeActivos.getData().items, function(record){
							if(record.data.activoTramite){
								comboTipoTrabajo.getStore().getProxy().extraParams.idActivo=record.data.idActivo;
								enTramite = true;							
							}
						});
						comboTipoTrabajo.validate();
					}else{
						comboTipoTrabajo.enable();
						comboTipoTrabajo.setReadOnly(true);
						comboTipoTrabajo.validate();
					}	
					
					if (!Ext.isEmpty(me.getView().lookupReference("listaActivosSubidaRef")) && 
						!Ext.isEmpty(me.getView().lookupReference("listaActivosSubidaRef").getColumnManager().getHeaderByDataIndex("activoTramite")) && enTramite ){						
						me.getView().lookupReference("listaActivosSubidaRef").getColumnManager().getHeaderByDataIndex("activoTramite").setHidden(false);
					}			
					if(window.lookupReference('subtipoTrabajoCombo').getValue() != null){
						me.onChangeSubtipoTrabajoCombo(window.lookupReference('subtipoTrabajoCombo'));
					}
    		    }		
    	    });
       	}else{
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
     },
     
     onClickGenerarPropuesta: function(btn) {
     	
     	var me = this, params = {},
     	idTrabajo = me.getViewModel().get('trabajo').get('id'),
     	config = {};
		
		var messageBox = Ext.Msg.prompt(HreRem.i18n('title.generar.propuesta'),"<span class='txt-guardar-propuesta'>" + HreRem.i18n('txt.aviso.guardar.propuesta') + "</span>", function(btn, text){
		    if (btn == 'ok'){
		    	
		    	//LLamada para comprobar si se puede crear la propuesta
		    	var url = $AC.getRemoteUrl('trabajo/comprobarCreacionPropuesta');
			    Ext.Ajax.request({
				  url:url,
				  params:  {idTrabajo : idTrabajo},
				  			
				  success: function(response,opts){
					  //Si se puede crear la propuesta, la crea
					  boton = me.lookupReference("botonGenerarPropuesta");
					  if(Ext.JSON.decode(response.responseText).success == "true") {
					    	params.nombrePropuesta = text;
					    	params.idTrabajo = idTrabajo;
		    				
					        config.params = params;
							config.url= $AC.getRemoteUrl('trabajo/createPropuestaPreciosFromTrabajo');
							
							me.fireEvent("downloadFile", config);
							boton.setDisabled(true);
					  }
					  else {
						  me.fireEvent("errorToast", Ext.JSON.decode(response.responseText).mensaje); 
					  }
							
				  },
				  failure: function (a, operation, context) {
					  
					  me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
				  }
		    	});
		    }
    	});

		messageBox.textField.maskRe=/^[A-Za-z0-9\s_/]+$/;
		messageBox.textField.mon(messageBox.textField.el, 'keypress', messageBox.textField.filterKeys, messageBox.textField);
		
     },
     
     comprobarExistePropuestaTrabajo: function(){
     	var me = this, params = {},
       	idTrabajo = me.getViewModel().get('trabajo').get('id');
     	//LLamada para comprobar si se puede crear la propuesta
     	var url = $AC.getRemoteUrl('trabajo/comprobarCreacionPropuesta');
 	    Ext.Ajax.request({
 		  url:url,
 		  params:  {idTrabajo : idTrabajo},
 		  			
 		  success: function(response,opts){
 			  
 			  boton = me.lookupReference("botonGenerarPropuesta");
 			  //Si se puede crear la propuesta, activa el boton sino lo desactiva
 			  if(Ext.JSON.decode(response.responseText).success == "true") {
 				  boton.setDisabled(false);
 			  }
 			  else {
 				  boton.setDisabled(true);
 			  }		
 		  }
     	});
      },
      
	comprobarActivosEnOtrasPropuestas: function() {
      	var me = this, params = {},
       	idTrabajo = me.getViewModel().get('trabajo').get('id');
       	
       	var boton = me.lookupReference("botonGenerarPropuesta");
       	if(!boton.isDisabled() && (me.getViewModel().get('trabajo').get('subtipoTrabajoCodigo')==='44'
    			|| me.getViewModel().get('trabajo').get('subtipoTrabajoCodigo')==='45')) 
    	{
	     	//LLamada para comprobar si hay activos en otras propuestas en trámite
	     	var url = $AC.getRemoteUrl('trabajo/comprobarActivosEnOtrasPropuesta');
	     	var advertencia;
	 	    Ext.Ajax.request({
				url:url,
				params:  {idTrabajo : idTrabajo},
	 		  			
				success: function(response,opts){
		 			//Respuesta que indica si se creará la propuesta con algunos activos (ya que existen algunos en otras propuestas en trámite)
			    	advertencia = Ext.JSON.decode(response.responseText).advertencia;
			    	
			    	if(!Ext.isEmpty(advertencia) /*&& !boton.isDisabled()*/) {
			    		var msgAdvertencia = me.lookupReference("msgAdvertenciaActivosEnOtrasPropuestas");
			    		var texto = "<span style= 'color: red; float: left'>";
			    		if(advertencia=='01'){
			    			texto += HreRem.i18n('msg.advertencia.precios.generar.prp.existen.activos.in.prp.entramite');
			    			boton.setDisabled(false);
			    		}else {
			    			texto += HreRem.i18n('msg.advertencia.precios.no.gernerar.prp.todos.activos.in.prp.tramite');
			    			boton.setDisabled(true);
			    		}
			    		texto += "</span>";
			    		msgAdvertencia.setText(texto);
			    	}
		 		}
	     	});
       	}
	},
     
     onClickBotonDescargarPlantilla: function(btn) {
    	var me = this,
		config = {};
		
		config.url= $AC.getRemoteUrl("trabajo/downloadTemplateActivosTrabajo");
		
		me.fireEvent("downloadFile", config);
     },
     
     
     onChangeComboProveedorGE: function(combo) {
     	var me = this,
     	chainedCombo = me.lookupReference(combo.chainedReference);   
     	
     	me.getViewModel().notify();

     	if(!Ext.isEmpty(chainedCombo.getValue())) {
 			chainedCombo.clearValue();
     	}
 		chainedCombo.getStore().load({ 			
 			callback: function(records, operation, success) {
    				if(!Ext.isEmpty(records) && records.length > 0) {
    					if (chainedCombo.selectFirst == true) {
	 	   					chainedCombo.setSelection(1);
	 	   				};
    					chainedCombo.setDisabled(false);
    					chainedCombo.setAllowBlank(false); 
    				}
 			}
 		});
 		if (me.lookupReference(chainedCombo.chainedReference) != null) {
 			var chainedDos = me.lookupReference(chainedCombo.chainedReference);
 			if(chainedDos.getXType()=='comboboxfieldbase'){
	 			if(!chainedDos.isDisabled()) {
	 				chainedDos.clearValue();
	 				chainedDos.getStore().removeAll();
	 				chainedDos.setDisabled(true);
	 			}
 			}
 			do{
 				chainedDos.setValue('');
 				chainedDos = me.lookupReference(chainedDos.chainedReference);
 			}while(chainedDos != null);
 		}
 		

     },
     
     onClickBotonFiltrar: function(btn) {
    	 var me = this;
    	 
    	 var store = me.getViewModel().get('storeSeleccionTarifas');
    	 store.load();
    	 
     },

     onClickRefrescarParticipacion: function(btn) {
    	var me = this;
    	var grid = btn.up('trabajosdetalle').lookupReference('listadoActivosTrabajo');

    	grid.mask(HreRem.i18n("msg.mask.loading"))
    	idTrabajo = me.getViewModel().get('trabajo').get('id');

	 	Ext.Ajax.request({
			url: $AC.getRemoteUrl('trabajo/recalcularParticipacion'),
			params:  {idTrabajo : idTrabajo},
			success: function(response,opts){
				grid.unmask();
				btn.up('activostrabajo').funcionRecargar();
			},
			failure: function (a, operation, context) {
				grid.unmask();
		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    }
	    });
	 	    
 	},
 	
 	
 	
 	cargarStoreHistoricoDeCampos: function(grid){
 		
 		var me = this;
 		
 		var storeHistorificacionDeCampos = me.getViewModel().data.storeHistorificacionDeCampos;
		storeHistorificacionDeCampos.getProxy().setExtraParams(
			{'idTrabajo':grid.idTrabajo,'codPestanya':grid.codigoPestanya});
		
 	},
 	
 	onVentanaTarifasChainedCombos: function(combo){
 		var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);    	
    	me.getViewModel().notify();
		chainedCombo.clearValue("");
		chainedCombo.getStore().load({ 			
			callback: function(records, operation, success) {
   				if(records.length > 0) {
   					chainedCombo.setDisabled(false);
   				} else {
   					chainedCombo.setDisabled(true);
   				}
			}
		});
 	},
 	
 	onCheckChangeMultiActivo: function(columna,newValue,oldValue,record){
 		var me = this;
 		if(newValue){
 			me.lookupReference('fieldSetSubirFichero').setHidden(false);
 			me.lookupReference('listaActivosSubidaRef').setHidden(false);
 			me.lookupReference('activosagrupaciontrabajo').setHidden(true);
 		}else{
 			me.lookupReference('fieldSetSubirFichero').setHidden(true);
 			me.lookupReference('listaActivosSubidaRef').setHidden(true);
 			me.lookupReference('activosagrupaciontrabajo').setHidden(false);
 		}
 	},
 	
 	onCheckChangeAplicaComite: function(columna,rowIndex,checked,record){
 		var me = this;
 		if(!checked){
 			me.lookupReference('comboResolucionComite').setDisabled(false);
 			me.lookupReference('comboResolucionComite').setAllowBlank(false);
 			me.lookupReference('comboResolucionComite').validate();
 	 		me.lookupReference('fechaResolComite').setDisabled(false);
 	 		me.lookupReference('resolComiteId').setDisabled(false);
 		}else{
 			me.lookupReference('comboResolucionComite').setDisabled(true);
 			me.lookupReference('comboResolucionComite').setAllowBlank(true);
 			me.lookupReference('comboResolucionComite').validate();
 	 		me.lookupReference('fechaResolComite').setDisabled(true);
 	 		me.lookupReference('resolComiteId').setDisabled(true);
 	 		me.lookupReference('resolComiteId').setValue(null);
 	 		me.lookupReference('fechaResolComite').setValue(null);
 	 		me.lookupReference('comboResolucionComite').setValue(null);
 		}
 	},
 	
 	requiredDateResolucionComite: function(){
 		var me = this;
		var comboResolucion = me.lookupReference('comboResolucionComite').getValue();
		if(comboResolucion != null && comboResolucion != '' ){
			if (comboResolucion == CONST.APROBACION_COMITE['SOLICITADO']){
				me.lookupReference('fechaResolComite').setAllowBlank(true);
			}
			else{
				me.lookupReference('fechaResolComite').setAllowBlank(false);
			}
		}
		else {
			me.lookupReference('fechaResolComite').setAllowBlank(true);
		}

		me.lookupReference('fechaResolComite').validate();
 	},
 	
 	onClickBotonCancelarVentanaAgendaTrabajo: function(btn) {		
    	btn.up('window').hide();
    },
    
    onClickBotonAnyadirAgendaTrabajo: function(btn){
    			
    			var me = this;
    			me.getView().mask(HreRem.i18n("msg.mask.loading"));
    			var correcto = true;
    			var form = btn.up().up().down("form");
    			url = $AC.getRemoteUrl("trabajo/createAgendaTrabajo");
    	 		var idTrabajo= btn.up('anyadiragendatrabajo').idTrabajo;	
    	 		var comboTipoGestion = me.lookupReference('comboTipoGestionRef');
    	 		var observaciones = me.lookupReference('observacionesRef');
    	 		
    	 		if(correcto) { 
    	 			if(form.isValid()){
    	 			form.submit({
    	 				url: url,
    					params : {idTrabajo: idTrabajo,
    								tipoGestion: comboTipoGestion.getValue(),
    								observacionesAgenda:observaciones.getValue()
    								},
    					success: function(fp, o) {
    						me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
    						me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['TRABAJO'], idTrabajo);
    						me.getView().unmask();				
    						me.onClickBotonCancelarVentanaAgendaTrabajo(btn);
    					},
    					failure: function(record, operation) {
    						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    						me.unmask();
    					}
    	 			});
    		 		}else{
    		 			me.getView().unmask();
    		 		}
    	 		} else {
    	 			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.no.valida"));
    				me.getView().unmask();
    	 		}
    	 		
    			
    			
    	},
 	loadGridSegundo: function(grid){
 		var me = this;
 		var idActivo = me.getView().idActivo;
 		var idAgrupacion = me.getView().idAgrupacion;
 		if(idActivo != null){
 			grid.getProxy().setExtraParams({'idActivo':idActivo});
 		}else{
 			if(idAgrupacion != null){
 				grid.getProxy().setExtraParams({'idAgrupacion':idAgrupacion});
 			}
 		}
 		
//		grid.load();
 	},
 	
 	onCheckChangeIncluirActivo: function(columna,rowIndex,checked,record){
 		var idAct;
 		idAct = me.getView().datos;
 		gridStore = me.getView().lookupReference('activosagrupaciontrabajo').getStore().getData();
 		for(var i = 0; i< idAct.length;i++){
 			if(gridStore.items[rowIndex].data.idActivo == idAct[i]){
 				if(!checked){
 					idAct.splice(i,1);
 					return;
 				}
 			}
 		}
 		if(checked){
 			idAct.push(gridStore.items[rowIndex].data.idActivo);
 		}		
 	},
 	
 	onExportListActivosTrabajo: function(btn){
    	var me = this;
    	
    	var idTrabajo = me.getViewModel().get("trabajo.id");
		var url =  $AC.getRemoteUrl('trabajo/generateExcelActivosTrabajo');
		
		var config = {};

		var initialData = {idTrabajo: idTrabajo};
		var params = Ext.apply(initialData);

		Ext.Object.each(params, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete params[key];
			}
		});

		config.params = params;
		config.url= url;
		
		me.fireEvent("downloadFile", config);		
    },
    filterStoreEstadoTrabajo: function ( store ) {
    	var me = this;
    	var estadoActual = me.getViewModel().get("trabajo.estadoCodigo");
    	var data;
    	Ext.Ajax.request({
    		url: $AC.getRemoteUrl('trabajo/getTransicionesEstadoTrabajo'),
    		params: {estadoActual : estadoActual},
    		async: false,
    		method: 'GET',
    		success: function ( response , opts ) {
    			data = Ext.decode(response.responseText);
    			store.filter([{
                    filterFn: function(rec){
                    	return data.data.includes(rec.getData().codigo) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']);
                    }
                }]);
    		},
    		failure: function () {
    			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    		}
    	});
    	
    },
    desbloqueaCamposSegunEstadoTrabajo: function (pestanya) {
    	var me = this;
    	var estadoTrabajo = me.getViewModel().get("trabajo.estadoCodigo");
    	var esGestorActivo = $AU.userIsRol(CONST.PERFILES['GESTOR_ACTIVOS']);
    	var esProvActivo = $AU.userIsRol(CONST.PERFILES['PROVEEDOR']);
    	var esFichaTrabajo = pestanya.getReference() == "fichatrabajo";
    	
    	me.bloqueaCamposTrabajo(esFichaTrabajo)
    	
    	if($AU.userIsRol(CONST.PERFILES['HAYASUPER'])){
    	
    		me.desbloqueaCamposTrabajo(esFichaTrabajo);
    		
    	}
    	
    	else if(esGestorActivo){
    		
    		if(esFichaTrabajo){
    			me.lookupReference('comboGestorActivoResposable').setReadOnly(false);	
    			me.lookupReference('descripcionGeneralRef').setReadOnly(false);
    			me.lookupReference('riesgosTercerosRef').setReadOnly(false);
    			me.lookupReference('checkboxUrgente').setReadOnly(false);	
    		}
    		
    		if(estadoTrabajo == "CUR" /*|| estadoTrabajo == "REJ"*/){
    			
    			if(esFichaTrabajo){
    				me.lookupReference('comboEstadoTrabajoRef').setReadOnly(false);
    				me.lookupReference('fechaEjecucionRef').setReadOnly(false);
		    		me.lookupReference('checkTarifaPlanaRef').setReadOnly(false);
		    		me.lookupReference('checkSiniestroRef').setReadOnly(false);
		    		me.lookupReference('checkboxCubreSeguroRef').setReadOnly(false);
					me.lookupReference('comboCiaAseguradora').setReadOnly(false);
					me.lookupReference('importePrecioAseguradoRef').setReadOnly(false);
		    		me.lookupReference('comboResolucionComite').setReadOnly(false);
					me.lookupReference('fechaResolucionComiteRef').setReadOnly(false);
					me.lookupReference('resolucionComiteIdRef').setReadOnly(false);
	    			me.lookupReference('comboProveedorLlave').setReadOnly(false);	
	    			me.lookupReference('fechaEntregaTrabajoRef').setReadOnly(false);
	    			me.lookupReference('comboReceptorLlave').setReadOnly(false);
	    			me.lookupReference('llavesNoAplicaRef').setReadOnly(false);
	    			me.lookupReference('llavesMotivoRef').setReadOnly(false);	    			
		    		me.lookupReference('aplicaComiteRef').setReadOnly(false);
		    		me.lookupReference('comboResolucionComite').setReadOnly(false);
					me.lookupReference('fechaResolucionComiteRef').setReadOnly(false);
					me.lookupReference('resolucionComiteIdRef').setReadOnly(false);
					me.lookupReference('tomaDePosesion').setReadOnly(false);
					me.lookupReference('subtipoTrabajoComboFicha').setReadOnly(false);
					me.lookupReference('tipoTrabajoFicha').setReadOnly(false);
					me.lookupReference('comboIdentificadorReamRef').setReadOnly(false);
					me.lookupReference('fechaConcreta').setReadOnly(false);
		    		me.lookupReference('horaConcreta').setReadOnly(false);
		    		me.lookupReference('fechaTope').setReadOnly(false);
	    			
    			} else {
    				me.lookupReference('comboProveedorGestionEconomica').setReadOnly(false);
    				me.lookupReference('proveedorContactoCombo').setReadOnly(false);
		    		me.lookupReference('gridtarifastrabajo').setTopBar(true)
		    		me.lookupReference('gridpresupuestostrabajo').setTopBar(true)
				    me.lookupReference('gridtarifastrabajo').setDisabled(false);
				    me.lookupReference('gridSuplidos').setTopBar(true);
				    me.lookupReference('gridSuplidos').setDisabled(false);
				    me.lookupReference('gridpresupuestostrabajo').setDisabled(false);
    			}
    			
	    	}else if(estadoTrabajo == "FIN" || estadoTrabajo == "SUB"){
	    		
	    		if(esFichaTrabajo){
	    			me.lookupReference('comboEstadoTrabajoRef').setReadOnly(false);	
		    		me.lookupReference('checkTarifaPlanaRef').setReadOnly(false);
		    		me.lookupReference('checkSiniestroRef').setReadOnly(false);
		    		me.lookupReference('subtipoTrabajoComboFicha').setReadOnly(false);
					me.lookupReference('tipoTrabajoFicha').setReadOnly(false);
					me.lookupReference('comboIdentificadorReamRef').setReadOnly(false);
					me.lookupReference('aplicaComiteRef').setReadOnly(false);
					me.lookupReference('comboResolucionComite').setReadOnly(false);
					me.lookupReference('comboProveedorLlave').setReadOnly(false);	
	    			me.lookupReference('fechaEntregaTrabajoRef').setReadOnly(false);
	    			me.lookupReference('comboReceptorLlave').setReadOnly(false);
	    			me.lookupReference('llavesNoAplicaRef').setReadOnly(false);
	    			me.lookupReference('llavesMotivoRef').setReadOnly(false);
    			} else {
		    		me.lookupReference('gridtarifastrabajo').setTopBar(true)
		    		me.lookupReference('gridpresupuestostrabajo').setTopBar(true)
				    me.lookupReference('gridtarifastrabajo').setDisabled(false);
				    me.lookupReference('gridSuplidos').setTopBar(true);
				    me.lookupReference('gridSuplidos').setDisabled(false);
				    me.lookupReference('gridpresupuestostrabajo').setDisabled(false);
    			}
	    		
	    	}else if(estadoTrabajo == "REJ"){
	    		
	    		if(esFichaTrabajo){
    				me.lookupReference('comboEstadoTrabajoRef').setReadOnly(false);
    				me.lookupReference('fechaConcreta').setReadOnly(false);
		    		me.lookupReference('horaConcreta').setReadOnly(false);
		    		me.lookupReference('fechaTope').setReadOnly(false);
    				me.lookupReference('subtipoTrabajoComboFicha').setReadOnly(false);
    				me.lookupReference('tipoTrabajoFicha').setReadOnly(false);
    				me.lookupReference('comboIdentificadorReamRef').setReadOnly(false);
    				me.lookupReference('comboProveedorLlave').setReadOnly(false);	
	    			me.lookupReference('fechaEntregaTrabajoRef').setReadOnly(false);
	    			me.lookupReference('comboReceptorLlave').setReadOnly(false);
	    			me.lookupReference('llavesNoAplicaRef').setReadOnly(false);
					me.lookupReference('llavesMotivoRef').setReadOnly(false);
					me.lookupReference('fechaConcreta').setReadOnly(false);
		    		me.lookupReference('horaConcreta').setReadOnly(false);
		    		me.lookupReference('fechaTope').setReadOnly(false);

    			}else{
    				me.lookupReference('gridSuplidos').setTopBar(true);
				    me.lookupReference('gridSuplidos').setDisabled(false);
    			}
	    		
	    	} else if (estadoTrabajo == "13"){
	    		
	    		if(esFichaTrabajo){
    				me.lookupReference('comboEstadoTrabajoRef').setReadOnly(false);
    				if(!me.getViewModel().get("trabajo.numAlbaran")){
    					me.lookupReference('subtipoTrabajoComboFicha').setReadOnly(false);
    					me.lookupReference('tipoTrabajoFicha').setReadOnly(false);
    					me.lookupReference('comboIdentificadorReamRef').setReadOnly(false);
    				}
    			} else {
					me.lookupReference('gridpresupuestostrabajo').setTopBar(true);
					me.lookupReference('gridSuplidos').setTopBar(true);
					me.lookupReference('gridSuplidos').setDisabled(false);
		    		me.lookupReference('gridpresupuestostrabajo').setDisabled(false);
				}
	    		
	    	}
    		
	    } else if(esProvActivo){
	    	
	    	if(estadoTrabajo == "CUR"){
	    		
	    		if(esFichaTrabajo){
    				me.lookupReference('comboEstadoTrabajoRef').setReadOnly(false);
		    		me.lookupReference('fechaEjecucionRef').setReadOnly(false);
		    		me.lookupReference('checkSiniestroRef').setReadOnly(false);
		    		me.lookupReference('comboProveedorLlave').setReadOnly(false);	
	    			me.lookupReference('fechaEntregaTrabajoRef').setReadOnly(false);
	    			me.lookupReference('comboReceptorLlave').setReadOnly(false);
	    			me.lookupReference('llavesNoAplicaRef').setReadOnly(false);
					me.lookupReference('llavesMotivoRef').setReadOnly(false);
    			} else {
    				me.lookupReference('gridtarifastrabajo').setTopBar(true)
    	    		me.lookupReference('gridpresupuestostrabajo').setTopBar(true)
    			    me.lookupReference('gridtarifastrabajo').setDisabled(false);
    			    me.lookupReference('gridpresupuestostrabajo').setDisabled(false);    
    			    me.lookupReference('gridSuplidos').setTopBar(true);
				    me.lookupReference('gridSuplidos').setDisabled(false);
    			
    			}
	    		
	    	} else if (estadoTrabajo == "REJ"){
	    		if(esFichaTrabajo){
    				me.lookupReference('comboEstadoTrabajoRef').setReadOnly(false);
		    		me.lookupReference('fechaEjecucionRef').setReadOnly(false);
		    		me.lookupReference('checkSiniestroRef').setReadOnly(false);
		    		me.lookupReference('comboProveedorLlave').setReadOnly(false);	
	    			me.lookupReference('fechaEntregaTrabajoRef').setReadOnly(false);
	    			me.lookupReference('comboReceptorLlave').setReadOnly(false);
	    			me.lookupReference('llavesNoAplicaRef').setReadOnly(false);
					me.lookupReference('llavesMotivoRef').setReadOnly(false);
    			} else {
    				me.lookupReference('gridtarifastrabajo').setTopBar(true)
    	    		me.lookupReference('gridpresupuestostrabajo').setTopBar(true)
    			    me.lookupReference('gridtarifastrabajo').setDisabled(false);
    			    me.lookupReference('gridpresupuestostrabajo').setDisabled(false);   
    			    me.lookupReference('gridSuplidos').setTopBar(true);
				    me.lookupReference('gridSuplidos').setDisabled(false);
    			}
	    	}
	    	
	    }
    	
    },
    bloqueaCamposTrabajo: function (esFichaTrabajo) {
    	var me = this;
    	
		if(esFichaTrabajo){
			me.lookupReference('comboGestorActivoResposable').setReadOnly(true);
    		me.lookupReference('comboEstadoTrabajoRef').setReadOnly(true);
    		me.lookupReference('fechaEjecucionRef').setReadOnly(true);
			me.lookupReference('checkTarifaPlanaRef').setReadOnly(true);
			me.lookupReference('checkSiniestroRef').setReadOnly(true);
    		me.lookupReference('checkboxCubreSeguroRef').setReadOnly(true);
			me.lookupReference('comboCiaAseguradora').setReadOnly(true);
			me.lookupReference('importePrecioAseguradoRef').setReadOnly(true);
			me.lookupReference('aplicaComiteRef').setReadOnly(true);
    		me.lookupReference('comboResolucionComite').setReadOnly(true);
			me.lookupReference('fechaResolucionComiteRef').setReadOnly(true);
			me.lookupReference('resolucionComiteIdRef').setReadOnly(true);
			me.lookupReference('riesgosTercerosRef').setReadOnly(true);
			me.lookupReference('checkboxUrgente').setReadOnly(true);	
			me.lookupReference('estadoGastoRef').setReadOnly(true);	
			me.lookupReference('descripcionGeneralRef').setReadOnly(true);
			me.lookupReference('fechaConcreta').setReadOnly(true);
			me.lookupReference('horaConcreta').setReadOnly(true);
			me.lookupReference('fechaTope').setReadOnly(true);
			me.lookupReference('comboProveedorLlave').setReadOnly(true);	
			me.lookupReference('fechaEntregaTrabajoRef').setReadOnly(true);
			me.lookupReference('comboReceptorLlave').setReadOnly(true);
			me.lookupReference('llavesNoAplicaRef').setReadOnly(true);
			me.lookupReference('llavesMotivoRef').setReadOnly(true);
			me.lookupReference('tomaDePosesion').setReadOnly(true);
			me.lookupReference('subtipoTrabajoComboFicha').setReadOnly(true);
			me.lookupReference('tipoTrabajoFicha').setReadOnly(true);
			me.lookupReference('comboIdentificadorReamRef').setReadOnly(true);
    	} else {
    		me.lookupReference('comboProveedorGestionEconomica').setReadOnly(true);
    		me.lookupReference('proveedorContactoCombo').setReadOnly(true);
		    me.lookupReference('gridpresupuestostrabajo').setTopBar(false);
		    me.lookupReference('gridSuplidos').setTopBar(false);
			me.lookupReference('gridSuplidos').setDisabled(true);
		    me.lookupReference('gridpresupuestostrabajo').setDisabled(true);
    	}
	},
    desbloqueaCamposTrabajo: function (esFichaTrabajo){
    	var me = this;
    	
    	if(esFichaTrabajo){
    		me.lookupReference('comboGestorActivoResposable').setReadOnly(false);
    		me.lookupReference('comboEstadoTrabajoRef').setReadOnly(false);
    		me.lookupReference('fechaEjecucionRef').setReadOnly(false);
			me.lookupReference('checkTarifaPlanaRef').setReadOnly(false);
			me.lookupReference('checkSiniestroRef').setReadOnly(false);
    		me.lookupReference('checkboxCubreSeguroRef').setReadOnly(false);
			me.lookupReference('comboCiaAseguradora').setReadOnly(false);
			me.lookupReference('importePrecioAseguradoRef').setReadOnly(false);
			me.lookupReference('aplicaComiteRef').setReadOnly(false);
    		me.lookupReference('comboResolucionComite').setReadOnly(false);
			me.lookupReference('fechaResolucionComiteRef').setReadOnly(false);
			me.lookupReference('resolucionComiteIdRef').setReadOnly(false);
			me.lookupReference('riesgosTercerosRef').setReadOnly(false);
			me.lookupReference('checkboxUrgente').setReadOnly(false);	
			me.lookupReference('estadoGastoRef').setReadOnly(false);	
			me.lookupReference('descripcionGeneralRef').setReadOnly(false);
			me.lookupReference('fechaConcreta').setReadOnly(false);
			me.lookupReference('horaConcreta').setReadOnly(false);
			me.lookupReference('fechaTope').setReadOnly(false);
			me.lookupReference('comboProveedorLlave').setReadOnly(false);	
			me.lookupReference('fechaEntregaTrabajoRef').setReadOnly(false);
			me.lookupReference('comboReceptorLlave').setReadOnly(false);
			me.lookupReference('llavesNoAplicaRef').setReadOnly(false);
			me.lookupReference('llavesMotivoRef').setReadOnly(false);
			me.lookupReference('tomaDePosesion').setReadOnly(false);
			me.lookupReference('subtipoTrabajoComboFicha').setReadOnly(false);
			me.lookupReference('tipoTrabajoFicha').setReadOnly(false);
			me.lookupReference('comboIdentificadorReamRef').setReadOnly(false);
    	} else {
    		me.lookupReference('comboProveedorGestionEconomica').setReadOnly(false);
    		me.lookupReference('proveedorContactoCombo').setReadOnly(false);
			me.lookupReference('gridtarifastrabajo').setTopBar(true)
		    me.lookupReference('gridpresupuestostrabajo').setTopBar(true)
		    me.lookupReference('gridtarifastrabajo').setDisabled(false);
		    me.lookupReference('gridSuplidos').setTopBar(true);
			me.lookupReference('gridSuplidos').setDisabled(false);
		    me.lookupReference('gridpresupuestostrabajo').setDisabled(false);
    	}
    },
 	valorComboSubtipo: function (){
 		var me = this;
 		var tipoTrabajo = me.lookupReference('tipoTrabajo').getValue();
 		var subTipoTrabajo = me.lookupReference('subtipoTrabajoCombo').getValue();
 		var comboTomaPosesion = me.lookupReference('tomaDePosesion');
		me.lookupReference('comboProveedorGestionEconomica2').setDisabled(true);
		me.lookupReference('proveedorContactoCombo2').setDisabled(true);
		
 		 
 	},
 	hiddenComboTomaPosesion: function(){
 		var me = this;
 		
 		var tipoTrabajoCodigo = me.getViewModel().get('trabajo').data.tipoTrabajoCodigo;
 		var subtipoTrabajoCodigo = me.getViewModel().get('trabajo').data.subtipoTrabajoCodigo;
 		var comboTomaPosesion = me.lookupReference('tomaDePosesion');
 		if (tipoTrabajoCodigo == CONST.TIPOS_TRABAJO['ACTUACION_TECNICA'] && subtipoTrabajoCodigo == CONST.SUBTIPOS_TRABAJO['TOMA_POSESION']) {
 		
 			comboTomaPosesion.allowBlank= false;
 			comboTomaPosesion.setHidden(false);
 			comboTomaPosesion.setVisible(true);
 		}else{
 		
 			comboTomaPosesion.allowBlank= true;
 			comboTomaPosesion.setHidden(true);
 		}
 		
 	},
    
    onBeforeLoadProveedor: function(combo){
    	var me = this;
    	var idact;
    	if(me.getView().idActivo != null){
    		idact = me.getView().idActivo;
    	}else{
    		if(me.getView().idAgrupacion != null){
    			idact = me.lookupReference('activosagrupaciontrabajo').getStore().getData().items[0].data.idActivo;
    		}else{
    			if(me.lookupReference('listaActivosSubidaRef').getStore().getData() != null && 
    					me.lookupReference('listaActivosSubidaRef').getStore().getData().length > 0){
    				idact = me.lookupReference('listaActivosSubidaRef').getStore().getData().items[0].data.idActivo;
    			}
    			
    		}
    	}
    	combo.getProxy().setExtraParams({'idActivo' : idact});
    },
    
    onAfterLoadProveedor: function(){
    	var me = this;
    	if(me.getView().idActivo != null){
    		idact = me.getView().idActivo;
    	}else{
    		if(me.getView().idAgrupacion != null){
    			idact = me.lookupReference('activosagrupaciontrabajo').getStore().getData().items[0].data.idActivo;
    		}else{
    			if(me.lookupReference('listaActivosSubidaRef').getStore().getData() != null && 
    					me.lookupReference('listaActivosSubidaRef').getStore().getData().length > 0){
    				idact = me.lookupReference('listaActivosSubidaRef').getStore().getData().items[0].data.idActivo;
    			}
    			
    		}
    	}
    	var tipoTrabajo = me.lookupReference('tipoTrabajo').getValue();
    	var subtipoTrabajo = me.lookupReference('subtipoTrabajoCombo').getValue();
		var comboProveedor = me.lookupReference('comboProveedorGestionEconomica2');
    	var cartera = me.getView().codCartera;
    	var codSubcartera = me.getView().codSubcartera;
    	var store = new Ext.data.Store({
					model: 'HreRem.model.ComboBase',
					proxy: {
						type: 'uxproxy',
						remoteUrl: 'trabajo/getComboProveedorFilteredCreaTrabajo',
						extraParams: {cartera: cartera},
						timeout: 200000
					},
					listeners: {
						load: function(){
							comboProveedor.setAllowBlank(false);
							if(comboProveedor.getValue() == null){
								comboProveedor.onTriggerClick();
							}
						}
					}
				});
		me.getView().mask("Cargando Proveedor");
    	Ext.Ajax.request({
    		url: $AC.getRemoteUrl('trabajo/getProveedorParametrizado'),
    		params: {	
    					idActivo : idact,
		    			tipoTrabajo: tipoTrabajo,
		    			subtipoTrabajo : subtipoTrabajo,
		    			cartera : cartera,
		    			subCartera: codSubcartera
    				},
    		method: 'GET',
    		success: function ( response , opts ) {
				me.getView().unmask();
    			data = Ext.decode(response.responseText);
				comboProveedor.enable();
				comboProveedor.setAllowBlank(false);
				comboProveedor.setStore(store);
				store.load();
    			if(data != null && data.data != null && data.data.id != null){
    				var idProveedor = data.data.id;
					var nombreProveedor = data.data.nombre;
					var nombreComercial = data.data.nombreComercial;
					var codigoProveedor = data.data.codigo;
					var estadoProveedor = data.data.estadoProveedorDescripcion;
					var tipoProveedor = data.data.descripcionTipoProveedor;
					var record = new Ext.data.Model({
						idProveedor: idProveedor, 
						nombre: nombreProveedor, 
						nombreComercial: nombreComercial,
						codigo: codigoProveedor, 
						estadoProveedorDescripcion: estadoProveedor,
						descripcionTipoProveedor: tipoProveedor
					});
    				comboProveedor.setValue(record);
					me.onChangeProveedorCombo(comboProveedor, idProveedor);
					comboProveedor.valueNotFoundRecord = record;
    			}else{
					comboProveedor.onTriggerClick();
				}
    		},
    		failure: function () {
				me.getView().unmask();
				comboProveedor.enable();
				comboProveedor.setStore(store);
				comboProveedor.onTriggerClick();
    		}
    	});
    },
    
    loadComboProveedorContacto: function(idProveedor) {
    	var me = this;
    	if (idProveedor != null) {
			if(idProveedor.data != null && idProveedor.data.idProveedor != null){
				idProveedor = idProveedor.data.idProveedor;
			}
			me.lookupReference('proveedorContactoCombo2').setDisabled(false);
			me.lookupReference('proveedorContactoCombo2').setStore(new Ext.data.Store({
				model: 'HreRem.model.ComboBase',
				proxy: {
					type: 'uxproxy',
					remoteUrl: 'trabajo/getComboProveedorContactoCreaTrabajo',
					extraParams: {idProveedor: idProveedor}
				}
				,remoteFilter: false
			}));
			me.lookupReference('proveedorContactoCombo2').getStore().load();
    	}
    },
    
    onChangeProveedorCombo: function(comboProveedor, value) {
    	var me = this;
    	if (value != null) {
        	me.loadComboProveedorContacto(value);
    	}
		comboProveedor.getStore().clearFilter();
    },

    finalizacionTrabajoProveedor: function(combo, newValue, oldValue) {
    	var me = this;

		var fechaComite = me.lookupReference('fechaResolucionComiteRef');
		var idComite = me.lookupReference('resolucionComiteIdRef');
		
		if(!Ext.isEmpty(fechaComite) && !Ext.isEmpty(idComite)){
			if(!fechaComite.isDisabled() && newValue === "FIN"){
				fechaComite.setAllowBlank(false);
				if(Ext.isEmpty(fechaComite.getValue()))
					fechaComite.markInvalid("Obligatorio para marcar como \"Finalizado\" el estado del trabajo");
			} else {
				fechaComite.setAllowBlank(true);
				fechaComite.clearInvalid();
			}
			if(!idComite.isDisabled() && newValue === "FIN"){ 
				idComite.setAllowBlank(false);
				if(Ext.isEmpty(idComite.getValue()))
					idComite.markInvalid("Obligatorio para marcar como \"Finalizado\" el estado del trabajo");
			} else {
				idComite.setAllowBlank(true);
				idComite.clearInvalid();
			}
		}
		
    	var esProveedor = $AU.userIsRol(CONST.PERFILES['PROVEEDOR']);
    	if (esProveedor && newValue === "FIN") {
    		me.getView().mask(HreRem.i18n("msg.mask.loading"));
	    	var idTrabajo = combo.lookupViewModel().get("trabajo.id");
	    	var urlDocumentoFinalizacionTrabajo = $AC.getRemoteUrl('trabajo/getDocumentosFinalizacionTrabajo');
	    	Ext.Ajax.request({
				  url:     urlDocumentoFinalizacionTrabajo,
				  async:   false,
				  method:  'GET',
				  params:  {idTrabajo: idTrabajo},
				  success: function(response, opts) {
					  var decode = Ext.JSON.decode(response.responseText);
					  var success = decode["success"];
					  if(success === "false") {
						  var data = decode["data"];
						  var size = decode["size"];
						  if(size === '1') {
							  me.fireEvent("errorToast", data);
						  } else {
							  me.fireEvent("errorToastLong", data);
						  }
						  combo.setValue(oldValue);
					  }
					  me.getView().unmask();
				  },
				  failure: function () {
					  me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					  me.getView().unmask();
				  }
	      	});
    	}
    },
    
    checkDisableCampoTomaPosesion: function(){
    	var isSuper = $AU.userIsRol(CONST.PERFILES['HAYASUPER']);
        var isGestorActivos = $AU.userIsRol(CONST.PERFILES['GESTOR_ACTIVOS']);
 	   	var isGestorAlquiler = $AU.userGroupHasRole(CONST.PERFILES['GESTOR_ALQUILER_HPM']);
 	   	var isUserGestedi = $AU.userIsRol(CONST.PERFILES['GESTEDI']);
 	   	
 	   	return !isSuper && !isGestorActivos && !isGestorAlquiler && isUserGestedi; 
    },
    
    calcularObligatoriedadCamposLlaves: function(){
    	var me = this;
    	if(me.getViewModel().get("trabajo.visualizarLlaves") && me.getViewModel().get("trabajo.llavesObligatoriasEstadoTrabajo")){
    		if(me.lookupReference('llavesNoAplicaRef').getValue()){
    			me.lookupReference('comboProveedorLlave').setAllowBlank(true);
	    		me.lookupReference('fechaEntregaTrabajoRef').setAllowBlank(true);
	    		me.lookupReference('comboReceptorLlave').setAllowBlank(true);
	    		me.lookupReference('llavesMotivoRef').setAllowBlank(false);
    		}else{
	    		me.lookupReference('comboProveedorLlave').setAllowBlank(false);
        		me.lookupReference('fechaEntregaTrabajoRef').setAllowBlank(false);
        		me.lookupReference('comboReceptorLlave').setAllowBlank(false);
        		me.lookupReference('llavesMotivoRef').setAllowBlank(true);
    		}
    	}else{
    		me.lookupReference('comboProveedorLlave').setAllowBlank(true);
    		me.lookupReference('fechaEntregaTrabajoRef').setAllowBlank(true);
    		me.lookupReference('comboReceptorLlave').setAllowBlank(true);
    		me.lookupReference('llavesMotivoRef').setAllowBlank(true);
    	}
    	
    },
    bloquearCombosFechaConcretayHoraPorSubtipoTomaPosesionYPaquetes:function(){
    	var me = this;
    	var subtipoTrabajoCodigo = me.lookupReference('subtipoTrabajoComboFicha').getValue();  	
 		
    	if (subtipoTrabajoCodigo == CONST.SUBTIPOS_TRABAJO['TOMA_POSESION'] || 
    			subtipoTrabajoCodigo == CONST.SUBTIPOS_TRABAJO['PAQUETES']) {
    		me.lookupReference('fechaConcreta').setAllowBlank(false);
    		me.lookupReference('horaConcreta').setAllowBlank(false);
    		
  		  }else{
    		me.lookupReference('fechaConcreta').setAllowBlank(true);
    		me.lookupReference('horaConcreta').setAllowBlank(true);
    	}
    },

	onChangeCheckAplicaComite: function(field, newValue, oldValue){
		var me = this;
		var fechaComite = me.lookupReference('fechaResolucionComiteRef');
		var idComite = me.lookupReference('resolucionComiteIdRef');
		var comboEstadoTrabajo = me.lookupReference('comboEstadoTrabajoRef');
		if(!Ext.isEmpty(comboEstadoTrabajo) && !Ext.isEmpty(comboEstadoTrabajo.getValue()) && comboEstadoTrabajo.getValue() === "FIN"){
			if(!Ext.isEmpty(fechaComite) && !Ext.isEmpty(idComite)){
				if(newValue){
					fechaComite.setAllowBlank(false);
					if(Ext.isEmpty(fechaComite.getValue()))
						fechaComite.markInvalid("Obligatorio para marcar como \"Finalizado\" el estado del trabajo");
					idComite.setAllowBlank(false);
					if(Ext.isEmpty(idComite.getValue()))
						idComite.markInvalid("Obligatorio para marcar como \"Finalizado\" el estado del trabajo");
				} else {
					fechaComite.setAllowBlank(true);
					fechaComite.clearInvalid();
					idComite.setAllowBlank(true);
					idComite.clearInvalid();

				}
				
			}
		}
	}
});
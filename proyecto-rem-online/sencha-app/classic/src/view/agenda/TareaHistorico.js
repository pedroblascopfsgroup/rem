Ext.define('HreRem.view.agenda.TareaHistorico',{
					extend : 'HreRem.view.common.TareaBase',
					xtype : 'tareaHistorico',
					reference : 'windowTareaHistorico',
					title : "Cheking",
					requires : ['HreRem.view.common.TareaController','HreRem.view.common.GenericCombo', 'HreRem.view.common.GenericComboEspecial', 'HreRem.view.common.GenericTextLabel'],
					tareaEditable: false,
					initComponent : function() {

						var me = this;
						
						me.width=800;
						me.title = me.titulo;
						me.json = Ext.decode(me.campos);
						me.campos = me.json.data;
						me.instrucciones = me.campos[0].fieldLabel;

						var camposFiltrados = [];
						var ecActivo = {};
						var ecTrabajo = {};
						var txtEcActivo = HreRem.i18n('fieldlabel.activo');
						var txtEcTrabajo = HreRem.i18n('fieldlabel.trabajo');
						var esInvisibleEcActivo = false;
						var esInvisibleEcTrabajo = false;
						
						//Bucle que busca los enlaces en el array me.campos,
						// para mantener funcionalidad "TareaGenerica", los enlaces deben retirarse de me.campos
						var numEnlaces = 0;
						for (var i = 0; i < me.campos.length; i++) {
							if (me.campos[i].xtype == 'elcactivo') {
								ecActivo = me.campos[i];
								txtEcActivo = ecActivo.fieldLabel;
								if ("INVISIBLE" == ecActivo.name){
									esInvisibleEcActivo = true;
								}
								numEnlaces++;
							}
							
							if (me.campos[i].xtype == 'elctrabajo') {
								ecTrabajo = me.campos[i];
								txtEcTrabajo = ecTrabajo.fieldLabel;
								if ("INVISIBLE" == ecTrabajo.name){
									esInvisibleEcTrabajo = true;
								}
								numEnlaces++;
							}
						}
						     
						//Elimina los enlaces, si existen
						//Los enlaces siempre van a continuaci�n de los campos
						for (var i = 0; i < numEnlaces; i++) {
							me.campos.pop();
						}

						for (var i = 1; i < me.campos.length - 1; i++) {
							if (me.campos[i].xtype == 'datefield') {
								me.campos[i].labelWidth = 180;
							} else if (me.campos[i].xtype == 'textarea') {
								me.campos[i].labelWidth = 180;
								me.campos[i].width = '100%';
							}else{
								me.campos[i].labelWidth = 180;
							}
							
							
							switch(me.campos[i].xtype){
							case 'combobox':
								var combo = {};
								combo.xtype = 'genericcombo';
								combo.name = me.campos[i].name;
								combo.diccionario = me.campos[i].store;
								combo.fieldLabel = me.campos[i].fieldLabel;
								combo.value = me.campos[i].value;
								combo.readOnly = true;
								camposFiltrados.push(combo);
								break;
								
							case 'comboboxespecial':
								var combo = {};
								combo.xtype = 'genericcomboespecial';
								combo.name = me.campos[i].name;
								combo.diccionario = me.campos[i].store;
								combo.fieldLabel = me.campos[i].fieldLabel;
								combo.value = me.campos[i].value;
								combo.readOnly = true;
								camposFiltrados.push(combo);
								break;
								
							case 'textinf':
								var textinf = {}
								textinf.xtype = 'generictextlabel';
								textinf.name = me.campos[i].name;
								textinf.fieldLabel = me.campos[i].fieldLabel;
								textinf.value = me.campos[i].value;
								textinf.readOnly = true;
								textinf.editable = false;
								camposFiltrados.push(textinf);
								break;
								
//							case 'timefield':
//								me.campos[i].format = 'H:i';
//								me.campos[i].increment = 30;
//								camposFiltrados.push(me.campos[i]);
//								break;
								
							case 'comboboxinicial':
								var combo = {};
								combo.xtype = 'genericcombo';
								combo.name = me.campos[i].name;
								combo.diccionario = me.campos[i].store;
								combo.fieldLabel = me.campos[i].fieldLabel;
								combo.readOnly = true;
								combo.value = me.campos[i].value;
								camposFiltrados.push(combo);
								break;
							
							case 'comboboxinicialedi':
								var combo = {};
								combo.xtype = 'genericcombo';
								combo.name = me.campos[i].name;
								combo.diccionario = me.campos[i].store;
								combo.fieldLabel = me.campos[i].fieldLabel;
								combo.readOnly = true;
								combo.value = me.campos[i].value;
								camposFiltrados.push(combo);
								break;
								
							case 'comboboxreadonly':
			                    var combo = {};
			                    combo.xtype = 'genericcombo';
			                    combo.name = me.campos[i].name;
			                    combo.diccionario = me.campos[i].store;
			                    combo.fieldLabel = me.campos[i].fieldLabel;
			                    combo.value = me.campos[i].value;
			                    combo.readOnly = true;
			                    combo.allowBlank = me.campos[i].noObligatorio;
			                    combo.blankText = me.campos[i].blankText;
			                    combo.msgTarget = me.campos[i].msgTarget;
			                    camposFiltrados.push(combo);
			                    break;	
			                    
							case 'numberfield':
								me.campos[i].hideTrigger = true;
								me.campos[i].minValue = 0;
								me.campos[i].readOnly = true;
								me.campos[i].editable = false;
								camposFiltrados.push(me.campos[i]);
								break;
								
							case 'numberfield2':
			                	me.campos[i].xtype = 'numberfield';
			                    me.campos[i].hideTrigger = true;
			                    me.campos[i].minValue = 0;
			                    me.campos[i].maxValue = 99;
			                    me.campos[i].allowBlank = me.campos[i].noObligatorio;
			                    camposFiltrados.push(me.campos[i]);
			                    break;
								
							case 'datemaxtoday':
								me.campos[i].xtype = 'datefield';
								me.campos[i].maxValue = $AC.getCurrentDate();
								me.campos[i].readOnly = true;
								me.campos[i].editable = false;
								camposFiltrados.push(me.campos[i]);
								break;
								
							case 'datemintoday':
			                    me.campos[i].xtype = 'datefield';
			                    me.campos[i].minValue = $AC.getCurrentDate();              
			        			me.campos[i].readOnly = true;
								me.campos[i].editable = false;								
								camposFiltrados.push(me.campos[i]);
			                    break;
							default:
								me.campos[i].editable = false;
								me.campos[i].readOnly = true;
								camposFiltrados.push(me.campos[i]);
								break;
						}
						}

						camposFiltrados[camposFiltrados.length] = me.campos[me.campos.length - 1];
						camposFiltrados[camposFiltrados.length - 1].labelWidth = 180;
						camposFiltrados[camposFiltrados.length - 1].width = '100%';
						camposFiltrados[camposFiltrados.length - 1].colspan = 2;
						camposFiltrados[camposFiltrados.length - 1].rowspan = 4;
						camposFiltrados[camposFiltrados.length - 1].readOnly = true;
						camposFiltrados[camposFiltrados.length - 1].editable = false;

						if(camposFiltrados.length%2 == 0)
						{
							camposFiltrados[camposFiltrados.length - 2].labelWidth = 180;
							camposFiltrados[camposFiltrados.length - 2].colspan = 2;
						}
						
						me.items = [

						{
							xtype : 'form',
							reference : 'formVerificarOferta',
							layout : 'column',
							defaults : {
								layout : 'form',
								xtype : 'container',
								defaultType : 'textfield',
								style : 'width: 98%'
							},

							items : [ {

								xtype : 'fieldset',
								collapsible : true,
								defaultType : 'textfield',
								defaults : {
									style : 'width: 100%'
								},
								layout : 'column',
								title : 'Instrucciones',

								items : [
								{
									xtype : 'label',
									cls : 'info-tarea',
									html : me.instrucciones,
									tipo : 'info'
								} ]

							}, {

								xtype : 'fieldset',
								collapsible : false,
								//defaultType : 'textfield',
								layout : {
									type : 'table',
									 columns: 2,
//									columns : 1,
									tableAttrs : {
										style : {
											width : '100%'
										}
									}
								},

								items : camposFiltrados
							}

							]

						} ];
						me.callParent();
						
						//El me. se puede sustituir por me.getLookupController() y meterlo dentro del controlador de vista.
				        var validacion = eval('me.' + me.codigoTarea + 'Validacion');
				        if (!Ext.isEmpty(validacion))
				            eval('me.' + me.codigoTarea + 'Validacion()');
						
					},

					showMotivo : function(cmp, newValue, oldValue) {

						var campo = cmp.up("form").down(
								"[itemId=motivoRechazoOferta]");
						var campoObs = cmp.up("form").down(
								"[itemId=obsVerificarOferta]");

						if (newValue == 1) {
							campo.setVisible(true);
							campo.allowBlank = false;
							campoObs.allowBlank = false;
						} else {
							campo.setVisible(false);
							campo.allowBlank = true;
							campoObs.allowBlank = true;
							cmp.up("form").isValid();
						}

					},

					evaluar : function() {

						var me = this;

						var parametros = me.down("form").getValues();
						parametros.idTarea = me.idTarea;

 						//var url = $AC.getRemoteUrl('tarea/saveFormAndAdvance');
						var url = $AC.getRemoteUrl('agenda/save');
						Ext.Ajax.request({
							url : url,
							params : parametros,
							success : function(response, opts) {
								me.fireEvent('actualizarGridTareas');

							},
							callback:  function(response, opts, success) {
								me.fireEvent('actualizarGridTareas');
							}
						});

					},

					mostrarValidacionesPost : function() {

					},
					
					T004_AutorizacionPropietarioValidacion: function() {
				        var me = this;
				        if(CONST.CARTERA['LIBERBANK']===me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera')){
				        	me.ocultarCampo(me.down('[name=numIncremento]'));
				        	me.ocultarCampo(me.down('[name=comboAmpliacion]'));
				        }else{
				        	me.ocultarCampo(me.down('[name=comboAmpliacionYAutorizacion]'));
				        }
				    },
				    
				    T013_DefinicionOfertaValidacion: function() {		
						var me = this;
						var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
						var comiteSuperior = me.down('[name=comiteSuperior]');
						var comite = me.down('[name=comite]');
						var comitePropuesto = me.down('[name=comitePropuesto]');
						var importeTotalOfertaAgrupada = me.down('[name=importeTotalOfertaAgrupada]');
						var huecoVenta = me.down('[name=huecoVenta]');
						var numOfertaPrincipal = me.down('[name=numOfertaPrincipal]');
						var comboConflicto = me.down('[name=comboConflicto]');
						var comboRiesgo   = me.down('[name=comboRiesgo]');
						var fechaEnvio = me.down('[name=fechaEnvio]');
						var observaciones = me.down('[name=observaciones]');
						
						me.ocultarCampo(comiteSuperior);
						me.ocultarCampo(comitePropuesto);
						me.ocultarCampo(importeTotalOfertaAgrupada);
						me.ocultarCampo(huecoVenta);
						me.ocultarCampo(numOfertaPrincipal);
					
						if(CONST.CARTERA['BANKIA'] == codigoCartera) {
							me.desocultarCampo(comiteSuperior);
							
						}else if(CONST.CARTERA['LIBERBANK'] == codigoCartera) {	
							
							var idExp = me.up('tramitesdetalle').getViewModel().get('tramite.idExpediente');
							var expedienteMain = Ext.ComponentQuery.query('[itemId="expediente_'+idExp+'"]')[0];
							var claseOferta;
							if(!Ext.isEmpty(expedienteMain)){
								claseOferta = expedienteMain.getViewModel().get('datosbasicosoferta.claseOfertaCodigo');
								if(claseOferta == '01'){
									me.ocultarCampo(comite);
									me.desocultarCampo(comitePropuesto);
									me.desocultarCampo(importeTotalOfertaAgrupada);
									me.desocultarCampo(huecoVenta);  	
								}else if(claseOferta == '02'){
									 me.desocultarCampo(numOfertaPrincipal);
									 me.ocultarCampo(comitePropuesto);
									 me.ocultarCampo(comboConflicto);
									 me.ocultarCampo(comboRiesgo);
									 me.ocultarCampo(fechaEnvio);
									 me.ocultarCampo(observaciones);
									 me.ocultarCampo(comite);
									 me.desocultarCampo(huecoVenta);
									 
								}else{					
									 me.ocultarCampo(comite);
									 me.desocultarCampo(comitePropuesto);
									 me.desocultarCampo(importeTotalOfertaAgrupada);
									 me.desocultarCampo(huecoVenta);
								}
							}else{
								var url = $AC.getRemoteUrl('ofertas/getClaseOferta');
						    	Ext.Ajax.request({
						    			url:url,
						    			params: {idExpediente : idExp},
						    			success: function(response,opts){
						    				 var claseOferta = Ext.JSON.decode(response.responseText).claseOferta;
						    				 if(claseOferta == '01'){
						    						me.ocultarCampo(comite);
						    						me.desocultarCampo(comitePropuesto);
						    						me.desocultarCampo(importeTotalOfertaAgrupada);
						    						me.desocultarCampo(huecoVenta);  	
						    					}else if(claseOferta == '02'){
						    						 me.desocultarCampo(numOfertaPrincipal);
						    						 me.ocultarCampo(comitePropuesto);
						    						 me.ocultarCampo(comboConflicto);
						    						 me.ocultarCampo(comboRiesgo);
						    						 me.ocultarCampo(fechaEnvio);
						    						 me.ocultarCampo(observaciones);
						    						 me.ocultarCampo(comite);
						    						 me.desocultarCampo(huecoVenta);
						    						 
						    					}else{					
						    						 me.ocultarCampo(comite);
						    						 me.desocultarCampo(comitePropuesto);
						    						 me.desocultarCampo(importeTotalOfertaAgrupada);
						    						 me.desocultarCampo(huecoVenta);
						    					}
						    			}
						    	});
							}			
						}
					},
					
					T013_ResolucionComiteValidacion: function() {
				        var me = this;
				        var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
				        var idExp = me.up('tramitesdetalle').getViewModel().get('tramite.idExpediente');
				        var comboResolucion = me.down('[name=comboResolucion]');
				        var comitePropuesto = me.down('[name=comitePropuesto]');
				        var importeTotalOfertaAgrupada = me.down('[name=importeTotalOfertaAgrupada]');

				        if (me.down('[name=comboResolucion]').getValue() != '03') {
				            me.deshabilitarCampo(me.down('[name=numImporteContra]'));
				        }
				       
						if(CONST.CARTERA['LIBERBANK'] != codigoCartera) {
							me.down('[name=fechaReunionComite]').hide();							
							me.ocultarCampo(comitePropuesto);
							me.ocultarCampo(importeTotalOfertaAgrupada);
						}else{
							me.desbloquearCampo(comboResolucion);
							me.bloquearCampo(comitePropuesto);
							
							var url = $AC.getRemoteUrl('ofertas/getClaseOferta');
					    	Ext.Ajax.request({
					    			url:url,
					    			params: {idExpediente : idExp},
					    			success: function(response,opts){
					    				 var claseOferta = Ext.JSON.decode(response.responseText).claseOferta;
					    				 if(claseOferta == '03'){
					    					 me.ocultarCampo(comitePropuesto);
					    					 me.ocultarCampo(importeTotalOfertaAgrupada);
					    				 }
					    			}
					    	});
						}						
				        me.down('[name=comboResolucion]').addListener('change', function(combo) {
				            if (combo.value == '03') {
				                me.habilitarCampo(me.down('[name=numImporteContra]'));
				            } else {
				                me.deshabilitarCampo(me.down('[name=numImporteContra]'));
				            }
				        })
				    },
				    T017_DefinicionOfertaValidacion: function() {		
						var me = this;
						var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
						var comiteSuperior = me.down('[name=comiteSuperior]');
						var comite = me.down('[name=comite]');
						if(CONST.CARTERA['BANKIA'] == codigoCartera) {
							me.ocultarCampo(comiteSuperior);
							me.ocultarCampo(comite);
							me.campoNoObligatorio(comiteSuperior);
							me.campoNoObligatorio(comite);
						}else{
							me.ocultarCampo(comiteSuperior);
						}
					},
				    T017_ResolucionCESValidacion: function(){
				    	var me = this;
				    	var comboResolucion = me.down('[name=comboResolucion]');
				    	var comboContraoferta = me.down('[name=numImporteContra]');
				    	var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
				    	var necesidadArras = me.down('[name=necesidadArras]');
				    	me.deshabilitarCampo(comboContraoferta);
				    	var observacionesBC = me.down('[name=observacionesBC]');
				  	  	me.ocultarCampo(observacionesBC);
				  	  	me.ocultarCampo(necesidadArras);
				    	
				  	  	if(CONST.CARTERA['BBVA']===codigoCartera){   		   		  
							me.down('[name=comboResolucion]').setFieldLabel(HreRem.i18n('title.resolucion'));
							me.down('[name=numImporteContra]').setFieldLabel(HreRem.i18n('fieldlabel.importe.contraoferta'));
							me.down('[name=fechaRespuesta]').setFieldLabel(HreRem.i18n('fieldlabel.fecha.respuesta'));
				  	  	}else if(CONST.CARTERA['BANKIA'] === codigoCartera){	
				  	  		var comboResolucion = me.down('[name=comboResolucion]');
				  	  		var fechaRespuesta = me.down('[name=fechaRespuesta]');
				  	  		comboResolucion.setFieldLabel(HreRem.i18n('fieldlabel.respuesta.BC'))
							fechaRespuesta.setFieldLabel(HreRem.i18n('fieldlabel.fecha.respuesta.BC'));
				  	  		me.desocultarCampo(necesidadArras)
				  	  		me.desocultarCampo(observacionesBC);
					  	  	me.ocultarCampo(comboContraoferta);
					        me.campoNoObligatorio(comboContraoferta);
					        comboResolucion.setReadOnly(true);
					        fechaRespuesta.setReadOnly(true);
					        observacionesBC.setReadOnly(true);
					        necesidadArras.setReadOnly(true);
					        	        
					        var idExp = me.up('tramitesdetalle').getViewModel().get('tramite.idExpediente');
							var url =  $AC.getRemoteUrl('expedientecomercial/getUltimaResolucionComiteBC');
							Ext.Ajax.request({
								url: url,
								params: {idExpediente : idExp},
							    success: function(response, opts) {
							    	var data = Ext.decode(response.responseText);
							    	var dto = data.data;
							    	if(!Ext.isEmpty(dto)){
							    		necesidadArras.setValue(dto.necesidadArrasActivo);
							    		fechaRespuesta.setValue(Ext.Date.format(new Date(dto.fechaRespuestaBC), 'd/m/Y'));
							    		comboResolucion.setValue(dto.respuestaBC);
							    		observacionesBC.setValue(dto.observacionesBC);
							    	}
							    }
							});
						}
						if(CONST.CARTERA['BANKIA'] !== codigoCartera) {
				    	comboResolucion.addListener('change', function(){
					        if(comboResolucion.value == '03'){
					        	me.habilitarCampo(comboContraoferta);
					        	comboContraoferta.allowBlank = false;
					        	comboContraoferta.validate();
					        }else{
					        	me.deshabilitarCampo(comboContraoferta);
					        	comboContraoferta.reset();
					        	comboContraoferta.allowBlank = true;
					        	comboContraoferta.validate();
					        }
				        });
				      }
				    },
				    
				    T015_VerificarScoringValidacion: function() {		
				    	var me = this;
				    	var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
				    	if(CONST.CARTERA['BANKIA'] == codigoCartera){
				    		me.ocultarCampo(me.down('[name=nMeses]'));
				        	me.ocultarCampo(me.down('[name=importeDeposito]'));
				        	me.ocultarCampo(me.down('[name=nombreFS]'));
				        	me.ocultarCampo(me.down('[name=documento]'));
				        	me.ocultarCampo(me.down('[name=deposito]'));
				        	me.ocultarCampo(me.down('[name=porcentajeImpuesto]'));
				        	me.ocultarCampo(me.down('[name=tipoImpuesto]'));
				        	me.ocultarCampo(me.down('[name=fiadorSolidario]'));
				        	me.ocultarCampo(me.down('[name=nMesesFianza]'));
							me.ocultarCampo(me.down('[name=importeFianza]'));

				    	}
					},
					T015_VerificarSeguroRentasValidacion: function() {		
						var me = this;	
						var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
				    	if(CONST.CARTERA['BANKIA'] == codigoCartera){
				    		me.ocultarCampo(me.down('[name=tipoImpuesto]'));
							me.ocultarCampo(me.down('[name=porcentajeImpuesto]'));
				    		
				    		me.ocultarCampo(me.down('[name=nMeses]'));
				    		me.ocultarCampo(me.down('[name=importeDeposito]'));
				    		me.ocultarCampo(me.down('[name=nombreFS]'));
				    		me.ocultarCampo(me.down('[name=documento]'));
				    		me.ocultarCampo(me.down('[name=nMesesFianza]'));
				    		me.ocultarCampo(me.down('[name=importeFianza]'));
				    		
				    		me.ocultarCampo(me.down('[name=deposito]'));
				        	me.ocultarCampo(me.down('[name=fiadorSolidario]'));
				        	me.ocultarCampo(me.down('[name=tipoImpuesto]'));
				        	me.ocultarCampo(me.down('[name=porcentajeImpuesto]'));

				    	}
					},
					T015_ElevarASancionValidacion: function(){
						var me = this;	
						var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
						if(CONST.CARTERA['BANKIA'] == codigoCartera){
							me.ocultarCampo(me.down('[name=comite]'));
				    	}
					},
				    T017_InstruccionesReservaValidacion: function() {		
						var me = this;
						var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
				
						var comboResultado = me.down('[name=comboResultado]');
						var motivoAplazamiento = me.down('[name=motivoAplazamiento]');		
						var tipoArras = me.down('[name=tipoArras]');
						var fechaEnvio = me.down('[name=fechaEnvio]');
						var comboQuitar = me.down('[name=comboQuitar]');
						
						if(CONST.CARTERA['BANKIA'] == codigoCartera) {
							me.desocultarCampo(comboResultado);
							me.desocultarCampo(motivoAplazamiento);		
							me.desocultarCampo(comboQuitar);	
						}else{						
							me.ocultarCampo(comboResultado);
							me.ocultarCampo(motivoAplazamiento);
							me.ocultarCampo(comboQuitar);
						}
					},
					
					T017_ObtencionContratoReservaValidacion: function() {		
						var me = this;
						var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
						
						var comboResultado = me.down('[name=comboResultado]');
						var motivoAplazamiento = me.down('[name=motivoAplazamiento]');
						
						var cartera = me.down('[name=cartera]');
						var oficinaReserva = me.down('[name=oficinaReserva]');
						
						var fechaFirma = me.down('[name=fechaFirma]');
						
						var comboQuitar = me.down('[name=comboQuitar]');
						
						if(CONST.CARTERA['BANKIA'] == codigoCartera) {
							me.desocultarCampo(comboResultado);
							me.desocultarCampo(motivoAplazamiento);
							me.desocultarCampo(comboQuitar);
						}else{
							me.ocultarCampo(comboResultado);							
							me.ocultarCampo(motivoAplazamiento);
							me.ocultarCampo(comboQuitar);
						}
					},
					T017_FirmaContratoValidacion: function() {
						var me = this;
						var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
						
						var comboResultado = me.down('[name=comboResultado]');
						var motivoAplazamiento = me.down('[name=motivoAplazamiento]');
						
						var comboFirma = me.down('[name=comboFirma]');
						var fechaFirma = me.down('[name=fechaFirma]');
						var numeroProtocolo = me.down('[name=numeroProtocolo]');
						
						if(CONST.CARTERA['BANKIA'] == codigoCartera) {
							me.desocultarCampo(comboResultado);
							me.desocultarCampo(motivoAplazamiento);
						}else{
							me.ocultarCampo(comboResultado);							
							me.ocultarCampo(motivoAplazamiento);
						}
					},
					T017_PBCReservaValidacion: function() {
						var me = this;
						var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
						
						var comboQuitar = me.down('[name=comboQuitar]');
						
						if(CONST.CARTERA['BANKIA'] == codigoCartera) {
							me.desocultarCampo(comboQuitar);
						}else{
							me.ocultarCampo(comboQuitar);
						}
					},
					T017_AgendarFechaFirmaArrasValidacion: function() {
						var me = this;
						var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
						
						var comboQuitar = me.down('[name=comboQuitar]');
						
						if(CONST.CARTERA['BANKIA'] == codigoCartera) {
							me.desocultarCampo(comboQuitar);
						}else{
							me.ocultarCampo(comboQuitar);
						}
					},
					T017_ConfirmarFechaFirmaArrasValidacion: function() {
						var me = this;
						var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
						
						var comboQuitar = me.down('[name=comboQuitar]');
						
						if(CONST.CARTERA['BANKIA'] == codigoCartera) {
							me.desocultarCampo(comboQuitar);
						}else{
							me.ocultarCampo(comboQuitar);
						}
					},
					
					 T015_DefinicionOfertaValidacion: function(){
					    	var me = this;
					    	var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');   	
					    	me.campoObligatorio(me.down('[name=tipoTratamiento]'));
					    	
					    	if(CONST.CARTERA['BANKIA'] == codigoCartera){
					    		me.ocultarCampo(me.down('[name=tipoInquilino]'));
						    	me.ocultarCampo(me.down('[name=nMesesFianza]'));
						    	me.ocultarCampo(me.down('[name=importeFianza]'));
						    	me.ocultarCampo(me.down('[name=deposito]'));
						    	me.ocultarCampo(me.down('[name=nMeses]'));
						    	me.ocultarCampo(me.down('[name=importeDeposito]'));
						    	me.ocultarCampo(me.down('[name=fiadorSolidario]'));
						    	me.ocultarCampo(me.down('[name=nombreFS]'));
						    	me.ocultarCampo(me.down('[name=documento]'));
						    	me.ocultarCampo(me.down('[name=tipoImpuesto]'));
						    	me.ocultarCampo(me.down('[name=porcentajeImpuesto]'));
					    	}else{

					    		var tratamiento = me.down('[name=tipoTratamiento]');
					
					    		if(tratamiento.value == '03'){
					    			me.habilitarCampo(me.down('[name=nMesesFianza]'));
					    	    	me.habilitarCampo(me.down('[name=importeFianza]'));
					    	    	me.habilitarCampo(me.down('[name=deposito]'));
					    	    	me.habilitarCampo(me.down('[name=fiadorSolidario]'));
					    	    	me.habilitarCampo(me.down('[name=tipoImpuesto]'));
					    	    	me.habilitarCampo(me.down('[name=porcentajeImpuesto]'));
					    			
					    			me.desocultarCampo(me.down('[name=nMesesFianza]'));
					    	    	me.desocultarCampo(me.down('[name=importeFianza]'));
					    	    	me.desocultarCampo(me.down('[name=deposito]'));
					    	    	me.desocultarCampo(me.down('[name=nMeses]'));
					    	    	me.desocultarCampo(me.down('[name=importeDeposito]'));
					    	    	me.desocultarCampo(me.down('[name=fiadorSolidario]'));
					    	    	me.desocultarCampo(me.down('[name=nombreFS]'));
					    	    	me.desocultarCampo(me.down('[name=documento]'));
					    	    	me.desocultarCampo(me.down('[name=tipoImpuesto]'));
					    	    	me.desocultarCampo(me.down('[name=porcentajeImpuesto]'));
					    	    	me.desocultarCampo(me.down('[name=observaciones]'));

					    		}else{
					    			me.ocultarCampo(me.down('[name=nMesesFianza]'));
					    	    	me.ocultarCampo(me.down('[name=importeFianza]'));
					    	    	me.ocultarCampo(me.down('[name=deposito]'));
					    	    	me.ocultarCampo(me.down('[name=nMeses]'));
					    	    	me.ocultarCampo(me.down('[name=importeDeposito]'));
					    	    	me.ocultarCampo(me.down('[name=fiadorSolidario]'));
					    	    	me.ocultarCampo(me.down('[name=nombreFS]'));
					    	    	me.ocultarCampo(me.down('[name=documento]'));
					    	    	me.ocultarCampo(me.down('[name=tipoImpuesto]'));
					    	    	me.ocultarCampo(me.down('[name=porcentajeImpuesto]'));
					    	    	me.ocultarCampo(me.down('[name=observaciones]'));	
					    		}
					    	}
					    },
						T017_T017_DocsPosVentaValidacion: function() {
							var me = this;
							var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
							
							var comboVentaSupensiva = me.down('[name=comboVentaSupensiva]');
							
							if(CONST.CARTERA['BANKIA'] == codigoCartera) {
								me.desocultarCampo(comboVentaSupensiva);
							}else{
								me.ocultarCampo(comboVentaSupensiva);
							}
						},

					ocultarCampo: function(campo) {
				        var me = this;
				        campo.setHidden(true);
					},
					habilitarCampo: function(campo) {
						var me = this;
						campo.setDisabled(false);
						me.campoObligatorio(campo);
					},
					deshabilitarCampo: function(campo) {
						var me = this;
						campo.setDisabled(true);
						me.campoNoObligatorio(campo);
					},
					bloquearCampo: function(campo) {
						var me = this;
						campo.setReadOnly(true);
						me.campoNoObligatorio(campo);
					},
					desbloquearCampo: function(campo) {
						var me = this;
						campo.setReadOnly(false);
						me.campoObligatorio(campo);
					},
					borrarCampo: function(campo) {
						campo.setValue(null);
					},
					campoObligatorio: function(campo) {
						var me = this;
						if (campo.noObligatorio) {
							campo.allowBlank = true;
						} else {
							campo.allowBlank = false;
						}
					},
					campoNoObligatorio: function(campo) {
						var me = this;
						campo.allowBlank = true;
					},
					desocultarCampo: function(campo) {
						var me = this;
						campo.setHidden(false);
					},
					
					setFechaActual: function(campo){
						var fecha = new Date();
						campo.setValue(Ext.Date.format(fecha, 'd/m/Y'));
					}
			});
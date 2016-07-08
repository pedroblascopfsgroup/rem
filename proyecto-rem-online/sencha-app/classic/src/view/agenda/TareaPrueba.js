Ext.define('HreRem.view.agenda.TareaPrueba',{
					extend : 'HreRem.view.common.TareaBase',
					xtype : 'tareaPrueba',
					reference : 'windowTareaPrueba',
					title : "Cheking",
					requires : ['HreRem.view.common.TareaController','HreRem.view.common.GenericCombo', 'HreRem.view.common.GenericComboEspecial', 'HreRem.view.common.GenericTextLabel', 'HreRem.view.agenda.TareaModel' ],
				    controller: 'tarea',
				    viewModel: {
				        type: 'tarea'
				    },
					//modal: false,
		            
				     /**
				     * Párametro para saber que componente abre la ventana, y poder refrescarlo después.
				     * @type Component
				     */
				    parent: null,
		                   
					initComponent : function() {

						var me = this;
						
						alert("Esta clase no se deberia de utilizar, ahora se llama Tarea Generica");
						
						
					    me.listeners = {
					    		afterrender: function(){
					    			me.lookupController().getValidacionPrevia(me);
					    			me.lookupController().getAdvertenciaTarea(me);
					    			me.lookupController().verBotonEnlaceTrabajo(me);
					    			}
						     };
			        	
						me.width=800;
						me.title = me.titulo;
						me.json = Ext.decode(me.campos);
						me.campos = me.json.data;
						me.instrucciones = me.campos[0].fieldLabel;

						var camposFiltrados = [];

						for (var i = 1; i < me.campos.length - 1; i++) {
							if (me.campos[i].allowBlank == 'false'){
								me.campos[i].allowBlank = false;
								me.campos[i].msgTarget = 'side';
							}else{
								me.campos[i].allowBlank = true;
							}
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
									combo.readOnly = false;
									camposFiltrados.push(combo);
									break;
									
								case 'comboboxespecial':
									var combo = {};
									combo.xtype = 'genericcomboespecial';
									combo.name = me.campos[i].name;
									combo.diccionario = me.campos[i].store;
									combo.fieldLabel = me.campos[i].fieldLabel;
									combo.readOnly = false;
									camposFiltrados.push(combo);
									break;
									
								case 'textinf':
									var textinf = {}
									textinf.xtype = 'generictextlabel';
									textinf.name = me.campos[i].name;
									textinf.fieldLabel = me.campos[i].fieldLabel;
									textinf.value = me.campos[i].value;
									camposFiltrados.push(textinf);
									break;
									
								case 'timefield':
									me.campos[i].format = 'H:i';
									me.campos[i].increment = 30;
									camposFiltrados.push(me.campos[i]);
									break;
									
								case 'comboboxinicial':
									var combo = {};
									combo.xtype = 'genericcombo';
									combo.name = me.campos[i].name;
									combo.diccionario = me.campos[i].store;
									combo.fieldLabel = me.campos[i].fieldLabel;
									combo.readOnly = false;
									combo.value = me.campos[i].value;
									camposFiltrados.push(combo);
									break;
									
								case 'numberfield':
									me.campos[i].hideTrigger = true;
									me.campos[i].minValue = 0;
									camposFiltrados.push(me.campos[i]);
									break;
									
								case 'datemaxtoday':
									me.campos[i].xtype = 'datefield';
									me.campos[i].maxValue = $AC.getCurrentDate();
									camposFiltrados.push(me.campos[i]);
									break;
									
								default:
									camposFiltrados.push(me.campos[i]);
									break;
							}

							
							
//							if (me.campos[i].xtype == 'combobox') {								
//								var combo = {};
//								combo.xtype = 'genericcombo';
//								combo.name = me.campos[i].name;
//								combo.diccionario = me.campos[i].store;
//								combo.fieldLabel = me.campos[i].fieldLabel;
//								combo.readOnly = false;
//								camposFiltrados.push(combo);
//							}else{
//								if(me.campos[i].xtype == 'comboboxespecial'){
//									var combo = {};
//									combo.xtype = 'genericcomboespecial';
//									combo.name = me.campos[i].name;
//									combo.diccionario = me.campos[i].store;
//									combo.fieldLabel = me.campos[i].fieldLabel;
//									combo.readOnly = false;
//									camposFiltrados.push(combo);
//								}else{
//									if(me.campos[i].xtype == 'textinf'){
//										var textinf = {}
//										textinf.xtype = 'generictextlabel';
//										textinf.name = me.campos[i].name;
//										textinf.fieldLabel = me.campos[i].fieldLabel;
//										textinf.value = me.campos[i].value;
//										camposFiltrados.push(textinf);
//									}else{
//										if(me.campos[i].xtype == 'timefield'){
//											me.campos[i].format = 'H:i';
//											me.campos[i].increment = 30;
//											camposFiltrados.push(me.campos[i]);
//										}else{
//											if(me.campos[i].xtype == 'comboboxinicial'){
//												var combo = {};
//												combo.xtype = 'genericcombo';
//												combo.name = me.campos[i].name;
//												combo.diccionario = me.campos[i].store;
//												combo.fieldLabel = me.campos[i].fieldLabel;
//												combo.readOnly = false;
//												combo.value = me.campos[i].value;
//												camposFiltrados.push(combo);
//											}else{
//												if(me.campos[i].xtype == 'numberfield'){
//													me.campos[i].hideTrigger = true;
//													me.campos[i].minValue = 0;
//													camposFiltrados.push(me.campos[i]);
//												}else{
//													camposFiltrados.push(me.campos[i]);
//												}
//											}
//										}
//										
//									}
//								}
//							}
						}
						
						
						camposFiltrados[camposFiltrados.length] = me.campos[me.campos.length - 1];
						camposFiltrados[camposFiltrados.length - 1].labelWidth = 180;
						camposFiltrados[camposFiltrados.length - 1].width = '100%';
						camposFiltrados[camposFiltrados.length - 1].colspan = 2;
						camposFiltrados[camposFiltrados.length - 1].rowspan = 4;
						
						
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

							items : [{
				                	xtype: 'label',
				                	cls: '.texto-alerta',
				                	bind : {
				                		html : '{textoAdvertenciaTarea}'
				                			},
				                	style: 'color: red'
		                		},
		                		{
									xtype : 'label',
									cls : 'info-tarea',
									bind : {
										html : '{errorValidacionGuardado}' 
											},
									tipo : 'info',
									style: 'color:red'
								},
								{
									xtype : 'label',
									cls : 'info-tarea',
									bind : {
										html : '{errorValidacion}' 
											},
									tipo : 'info',
									style: 'color:red'
								},        
								{
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
							},

							{
							xtype : 'fieldset',
							collapsible : false,
							defaultType : 'textfield',
							defaults : {
								style : 'width: 100%'
							},
							layout : 'column',
							title : 'Enlaces directos',
							items : [ {
									xtype : 'button',
									html : '<div style="color: #26607c">Ir al Trabajo</div>',
									//cls : 'boton-link',
									style : 'background: transparent; border: none;',
									hidden: true,
									handler: 'enlaceAbrirTrabajo'
								},
								{
									xtype : 'button',
									html : '<div style="color: #26607c">Ir al Activo</div>',
									//cls : 'boton-link',
									style : 'background: transparent; border: none;',
									handler: 'enlaceAbrirActivo'
								}]

							}

							]

						} ];
						me.callParent();
						
						
						//El me. se puede sustituir por me.getLookupController() y meterlo dentro del controlador de vista.
						var validacion = eval('me.'+me.codigoTarea+'Validacion');
						if(!Ext.isEmpty(validacion))
							eval('me.'+me.codigoTarea+'Validacion()');

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
						//debugger;
						var me = this;

						var parametros = me.down("form").getValues();
						parametros.idTarea = me.idTarea;

 						//var url = $AC.getRemoteUrl('tarea/saveFormAndAdvance');
						var url = $AC.getRemoteUrl('agenda/save');
						Ext.Ajax.request({
							url : url,
							params : parametros,
							success : function(response, opts) {
								//me.parent.fireEvent('aftersaveTarea', me.parent);
								me.json = Ext.decode(response.responseText);
								
								if(me.json.errorValidacionGuardado){
					    			me.getViewModel().set("errorValidacionGuardado", me.json.errorValidacionGuardado);
			        				me.unmask();
								}else{
			        				me.unmask();
			        				//me.mostrarValidacionesPost();
							    	me.fireEvent("refreshOnActivate", "trabajosmain");
							    	me.fireEvent("refreshOnActivate", "agendamain");
			        				me.destroy();
								}

							},
							callback:  function(response, opts, success) {
								me.parent.fireEvent('aftersaveTarea', me.parent);
							}
						});

					},

					obtenerIdEnlaces : {
						//Obtiene los ids necesarios para las entidades referenciadas en los enlaces
						
						
					},
					
					mostrarValidacionesPost : function() {

					},
					
					
					T001_VerificarEstadoPosesorioValidacion: function() {
						var me = this;
						
						me.deshabilitarCampo(me.down('[name=comboTitulo]'));
						
						me.down('[name=comboOcupado]').addListener('change', function(combo){
							if(combo.value == '01'){
								me.habilitarCampo(me.down('[name=comboTitulo]'));
							}else{
								me.deshabilitarCampo(me.down('[name=comboTitulo]'));
							}
						})
					},
					
					T002_ObtencionLPOGestorInternoValidacion: function() {
						var me = this;
						
						me.deshabilitarCampo(me.down('[name=fechaEmision]'));
						me.deshabilitarCampo(me.down('[name=refDocumento]'));
						me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));
						
						me.down('[name=comboObtencion]').addListener('change', function(combo){
							if(combo.value == '01'){
								me.habilitarCampo(me.down('[name=fechaEmision]'));
								me.habilitarCampo(me.down('[name=refDocumento]'));
								me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));
							}else{
								me.deshabilitarCampo(me.down('[name=fechaEmision]'));
								me.deshabilitarCampo(me.down('[name=refDocumento]'));
								me.habilitarCampo(me.down('[name=motivoNoObtencion]'));
							}
						})
					},
					
					
					T002_ObtencionDocumentoGestoriaValidacion: function() {
						var me = this;
						
						me.deshabilitarCampo(me.down('[name=fechaEmision]'));
						me.deshabilitarCampo(me.down('[name=refDocumento]'));
						me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));
						
						me.down('[name=comboObtencion]').addListener('change', function(combo){
							if(combo.value == '01'){
								me.habilitarCampo(me.down('[name=fechaEmision]'));
								me.habilitarCampo(me.down('[name=refDocumento]'));
								me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));
							}else{
								me.deshabilitarCampo(me.down('[name=fechaEmision]'));
								me.deshabilitarCampo(me.down('[name=refDocumento]'));
								me.habilitarCampo(me.down('[name=motivoNoObtencion]'));
							}
						})
					},
					
					
					T003_AnalisisPeticionValidacion: function() {
						var me = this;
						
						me.deshabilitarCampo(me.down('[name=comboSaldo]'));
						me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
						
						me.down('[name=comboTramitar]').addListener('change', function(combo){
							if(combo.value == '01'){
								me.habilitarCampo(me.down('[name=comboSaldo]'));
								me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
							}else{
								me.deshabilitarCampo(me.down('[name=comboSaldo]'));
								me.habilitarCampo(me.down('[name=motivoDenegacion]'));
							}
						})
					},
					
					
					T004_AnalisisPeticionValidacion: function() {
				    	 var me = this;
				    	 
				    	 me.deshabilitarCampo(me.down('[name=comboAseguradoras]'));
				    	 me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
				    	 if(me.down('[name=comboTarifa]').value == '02'){
				    		 me.bloquearCampo(me.down('[name=comboTarifa]'));
				    	 }
				    		 
				    	 
				    	 me.down('[name=comboTramitar]').addListener('change', function(combo){
				    		 if(combo.value == '01'){
				    			 me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
				    			 me.habilitarCampo(me.down('[name=comboCubierto]'));
				    			 if(me.down('[name=comboCubierto]').value == '01'){
				    				 me.habilitarCampo(me.down('[name=comboAseguradoras]'));
				    			 }
				    			 me.habilitarCampo(me.down('[name=comboTarifa]'));
				    		 }else{
				    			 me.habilitarCampo(me.down('[name=motivoDenegacion]'));
				    			 me.deshabilitarCampo(me.down('[name=comboCubierto]'));
				    			 me.deshabilitarCampo(me.down('[name=comboAseguradoras]'));
				    			 me.deshabilitarCampo(me.down('[name=comboTarifa]'));
				    		 }
				    	 });
				    	 
				    	 me.down('[name=comboCubierto]').addListener('change', function(combo){
				    		 if(combo.value == '01'){
				    			 me.habilitarCampo(me.down('[name=comboAseguradoras]'));
				    		 }else{
				    			 me.deshabilitarCampo(me.down('[name=comboAseguradoras]'));
				    		 }
				    	 });
				    	 
				    	 
				    	 

				 		
				     },


				     T004_EleccionPresupuestoValidacion: function(){
				    	 var me = this;
				    	 
				    	 me.deshabilitarCampo(me.down('[name=motivoInvalidez]'));
				    	 
				    	 me.down('[name=comboPresupuesto]').addListener('change', function(combo){
				    		 if(combo.value == '01'){
				    			 me.deshabilitarCampo(me.down('[name=motivoInvalidez]'));
				    		 }else{
				    			 me.habilitarCampo(me.down('[name=motivoInvalidez]'));
				    		 }
				    	 })
				    	 
				     },
				     
				    
				     T004_AutorizacionPropietarioValidacion: function(){
				    	 var me = this;
				    	 
				    	 me.deshabilitarCampo(me.down('[name=numIncremento]'));
				    	 
				    	 me.down('[name=comboAmpliacion]').addListener('change', function(combo){
				    		 if(combo.value == '01'){
				    			 me.habilitarCampo(me.down('[name=numIncremento]'));
				    		 }else{
				    			 me.deshabilitarCampo(me.down('[name=numIncremento]'));
				    		 }
				    	 })
				     },
				     
				     
				     T004_FijacionPlazoValidacion: function(){
				    	 var me = this;
				    	 
				    	 me.down('[name=fechaTope]').addListener('change', function(campo){
				    		 if(campo.value != '' && campo.value != null){
				    			 me.borrarCampo(me.down('[name=fechaConcreta]'));
				    			 me.borrarCampo(me.down('[name=horaConcreta]'));
				    		 }
				    	 });
				    	 
				    	 me.down('[name=fechaConcreta]').addListener('change', function(campo){
				    		 if(campo.value != '' && campo.value != null){
				    			 me.borrarCampo(me.down('[name=fechaTope]'));
				    		 }
				    	 });
				    	 
				    	 me.down('[name=horaConcreta]').addListener('change', function(campo){
				    		 if(campo.value != '' && campo.value != null){
				    			 me.borrarCampo(me.down('[name=fechaTope]'));
				    		 }
				    	 })
				     },
				     
				     
				     T004_ResultadoNoTarificadaValidacion: function(){
				    	 var me = this;
				    	 
				    	 me.deshabilitarCampo(me.down('[name=fechaFinalizacion]'));
				    	 
				    	 me.down('[name=comboModificacion]').addListener('change', function(combo){
				    		 if(combo.value == '01'){
				    			 me.deshabilitarCampo(me.down('[name=fechaFinalizacion]'));
				    		 }else{
				    			 me.habilitarCampo(me.down('[name=fechaFinalizacion]'));
				    		 }
				    	 })
				    	 
				    	 
				     },
				     
				     T004_ValidacionTrabajoValidacion: function(){
				    	 var me = this;
				    	 
				    	 me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
				    	 me.deshabilitarCampo(me.down('[name=fechaValidacion]'));
				    	 me.deshabilitarCampo(me.down('[name=comboValoracion]'));
				    	 
				    	 me.down('[name=comboEjecutado]').addListener('change', function(combo){
				    		 if(combo.value == '01'){
				    			 me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
						    	 me.habilitarCampo(me.down('[name=fechaValidacion]'));
						    	 me.habilitarCampo(me.down('[name=comboValoracion]'));
				    		 }else{
				    			 me.habilitarCampo(me.down('[name=motivoIncorreccion]'));
						    	 me.deshabilitarCampo(me.down('[name=fechaValidacion]'));
						    	 me.deshabilitarCampo(me.down('[name=comboValoracion]'));
				    		 }
				    	 })
				     },
				     
				     T008_ObtencionDocumentoValidacion: function(){
						var me = this;
							
						me.deshabilitarCampo(me.down('[name=fechaEmision]'));
						me.deshabilitarCampo(me.down('[name=refDocumento]'));
						me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));
							
						me.down('[name=comboObtencion]').addListener('change', function(combo){
							if(combo.value == '01'){
								me.habilitarCampo(me.down('[name=fechaEmision]'));
								me.habilitarCampo(me.down('[name=refDocumento]'));
								me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));
							}else{
								me.deshabilitarCampo(me.down('[name=fechaEmision]'));
								me.deshabilitarCampo(me.down('[name=refDocumento]'));
								me.habilitarCampo(me.down('[name=motivoNoObtencion]'));
							}
						})	 
				     },
				     
					habilitarCampo: function(campo) {				    	
					    	var me = this;
					    	campo.setDisabled(false);
					},
					deshabilitarCampo: function(campo) {				    	
				    	var me = this;
				    	campo.setDisabled(true);
				    },
				    bloquearCampo: function(campo) {
				    	var me = this;
				    	campo.setReadOnly(true);
				    },
				    desbloquearCampo: function(campo) {
				    	var me = this;
				    	campo.setReadOnly(false);
				    },
				    borrarCampo: function(campo) {
				    	campo.setValue(null);
				    },
				    campoObligatorio: function(campo){
				    	var me = this;
				    	campo.allowBlank = false;
				    	campo.msgTarget = 'side';
				    },
				    campoNoObligatorio: function(campo){
				    	var me = this;
				    	campo.allowBlank = true ;
				    	campo.msgTarget = null;
				    }

				});

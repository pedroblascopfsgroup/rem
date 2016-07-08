Ext.define('HreRem.view.agenda.TareaGenerica',{
					extend : 'HreRem.view.common.TareaBase',
					xtype : 'tareagenerica',
					reference : 'windowTareaGenerica',
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
				    
				    /**
				     * Párametro para guardar el id del trabajo en caso de existir.
				     * @type Long
				     */
				    idTrabajo: null,
				    
				   	/**
				     * Párametro para guardar el id del activo en caso de existir.
				     * @type Long
				     */
				    idActivo: null,
		                   
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

						//Listener afterrender, con
						// - Validacion PRE
						// - Advertencias tarea
						// - Visibilidad Enlace Trabajo
						// - Visibilidad Enlace Activo
					    me.listeners = {
					    		afterrender: function(){
					    			me.lookupController().getValidacionPrevia(me);
					    			me.lookupController().getAdvertenciaTarea(me);
					    			me.lookupController().verBotonEnlaceTrabajo(me, esInvisibleEcTrabajo);
					    			me.lookupController().verBotonEnlaceActivo(me, esInvisibleEcActivo);
					    			}
						     };
						     
						//Elimina los enlaces, si existen
						//Los enlaces siempre van a continuaci�n de los campos
						for (var i = 0; i < numEnlaces; i++) {
							me.campos.pop();
						}
						
						//Bucle que quita el �ltimo campo = Observaciones, para construir la tarea con
						// 2 columnas de campos y agregar "Observaciones" al final, en todo el ancho form
						for (var i = 1; i < me.campos.length - 1; i++) {
							if (me.campos[i].allowBlank == 'false'){
								me.campos[i].allowBlank = false;								
								me.campos[i].noObligatorio = false;
							}else{
								me.campos[i].allowBlank = true;
								me.campos[i].noObligatorio = true;
							}
							if (me.campos[i].xtype == 'datefield') {
								me.campos[i].labelWidth = 180;
							} else if (me.campos[i].xtype == 'textarea') {
								me.campos[i].labelWidth = 180;
								me.campos[i].width = '100%';
							}else{
								me.campos[i].labelWidth = 180;
							}
							
							me.campos[i].msgTarget = 'side';
							
							//Este switch seg�n el caso reutiliza las propiedades de items que se han
							// definido en el array "me.campos[]" o crean arrays de items nuevos.
							// Si creas un nuevo "case" y decides crear un array nuevo en lugar de reutilizar
							// "me.campos[]", debes definir todas las propiedades comunes que se han definido
							// en los que crean un objeto nuevo: "allowBlank", "blankText", "msgTarget"... 
							// Sirva como ejemplo cualquiera de los existentes.
							switch(me.campos[i].xtype){
								case 'combobox':
									var combo = {};
									combo.xtype = 'genericcombo';
									combo.name = me.campos[i].name;
									combo.diccionario = me.campos[i].store;
									combo.fieldLabel = me.campos[i].fieldLabel;
									combo.readOnly = false;
									combo.allowBlank = me.campos[i].noObligatorio;
									combo.blankText =  me.campos[i].blankText;
									combo.msgTarget = me.campos[i].msgTarget;
									camposFiltrados.push(combo);
									break;
									
								case 'comboboxespecial':
									var combo = {};
									combo.xtype = 'genericcomboespecial';
									combo.name = me.campos[i].name;
									combo.diccionario = me.campos[i].store;
									combo.fieldLabel = me.campos[i].fieldLabel;
									combo.readOnly = false;
									combo.allowBlank = me.campos[i].noObligatorio;
									combo.blankText =  me.campos[i].blankText;
									combo.msgTarget = me.campos[i].msgTarget;
									camposFiltrados.push(combo);
									break;
									
								case 'textinf':
									var textinf = {}
									textinf.xtype = 'generictextlabel';
									textinf.name = me.campos[i].name;
									textinf.fieldLabel = me.campos[i].fieldLabel;
									textinf.value = me.campos[i].value;
									textinf.allowBlank = me.campos[i].noObligatorio;
									textinf.blankText =  me.campos[i].blankText;
									textinf.msgTarget = me.campos[i].msgTarget;
									camposFiltrados.push(textinf);
									break;
									
								case 'timefield':
									me.campos[i].format = 'H:i';
									me.campos[i].increment = 30;
									me.campos[i].allowBlank = me.campos[i].noObligatorio;
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
									combo.allowBlank = me.campos[i].noObligatorio;
									combo.blankText =  me.campos[i].blankText;
									combo.msgTarget = me.campos[i].msgTarget;
									camposFiltrados.push(combo);
									break;
									
								case 'numberfield':
									me.campos[i].hideTrigger = true;
									me.campos[i].minValue = 0;
									me.campos[i].allowBlank = me.campos[i].noObligatorio;
									camposFiltrados.push(me.campos[i]);
									break;
									
								case 'datemaxtoday':
									me.campos[i].xtype = 'datefield';
									me.campos[i].maxValue = $AC.getCurrentDate();
									me.campos[i].allowBlank = me.campos[i].noObligatorio;
									camposFiltrados.push(me.campos[i]);
									break;
																	
								default:
									camposFiltrados.push(me.campos[i]);
									break;
							}

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
							hidden: (esInvisibleEcTrabajo && esInvisibleEcActivo),
							items : [ {
									xtype : 'button',
									html : '<div style="color: #26607c">'+txtEcTrabajo+'</div>',
									//cls : 'boton-link',
									style : 'background: transparent; border: none;',
									hidden: esInvisibleEcTrabajo,
									reflinks: CONST.MAP_TAB_TRABAJO_XTYPE[''+ecTrabajo.name+''],
									handler: 'enlaceAbrirTrabajo'
								},
								{
									xtype: 'image',
									height: 20,
									width: 5,
									bind: {
										src: 'resources/images/separador.png'
									}
								},
								{
									xtype : 'button',
									html : '<div style="color: #26607c">'+txtEcActivo+'</div>',
									//cls : 'boton-link',
									style : 'background: transparent; border: none;',
									hidden: esInvisibleEcActivo,
									reflinks: CONST.MAP_TAB_ACTIVO_XTYPE[''+ecActivo.name+''],
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
							    	me.fireEvent("refreshComponentOnActivate", "trabajosmain");
							    	me.fireEvent("refreshComponentOnActivate", "agendamain");
							    	me.fireEvent("refreshComponentOnActivate", "agendaalertasmain");
							    	me.fireEvent("refreshComponentOnActivate", "agendaavisosmain");
							    	if(!Ext.isEmpty(me.idTrabajo)) {
							    		me.fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['TRABAJO'], me.idTrabajo);
							    	}
							    	if(!Ext.isEmpty(me.idActivo)) {
							    		me.fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['ACTIVO'], me.idActivo);	
							    	}
							    	
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
					
					
					T001_CheckingDocumentacionAdmisionValidacion: function() {
						var me = this;
						
						me.down('[name=fecha]').setValue($AC.getCurrentDate());						
					},
					
					T001_CheckingDocumentacionGestionValidacion: function() {
						var me = this;
						
						me.down('[name=fecha]').setValue($AC.getCurrentDate());
					},
					
					T001_CheckingInformacionValidacion: function() {
						var me = this;
						
						me.down('[name=fecha]').setValue($AC.getCurrentDate());
					},
					
					T001_VerificarEstadoPosesorioValidacion: function() {
						var me = this;
						
						me.down('[name=fecha]').setValue($AC.getCurrentDate());
						me.deshabilitarCampo(me.down('[name=comboTitulo]'));
						
						me.down('[name=comboOcupado]').addListener('change', function(combo){
							if(combo.value == '01'){
								me.habilitarCampo(me.down('[name=comboTitulo]'));
							}else{
								me.deshabilitarCampo(me.down('[name=comboTitulo]'));
							}
						})
					},

					T002_AnalisisPeticionValidacion: function() {
						var me = this;
						
						me.deshabilitarCampo(me.down('[name=comboGasto]'));
						me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
						me.deshabilitarCampo(me.down('[name=comboSaldo]'));
						
						me.down('[name=comboTramitar]').addListener('change', function(combo){
							if(combo.value == '01'){
								me.habilitarCampo(me.down('[name=comboGasto]'));
								me.habilitarCampo(me.down('[name=comboSaldo]'));
								me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
							}else{
								me.deshabilitarCampo(me.down('[name=comboGasto]'));
								me.deshabilitarCampo(me.down('[name=comboSaldo]'));
								me.habilitarCampo(me.down('[name=motivoDenegacion]'));
							}
						})
					},
					
					T002_AutorizacionPropietarioValidacion: function() {
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
					
					
					T002_ValidacionActuacionValidacion: function() {
						var me = this;

						me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
						me.deshabilitarCampo(me.down('[name=comboValoracion]'));
						me.deshabilitarCampo(me.down('[name=fechaValidacion]'));
						
						me.down('[name=comboCorreccion]').addListener('change', function(combo){
							if(combo.value == '01'){
								me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
								me.habilitarCampo(me.down('[name=comboValoracion]'));
								me.habilitarCampo(me.down('[name=fechaValidacion]'));
							}else{
								me.habilitarCampo(me.down('[name=motivoIncorreccion]'));
								me.deshabilitarCampo(me.down('[name=comboValoracion]'));
								me.deshabilitarCampo(me.down('[name=fechaValidacion]'));
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
					
					T003_AutorizacionPropietarioValidacion: function() {
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
				    	 
				    	 if (me.down('[name=fechaTope]').value != null){
			    			 me.down('[name=fechaTope]').allowBlank = false;
			    			 me.down('[name=fechaConcreta]').allowBlank = true;
			    			 me.down('[name=horaConcreta]').allowBlank = true;
			    			 me.down('[name=fechaConcreta]').reset();
			    			 me.down('[name=horaConcreta]').reset();
				    	 } else if (me.down('[name=fechaConcreta]').value != null){
			    			 me.down('[name=fechaTope]').allowBlank = true;
			    			 me.down('[name=fechaConcreta]').allowBlank = false;
			    			 me.down('[name=horaConcreta]').allowBlank = false;
			    			 me.down('[name=fechaTope]').reset();
				    	 } else {
			    			 me.down('[name=fechaTope]').allowBlank = false;
			    			 me.down('[name=fechaConcreta]').allowBlank = true;
			    			 me.down('[name=horaConcreta]').allowBlank = true;
				    	 }
				    	 				    	 
				    	 me.down('[name=fechaTope]').addListener('focus', function(campo){
			    			 me.down('[name=fechaTope]').allowBlank = false;
			    			 me.down('[name=fechaConcreta]').allowBlank = true;
			    			 me.down('[name=horaConcreta]').allowBlank = true;
			    			 me.down('[name=fechaConcreta]').reset();
			    			 me.down('[name=horaConcreta]').reset();
			    			 me.down('[name=fechaConcreta]').setValue('');
			    			 me.down('[name=horaConcreta]').setValue('');
				    	 });
				    	 
				    	 me.down('[name=fechaConcreta]').addListener('focus', function(campo){
			    			 me.down('[name=fechaTope]').allowBlank = true;
			    			 me.down('[name=fechaConcreta]').allowBlank = false;
			    			 me.down('[name=horaConcreta]').allowBlank = false;
			    			 me.down('[name=fechaTope]').reset();
			    			 me.down('[name=fechaTope]').setValue('');
				    	 });
				    	 
				    	 me.down('[name=horaConcreta]').addListener('focus', function(campo){
			    			 me.down('[name=fechaTope]').allowBlank = true;
			    			 me.down('[name=fechaConcreta]').allowBlank = false;
			    			 me.down('[name=horaConcreta]').allowBlank = false;
			    			 me.down('[name=fechaTope]').reset();
			    			 me.down('[name=fechaTope]').setValue('');
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
			    
					T005_AnalisisPeticionValidacion: function() {
						var me = this;
						
						me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
						me.deshabilitarCampo(me.down('[name=comboSaldo]'));
						me.bloquearCampo(me.down('[name=saldoDisponible]'));
						
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
					
					T005_AutorizacionPropietarioValidacion: function() {
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
					
					T006_AnalisisPeticionValidacion: function() {
						var me = this;
						
						me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
						me.deshabilitarCampo(me.down('[name=comboSaldo]'));
						me.bloquearCampo(me.down('[name=saldoDisponible]'));
						
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
					
					T006_AutorizacionPropietarioValidacion: function() {
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
					
					T006_EmisionInformeValidacion: function() { 
						var me = this;

						me.deshabilitarCampo(me.down('[name=fechaEmision]'));
						me.deshabilitarCampo(me.down('[name=motivoNoEmision]'));

						me.down('[name=comboImposibilidad]').addListener('change', function(combo){
							if(combo.value == '01'){
								me.down('[name=motivoNoEmision]').reset();
								me.deshabilitarCampo(me.down('[name=motivoNoEmision]'));
								me.habilitarCampo(me.down('[name=fechaEmision]'));								
							}else{
								me.down('[name=fechaEmision]').reset();
								me.habilitarCampo(me.down('[name=motivoNoEmision]'));
								me.deshabilitarCampo(me.down('[name=fechaEmision]'));								
							}
						})
					},
					
					T006_ValidacionInformeValidacion: function() {
						var me = this;
						
						me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
						me.deshabilitarCampo(me.down('[name=comboValoracion]'));
						me.deshabilitarCampo(me.down('[name=fechaValidacion]'));
						
						me.down('[name=comboCorreccion]').addListener('change', function(combo){
							if(combo.value == '01'){
								me.down('[name=motivoIncorreccion]').reset();
								me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
								me.habilitarCampo(me.down('[name=comboValoracion]'));
								me.habilitarCampo(me.down('[name=fechaValidacion]'));
								me.down('[name=fechaValidacion]').setValue($AC.getCurrentDate());
							}else{
								me.down('[name=fechaValidacion]').reset();
								me.down('[name=comboValoracion]').reset();
								me.habilitarCampo(me.down('[name=motivoIncorreccion]'));
								me.deshabilitarCampo(me.down('[name=comboValoracion]'));
								me.deshabilitarCampo(me.down('[name=fechaValidacion]'));
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
				    campoObligatorio: function(campo){
				    	var me = this;
				    	if(campo.noObligatorio){
				    		campo.allowBlank = true;
				    	}else{
				    		campo.allowBlank = false;
				    	}
				    },
				    campoNoObligatorio: function(campo){
				    	var me = this;
				    	campo.allowBlank = true ;
				    }

				});

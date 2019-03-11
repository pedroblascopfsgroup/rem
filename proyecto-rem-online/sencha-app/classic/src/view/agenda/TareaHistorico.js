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
								combo.value = me.campos[i].value;
								camposFiltrados.push(combo);
								break;
								
							case 'numberfield':
								me.campos[i].hideTrigger = true;
								me.campos[i].minValue = 0;
								me.campos[i].readOnly = true;
								me.campos[i].editable = false;
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
					
					ocultarCampo: function(campo) {
				        var me = this;
				        campo.setHidden(true);
				    }
			});
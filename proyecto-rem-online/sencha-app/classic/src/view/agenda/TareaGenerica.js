Ext.define('HreRem.view.agenda.TareaGenerica', {
    extend: 'HreRem.view.common.TareaBase',
    xtype: 'tareagenerica',
    reference: 'windowTareaGenerica',
    requires: ['HreRem.view.common.TareaController', 'HreRem.view.common.GenericCombo', 'HreRem.view.common.GenericComboEspecial', 'HreRem.view.common.GenericTextLabel', 'HreRem.view.common.DisplayFieldBase', 'HreRem.view.agenda.TareaModel'],
    controller: 'tarea',
    viewModel: {
        type: 'tarea'
    },
    //modal: false,

    /**
     * P�rametro para saber que componente abre la ventana, y poder refrescarlo despu�s.
     * @type Component
     */
    parent: null,

    /**
     * P�rametro para guardar el id del trabajo en caso de existir.
     * @type Long
     */
    idTrabajo: null,

    /**
     * P�rametro para guardar el id del activo en caso de existir.
     * @type Long
     */
    idActivo: null,

    /**
     * P�rametro para guardar el id del expediente en caso de existir.
     * @type Long
     */
    idExpediente: null,
    numExpediente: null,

    initComponent: function() {
        var me = this;
        
        me. btn_guardar_txt = HreRem.i18n("btn.saveBtnText");

        me.width = 800;
        me.title = me.titulo;
        me.json = Ext.decode(me.campos);
        me.campos = me.json.data;
        me.instrucciones = me.campos[0].fieldLabel;

        var camposFiltrados = [];
        var ecActivo = {};
        var ecTrabajo = {};
        var ecExpediente = {};
        var txtEcActivo = HreRem.i18n('fieldlabel.activo');
        var txtEcTrabajo = HreRem.i18n('fieldlabel.trabajo');
        var txtEcExpediente = HreRem.i18n('fieldlabel.expediente');
        var esInvisibleEcActivo = false;
        var esInvisibleEcTrabajo = false;
        var esInvisibleEcExpediente = true;
        //Bucle que busca los enlaces en el array me.campos,
        // para mantener funcionalidad "TareaGenerica", los enlaces deben retirarse de me.campos
        var numEnlaces = 0;
        for (var i = 0; i < me.campos.length; i++) {
            if (me.campos[i].xtype == 'elcactivo') {
                ecActivo = me.campos[i];
                txtEcActivo = ecActivo.fieldLabel;
                if ("INVISIBLE" == ecActivo.name) {
                    esInvisibleEcActivo = true;
                }
                numEnlaces++;
            }

            if (me.campos[i].xtype == 'elctrabajo') {
                ecTrabajo = me.campos[i];
                txtEcTrabajo = ecTrabajo.fieldLabel;
                if ("INVISIBLE" == ecTrabajo.name) {
                    esInvisibleEcTrabajo = true;
                }
                numEnlaces++;
            }

            if (me.campos[i].xtype == 'elcexpediente') {
                ecExpediente = me.campos[i];
                txtEcExpediente = ecExpediente.fieldLabel;
                if ("INVISIBLE" == ecExpediente.name) {
                    esInvisibleEcExpediente = true;
                }
                numEnlaces++;
            }
        }

        //Listener afterrender, con
        // - Validacion PRE
        // - Advertencias tarea
        // - Visibilidad Enlace Trabajo
        // - Visibilidad Enlace Activo
        // - Visibilidad Enlace Expediente
        me.listeners = {
            afterrender: function() {
            	me.lookupController().getValidacionPrevia(me);
                me.lookupController().getAdvertenciaTarea(me);
                me.lookupController().getAdvertenciaTareaComercial(me);
                me.lookupController().verBotonEnlaceTrabajo(me, esInvisibleEcTrabajo);
                me.lookupController().verBotonEnlaceActivo(me, esInvisibleEcActivo);
                me.lookupController().verBotonEnlaceExpediente(me, esInvisibleEcExpediente);
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
            if (me.campos[i].allowBlank == 'false') {
                me.campos[i].allowBlank = false;
                me.campos[i].noObligatorio = false;
            } else {
                me.campos[i].allowBlank = true;
                me.campos[i].noObligatorio = true;
            }
            if (me.campos[i].xtype == 'datefield') {
                me.campos[i].labelWidth = 180;
            } else if (me.campos[i].xtype == 'textarea') {
                me.campos[i].labelWidth = 180;
                me.campos[i].width = '100%';
            } else {
                me.campos[i].labelWidth = 180;
            }

            me.campos[i].msgTarget = 'side';
            //Este switch seg�n el caso reutiliza las propiedades de items que se han
            // definido en el array "me.campos[]" o crean arrays de items nuevos.
            // Si creas un nuevo "case" y decides crear un array nuevo en lugar de reutilizar
            // "me.campos[]", debes definir todas las propiedades comunes que se han definido
            // en los que crean un objeto nuevo: "allowBlank", "blankText", "msgTarget"... 
            // Sirva como ejemplo cualquiera de los existentes.
            switch (me.campos[i].xtype) {
                case 'combobox':
                    var combo = {};
                    combo.xtype = 'genericcombo';
                    combo.name = me.campos[i].name;
                    combo.diccionario = me.campos[i].store;
                    combo.fieldLabel = me.campos[i].fieldLabel;
                    combo.readOnly = false;
                    combo.allowBlank = me.campos[i].noObligatorio;
                    combo.blankText = me.campos[i].blankText;
                    combo.msgTarget = me.campos[i].msgTarget;
                    if(me.campos[i].value != null){
                    	combo.value = me.campos[i].value; 
                    }
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
                    combo.blankText = me.campos[i].blankText;
                    combo.msgTarget = me.campos[i].msgTarget;
                    camposFiltrados.push(combo);
                    break;

                case 'textinf':
                    var textinf = {};
                    textinf.xtype = 'generictextlabel';
                    textinf.name = me.campos[i].name;
                    textinf.fieldLabel = me.campos[i].fieldLabel;
                    textinf.value = me.campos[i].value;
                    textinf.allowBlank = me.campos[i].noObligatorio;
                    textinf.blankText = me.campos[i].blankText;
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
                    combo.blankText = me.campos[i].blankText;
                    combo.msgTarget = me.campos[i].msgTarget;
                    camposFiltrados.push(combo);
                    break;

                case 'comboboxinicialedi':
                    var combo = {};
                    combo.xtype = 'genericcombo';
                    combo.name = me.campos[i].name;
                    combo.diccionario = me.campos[i].store;
                    combo.fieldLabel = me.campos[i].fieldLabel;
                    combo.value = me.campos[i].value;
                    combo.allowBlank = me.campos[i].noObligatorio;
                    combo.blankText = me.campos[i].blankText;
                    combo.msgTarget = me.campos[i].msgTarget;
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
                    me.campos[i].allowBlank = me.campos[i].noObligatorio;
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
                    me.campos[i].allowBlank = me.campos[i].noObligatorio;
                    camposFiltrados.push(me.campos[i]);
                    break;
                case 'datemintoday':
                    me.campos[i].xtype = 'datefield';
                    me.campos[i].minValue = $AC.getCurrentDate();
                    me.campos[i].allowBlank = me.campos[i].noObligatorio;
                    camposFiltrados.push(me.campos[i]);
                    break;
                case 'checkbox':
                    var checkbox = {};
                    checkbox.xtype = 'checkboxfield';
                    checkbox.name = me.campos[i].name;
                    checkbox.fieldLabel = me.campos[i].fieldLabel;
                    checkbox.readOnly = false;
                    checkbox.allowBlank = me.campos[i].noObligatorio;
                    checkbox.inputValue = true;
                    checkbox.uncheckedValue = false;
                    camposFiltrados.push(checkbox);
                    break;
                default:
                    camposFiltrados.push(me.campos[i]);
                    break;
            }

        }
        
        if(me.campos[me.campos.length - 1].xtype != 'displayfieldbase'){
	        camposFiltrados[camposFiltrados.length] = me.campos[me.campos.length - 1];
	        camposFiltrados[camposFiltrados.length - 1].labelWidth = 180;
	        camposFiltrados[camposFiltrados.length - 1].width = '100%';
	        camposFiltrados[camposFiltrados.length - 1].colspan = 2;
	        camposFiltrados[camposFiltrados.length - 1].rowspan = 4;
        }
        if (camposFiltrados.length % 2 == 0) {
            camposFiltrados[camposFiltrados.length - 2].labelWidth = 180;
            camposFiltrados[camposFiltrados.length - 2].colspan = 2;
        }

        me.items = [

            {
                xtype: 'form',
                reference: 'formVerificarOferta',
                layout: 'column',
                defaults: {
                    layout: 'form',
                    xtype: 'container',
                    defaultType: 'textfield',
                    style: 'width: 98%'
                },

                items: [{
                        xtype: 'label',
                        cls: '.texto-alerta',
                        bind: {
                            html: '{textoAdvertenciaTarea}'
                        },
                        style: 'color: red'
                    }, {
                        xtype: 'label',
                        cls: '.texto-alerta',
                        bind: {
                            html: '{textoAdvertenciaTareaComercial}'
                        },
                        style: 'color: red'
                    },{
                        xtype: 'label',
                        cls: 'info-tarea',
                        bind: {
                            html: '{errorValidacionGuardado}'
                        },
                        tipo: 'info',
                        style: 'color:red'
                    }, {
                        xtype: 'label',
                        cls: 'info-tarea',
                        bind: {
                            html: '{errorValidacion}'
                        },
                        tipo: 'info',
                        style: 'color:red'
                    }, {
                        xtype: 'fieldset',
                        collapsible: true,
                        defaultType: 'textfield',
                        defaults: {
                            style: 'width: 100%'
                        },
                        layout: 'column',
                        title: 'Instrucciones',

                        items: [{
                            xtype: 'label',
                            cls: 'info-tarea',
                            html: me.instrucciones,
                            tipo: 'info'
                        }]

                    }, {

                        xtype: 'fieldset',
                        collapsible: false,
                        reference: 'cuerpo', 
                        //defaultType : 'textfield',
                        layout: {
                            type: 'table',
                            columns: 2,
                            tableAttrs: {
                                style: {
                                    width: '100%'
                                }
                            }
                        },

                        items: camposFiltrados
                    },

                    {
                        xtype: 'fieldset',
                        collapsible: false,
                        defaultType: 'textfield',
                        defaults: {
                            style: 'width: 100%'
                        },
                        layout: 'column',
                        title: 'Enlaces directos',
                        hidden: (esInvisibleEcTrabajo && esInvisibleEcActivo && esInvisibleEcExpediente),
                        items: [{
                            xtype: 'button',
                            html: '<div style="color: #26607c">' + txtEcTrabajo + '</div>',
                            //cls : 'boton-link',
                            style: 'background: transparent; border: none;',
                            hidden: esInvisibleEcTrabajo,
                            reflinks: CONST.MAP_TAB_TRABAJO_XTYPE['' + ecTrabajo.name + ''],
                            handler: 'enlaceAbrirTrabajo'
                        }, {
                            xtype: 'button',
                            html: '<div style="color: #26607c">' + txtEcExpediente + '</div>',
                            //cls : 'boton-link',
                            style: 'background: transparent; border: none;',
                            hidden: esInvisibleEcExpediente,
                            reflinks: CONST.MAP_TAB_EXPEDIENTE_XTYPE['' + ecExpediente.name + ''],
                            handler: 'enlaceAbrirExpediente'
                        }, {
                            xtype: 'image',
                            height: 20,
                            width: 5,
                            bind: {
                                src: 'resources/images/separador.png'
                            }
                        }, {
                            xtype: 'button',
                            html: '<div style="color: #26607c">' + txtEcActivo + '</div>',
                            //cls : 'boton-link',
                            style: 'background: transparent; border: none;',
                            hidden: esInvisibleEcActivo,
                            reflinks: CONST.MAP_TAB_ACTIVO_XTYPE['' + ecActivo.name + ''],
                            handler: 'enlaceAbrirActivo'
                        }]

                    }

                ]

            }
        ];
        me.callParent();

        
        //El me. se puede sustituir por me.getLookupController() y meterlo dentro del controlador de vista.
        var validacion = eval('me.' + me.codigoTarea + 'Validacion');
        if (!Ext.isEmpty(validacion))
            eval('me.' + me.codigoTarea + 'Validacion()');

    },

    showMotivo: function(cmp, newValue, oldValue) {

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

    evaluar: function() {
        var me = this;

        var parametros = me.down("form").getValues();
        parametros.idTarea = me.idTarea;
        var urlTipoTitulo =  $AC.getRemoteUrl('agenda/getTipoTituloActivoByIdTarea');
		Ext.Ajax.request({
			
			url: urlTipoTitulo,
		     params: parametros,
		
		     success: function(response, opts) {
		    	 var data = Ext.decode(response.responseText);
		    	 var tipoTituloActivoCodigo = data.tipoTituloActivo;
		    	 if ("04" == tipoTituloActivoCodigo) {
		    		 Ext.MessageBox.alert(' ',HreRem.i18n('tarea.aviso.liquidacion.colaterales'));
		    	 }
		     }
		});

        //var url = $AC.getRemoteUrl('tarea/saveFormAndAdvance');
        var url = $AC.getRemoteUrl('agenda/save');
        Ext.Ajax.request({
            url: url,
            params: parametros,
            success: function(response, opts) {            	
                //me.parent.fireEvent('aftersaveTarea', me.parent);
                me.json = Ext.decode(response.responseText);
				if(me.json.errorTareaFinalizada){
					me.getViewModel().set("errorValidacionGuardado", "La tarea ya ha sido finalizada");
                    me.unmask();
				}else if (me.json.errorValidacionGuardado) {
                    me.getViewModel().set("errorValidacionGuardado", me.json.errorValidacionGuardado);
                    me.unmask();
                } else { 
                	var codigoTarea= me.codigoTarea;
                	// en este if actualizamos el grid de la pestaña Scoring o Seguro rentas, una vez finalizada las tareas Verificar... de cada uno.
                    if(!Ext.isEmpty(codigoTarea)){
                    	panelExpediente = me.up('activosmain').down('panel[title=Expediente '+me.numExpediente+']');
                    	if(!Ext.isEmpty(panelExpediente)){
	                    	if(CONST.TAREAS['T015_VERIFICARSCORING'] == codigoTarea){
	                    		var tabScoring = panelExpediente.down('scoringexpediente');
	                    		var grid = tabScoring.down('gridBaseEditableRow');
	                    		if(!Ext.isEmpty(grid)) {
	                    			store = grid.getStore();
	                    			store.load();
	                    		}
	                    	} else if(CONST.TAREAS['T015_VERIFICARSEGURORENTAS'] == codigoTarea){
	                    		var tabScoring = panelExpediente.down('segurorentasexpediente');
	                    		var grid = tabScoring.down('gridBaseEditableRow');
	                    		if(!Ext.isEmpty(grid)) {
	                    			store = grid.getStore();
	                    			store.load();
	                    		}
	                    	} else if(CONST.TAREAS['T013_DEFINICIONOFERTA'] == codigoTarea || CONST.TAREAS['T013_RESOLUCIONCOMITE'] == codigoTarea){
	                    		var url = $AC.getRemoteUrl('agenda/avanzarOfertasDependientes');
	                    		var data;
	                    		Ext.Ajax.request({
					    			url:url,
					    			params: parametros,
					    			success: function(response, opts) {
					    				 data = Ext.decode(response.responseText);
					    				if (data.success === "false" && data.msgError.length > 0) {
					    					me.fireEvent("errorToast", data.msgError);
				    						me.parent.fireEvent('aftersaveTarea', me.parent);
					    				}
					    			}
					    		});
	                    	}
                    	}
                    }
                    me.unmask();
                    //me.mostrarValidacionesPost();
                    me.fireEvent("refreshComponentOnActivate", "trabajosmain");
                    me.fireEvent("refreshComponentOnActivate", "agendamain");
                    me.fireEvent("refreshComponentOnActivate", "agendaalertasmain");
                    me.fireEvent("refreshComponentOnActivate", "agendaavisosmain");

                    // TODO: FALTA REFRESCAR EL EXPEDIENTE

                    if (!Ext.isEmpty(me.idTrabajo)) {
                        me.fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['TRABAJO'], me.idTrabajo);
                    }
                    if (!Ext.isEmpty(me.idActivo)) {
                        me.fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['ACTIVO'], me.idActivo);
                    }
                    if (!Ext.isEmpty(me.idExpediente)) {
                        me.fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['EXPEDIENTE'], me.idExpediente);
                    }
                    
                    
                    me.destroy();
                }

            },
            callback: function(response, opts, success) {
                me.parent.fireEvent('aftersaveTarea', me.parent);
            }
        });

    },
    obtenerIdEnlaces: {
        //Obtiene los ids necesarios para las entidades referenciadas en los enlaces


    },

    mostrarValidacionesPost: function() {

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

        me.down('[name=comboOcupado]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=comboTitulo]'));
            } else {
                me.deshabilitarCampo(me.down('[name=comboTitulo]'));
            }
        })
    },

    T002_AnalisisPeticionValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=comboGasto]'));
        me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));

        me.down('[name=comboTramitar]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=comboGasto]'));
                me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
            } else {
                me.deshabilitarCampo(me.down('[name=comboGasto]'));
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
            }
        })
    },

    T002_AutorizacionPropietarioValidacion: function() {
        var me = this;

        me.down('[name=fecha]').setValue($AC.getCurrentDate());

        me.deshabilitarCampo(me.down('[name=numIncremento]'));

        me.down('[name=comboAmpliacion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=numIncremento]'));
            } else {
                me.deshabilitarCampo(me.down('[name=numIncremento]'));
            }
        })
    },

    T002_ObtencionLPOGestorInternoValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaEmision]'));
        me.deshabilitarCampo(me.down('[name=refDocumento]'));
        me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));

        me.down('[name=comboObtencion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=fechaEmision]'));
                me.habilitarCampo(me.down('[name=refDocumento]'));
                me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));
            } else {
                me.deshabilitarCampo(me.down('[name=fechaEmision]'));
                me.deshabilitarCampo(me.down('[name=refDocumento]'));
                me.habilitarCampo(me.down('[name=motivoNoObtencion]'));
            }
        })
    },


    T002_ObtencionDocumentoGestoriaValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaObtencion]'));
        me.deshabilitarCampo(me.down('[name=refDocumento]'));
        me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));

        me.down('[name=comboObtencion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=fechaObtencion]'));
                me.habilitarCampo(me.down('[name=refDocumento]'));
                me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));
            } else {
                me.deshabilitarCampo(me.down('[name=fechaObtencion]'));
                me.deshabilitarCampo(me.down('[name=refDocumento]'));
                me.habilitarCampo(me.down('[name=motivoNoObtencion]'));
            }
        })
    },

    T002_SolicitudExtraordinariaValidacion: function() {
        var me = this;

        me.down('[name=fecha]').setValue($AC.getCurrentDate());
    },

    T002_ValidacionActuacionValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
        me.deshabilitarCampo(me.down('[name=comboValoracion]'));
        //me.deshabilitarCampo(me.down('[name=fechaValidacion]'));

        me.down('[name=comboCorreccion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
                me.habilitarCampo(me.down('[name=comboValoracion]'));
                //me.habilitarCampo(me.down('[name=fechaValidacion]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoIncorreccion]'));
                me.deshabilitarCampo(me.down('[name=comboValoracion]'));
                //me.deshabilitarCampo(me.down('[name=fechaValidacion]'));
            }
        })
    },

    T003_AnalisisPeticionValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=comboSaldo]'));
        me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));

        me.down('[name=comboTramitar]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=comboSaldo]'));
                me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
            } else {
                me.deshabilitarCampo(me.down('[name=comboSaldo]'));
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
            }
        })
    },

    T003_EmisionCertificadoValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoNoEmision]'));
        me.deshabilitarCampo(me.down('[name=fechaEmision]'));
        me.deshabilitarCampo(me.down('[name=comboCalificacion]'));
        me.deshabilitarCampo(me.down('[name=comboProcede]'));

        me.down('[name=comboEmision]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoNoEmision]'));
                me.habilitarCampo(me.down('[name=fechaEmision]'));
                me.habilitarCampo(me.down('[name=comboCalificacion]'));
                me.habilitarCampo(me.down('[name=comboProcede]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoNoEmision]'));
                me.deshabilitarCampo(me.down('[name=fechaEmision]'));
                me.deshabilitarCampo(me.down('[name=comboCalificacion]'));
                me.deshabilitarCampo(me.down('[name=comboProcede]'));
            }
        })
    },

    T003_AutorizacionPropietarioValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=numIncremento]'));

        me.down('[name=comboAmpliacion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=numIncremento]'));
            } else {
                me.deshabilitarCampo(me.down('[name=numIncremento]'));
            }
        })
    },

    T004_AnalisisPeticionValidacion: function() {
        var me = this;
		var esTarifaPlana = me.up('tramitesdetalle').getViewModel().get('tramite.esTarifaPlana');
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		var codigoSubcartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoSubcartera');
		
		if(CONST.CARTERA['SAREB'] == codigoCartera && CONST.SUBCARTERA['SAREBINMOBILIARIO'] == codigoSubcartera) {
			me.ocultarCampo(me.down('[name=huecoTP]'));
		}else{
			if(me.down('[name=comboTarifaPlana]') != null){
				me.ocultarCampo(me.down('[name=comboTarifaPlana]'));
			}
		}
		
		if(me.down('[name=comboAseguradoras]') != null){
			me.deshabilitarCampo(me.down('[name=comboAseguradoras]'));
		}
		if(me.down('[name=motivoDenegacion]')){
			me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
		}
		if(me.down('[name=comboTarifaPlana]')){
			me.deshabilitarCampo(me.down('[name=comboTarifaPlana]'));
		}
        if (esTarifaPlana && CONST.CARTERA['SAREB'] != codigoCartera) {
            me.bloquearCampo(me.down('[name=comboTarifa]'));
        }

        me.down('[name=comboTramitar]').addListener('change', function(combo) {
            if (combo.value == '01') {
            	me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
                me.habilitarCampo(me.down('[name=comboCubierto]'));   
                me.habilitarCampo(me.down('[name=comboTarifaPlana]'));
                if (me.down('[name=comboCubierto]').value == '01') {
                    me.habilitarCampo(me.down('[name=comboAseguradoras]'));
                }
                me.habilitarCampo(me.down('[name=comboTarifa]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
                me.deshabilitarCampo(me.down('[name=comboCubierto]'));
                me.deshabilitarCampo(me.down('[name=comboAseguradoras]'));
                me.deshabilitarCampo(me.down('[name=comboTarifa]'));
                me.deshabilitarCampo(me.down('[name=comboTarifaPlana]'));
            }
        });

        me.down('[name=comboCubierto]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=comboAseguradoras]'));
            } else {
                me.deshabilitarCampo(me.down('[name=comboAseguradoras]'));
            }
        });





    },


    T004_EleccionPresupuestoValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoInvalidez]'));

        me.down('[name=comboPresupuesto]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoInvalidez]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoInvalidez]'));
            }
        })

    },


    T004_AutorizacionPropietarioValidacion: function() {
        var me = this;
        
        if(CONST.CARTERA['LIBERBANK']===me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera')){
        	me.ocultarCampo(me.down('[name=numIncremento]'));
        	me.ocultarCampo(me.down('[name=comboAmpliacion]'));
        	me.deshabilitarCampo(me.down('[name=numIncremento]'));
        	me.deshabilitarCampo(me.down('[name=comboAmpliacion]'));
        }else{
        	me.ocultarCampo(me.down('[name=comboAmpliacionYAutorizacion]'));
        	me.deshabilitarCampo(me.down('[name=comboAmpliacionYAutorizacion]'));
        	me.deshabilitarCampo(me.down('[name=numIncremento]'));
        	me.down('[name=comboAmpliacion]').addListener('change', function(combo) {
                if (combo.value == '01') {
                    me.habilitarCampo(me.down('[name=numIncremento]'));
                } else {
                    me.deshabilitarCampo(me.down('[name=numIncremento]'));
                }
            });
        }
    },


    T004_FijacionPlazoValidacion: function() {

        var me = this;
        var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');

        var fechaTope = me.down('[name=fechaTope]');
        var fechaConcreta = me.down('[name=fechaConcreta]');
        var horaConcreta = me.down('[name=horaConcreta]');

        me.down('[name=fechaTope]').allowBlank = true;
        me.down('[name=fechaConcreta]').allowBlank = true;
        me.down('[name=horaConcreta]').allowBlank = true;
        
        if(CONST.CARTERA['CERBERUS'] == codigoCartera || CONST.CARTERA['EGEO'] == codigoCartera){
        	me.down('[name=fechaConcreta]').allowBlank = false;
        }else{
        	me.down('[name=fechaConcreta]').allowBlank = true;
        }

        if(fechaTope.value != '' && fechaTope.value !=null){
            me.down('[name=fechaConcreta]').allowBlank = true;
            me.down('[name=horaConcreta]').allowBlank = true;
        }

         if((fechaConcreta.value != '' && fechaConcreta.value !=null)
                && (horaConcreta.value != '' && horaConcreta.value !=null)){
            me.down('[name=fechaTope]').allowBlank = true;
        }
        
        me.down('[name=fechaTope]').addListener('change', function(combo) {
	       if (combo.value != '' && combo.value != null) {
		       me.borrarCampo(me.down('[name=fechaConcreta]'));
		       me.borrarCampo(me.down('[name=horaConcreta]'));
		       me.down('[name=fechaConcreta]').allowBlank = true;
	           me.down('[name=horaConcreta]').allowBlank = true;
	           me.down('[name=fechaTope]').allowBlank = false;
	           me.down('[name=fechaConcreta]').validate();
	           me.down('[name=horaConcreta]').validate();
	       } else {
		       me.down('[name=fechaTope]').allowBlank = true;
		       me.down('[name=fechaTope]').validate();
	       }
        });
        
        me.down('[name=fechaConcreta]').addListener('change', function(combo) {    	
	       if (combo.value != '' && combo.value != null) {
		       me.borrarCampo(me.down('[name=fechaTope]'));
		       me.down('[name=fechaConcreta]').allowBlank = false;
		       me.down('[name=horaConcreta]').allowBlank = false;
		       me.down('[name=fechaTope]').allowBlank = true;
		       me.down('[name=fechaTope]').validate();
	       } else {
	       		me.down('[name=fechaConcreta]').allowBlank = true;
	       		me.down('[name=horaConcreta]').allowBlank = true;
	       		me.down('[name=fechaConcreta]').validate();
	       		me.down('[name=horaConcreta]').validate();
	       }
        });
        
        me.down('[name=horaConcreta]').addListener('change', function(combo) {
	       if (combo.value != '' && combo.value != null) {
	       	me.borrarCampo(me.down('[name=fechaTope]'));
	       	me.down('[name=fechaConcreta]').allowBlank = false;
	           me.down('[name=horaConcreta]').allowBlank = false;
	           me.down('[name=fechaTope]').allowBlank = true;
	           me.down('[name=fechaTope]').validate();
	       } else {
	       	me.down('[name=fechaConcreta]').allowBlank = true;
	           me.down('[name=horaConcreta]').allowBlank = true;
	           me.down('[name=fechaConcreta]').validate();
	           me.down('[name=horaConcreta]').validate();
	       }
        });        
    },

    T004_ResultadoNoTarificadaValidacion: function() {
        var me = this;

        var fechaFinalizacion = me.down('[name=fechaFinalizacion]');
        var motivoNoRealizacion = me.down('[name=motivoNoRealizacion]');
        var comboModificacion = me.down('[name=comboModificacion]');
        var fechaAtPrimaria = me.down('[name=fechaAtPrimaria]');
        var comboRealizacion = me.down('[name=comboRealizacion]');
        var observaciones = me.down('[name=observaciones]');
        
        me.deshabilitarCampo(fechaFinalizacion);
        me.deshabilitarCampo(motivoNoRealizacion);

//        comboModificacion.addListener('change', function(combo) {
//            if (combo.value == '01') {
//                me.deshabilitarCampo(fechaFinalizacion);
//            } else if (combo.value == '02') {
//                me.habilitarCampo(fechaFinalizacion);
//            }
//        });
        comboRealizacion.addListener('change', function(combo) {
        	 if (combo.value == '02') {
        		 
        		me.deshabilitarCampo(comboModificacion);
              	me.deshabilitarCampo(fechaFinalizacion);
              	me.deshabilitarCampo(fechaAtPrimaria);
              	
              	me.borrarCampo(comboModificacion);
              	me.borrarCampo(fechaFinalizacion);
              	me.borrarCampo(fechaAtPrimaria);
              	
              	me.habilitarCampo(motivoNoRealizacion);

        	 }else if (combo.value == '01'){
        		me.habilitarCampo(comboModificacion);
              	me.habilitarCampo(fechaAtPrimaria);
              	me.habilitarCampo(fechaFinalizacion);
              	 
              	me.deshabilitarCampo(motivoNoRealizacion);
              	me.borrarCampo(motivoNoRealizacion);
        	 }
        });

    },
    
    T004_ResultadoTarificadaValidacion: function() {
    	var me = this;
    	
    	var fechaFinalizacion = me.down('[name=fechaFinalizacion]');
    	var fechaAtPrimaria = me.down('[name=fechaAtPrimaria]');
    	var comboRealizacion = me.down('[name=comboRealizacion]');
    	var motivoNoRealizacion = me.down('[name=motivoNoRealizacion]');
    	var observaciones = me.down('[name=observaciones]');
    	
    	me.deshabilitarCampo(motivoNoRealizacion);
    	
    	comboRealizacion.addListener('change', function(combo) {
       	 if (combo.value == '02') {
       		 
             me.deshabilitarCampo(fechaFinalizacion);
             me.deshabilitarCampo(fechaAtPrimaria);
             	
             me.borrarCampo(fechaFinalizacion);
             me.borrarCampo(fechaAtPrimaria);
             	
             me.habilitarCampo(motivoNoRealizacion);

       	 }else if (combo.value == '01'){
       		 
       		 me.habilitarCampo(fechaAtPrimaria);
             me.habilitarCampo(fechaFinalizacion);
       		 
       		 me.deshabilitarCampo(motivoNoRealizacion);
       		 me.borrarCampo(motivoNoRealizacion);
       	 }
       	}); 
    },

    T004_ValidacionTrabajoValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
        me.deshabilitarCampo(me.down('[name=fechaValidacion]'));
        me.deshabilitarCampo(me.down('[name=comboValoracion]'));

        me.down('[name=comboEjecutado]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
                me.habilitarCampo(me.down('[name=fechaValidacion]'));
                me.habilitarCampo(me.down('[name=comboValoracion]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoIncorreccion]'));
                me.deshabilitarCampo(me.down('[name=fechaValidacion]'));
                me.deshabilitarCampo(me.down('[name=comboValoracion]'));
            }
        })
    },
    
    T004_CierreEconomicoValidacion: function() {
    	var me = this;
    	var codigoSubtipoTrabajo = me.up('tramitesdetalle').getViewModel().get("tramite.codigoSubtipoTrabajo");
    	var activoAplicaGestion = me.up('tramitesdetalle').getViewModel().get("tramite.activoAplicaGestion");
    	
    	if(CONST.SUBTIPOS_TRABAJO['TOMA_POSESION'] != codigoSubtipoTrabajo){
    		me.deshabilitarCampo(me.down('[name=tieneOkTecnico]'));
    		me.ocultarCampo(me.down('[name=tieneOkTecnico]'));
    	}
    	
    	if(!activoAplicaGestion){
    		me.deshabilitarCampo(me.down('[name=tieneOkTecnico]'));
    	}
    },

    T005_AnalisisPeticionValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
        me.deshabilitarCampo(me.down('[name=comboSaldo]'));
        me.bloquearCampo(me.down('[name=saldoDisponible]'));

        me.down('[name=comboTramitar]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=comboSaldo]'));
                me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
            } else {
                me.deshabilitarCampo(me.down('[name=comboSaldo]'));
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
            }
        })
    },

    T005_AutorizacionPropietarioValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=numIncremento]'));

        me.down('[name=comboAmpliacion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=numIncremento]'));
            } else {
                me.deshabilitarCampo(me.down('[name=numIncremento]'));
            }
        })
    },

    T006_AnalisisPeticionValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
        me.deshabilitarCampo(me.down('[name=comboSaldo]'));
        me.bloquearCampo(me.down('[name=saldoDisponible]'));

        me.down('[name=comboTramitar]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=comboSaldo]'));
                me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
            } else {
                me.deshabilitarCampo(me.down('[name=comboSaldo]'));
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
            }
        })
    },

    T006_AutorizacionPropietarioValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=numIncremento]'));

        me.down('[name=comboAmpliacion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=numIncremento]'));
            } else {
                me.deshabilitarCampo(me.down('[name=numIncremento]'));
            }
        })
    },

    T006_EmisionInformeValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaEmision]'));
        me.deshabilitarCampo(me.down('[name=motivoNoEmision]'));

        me.down('[name=comboImposibilidad]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.down('[name=motivoNoEmision]').reset();
                me.deshabilitarCampo(me.down('[name=motivoNoEmision]'));
                me.habilitarCampo(me.down('[name=fechaEmision]'));
            } else {
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

        me.down('[name=comboCorreccion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.down('[name=motivoIncorreccion]').reset();
                me.deshabilitarCampo(me.down('[name=motivoIncorreccion]'));
                me.habilitarCampo(me.down('[name=comboValoracion]'));
                me.habilitarCampo(me.down('[name=fechaValidacion]'));
                me.down('[name=fechaValidacion]').setValue($AC.getCurrentDate());
            } else {
                me.down('[name=fechaValidacion]').reset();
                me.down('[name=comboValoracion]').reset();
                me.habilitarCampo(me.down('[name=motivoIncorreccion]'));
                me.deshabilitarCampo(me.down('[name=comboValoracion]'));
                me.deshabilitarCampo(me.down('[name=fechaValidacion]'));
            }
        })
    },

    T008_AnalisisPeticionValidacion: function() {
        var me = this;
        me.deshabilitarCampo(me.down('[name=motivoDenegar]'));

        me.down('[name=comboTramitar]').addListener('change', function(combo) {

            if (combo.value === '02') {
                me.habilitarCampo(me.down('[name=motivoDenegar]'));
                me.down('[name=motivoDenegar]').allowBlank = false;
            } else {
                me.deshabilitarCampo(me.down('[name=motivoDenegar]'));
                me.down('[name=motivoDenegar]').allowBlank = true;
            }

        });

    },

    T008_ObtencionDocumentoValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaEmision]'));
        me.deshabilitarCampo(me.down('[name=refDocumento]'));
        me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));

        me.down('[name=comboObtencion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=fechaEmision]'));
                me.down('[name=fechaEmision]').allowBlank = false;
                me.habilitarCampo(me.down('[name=refDocumento]'));
                me.deshabilitarCampo(me.down('[name=motivoNoObtencion]'));
                me.down('[name=motivoNoObtencion]').allowBlank = true;
            } else {
                me.deshabilitarCampo(me.down('[name=refDocumento]'));
                me.habilitarCampo(me.down('[name=motivoNoObtencion]'));
                me.down('[name=motivoNoObtencion]').allowBlank = false;

                if (me.down('[name=motivoNoObtencion]').value == '02') {
                    me.habilitarCampo(me.down('[name=fechaEmision]'));
                    me.down('[name=fechaEmision]').allowBlank = false;
                } else {
                    me.deshabilitarCampo(me.down('[name=fechaEmision]'));
                    me.down('[name=fechaEmision]').allowBlank = true;
                }
            }
        });

        me.down('[name=motivoNoObtencion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=fechaEmision]'));
                me.down('[name=fechaEmision]').allowBlank = true;
            } else {
                me.habilitarCampo(me.down('[name=fechaEmision]'));
                me.down('[name=fechaEmision]').allowBlank = false;
            }
        })

    },

    T008_CierreEconomicoValidacion: function() {
        var me = this;
        me.down('[name=fechaCierre]').setValue($AC.getCurrentDate());
    },

    T009_AnalisisPeticionValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
        me.campoObligatorio(me.down('[name=comboTramitar]'));

        me.down('[name=comboTramitar]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
                me.down('[name=motivoDenegacion]').noObligatorio=false;
            }
        })
    },

    T009_GenerarPropuestaPreciosValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaGeneracion]'));
        me.deshabilitarCampo(me.down('[name=nombrePropuesta]'));

    },

    T010_AnalisisPeticionCargaListValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));

        me.down('[name=comboAceptacion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
            }
        })
    },

    T011_RevisionInformeComercialValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));

        me.down('[name=comboAceptacion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
            }
        })
    },

    T011_AnalisisPeticionCorreccionValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoRechazo]'));

        me.down('[name=comboAceptacion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoRechazo]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoRechazo]'));
            }
        })
    },

    T012_AnalisisPeticionActualizacionEstadoValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));

        me.down('[name=comboAceptacion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
            }
        })
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
					me.campoNoObligatorio(comite);
					me.desocultarCampo(comitePropuesto);
					me.campoNoObligatorio(comitePropuesto);
					me.desocultarCampo(importeTotalOfertaAgrupada);
					me.bloquearCampo(me.down('[name=importeTotalOfertaAgrupada]'));
					me.desocultarCampo(huecoVenta);  	
				}else if(claseOferta == '02'){
					 me.desocultarCampo(numOfertaPrincipal);
					 me.bloquearCampo(me.down('[name=numOfertaPrincipal]'));
					 me.ocultarCampo(comitePropuesto);
					 me.ocultarCampo(comboConflicto);
					 me.ocultarCampo(comboRiesgo);
					 me.ocultarCampo(fechaEnvio);
					 me.ocultarCampo(observaciones);
					 me.ocultarCampo(comite);
					 me.desocultarCampo(huecoVenta);
					 
				}else{					
					 me.ocultarCampo(comite);
					 me.campoNoObligatorio(comite);
					 me.desocultarCampo(comitePropuesto);
					 me.campoNoObligatorio(comitePropuesto);
					 me.desocultarCampo(importeTotalOfertaAgrupada);
					 me.bloquearCampo(me.down('[name=importeTotalOfertaAgrupada]'));
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
		    						me.campoNoObligatorio(comite);
		    						me.desocultarCampo(comitePropuesto);
		    						me.campoNoObligatorio(comitePropuesto);
		    						me.desocultarCampo(importeTotalOfertaAgrupada);
		    						me.bloquearCampo(me.down('[name=importeTotalOfertaAgrupada]'));
		    						me.desocultarCampo(huecoVenta);  	
		    					}else if(claseOferta == '02'){
		    						 me.desocultarCampo(numOfertaPrincipal);
		    						 me.bloquearCampo(me.down('[name=numOfertaPrincipal]'));
		    						 me.ocultarCampo(comitePropuesto);
		    						 me.ocultarCampo(comboConflicto);
		    						 me.ocultarCampo(comboRiesgo);
		    						 me.ocultarCampo(fechaEnvio);
		    						 me.ocultarCampo(observaciones);
		    						 me.ocultarCampo(comite);
		    						 me.desocultarCampo(huecoVenta);
		    						 
		    					}else{					
		    						 me.ocultarCampo(comite);
		    						 me.campoNoObligatorio(comite);
		    						 me.desocultarCampo(comitePropuesto);
		    						 me.campoNoObligatorio(comitePropuesto);
		    						 me.desocultarCampo(importeTotalOfertaAgrupada);
		    						 me.bloquearCampo(me.down('[name=importeTotalOfertaAgrupada]'));
		    						 me.desocultarCampo(huecoVenta);
		    					}
		    			}
		    	});
			}			
		}
	},
	
	T013_PBCReservaValidacion: function() {
        var me = this;
        me.campoObligatorio(me.down('[name=comboRespuesta]'));
    }, 
	
	T013_DocumentosPostVentaValidacion: function() {
		var me = this;
		var fechaIngreso = me.down('[name=fechaIngreso]');
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		var codigoSubcartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoSubcartera');
		fechaIngreso.setMaxValue($AC.getCurrentDate());
		me.down('[name=fechaIngreso]').allowBlank = false;
		
		if(CONST.CARTERA['BANKIA'] == codigoCartera && CONST.SUBCARTERA['BH'] != codigoSubcartera){
			me.deshabilitarCampo(me.down('[name=checkboxVentaDirecta]'));
			me.deshabilitarCampo(me.down('[name=fechaIngreso]'));
		} else if(CONST.CARTERA['CAJAMAR'] == codigoCartera) {
			me.deshabilitarCampo(me.down('[name=fechaIngreso]'));
		} else if(!Ext.isEmpty(fechaIngreso.getValue()) && (CONST.CARTERA['CERBERUS'] == codigoCartera && CONST.SUBCARTERA['AGORAINMOBILIARIO'] != codigoSubcartera)) {
			me.deshabilitarCampo(me.down('[name=checkboxVentaDirecta]'));
			me.bloquearCampo(me.down('[name=fechaIngreso]'));
		} else if(Ext.isEmpty(fechaIngreso.getValue()) && (CONST.CARTERA['CERBERUS'] == codigoCartera && CONST.SUBCARTERA['AGORAINMOBILIARIO'] != codigoSubcartera)) {
			me.habilitarCampo(me.down('[name=checkboxVentaDirecta]'));
			me.deshabilitarCampo(me.down('[name=fechaIngreso]'));
		} else if(CONST.CARTERA['LIBERBANK'] == codigoCartera){
			me.habilitarCampo(me.down('[name=fechaIngreso]'));
		}

		me.down('[name=checkboxVentaDirecta]').addListener('change', function(checkbox, newValue, oldValue, eOpts) {
			if(CONST.CARTERA['LIBERBANK'] != codigoCartera && CONST.CARTERA['CAJAMAR'] != codigoCartera && (CONST.CARTERA['CERBERUS'] == codigoCartera && CONST.SUBCARTERA['AGORAINMOBILIARIO'] != codigoSubcartera)){
				if (newValue) {
	            	me.habilitarCampo(me.down('[name=fechaIngreso]'));
	            	me.down('[name=fechaIngreso]').validate();
	            } else {
	            	me.deshabilitarCampo(me.down('[name=fechaIngreso]'));
	            	me.campoNoObligatorio(me.down('[name=fechaIngreso]'));
	            	me.down('[name=fechaIngreso]').reset();
	            }
			}
        })
	},
    T013_FirmaPropietarioValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaFirma]'));
        me.deshabilitarCampo(me.down('[name=notario]'));
        me.deshabilitarCampo(me.down('[name=numProtocolo]'));
        me.deshabilitarCampo(me.down('[name=precioEscrituracion]'));
        me.deshabilitarCampo(me.down('[name=motivoAnulacion]'));

        me.down('[name=comboFirma]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=fechaFirma]'));
                me.habilitarCampo(me.down('[name=notario]'));
                me.habilitarCampo(me.down('[name=numProtocolo]'));
                me.habilitarCampo(me.down('[name=precioEscrituracion]'));
                me.deshabilitarCampo(me.down('[name=motivoAnulacion]'));
            } else {
                me.deshabilitarCampo(me.down('[name=fechaFirma]'));
                me.deshabilitarCampo(me.down('[name=notario]'));
                me.deshabilitarCampo(me.down('[name=numProtocolo]'));
                me.deshabilitarCampo(me.down('[name=precioEscrituracion]'));
                me.habilitarCampo(me.down('[name=motivoAnulacion]'));
            }
        })
    },
    
    T013_ObtencionContratoReservaValidacion: function(){
    	var me = this;
        var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');

    	if((me.down('[name=fechaFirma]').getValue()!=null && me.down('[name=fechaFirma]').getValue()!="") || (CONST.CARTERA['LIBERBANK'] == codigoCartera)){
    		me.down('[name=fechaFirma]').setReadOnly(true);
        	
    	}
    },

    T013_ResolucionComiteValidacion: function() {
        var me = this;
        var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
        var idExp = me.up('tramitesdetalle').getViewModel().get('tramite.idExpediente');
        var comboResolucion = me.down('[name=comboResolucion]');
        var comitePropuesto = me.down('[name=comitePropuesto]');
        var importeTotalOfertaAgrupada = me.down('[name=importeTotalOfertaAgrupada]');
        var comboResolucionComite = me.down('[name=comiteSancionador]');

        if (me.down('[name=comboResolucion]').getValue() != '03') {
            me.deshabilitarCampo(me.down('[name=numImporteContra]'));
        }
        if(CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.down('[name=comboResolucion]').setReadOnly(true);
			me.down('[name=numImporteContra]').setReadOnly(true);
			me.down('[name=fechaRespuesta]').setReadOnly(true);
        }
        else{
        	me.down('[name=comboResolucion]').setReadOnly(false);
			me.down('[name=numImporteContra]').setReadOnly(false);
			me.down('[name=fechaRespuesta]').setReadOnly(false);
        }
		if(CONST.CARTERA['LIBERBANK'] != codigoCartera) {
			me.down('[name=fechaReunionComite]').hide();
			me.ocultarCampo(comitePropuesto);
			me.ocultarCampo(importeTotalOfertaAgrupada);
		}else{
			me.desbloquearCampo(comboResolucion);
			me.bloquearCampo(comitePropuesto);
			
			comboResolucionComite.setStore(new Ext.data.Store({
													model: 'HreRem.model.DDBase',
												    autoLoad: true,
												    proxy: Ext.create('HreRem.ux.data.Proxy',{
														remoteUrl: 'generic/getComitesResolucionLiberbank',
														extraParams: {idExp: idExp}
													})
												})
											);
			
			comboResolucionComite.allowBlank = false;
											
			var url = $AC.getRemoteUrl('ofertas/getClaseOferta');
	    	Ext.Ajax.request({
	    			url:url,
	    			params: {idExpediente : idExp},
	    			success: function(response,opts){
	    				 var claseOferta = Ext.JSON.decode(response.responseText).claseOferta;
	    				 if(claseOferta == '03'){
	    					 me.ocultarCampo(comitePropuesto);
	    					 me.ocultarCampo(importeTotalOfertaAgrupada);
	    				 }else if(claseOferta == '01' || claseOferta == '02'){
	    				 	me.bloquearCampo(importeTotalOfertaAgrupada);
	    				 }
	    			}
	    	});
		}
		if(CONST.CARTERA['GIANTS'] == codigoCartera && $AU.userIsRol(CONST.PERFILES['GESTOR_COMERCIAL'])){
    		if(me.down('[name=fechaRespuesta]').getValue() != null && me.down('[name=fechaRespuesta]').getValue() != ""){
    			me.down('[name=fechaRespuesta]').setReadOnly(true);
    		}
    		if(me.down('[name=comboResolucion]').getValue() != null && me.down('[name=comboResolucion]').getValue() != ""){
    			me.down('[name=comboResolucion]').setReadOnly(true);
    		}
    		if(me.down('[name=numImporteContra]').getValue() != null && me.down('[name=numImporteContra]').getValue() != ""){
    			me.down('[name=numImporteContra]').setReadOnly(true);
    		}
    		if(me.down('[name=observaciones]').getValue() != null && me.down('[name=observaciones]').getValue() != ""){
    			me.down('[name=observaciones]').setReadOnly(true);
    		}
    	}
    	
        me.down('[name=comboResolucion]').addListener('change', function(combo) {
            if (combo.value == '03') {
                me.habilitarCampo(me.down('[name=numImporteContra]'));
                me.down('[name=numImporteContra]').allowBlank = false;
            } else {
                me.deshabilitarCampo(me.down('[name=numImporteContra]'));
                me.down('[name=numImporteContra]').reset();
                me.down('[name=numImporteContra]').allowBlank = true;
            }
        })
    },

    T013_RespuestaOfertanteValidacion: function(){
    	var me = this;
    	var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
    	if(CONST.CARTERA['BANKIA'] == codigoCartera) {
	    	if (me.down('[name=comboRespuesta]').getValue() != '03') {
	            me.deshabilitarCampo(me.down('[name=importeOfertante]'));
	        }
	
	        me.down('[name=comboRespuesta]').addListener('change', function(combo) {
	            if (combo.value == '03') {
	                me.habilitarCampo(me.down('[name=importeOfertante]'));
	            } else {
	                me.deshabilitarCampo(me.down('[name=importeOfertante]'));
	            }
	        });
    	}else{
    		me.deshabilitarCampo(me.down('[name=importeOfertante]'));
    		me.down('[name=comboRespuesta]').addListener('focus', function(combo) {
				me.down('[name=comboRespuesta]').getStore().removeAt(2); //Quitar Contraoferta
			});
    	}
    },
    
    T013_RatificacionComiteValidacion: function(){
    	var me = this;
    	var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		var comboRatificacion = me.down('[name=comboRatificacion]');
		var fechaRespuesta = me.down('[name=fechaRespuesta]');
		var importeContraoferta = me.down('[name=importeContraoferta]');
		if(CONST.CARTERA['BANKIA'] != codigoCartera) {
			comboRatificacion.setReadOnly(false);
			fechaRespuesta.setReadOnly(false);
			me.ocultarCampo(importeContraoferta);
			comboRatificacion.addListener('focus', function(combo) {
				comboRatificacion.getStore().removeAt(2); //Quitar Contraoferta
			});
		}else{
			comboRatificacion.setReadOnly(true);
			fechaRespuesta.setReadOnly(true);
			me.desocultarCampo(importeContraoferta);
			if(comboRatificacion.value == '03'){
					me.habilitarCampo(importeContraoferta);
				}else{
					me.deshabilitarCampo(importeContraoferta);	
				}
			comboRatificacion.addListener('change', function(combo) {
				if(combo.value == '03'){
					me.habilitarCampo(importeContraoferta);
				}else{
					me.deshabilitarCampo(importeContraoferta);	
				}	
			});
		}
    	
    },
    
    T013_ResultadoPBCValidacion: function() {
        var me = this;
        
        var codigoSubcartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoSubcartera');
        if (CONST.SUBCARTERA['OMEGA'] == codigoSubcartera) {
        	me.title = HreRem.i18n('fieldset.salto.tarea.pbc.venta');
        } else {
        	me.title = HreRem.i18n('fieldset.salto.tarea.resultado.pbc');
        }
    },

    T013_ResolucionTanteoValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=administracion]'));
        me.deshabilitarCampo(me.down('[name=nif]'));

        me.down('[name=comboEjerce]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=administracion]'));
                me.habilitarCampo(me.down('[name=nif]'));
            } else {
                me.deshabilitarCampo(me.down('[name=administracion]'));
                me.deshabilitarCampo(me.down('[name=nif]'));
            }
        });
    },

    T013_PosicionamientoYFirmaValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaFirma]'));
        me.deshabilitarCampo(me.down('[name=motivoNoFirma]'));
        me.deshabilitarCampo(me.down('[name=obsAsisPBC]'));
        me.down('[name=tieneReserva]').hide();

        me.down('[name=comboFirma]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=fechaFirma]'));
                me.habilitarCampo(me.down('[name=numProtocolo]'));
                me.habilitarCampo(me.down('[name=comboCondiciones]'));
                me.habilitarCampo(me.down('[name=condiciones]'));

                me.deshabilitarCampo(me.down('[name=motivoNoFirma]'));
                me.down('[name=motivoNoFirma]').reset();

            } else {

                var tieneReserva = me.down('[name=tieneReserva]');
                if (tieneReserva.value == '01') {
                    me.deshabilitarCampo(me.down('[name=motivoNoFirma]'));
                    me.down('[name=motivoNoFirma]').reset();
                } else {
                    me.habilitarCampo(me.down('[name=motivoNoFirma]'));
                }
                me.deshabilitarCampo(me.down('[name=fechaFirma]'));
                me.deshabilitarCampo(me.down('[name=numProtocolo]'));
                me.deshabilitarCampo(me.down('[name=comboCondiciones]'));
                me.deshabilitarCampo(me.down('[name=condiciones]'));
                me.down('[name=fechaFirma]').reset();
                me.down('[name=numProtocolo]').reset();
                me.down('[name=comboCondiciones]').reset();
                me.down('[name=condiciones]').reset();
            }
        });
        
        me.down('[name=asistenciaPBC]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=obsAsisPBC]'));
            } else {
            	me.habilitarCampo(me.down('[name=obsAsisPBC]'));
            }
        });
    },

    T013_ResolucionExpedienteValidacion: function() {
        var me = this;
        var tipoArras = me.down('[name=tipoArras]');
        var estadoReserva = me.down('[name=estadoReserva]');
        var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		var storeMotivoAnulacion = me.down('[name=motivoAnulacion]').getStore();

        me.deshabilitarCampo(me.down('[name=comboProcede]'));
        if(CONST.CARTERA['BANKIA'] == codigoCartera) {
        	me.deshabilitarCampo(me.down('[name=comboMotivoAnulacionReserva]'));
        } else {
        	me.campoNoObligatorio(me.down('[name=comboMotivoAnulacionReserva]'));
        	me.down('[name=comboMotivoAnulacionReserva]').setHidden(true);
        }

        if (!Ext.isEmpty(estadoReserva) && estadoReserva.value == 'Firmada') {
            me.habilitarCampo(me.down('[name=comboProcede]'));
        }

        me.down('[name=comboProcede]').addListener('change', function(combo) {
            if (combo.value == '01' && tipoArras.value == 'Confirmatorias') {
                me.down('[name=comboProcede]').blankText = HreRem.i18n('tarea.validacion.error.valor.no.permitido.by.tipo.arras');
                me.down('[name=comboProcede]').reset();
            } else if((combo.value == '01' || combo.value == '02' || combo.value == '03') && CONST.CARTERA['BANKIA'] == codigoCartera) {
            	me.habilitarCampo(me.down('[name=comboMotivoAnulacionReserva]'));
            	me.down('[name=comboMotivoAnulacionReserva]').reset();
            } else if(combo.value == '03' && CONST.CARTERA['BANKIA'] == codigoCartera) {
            	//me.deshabilitarCampo(me.down('[name=comboMotivoAnulacionReserva]'));
            	//me.down('[name=comboMotivoAnulacionReserva]').reset();
            }
        });

		storeMotivoAnulacion.addListener('load', function(store, records, successful, operation, eOpts){
			store.filter('visibleWeb', true);
		});
    },
    
    T013_RespuestaBankiaDevolucionValidacion: function() {
    	var me = this;
    	var fecha = me.down('[name=fecha]');
    	var comboRespuesta = me.down('[name=comboRespuesta]');
    	var observaciones = me.down('[name=observaciones]');
    	fecha.setReadOnly(true);
    	comboRespuesta.setReadOnly(true);
    	observaciones.setReadOnly(true);
    },
    T013_PendienteDevolucionValidacion: function() {
    	var me = this;
    	var fecha = me.down('[name=fecha]');
    	var comboRespuesta = me.down('[name=comboRespuesta]');
    	var observaciones = me.down('[name=observaciones]');
    	fecha.setReadOnly(true);
    	comboRespuesta.setReadOnly(true);
    	observaciones.setReadOnly(true);
    },
    
    T013_RespuestaBankiaAnulacionDevolucionValidacion: function() {
    	var me = this;
    	var fecha = me.down('[name=fecha]');
    	var comboRespuesta = me.down('[name=comboRespuesta]');
    	var observaciones = me.down('[name=observaciones]');
    	fecha.setReadOnly(true);
    	comboRespuesta.setReadOnly(true);
    	observaciones.setReadOnly(true);
    },

    T014_PosicionamientoFirmaValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaInicio]'));
        me.deshabilitarCampo(me.down('[name=fechaFin]'));
        me.deshabilitarCampo(me.down('[name=numContrato]'));

        me.down('[name=comboFirma]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=fechaInicio]'));
                me.habilitarCampo(me.down('[name=fechaFin]'));
                me.habilitarCampo(me.down('[name=numContrato]'));
            } else {
                me.deshabilitarCampo(me.down('[name=fechaInicio]'));
                me.deshabilitarCampo(me.down('[name=fechaFin]'));
                me.deshabilitarCampo(me.down('[name=numContrato]'));
            }
        });

        me.down('[name=fechaFin]').addListener('change', function() {
            var finicio = me.down('[name=fechaInicio]');
            var ffin = me.down('[name=fechaFin]');
            var dfinicio = new Date(finicio.value);
            var dffin = new Date(ffin.value);

            if (ffin.value == null) {
                ffin.blankText = HreRem.i18n('tarea.validacion.error.ffin.obligatoria');
            } else {
                if (dfinicio > dffin) {
                    finicio.blankText = HreRem.i18n('tarea.validacion.error.ffin.mayor');
                    finicio.setValue('');
                }
            }

        });

        me.down('[name=fechaInicio]').addListener('change', function() {
            var finicio = me.down('[name=fechaInicio]');
            var ffin = me.down('[name=fechaFin]');
            var dfinicio = new Date(finicio.value);
            var dffin = new Date(ffin.value);

            if (finicio.value == null) {
                ffin.blankText = HreRem.i18n('tarea.validacion.error.finicio.obligatoria');
            } else {
                if (dfinicio > dffin) {
                    ffin.blankText = HreRem.i18n('tarea.validacion.error.finicio.menor');
                    ffin.setValue('');
                }
            }

        });
    },

    T014_DefinicionOfertaValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaEnvio]'));

        if (me.down('[name=comite]').value != 'Haya') {
            me.habilitarCampo(me.down('[name=fechaEnvio]'));
        }
    },   
    
    T015_DefinicionOfertaValidacion: function(){
    	var me = this;
    	var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');   	
    	me.campoObligatorio(me.down('[name=tipoTratamiento]'));
    	
    	if(CONST.CARTERA['BANKIA'] == codigoCartera){
    		me.bloquearCampo(me.down('[name=tipoTratamiento]'));
    		me.campoObligatorio(me.down('[name=tipoTratamiento]'));
    		me.down('[name=tipoTratamiento]').setValue(CONST.TIPO_INQUILINO['NINGUNA']);
    		me.ocultaryHacerNoObligatorio(me.down('[name=tipoInquilino]'));
	    	me.ocultaryHacerNoObligatorio(me.down('[name=nMesesFianza]'));
	    	me.ocultaryHacerNoObligatorio(me.down('[name=importeFianza]'));
	    	me.ocultaryHacerNoObligatorio(me.down('[name=deposito]'));
	    	me.ocultaryHacerNoObligatorio(me.down('[name=nMeses]'));
	    	me.ocultaryHacerNoObligatorio(me.down('[name=importeDeposito]'));
	    	me.ocultaryHacerNoObligatorio(me.down('[name=fiadorSolidario]'));
	    	me.ocultaryHacerNoObligatorio(me.down('[name=nombreFS]'));
	    	me.ocultaryHacerNoObligatorio(me.down('[name=documento]'));
	    	me.ocultaryHacerNoObligatorio(me.down('[name=tipoImpuesto]'));
	    	me.ocultaryHacerNoObligatorio(me.down('[name=porcentajeImpuesto]'));
    	}else{

	    	me.down('[name=tipoTratamiento]').addListener('change', function() {
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
	    	    	
	    	    	me.down('[name=nMesesFianza]').noObligatorio=false;
	    	    	me.down('[name=importeFianza]').noObligatorio=false;
	    	    	
	    	    	me.campoObligatorio(me.down('[name=nMesesFianza]'));
	    	    	me.campoObligatorio(me.down('[name=importeFianza]'));
	    	    	
	    	    	me.campoNoObligatorio(me.down('[name=tipoImpuesto]'));
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
	    	    	
	    	    	me.down('[name=nMesesFianza]').noObligatorio=true;
	    	    	me.down('[name=importeFianza]').noObligatorio=true;
	    	    	
	    	    	me.campoNoObligatorio(me.down('[name=nMesesFianza]'));
	    	    	me.campoNoObligatorio(me.down('[name=importeFianza]'));
	    	    	me.campoNoObligatorio(me.down('[name=tipoImpuesto]'));
	
	    	    	
	    	    	me.borrarCampo(me.down('[name=nMesesFianza]'));
	    	    	me.borrarCampo(me.down('[name=nMeses]'));
	    	    	me.borrarCampo(me.down('[name=importeDeposito]'));
	    	    	me.borrarCampo(me.down('[name=fiadorSolidario]'));
	    	    	me.borrarCampo(me.down('[name=nombreFS]'));
	    	    	me.borrarCampo(me.down('[name=documento]'));
	    	    	me.borrarCampo(me.down('[name=deposito]'));
	    	    	me.borrarCampo(me.down('[name=tipoImpuesto]'));
	    	    	me.borrarCampo(me.down('[name=porcentajeImpuesto]'));
	    	    	me.borrarCampo(me.down('[name=observaciones]'));
	    	    	
	    		}
	
	        });
	    	
	    	me.down('[name=deposito]').addListener('change', function(){
	    		var deposito = me.down('[name=deposito]');
	    		
	    		if(deposito.value){
	    			me.down('[name=nMeses]').noObligatorio=false;
	    			me.down('[name=importeDeposito]').noObligatorio=false;
	    			
	    			me.habilitarCampo(me.down('[name=nMeses]'));
	            	me.habilitarCampo(me.down('[name=importeDeposito]'));
	    		}else{
	    			me.down('[name=nMeses]').noObligatorio=true;
	    			me.down('[name=importeDeposito]').noObligatorio=true;
	    			me.deshabilitarCampo(me.down('[name=nMeses]'));
	            	me.deshabilitarCampo(me.down('[name=importeDeposito]'));
	            	
	            	me.borrarCampo(me.down('[name=nMeses]'));
	            	me.borrarCampo(me.down('[name=importeDeposito]'));
	            	
	            	me.campoNoObligatorio(me.down('[name=nMeses]'));
	            	me.campoNoObligatorio(me.down('[name=importeDeposito]'));
	    		}	
	    	});
	    	
	    	me.down('[name=fiadorSolidario]').addListener('change', function(){
	    		
	    		var fiadorSolidario = me.down('[name=fiadorSolidario]');
	    		
	    		if(fiadorSolidario.value){
	    			me.down('[name=nombreFS]').noObligatorio=false;
	    			me.down('[name=documento]').noObligatorio=false;
	    			
	    			me.habilitarCampo(me.down('[name=nombreFS]'));
	            	me.habilitarCampo(me.down('[name=documento]'));
	    		}else{
	    			me.down('[name=nombreFS]').noObligatorio=true;
	    			me.down('[name=documento]').noObligatorio=true;
	    			me.deshabilitarCampo(me.down('[name=nombreFS]'));
	            	me.deshabilitarCampo(me.down('[name=documento]'));
	            	
	            	me.borrarCampo(me.down('[name=nombreFS]'));
	            	me.borrarCampo(me.down('[name=documento]'));
	            	
	            	me.campoNoObligatorio(me.down('[name=nombreFS]'));
	            	me.campoNoObligatorio(me.down('[name=documento]'));
	    		}        	
	    	});
	    	
	    	me.down('[name=tipoImpuesto]').addListener('change', function(){
	    		
	    		var tipoImpuesto = me.down('[name=tipoImpuesto]');
	    		
	    		if(tipoImpuesto.value){
	    			me.down('[name=porcentajeImpuesto]').noObligatorio=false;
	    		} else {
	    			me.down('[name=porcentajeImpuesto]').noObligatorio=true;
	    		}
	    		
	    		me.campoObligatorio(me.down('[name=porcentajeImpuesto]'));
	    	});
    	}
    },
    
    T015_FirmaValidacion: function(){
    	var me = this;
    	
    	me.down('[name=fechaFirma]').noObligatorio=false;
    	me.campoObligatorio(me.down('[name=fechaFirma]'));
    },
    
    T015_VerificarScoringValidacion: function(){
    	var me = this;
    	var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
    	var codigoEstadoBC = me.up('tramitesdetalle').getViewModel().get('tramite.codigoEstadoExpedienteBC');
    	
    	if(CONST.CARTERA['BANKIA'] == codigoCartera){
    		me.ocultaryHacerNoObligatorio(me.down('[name=nMeses]'));
        	me.ocultaryHacerNoObligatorio(me.down('[name=importeDeposito]'));
        	me.ocultaryHacerNoObligatorio(me.down('[name=nombreFS]'));
        	me.ocultaryHacerNoObligatorio(me.down('[name=documento]'));
        	
        	me.ocultaryHacerNoObligatorio(me.down('[name=deposito]'));
        	me.ocultaryHacerNoObligatorio(me.down('[name=porcentajeImpuesto]'));
        	me.ocultaryHacerNoObligatorio(me.down('[name=tipoImpuesto]'));
        	me.ocultaryHacerNoObligatorio(me.down('[name=fiadorSolidario]'));
        	me.ocultaryHacerNoObligatorio(me.down('[name=nMesesFianza]'));
			me.ocultaryHacerNoObligatorio(me.down('[name=importeFianza]'));

    	}else{
    		me.deshabilitarCampo(me.down('[name=nMeses]'));
        	me.deshabilitarCampo(me.down('[name=importeDeposito]'));
        	me.deshabilitarCampo(me.down('[name=nombreFS]'));
        	me.deshabilitarCampo(me.down('[name=documento]'));
    	}
    	
    	me.campoObligatorio(me.down('[name=resultadoScoring]'));
    	me.deshabilitarCampo(me.down('[name=motivoRechazo]'));
    	me.deshabilitarCampo(me.down('[name=fechaSancScoring]'));
    	me.deshabilitarCampo(me.down('[name=nExpediente]'));


    	var scoring = me.down('[name=resultadoScoring]');
    	var storeScoring = scoring.getStore();
    			storeScoring.addListener('load', function(store, records, successful, operation, eOpts){
    			var dataScoring = store.getData().items; 
    			if(CONST.CARTERA['BANKIA'] != codigoCartera){
    				var indexConDudas;
    				for( var i = 0 ; i < dataScoring.length; i++) { 
    					if(dataScoring[i].getData().codigo == '03'){  
    						indexConDudas = i; 
    						break;
    					}
    				}
    				store.splice(indexConDudas, 1);
    			}
    		});
    		
    		
    	me.down('[name=tipoImpuesto]').noObligatorio=true;
    	
    	me.down('[name=resultadoScoring]').addListener('change', function() {
    		var resultadoScoring = me.down('[name=resultadoScoring]');
    		if(resultadoScoring.value == '01' || resultadoScoring.value == '03'){
    		
    			me.down('[name=nExpediente]').noObligatorio=false;
    			me.campoObligatorio(me.down('[name=nExpediente]'));
            	me.habilitarCampo(me.down('[name=nExpediente]'));
            	me.habilitarCampo(me.down('[name=fechaSancScoring]'));

            	
            	me.down('[name=motivoRechazo]').noObligatorio=true;
            	me.deshabilitarCampo(me.down('[name=motivoRechazo]'));
            	me.borrarCampo(me.down('[name=motivoRechazo]'));
            	me.campoNoObligatorio(me.down('[name=motivoRechazo]'));
    			
    			if(CONST.CARTERA['BANKIA'] != codigoCartera){
	    			me.down('[name=nMesesFianza]').noObligatorio=false;
	    			me.down('[name=importeFianza]').noObligatorio=false;
	    			
	    			me.habilitarCampo(me.down('[name=nMesesFianza]'));
	    			me.habilitarCampo(me.down('[name=importeFianza]'));
	    			me.habilitarCampo(me.down('[name=motivoRechazo]'));
	    			
	    			me.campoObligatorio(me.down('[name=nMesesFianza]'));
	    			me.campoObligatorio(me.down('[name=importeFianza]'));
	    			

	            	me.habilitarCampo(me.down('[name=deposito]'));
	            	me.habilitarCampo(me.down('[name=porcentajeImpuesto]'));
	            	me.habilitarCampo(me.down('[name=tipoImpuesto]'));
	            	me.habilitarCampo(me.down('[name=fiadorSolidario]'));
	            	me.down('[name=deposito]').noObligatorio=true;
	            	me.down('[name=fiadorSolidario]').noObligatorio=true;
	            	me.down('[name=porcentajeImpuesto]').noObligatorio=true;
	            	me.down('[name=tipoImpuesto]').noObligatorio=true;
    			}
            	
    			
    		}else{
    			me.down('[name=nExpediente]').noObligatorio=true;
    			me.campoObligatorio(me.down('[name=motivoRechazo]'));
            	me.campoNoObligatorio(me.down('[name=nExpediente]'));
            	me.habilitarCampo(me.down('[name=motivoRechazo]'));
            	me.deshabilitarCampo(me.down('[name=fechaSancScoring]'));
            	me.borrarCampo(me.down('[name=fechaSancScoring]'));
            	me.borrarCampo(me.down('[name=nExpediente]'));
            	me.deshabilitarCampo(me.down('[name=nExpediente]'));


    			if(CONST.CARTERA['BANKIA'] != codigoCartera){
	    			me.down('[name=nMesesFianza]').noObligatorio=true;
	    			me.down('[name=importeFianza]').noObligatorio=true;
	    			me.down('[name=motivoRechazo]').noObligatorio=false;
	
	            	me.deshabilitarCampo(me.down('[name=nMesesFianza]'));
	            	me.deshabilitarCampo(me.down('[name=importeFianza]'));
	            	
	            	me.borrarCampo(me.down('[name=nMesesFianza]'));
	            	me.borrarCampo(me.down('[name=importeFianza]'));
	    			
	            	me.campoNoObligatorio(me.down('[name=nMesesFianza]'));
	            	me.campoNoObligatorio(me.down('[name=importeFianza]'));
	    			me.deshabilitarCampo(me.down('[name=nExpediente]'));
	            	me.deshabilitarCampo(me.down('[name=deposito]'));
	            	me.deshabilitarCampo(me.down('[name=fiadorSolidario]'));
	            	me.deshabilitarCampo(me.down('[name=tipoImpuesto]'));
	            	me.deshabilitarCampo(me.down('[name=porcentajeImpuesto]'));
    			}
    		}
        });
    	
    	
    	me.down('[name=deposito]').addListener('change', function(){
    		var deposito = me.down('[name=deposito]');
    		
    		if(deposito.value){
    			me.down('[name=nMeses]').noObligatorio=false;
    			me.down('[name=importeDeposito]').noObligatorio=false;
    			
    			me.habilitarCampo(me.down('[name=nMeses]'));
            	me.habilitarCampo(me.down('[name=importeDeposito]'));
            	
            	me.campoObligatorio(me.down('[name=nMeses]'));
            	me.campoObligatorio(me.down('[name=importeDeposito]'));
    		}else{
    			me.down('[name=nMeses]').noObligatorio=true;
    			me.down('[name=importeDeposito]').noObligatorio=true;
    			
    			me.deshabilitarCampo(me.down('[name=nMeses]'));
            	me.deshabilitarCampo(me.down('[name=importeDeposito]'));
            	
            	me.borrarCampo(me.down('[name=nMeses]'));
            	me.borrarCampo(me.down('[name=importeDeposito]'));
            	
            	me.campoNoObligatorio(me.down('[name=nMeses]'));
            	me.campoNoObligatorio(me.down('[name=importeDeposito]'));

    		}	
    	});
    	
    	me.down('[name=fiadorSolidario]').addListener('change', function(){
    		
    		var fiadorSolidario = me.down('[name=fiadorSolidario]');
    		
    		if(fiadorSolidario.value){
    			
    			me.down('[name=nombreFS]').noObligatorio=false;
    			me.down('[name=documento]').noObligatorio=false;
    			
    			me.habilitarCampo(me.down('[name=nombreFS]'));
            	me.habilitarCampo(me.down('[name=documento]'));
            	me.down('[name=documento]').maskre=/[A-Za-z0-9]/;
            	me.down('[name=documento]').regex=/^[A-Za-z0-9]{1}[0-9]{7}[A-Za-z]{1}$/;
            	
            	
            	me.campoObligatorio(me.down('[name=nombreFS]'));
            	me.campoObligatorio(me.down('[name=documento]'));
    		}else{
    			me.down('[name=nombreFS]').noObligatorio=true;
    			me.down('[name=documento]').noObligatorio=true;
    			
    			me.deshabilitarCampo(me.down('[name=nombreFS]'));
            	me.deshabilitarCampo(me.down('[name=documento]'));
            	
            	me.borrarCampo(me.down('[name=nombreFS]'));
            	me.borrarCampo(me.down('[name=documento]'));
            	
            	me.campoNoObligatorio(me.down('[name=nombreFS]'));
            	me.campoNoObligatorio(me.down('[name=documento]'));
    		}        	
    	});
    	
    	me.down('[name=tipoImpuesto]').addListener('change', function(){
    		var tipoImpuesto = me.down('[name=tipoImpuesto]');
    		
    		if(tipoImpuesto.value){
    			me.down('[name=porcentajeImpuesto]').noObligatorio=false;
            	
            	me.campoObligatorio(me.down('[name=porcentajeImpuesto]'));
    		}else{
    			me.down('[name=porcentajeImpuesto]').noObligatorio=true;
            	
            	me.campoNoObligatorio(me.down('[name=porcentajeImpuesto]'));

    		}	
    	});

    },
    
    T015_VerificarSeguroRentasValidacion: function(){
    	var me = this;
    	var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');

    	me.campoObligatorio(me.down('[name=resultadoRentas]'));
    	me.campoObligatorio(me.down('[name=aseguradora]'));
    	
    	if(CONST.CARTERA['BANKIA'] == codigoCartera){
    		me.ocultaryHacerNoObligatorio(me.down('[name=tipoImpuesto]'));
			me.ocultaryHacerNoObligatorio(me.down('[name=porcentajeImpuesto]'));
    		
    		me.ocultaryHacerNoObligatorio(me.down('[name=nMeses]'));
    		me.ocultaryHacerNoObligatorio(me.down('[name=importeDeposito]'));
    		me.ocultaryHacerNoObligatorio(me.down('[name=nombreFS]'));
    		me.ocultaryHacerNoObligatorio(me.down('[name=documento]'));
    		me.ocultaryHacerNoObligatorio(me.down('[name=nMesesFianza]'));
    		me.ocultaryHacerNoObligatorio(me.down('[name=importeFianza]'));
    		
    		me.ocultaryHacerNoObligatorio(me.down('[name=deposito]'));
        	me.ocultaryHacerNoObligatorio(me.down('[name=fiadorSolidario]'));
        	me.ocultaryHacerNoObligatorio(me.down('[name=tipoImpuesto]'));
        	me.ocultaryHacerNoObligatorio(me.down('[name=porcentajeImpuesto]'));
        	
    	}else{
	    	me.deshabilitarCampo(me.down('[name=nMeses]'));
	    	me.deshabilitarCampo(me.down('[name=importeDeposito]'));
	    	me.deshabilitarCampo(me.down('[name=nombreFS]'));
	    	me.deshabilitarCampo(me.down('[name=documento]'));
	    	me.deshabilitarCampo(me.down('[name=nMesesFianza]'));
	    	me.deshabilitarCampo(me.down('[name=importeFianza]'));
    	}
    	me.down('[name=tipoImpuesto]').noObligatorio=true;
    	
    	me.down('[name=resultadoRentas]').addListener('change', function() {
    		var resultadoRentas = me.down('[name=resultadoRentas]');

    		if(resultadoRentas.value == '01' || resultadoRentas.value == '03'){
    			
    			if(CONST.CARTERA['BANKIA'] != codigoCartera){
	    			me.down('[name=nMesesFianza]').noObligatorio=false;
	    			me.down('[name=importeFianza]').noObligatorio=false;
	    			
	    			me.habilitarCampo(me.down('[name=nMesesFianza]'));
	    			me.habilitarCampo(me.down('[name=importeFianza]'));
	    			
	    			me.campoObligatorio(me.down('[name=nMesesFianza]'));
	    			me.campoObligatorio(me.down('[name=importeFianza]'));

	    			me.habilitarCampo(me.down('[name=tipoImpuesto]'));
	    			me.habilitarCampo(me.down('[name=porcentajeImpuesto]'));
	    			me.habilitarCampo(me.down('[name=tipoImpuesto]'));
	    			me.down('[name=tipoImpuesto]').noObligatorio=true;
	            	me.habilitarCampo(me.down('[name=porcentajeImpuesto]'));
	            	me.habilitarCampo(me.down('[name=fiadorSolidario]'));
    			}
    			
            	me.habilitarCampo(me.down('[name=aseguradora]'));
            	me.down('[name=aseguradora]').noObligatorio=false;
            	me.campoObligatorio(me.down('[name=aseguradora]'));
            	me.habilitarCampo(me.down('[name=envioEmail]'));
    		}else{
    			
    			if(CONST.CARTERA['BANKIA'] != codigoCartera){
	    			me.down('[name=nMesesFianza]').noObligatorio=true;
	    			me.down('[name=importeFianza]').noObligatorio=true;
	    			
	            	me.deshabilitarCampo(me.down('[name=nMesesFianza]'));
	            	me.deshabilitarCampo(me.down('[name=importeFianza]'));	
	            	me.borrarCampo(me.down('[name=nMesesFianza]'));
	            	me.borrarCampo(me.down('[name=importeFianza]'));
	            	me.campoNoObligatorio(me.down('[name=nMesesFianza]'));
	            	me.campoNoObligatorio(me.down('[name=importeFianza]'));
	            	me.deshabilitarCampo(me.down('[name=deposito]'));
	            	me.deshabilitarCampo(me.down('[name=fiadorSolidario]'));
	            	me.deshabilitarCampo(me.down('[name=tipoImpuesto]'));
	            	me.deshabilitarCampo(me.down('[name=porcentajeImpuesto]'));
	            	
	            	me.down('[name=deposito]').noObligatorio=true;
	            	me.down('[name=fiadorSolidario]').noObligatorio=true;
	            	me.down('[name=tipoImpuesto]').noObligatorio=true;
	            	me.down('[name=porcentajeImpuesto]').noObligatorio=true;
            	
    			}
            	
            	me.deshabilitarCampo(me.down('[name=aseguradora]'));
            	me.deshabilitarCampo(me.down('[name=envioEmail]'));
            	me.down('[name=aseguradora]').noObligatorio=true;
            	me.down('[name=envioEmail]').noObligatorio=true;
    		}
        });
    	
    	
    	me.down('[name=deposito]').addListener('change', function(){
    		var deposito = me.down('[name=deposito]');
    		
    		if(deposito.value){
    			me.down('[name=nMeses]').noObligatorio=false;
    			me.down('[name=importeDeposito]').noObligatorio=false;
    			
    			me.habilitarCampo(me.down('[name=nMeses]'));
            	me.habilitarCampo(me.down('[name=importeDeposito]'));
            	
            	me.campoObligatorio(me.down('[name=nMeses]'));
            	me.campoObligatorio(me.down('[name=importeDeposito]'));
    		}else{
    			me.down('[name=nMeses]').noObligatorio=true;
    			me.down('[name=importeDeposito]').noObligatorio=true;
    			
    			me.deshabilitarCampo(me.down('[name=nMeses]'));
            	me.deshabilitarCampo(me.down('[name=importeDeposito]'));
            	
            	me.borrarCampo(me.down('[name=nMeses]'));
            	me.borrarCampo(me.down('[name=importeDeposito]'));
            	
            	me.campoNoObligatorio(me.down('[name=nMeses]'));
            	me.campoNoObligatorio(me.down('[name=importeDeposito]'));

    		}	
    	});
    	
    	me.down('[name=fiadorSolidario]').addListener('change', function(){
    		
    		var fiadorSolidario = me.down('[name=fiadorSolidario]');
    		
    		if(fiadorSolidario.value){
    			
    			me.down('[name=nombreFS]').noObligatorio=false;
    			me.down('[name=documento]').noObligatorio=false;
    			
    			me.habilitarCampo(me.down('[name=nombreFS]'));
            	me.habilitarCampo(me.down('[name=documento]'));
            	me.down('[name=documento]').maskre=/[A-Za-z0-9]/;
            	me.down('[name=documento]').regex=/^[A-Za-z0-9]{1}[0-9]{7}[A-Za-z]{1}$/;
            	
            	me.campoObligatorio(me.down('[name=nombreFS]'));
            	me.campoObligatorio(me.down('[name=documento]'));
    		}else{
    			me.down('[name=nombreFS]').noObligatorio=true;
    			me.down('[name=documento]').noObligatorio=true;
    			
    			me.deshabilitarCampo(me.down('[name=nombreFS]'));
            	me.deshabilitarCampo(me.down('[name=documento]'));
            	
            	me.borrarCampo(me.down('[name=nombreFS]'));
            	me.borrarCampo(me.down('[name=documento]'));
            	
            	me.campoNoObligatorio(me.down('[name=nombreFS]'));
            	me.campoNoObligatorio(me.down('[name=documento]'));
    		}        	
    	});
    	
    	
    	me.down('[name=envioEmail]').addListener('afterrender', function(){
    		
    		var envioEmail = me.down('[name=envioEmail]');
    		
    		Ext.apply(envioEmail, {vtype: 'email'});
    	});
    },
    
    T015_ElevarASancionValidacion: function(){
    	var me = this;
    	var idActivo= me.idActivo;
    	var resolucionOferta = me.down('[name=resolucionOferta]');
    	var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
    	var importeContraoferta = me.down('[name=importeContraoferta]');
    	var observacionesBC = me.down('[name=observacionesBC]');

    	me.deshabilitarCampo(me.down('[name=motivoAnulacion]'));
		me.deshabilitarCampo(me.down('[name=comite]'));
		me.bloquearCampo(me.down('[name=fechaElevacion]'));
		
		if (CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.ocultaryHacerNoObligatorio(me.down('[name=comite]'));
			me.bloquearCampo(me.down('[name=fechaElevacion]'));
			var fecha = new Date();
			me.down('[name=fechaElevacion]').setValue(fecha);
			me.deshabilitarCampo(importeContraoferta);
			me.ocultaryHacerNoObligatorio(me.down('[name=refCircuitoCliente]'));
			me.bloquearObligatorio(resolucionOferta);
			me.bloquearCampo(observacionesBC);
			var idTarea = me.idTarea; 
				
			var url =  $AC.getRemoteUrl('expedientecomercial/getValoresTareaElevarSancion');
			Ext.Ajax.request({
				url: url,
				params: {idTarea : idTarea},
			    success: function(response, opts) {
			    	var data = Ext.decode(response.responseText);
			    	var dto = data.data;
			    	
			    	if(!Ext.isEmpty(dto)){			    		
			    		observacionesBC.setValue(dto.observacionesBC);
			    		resolucionOferta.setValue(dto.comboResolucion);
			    		if(dto.comboResolucion == '03'){
			    			me.habilitarCampo(importeContraoferta);
			    			me.campoObligatorio(importeContraoferta);
			    			importeContraoferta.allowBlank = fals
			    		}
			    	}
			    }
			});
			
		}else{
			me.ocultaryHacerNoObligatorio(importeContraoferta);
			me.ocultaryHacerNoObligatorio(observacionesBC);
			
			var resolucionOferta = resolucionOferta.getStore();
	    	resolucionOferta.addListener('load', function(store, records, successful, operation, eOpts){
				var data = store.getData().items; 
				if(CONST.CARTERA['BANKIA'] != codigoCartera){
					var indexContraoferta;
					for( var i = 0 ; i < data.length; i++) { 
						if(data[i].getData().codigo == '03'){  
							indexContraoferta = i; 
							break;
						}
					}
					store.splice(indexContraoferta, 1);
				}
			});
			
			me.down('[name=refCircuitoCliente]').maxLength=20;
			
			var storeComite = Ext.create('Ext.data.Store', {
			     model:Ext.create('HreRem.model.ComiteAlquilerModel'),
			     proxy: {
			         type: 'uxproxy',
			         remoteUrl: 'generic/getComitesAlquilerByCartera',
			         extraParams: {idActivo: idActivo},
			         reader: {
			             type: 'json',
			             rootProperty: 'data'
			         }
			     },
			     autoLoad: false
			 });
			me.down('[name=comite]').setStore(storeComite);
			
			storeComite.load();
				
	    	me.down('[name=resolucionOferta]').addListener('change', function(){
	    		var resolucionOferta = me.down('[name=resolucionOferta]');

	    		if(resolucionOferta.value == '01' || resolucionOferta.value == '03'){

	    			if(CONST.CARTERA['BANKIA'] != codigoCartera){
						me.habilitarCampo(me.down('[name=comite]'));
		    			me.campoObligatorio(me.down('[name=comite]'));
	    			}else{
	    				if(resolucionOferta.value == '03'){
	    					me.habilitarCampo(importeContraoferta);
	    				}else{
	    					me.deshabilitarCampo(importeContraoferta);
	    				}
	    			}
	    			
	    			me.deshabilitarCampo(me.down('[name=motivoAnulacion]'));
	    			me.habilitarCampo(me.down('[name=fechaElevacion]'));
	    			
	    			me.campoNoObligatorio(me.down('[name=motivoAnulacion]'));
	    			me.campoObligatorio(me.down('[name=fechaElevacion]'));
	    			me.setFechaActual(me.down('[name=fechaElevacion]'));
	    			
	    		}else{
	    			
	    			me.down('[name=motivoAnulacion]').noObligatorio=false;
	    			me.down('[name=fechaElevacion]').noObligatorio=true;
	    			
	    			me.habilitarCampo(me.down('[name=motivoAnulacion]'));
	            	me.deshabilitarCampo(me.down('[name=fechaElevacion]'));
	            	me.deshabilitarCampo(me.down('[name=comite]'));
	            	
	            	me.borrarCampo(me.down('[name=comite]'));
	            	me.borrarCampo(me.down('[name=fechaElevacion]'));
	            	
	            	me.campoObligatorio(me.down('[name=motivoAnulacion]'));
	            	me.campoNoObligatorio(me.down('[name=fechaElevacion]'));
	            	
	            	me.deshabilitarCampo(importeContraoferta);
	    			
	    		}
	    	});
		}
		

    	
    	
    },
    
    
    T015_ResolucionExpedienteValidacion: function(){
    	var me = this;
    	var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
    	me.deshabilitarCampo(me.down('[name=motivo]'));
    	me.deshabilitarCampo(me.down('[name=importeContraoferta]'));
    	
    	me.campoObligatorio(me.down('[name=resolucionExpediente]'));
    	me.down('[name=resolucionExpediente]').addListener('change', function(){
    		
    		var resolucionExpediente = me.down('[name=resolucionExpediente]');
    		if(resolucionExpediente.value == '01'){
    			
    			me.down('[name=motivo]').noObligatorio=true;
    			me.down('[name=importeContraoferta]').noObligatorio=true;
    			
    			me.deshabilitarCampo(me.down('[name=motivo]'));
    			me.deshabilitarCampo(me.down('[name=importeContraoferta]'));
    			
    		} else if (resolucionExpediente.value == '03'){
    			
    			me.down('[name=motivo]').noObligatorio=true;
    			me.down('[name=importeContraoferta]').noObligatorio=false;
    			me.campoObligatorio(me.down('[name=importeContraoferta]'));
    			
    			me.deshabilitarCampo(me.down('[name=motivo]'));
    			me.habilitarCampo(me.down('[name=importeContraoferta]'));

    		}else{
    			
    			me.down('[name=motivo]').noObligatorio=false;
    			me.down('[name=importeContraoferta]').noObligatorio=true;
    			
    			me.habilitarCampo(me.down('[name=motivo]'));
    			me.deshabilitarCampo(me.down('[name=importeContraoferta]'));

    		}

    	});
    	
    	if(CONST.CARTERA['LIBERBANK'] != codigoCartera) {
			me.down('[name=fechaReunionComite]').hide();
			me.down('[name=comiteInternoSancionador]').hide();
		}
    	
    },
    
    T015_AceptacionClienteValidacion: function(){
    	var me = this; 
    	me.down('[name=aceptacionContraoferta]').noObligatorio=false;
    	me.campoObligatorio(me.down('[name=aceptacionContraoferta]'));
    },
    
    T015_ResolucionPBCValidacion: function(){
    	var me = this;
    	me.down('[name=resultadoPBC]').noObligatorio=false;
    	me.campoObligatorio(me.down('[name=resultadoPBC]'));
    },
    
    T015_PosicionamientoValidacion: function(){
    	var me = this;
    	me.down('[name=fechaFirmaContrato]').noObligatorio=false;
    	me.down('[name=lugarFirma]').noObligatorio=false;
    	me.campoObligatorio(me.down('[name=fechaFirmaContrato]'));
    	me.campoObligatorio(me.down('[name=lugarFirma]'));
    },
    
    T015_CierreContratoValidacion: function(){
    	var me = this;
    	me.down('[name=docOK]').noObligatorio=false;
    	me.down('[name=ncontratoPrinex]').noObligatorio=false;
    	me.campoObligatorio(me.down('[name=docOK]'));
    	me.campoObligatorio(me.down('[name=ncontratoPrinex]'));
    	me.down('[name=ncontratoPrinex]').minLength=9;
    	me.down('[name=ncontratoPrinex]').maxLength=9;
    	
    	me.setFechaActual(me.down('[name=fechaValidacion]'));

    	me.down('[name=ncontratoPrinex]').addListener('change', function(field, newValue, oldValue, eOpts){
 
     		if(newValue.length >= 4 && newValue.length < 8
				&& !newValue.includes("-")){
     			field.setValue(newValue.substring(0,4)+ "-" + newValue.substring(4,8)); 
         		
     		}
			
			field.validate();
     	});
		me.down('[name=ncontratoPrinex]').validator = new Function("value",
			"return value.match(/^[0-9]{4}-[0-9]{4}$/) ? true : 'Formato nº contrato: XXXX-XXXX donde X debe ser numérico'");
		
		me.down('[name=ncontratoPrinex]').validate();
    },

    T016_ProcesoAdecuacionValidacion: function() {
        var me = this;
        var comboReforma = me.down('[name=necesitaReforma]');
        var fechaRevision = me.down('[name=fechaRevision]');
        var importeReforma = me.down('[name=importeReforma]');
        comboReforma.allowBlank = false;
        fechaRevision.allowBlank = false;
        me.setFechaActual(me.down('[name=fechaRevision]'));
        importeReforma.allowBlank = false;
    	me.deshabilitarCampo(me.down('[name=importeReforma]'));
        comboReforma.addListener('change', function(){
	        if(comboReforma.value == '01'){
	        	me.habilitarCampo(me.down('[name=importeReforma]'));
	        	importeReforma.allowBlank = false;
	        	importeReforma.validate();
	        }
	        else{
	        	
	        	me.deshabilitarCampo(me.down('[name=importeReforma]'));
	        	me.down('[name=importeReforma]').reset();
	        	importeReforma.allowBlank = true;
	        	importeReforma.validate();
	        }
        });
        fechaRevision.addListener('click', function(){
        	me.down('[name=fechaRevision]').reset();
        	me.setDate(me.down('[name=fechaRevision]'));
        	
        });
    },
    
    T016_ComunicarGENCATValidacion: function() {
        var me = this;
        var fecha = me.down('[name=fechaTarea]');
        var fechaComunicacion = me.down('[name=fechaComunicacion]');
        fecha.setValue($AC.getCurrentDate()); 
        //me.deshabilitarCampo(fecha);
        fecha.setReadOnly(true);
        fechaComunicacion.allowBlank = false;
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
	
    T017_AnalisisPMValidacion: function(){
    	var me = this;
    	var comboResolucion = me.down('[name=comboResolucion]');
    	var comboContraoferta = me.down('[name=numImporteContra]');
    	me.deshabilitarCampo(comboContraoferta);
		
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
	        if(!$AU.userIsRol(CONST.PERFILES['HAYASUPER'])){
	    		comboResolucion.setReadOnly(true);
	        	fechaRespuesta.setReadOnly(true);
	    	}
	        comboResolucion.setReadOnly(false);
        	fechaRespuesta.setReadOnly(false);
        	
	        observacionesBC.setReadOnly(true);
	        necesidadArras.setReadOnly(true); 
	        
	        var comboResolucionStore = comboResolucion.getStore();
	        comboResolucionStore.addListener('load', function(store, records, successful, operation, eOpts){
			var dataScoring = store.getData().items; 
				var indexConDudas;
				for( var i = 0 ; i < dataScoring.length; i++) { 
					if(dataScoring[i].getData().codigo == '03'){  
						indexConDudas = i; 
						break;
					}
				}
				store.splice(indexConDudas, 1);			
		});
	        	        
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
    T017_ResolucionArrowValidacion: function(){
    	var me = this;
    	var comboResolucion = me.down('[name=comboResolucion]');
    	var comboContraoferta = me.down('[name=numImporteContra]');
    	me.deshabilitarCampo(comboContraoferta);
		
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
    },

    T017_RatificacionComiteCESValidacion: function(){
    	var me = this;
    	var comboRatificacion = me.down('[name=comboRatificacion]');
    	var importeContraoferta = me.down('[name=numImporteContra]');
    	var importeOferta = me.down('[name=numImporteOferta]');
    	me.deshabilitarCampo(importeContraoferta);
    	me.bloquearCampo(importeOferta);
		
    	comboRatificacion.addListener('change', function(){
	        if(comboRatificacion.value == '03'){
	        	me.habilitarCampo(importeContraoferta);
	        	importeContraoferta.allowBlank = false;
	        	importeContraoferta.validate();
	        }else{
	        	me.deshabilitarCampo(importeContraoferta);
	        	importeContraoferta.reset();
	        	importeContraoferta.allowBlank = true;
	        	importeContraoferta.validate();
	        }
        });
    },
    T017_RespuestaOfertantePMValidacion: function () {
    	var me = this;
    	var comboRespuestaOfertante = me.down( '[name=comboRespuesta]' ),
    		comboFechaRespuestaPM = me.down ( '[name=fechaRespuesta]' );
    		
    		me.campoObligatorio(comboRespuestaOfertante);
    		comboFechaRespuestaPM.validate();
    		me.campoObligatorio(comboFechaRespuestaPM);
    		comboRespuestaOfertante.validate();
    		me.desbloquearCampo(comboFechaRespuestaPM);
    },
    T017_RespuestaOfertanteCESValidacion: function() {
    	var me = this;
    	var comboRespuestaOfertante = me.down( '[name=comboRespuesta]' ),
    		comboFechaRespuesta = me.down ( '[name=fechaRespuesta]' ),
    		numImporteContraOfertaOfertante = me.down( '[name=importeContraofertaOfertante]' );
    		
    		console.log(comboRespuestaOfertante);
    		console.log(comboFechaRespuesta);
    		comboRespuestaOfertante.allowBlank = false;
    		me.campoObligatorio(comboRespuestaOfertante);
    		comboRespuestaOfertante.validate();
    		me.campoObligatorio(comboFechaRespuesta);
    		comboFechaRespuesta.validate();
    		me.desbloquearCampo(comboFechaRespuesta);
    		me.campoObligatorio(numImporteContraOfertaOfertante);
    		
    		if (comboRespuestaOfertante.getValue() != '03') {
	            me.deshabilitarCampo(numImporteContraOfertaOfertante);
	        }
	    	comboRespuestaOfertante.addListener('change', function(combo) {
	            if (combo.value == '03') {
	                me.habilitarCampo(numImporteContraOfertaOfertante);
	            } else {
	                me.deshabilitarCampo(numImporteContraOfertaOfertante);
	                numImporteContraOfertaOfertante.reset();
	            }
	        });
    },
    T017_AdvisoryNoteValidacion: function () {
    	var me = this;
    	var fechaEnvio = me.down('[name=fechaEnvio]');
    	me.campoObligatorio(fechaEnvio);
    	fechaEnvio.validate();
    	me.desbloquearCampo(fechaEnvio);
    },
    T017_RecomendCESValidacion: function(){
    	var me = this;
    	var comboRespuesta = me.down('[name=comboRespuesta]'),
    		fechaRespuesta = me.down('[name=fechaRespuesta]');
    		
    		me.campoObligatorio(comboRespuesta);
    		comboRespuesta.validate();
    		me.campoObligatorio(fechaRespuesta);
    		me.desbloquearCampo(fechaRespuesta);
			fechaRespuesta.validate();
    },
    T017_ResolucionPROManzanaValidacion: function () {
    	var me = this ;
    	var comboRespuesta = me.down('[name=comboRespuesta]'),
    		fechaRespuesta = me.down('[name=fechaRespuesta]');
    	
    		me.campoObligatorio(comboRespuesta);
    		comboRespuesta.validate();
    		me.campoObligatorio(fechaRespuesta);
    		me.desbloquearCampo(fechaRespuesta);
    		fechaRespuesta.validate();
    },
    T017_ResolucionDivarianValidacion: function () {
    	var me = this ;
    	var comboRespuesta = me.down('[name=comboRespuesta]'),
    		fechaRespuesta = me.down('[name=fechaRespuesta]');
    	
    		me.campoObligatorio(comboRespuesta);
    		comboRespuesta.validate();
    		me.campoObligatorio(fechaRespuesta);
    		me.desbloquearCampo(fechaRespuesta);
    		fechaRespuesta.validate();
    },
   T017_ObtencionContratoReservaValidacion: function(){
    	var me = this;
        var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
        var codigoSubcartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoSubcartera');
        var idExpediente = me.up('tramitesdetalle').getViewModel().get('tramite.idExpediente');
        
		var comboResultado = me.down('[name=comboResultado]');
		var motivoAplazamiento = me.down('[name=motivoAplazamiento]');
		var cartera = me.down('[name=cartera]');
		var oficinaReserva = me.down('[name=oficinaReserva]');
		var fechaFirma = me.down('[name=fechaFirma]');
		var comboQuitar = me.down('[name=comboQuitar]');
        
        var parametros = me.down("form").getValues();
        parametros.idExpediente = idExpediente;
        
        var urlFechaFirma =  $AC.getRemoteUrl('reserva/getFechaFirmaByIdExpediente');
        
        Ext.Ajax.request({
			url: urlFechaFirma,
		    params: parametros,
		    success: function(response, opts) {
		    	var data = Ext.decode(response.responseText);
		    	var fechaFirma = new Date(data.fechaFirma);
		    	me.down('[name=fechaFirma]').setValue(Ext.Date.format(fechaFirma, 'd/m/Y'));
		    }
		});
		
    	if((me.down('[name=fechaFirma]').getValue()!=null && me.down('[name=fechaFirma]').getValue()!="") || 
    			(CONST.CARTERA['LIBERBANK'] == codigoCartera || (CONST.CARTERA['CERBERUS'] == codigoCartera && CONST.SUBCARTERA['APPLEINMOBILIARIO'] == codigoSubcartera))){
    		me.down('[name=fechaFirma]').setReadOnly(true);
    		me.campoObligatorio(me.down('[name=fechaFirma]'));
    	}
		
		if(CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.habilitarCampo(comboResultado);
			me.campoObligatorio(comboResultado);
			me.habilitarCampo(motivoAplazamiento);
			me.campoObligatorio(motivoAplazamiento);
			me.habilitarCampo(comboQuitar);
			me.campoObligatorio(comboQuitar);
			comboQuitar.setValue('02');
			
			
	        me.down('[name=comboResultado]').addListener('change', function(combo) {
	            if (combo.value == '01') { //SI
	            	me.habilitarCampo(motivoAplazamiento);
					me.campoObligatorio(motivoAplazamiento);
					me.deshabilitarCampo(fechaFirma);
					me.borrarCampo(fechaFirma);
					me.deshabilitarCampo(cartera);
					me.deshabilitarCampo(oficinaReserva);
	            } else { //NO
					me.deshabilitarCampo(motivoAplazamiento);
					me.borrarCampo(motivoAplazamiento);
					me.habilitarCampo(cartera);
					me.campoNoObligatorio(cartera);					
					me.habilitarCampo(cartera);
					me.campoNoObligatorio(cartera);
					me.habilitarCampo(fechaFirma);					
	            }
        	});
	        
	        me.down('[name=comboQuitar]').addListener('change', function(combo) {
	            if (combo.value == '01') { //SI
	            	me.deshabilitarCampo(comboResultado);
					me.borrarCampo(comboResultado);
					me.deshabilitarCampo(motivoAplazamiento);
					me.borrarCampo(motivoAplazamiento);
					me.deshabilitarCampo(cartera);
					me.borrarCampo(cartera);
					me.deshabilitarCampo(oficinaReserva);
					me.borrarCampo(oficinaReserva);
					me.deshabilitarCampo(fechaFirma);
					me.borrarCampo(fechaFirma);
	            } else { //NO
					me.habilitarCampo(comboResultado);
					me.campoObligatorio(comboResultado);
					me.habilitarCampo(motivoAplazamiento);
					me.campoNoObligatorio(motivoAplazamiento);					
					me.habilitarCampo(cartera);
					me.campoNoObligatorio(cartera);
					me.habilitarCampo(oficinaReserva);
					me.campoNoObligatorio(oficinaReserva);	
					me.habilitarCampo(fechaFirma);					
	            }
        	});
			
		}else{
			//SI NO ES CAIXA/BANKIA
			me.deshabilitarCampo(comboResultado);
			me.ocultarCampo(comboResultado);
			me.deshabilitarCampo(motivoAplazamiento);
			me.ocultarCampo(motivoAplazamiento);
		}
    },
    T017_ResolucionExpedienteValidacion: function() {
        var me = this;
        var tipoArras = me.down('[name=tipoArras]');
        var estadoReserva = me.down('[name=estadoReserva]');
        var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		var storeMotivoAnulacion = me.down('[name=motivoAnulacion]').getStore();
		
        me.deshabilitarCampo(me.down('[name=comboProcede]'));
        if(CONST.CARTERA['BANKIA'] == codigoCartera) {
        	me.deshabilitarCampo(me.down('[name=comboMotivoAnulacionReserva]'));
        } else {
        	me.campoNoObligatorio(me.down('[name=comboMotivoAnulacionReserva]'));
        	me.down('[name=comboMotivoAnulacionReserva]').setHidden(true);
        }

        if (!Ext.isEmpty(estadoReserva) && estadoReserva.value == 'Firmada') {
            me.habilitarCampo(me.down('[name=comboProcede]'));
        }

        me.down('[name=comboProcede]').addListener('change', function(combo) {
            if (combo.value == '01' && tipoArras.value == 'Confirmatorias') {
                me.down('[name=comboProcede]').blankText = HreRem.i18n('tarea.validacion.error.valor.no.permitido.by.tipo.arras');
                me.down('[name=comboProcede]').reset();
            } else if((combo.value == '01' || combo.value == '02' || combo.value == '03') && CONST.CARTERA['BANKIA'] == codigoCartera) {
            	me.habilitarCampo(me.down('[name=comboMotivoAnulacionReserva]'));
            	me.down('[name=comboMotivoAnulacionReserva]').reset();
            } else if(combo.value == '03' && CONST.CARTERA['BANKIA'] == codigoCartera) {
            	//me.deshabilitarCampo(me.down('[name=comboMotivoAnulacionReserva]'));
            	//me.down('[name=comboMotivoAnulacionReserva]').reset();
            }
        });

		storeMotivoAnulacion.addListener('load', function(store, records, successful, operation, eOpts){
			store.filter('visibleWeb', true);
		});
    },
    T017_PosicionamientoYFirmaValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaFirma]'));
        me.deshabilitarCampo(me.down('[name=motivoNoFirma]'));
        me.deshabilitarCampo(me.down('[name=obsAsisPBC]'));
        me.down('[name=tieneReserva]').hide();

        me.down('[name=comboFirma]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.habilitarCampo(me.down('[name=fechaFirma]'));
                me.habilitarCampo(me.down('[name=numProtocolo]'));
                me.habilitarCampo(me.down('[name=comboCondiciones]'));
                me.habilitarCampo(me.down('[name=condiciones]'));

                me.deshabilitarCampo(me.down('[name=motivoNoFirma]'));
                me.down('[name=motivoNoFirma]').reset();

            } else {

                var tieneReserva = me.down('[name=tieneReserva]');
                if (tieneReserva.value == '01') {
                    me.deshabilitarCampo(me.down('[name=motivoNoFirma]'));
                    me.down('[name=motivoNoFirma]').reset();
                } else {
                    me.habilitarCampo(me.down('[name=motivoNoFirma]'));
                }
                me.deshabilitarCampo(me.down('[name=fechaFirma]'));
                me.deshabilitarCampo(me.down('[name=numProtocolo]'));
                me.deshabilitarCampo(me.down('[name=comboCondiciones]'));
                me.deshabilitarCampo(me.down('[name=condiciones]'));
                me.down('[name=fechaFirma]').reset();
                me.down('[name=numProtocolo]').reset();
                me.down('[name=comboCondiciones]').reset();
                me.down('[name=condiciones]').reset();
            }
        });
        
        me.down('[name=asistenciaPBC]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=obsAsisPBC]'));
            } else {
            	me.habilitarCampo(me.down('[name=obsAsisPBC]'));
            }
        });
    },
	T017_DocsPosVentaValidacion: function() {
		var me = this;
		var fechaIngreso = me.down('[name=fechaIngreso]');
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		var codigoSubcartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoSubcartera');
		var comboVentaSupensiva = me.down('[name=comboVentaSupensiva]');
		comboVentaSupensiva.setValue('02');
		me.ocultarCampo(me.down('[name=comboVentaSupensiva]'));
		me.deshabilitarCampo(me.down('[name=comboVentaSupensiva]'));
		fechaIngreso.setMaxValue($AC.getCurrentDate());
		
		if(CONST.CARTERA['BANKIA'] == codigoCartera && CONST.SUBCARTERA['BH'] != codigoSubcartera){
			me.down('[name=comboVentaSupensiva]').setDisabled(false);
			me.editableyNoObligatorio(me.down('[name=comboVentaSupensiva]'));
			me.desocultarCampo(me.down('[name=comboVentaSupensiva]'));
			me.deshabilitarCampo(me.down('[name=checkboxVentaDirecta]'));
			me.deshabilitarCampo(me.down('[name=fechaIngreso]'));
			me.campoObligatorio(me.down('[name=fechaIngreso]'));
		}else if(!Ext.isEmpty(fechaIngreso.getValue()) && CONST.CARTERA['CAJAMAR'] != codigoCartera && (CONST.CARTERA['CERBERUS'] == codigoCartera && CONST.SUBCARTERA['AGORAINMOBILIARIO'] != codigoSubcartera)) {
			me.deshabilitarCampo(me.down('[name=checkboxVentaDirecta]'));
		}else if(CONST.CARTERA['SAREB'] == codigoCartera) {
        	me.down('[name=fechaIngreso]').allowBlank = false;
		}else if(CONST.CARTERA['CAJAMAR'] == codigoCartera) {
        	me.down('[name=fechaIngreso]').allowBlank = false;
		}else if(CONST.CARTERA['BANKIA'] == codigoCartera && CONST.SUBCARTERA['BH'] == codigoSubcartera) {
			me.down('[name=comboVentaSupensiva]').setDisabled(false);
			me.editableyNoObligatorio(me.down('[name=comboVentaSupensiva]'));
			me.desocultarCampo(me.down('[name=comboVentaSupensiva]'));
        	me.down('[name=fechaIngreso]').allowBlank = false;	
		} else if(Ext.isEmpty(fechaIngreso.getValue()) && CONST.CARTERA['CAJAMAR'] != codigoCartera && (CONST.CARTERA['CERBERUS'] == codigoCartera && CONST.SUBCARTERA['AGORAINMOBILIARIO'] != codigoSubcartera)) {
			me.habilitarCampo(me.down('[name=checkboxVentaDirecta]'));
			me.habilitarCampo(me.down('[name=fechaIngreso]'));
	        me.down('[name=fechaIngreso]').allowBlank = false;
	        me.down('[name=fechaIngreso]').validate();
		}else if(CONST.CARTERA['BBVA'] == codigoCartera){
			me.down('[name=fechaIngreso]').allowBlank = false;
		}

		me.down('[name=checkboxVentaDirecta]').addListener('change', function(checkbox, newValue, oldValue, eOpts) {
			if(CONST.CARTERA['LIBERBANK'] != codigoCartera && CONST.CARTERA['CAJAMAR'] != codigoCartera && (CONST.CARTERA['CERBERUS'] == codigoCartera && CONST.SUBCARTERA['AGORAINMOBILIARIO'] != codigoSubcartera)){
				if (newValue) {
	            	me.habilitarCampo(me.down('[name=fechaIngreso]'));
	            	me.down('[name=fechaIngreso]').allowBlank = false;
	            	me.down('[name=fechaIngreso]').validate();
	            } else {
	            	me.down('[name=fechaIngreso]').reset();
	            }
			}
        })
	},
	
	T017_AgendarFechaFirmaArrasValidacion: function() {
		var me = this;
		var fechaEnvio = me.down('[name=fechaEnvio]');
		fechaEnvio.setValue($AC.getCurrentDate());
		me.bloquearCampo(fechaEnvio);
		me.campoObligatorio(fechaEnvio);
		var idExp = me.up('tramitesdetalle').getViewModel().get('tramite.idExpediente');
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		
		var fechaEnvio = me.down('[name=fechaEnvio]');
		var fechaEnvioPropuesta = me.down('[name=fechaEnvioPropuesta]');
		var comboQuitar = me.down('[name=comboQuitar]');
		
        var url =  $AC.getRemoteUrl('expedientecomercial/getUltimaFechaPropuesta');
		Ext.Ajax.request({
			url: url,
			params: {idExpediente : idExp},
		    success: function(response, opts) {
		    	var data = Ext.decode(response.responseText);
		    	var dto = data.data;
		    	
		    	if(!Ext.isEmpty(dto.fechaPropuesta)){		
		    		var fechaFirma = new Date(dto.fechaPropuesta);
			    	var campoFirma = me.down('[name=fechaEnvioPropuesta]');
			    	campoFirma.setValue(Ext.Date.format(fechaFirma, 'd/m/Y'));
			    	me.bloquearCampo(campoFirma);
					me.campoObligatorio(campoFirma);
		    	}
		    }
		});
		
		if (CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.habilitarCampo(comboQuitar);
			me.campoNoObligatorio(comboQuitar);
			comboQuitar.setValue('02');
			
			me.down('[name=comboQuitar]').addListener('change', function(combo) {
				if (combo.value == '01') { //SI
					me.deshabilitarCampo(fechaEnvio);
					me.borrarCampo(fechaEnvio);
					me.deshabilitarCampo(fechaEnvioPropuesta);
					me.borrarCampo(fechaEnvioPropuesta);
				} else { //NO
					me.habilitarCampo(fechaEnvio);
					me.campoObligatorio(fechaEnvio);
					me.habilitarCampo(fechaEnvioPropuesta);
					me.campoObligatorio(fechaEnvioPropuesta);
				}
			});
		} else {
			me.deshabilitarCampo(comboQuitar);
			me.ocultarCampo(comboQuitar);
		}
	},
	
	T017_ConfirmarFechaFirmaArrasValidacion: function() {
		var me = this;
		var fechaValidacionBc = me.down('[name=fechaValidacionBC]');
		var comboValidacionBC = me.down('[name=comboValidacionBC]');
		var fechaPropuesta = me.down('[name=fechaPropuesta]');
		var observacionesBC = me.down('[name=observacionesBC]');
		var comboQuitar = me.down('[name=comboQuitar]');
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		
		
		me.bloquearCampo(fechaPropuesta);
		me.campoObligatorio(fechaPropuesta);
		me.bloquearCampo(fechaValidacionBc);
		me.campoObligatorio(fechaValidacionBc);
		me.bloquearCampo(comboValidacionBC);
		me.campoObligatorio(comboValidacionBC);
		me.bloquearCampo(observacionesBC);

		
		var idExp = me.up('tramitesdetalle').getViewModel().get('tramite.idExpediente');
		var url =  $AC.getRemoteUrl('expedientecomercial/getConfirmacionBCFechaFirmaArras');
		Ext.Ajax.request({
			url: url,
			params: {idExpediente : idExp},
		    success: function(response, opts) {
		    	var data = Ext.decode(response.responseText);
		    	var dto = data.data;
		    	if(!Ext.isEmpty(dto)){
		    		fechaPropuesta.setValue(Ext.Date.format(new Date(dto.fechaPropuesta), 'd/m/Y'));
		    		fechaValidacionBc.setValue(Ext.Date.format(new Date(dto.fechaBC), 'd/m/Y'));
		    		comboValidacionBC.setValue(dto.validacionBC);
		    		observacionesBC.setValue(dto.comentariosBC);
		    	}
		    }
		});
		
		if (CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.habilitarCampo(comboQuitar);
			me.campoNoObligatorio(comboQuitar);
			comboQuitar.setValue('02');
			
			me.down('[name=comboQuitar]').addListener('change', function(combo) {
				if (combo.value == '01') { //SI
					me.deshabilitarCampo(fechaValidacionBc);
					me.borrarCampo(fechaValidacionBc);
					me.deshabilitarCampo(comboValidacionBC);
					me.borrarCampo(comboValidacionBC);
					me.deshabilitarCampo(fechaPropuesta);
					me.borrarCampo(fechaPropuesta);
					me.deshabilitarCampo(observacionesBC);
					me.borrarCampo(observacionesBC);
				} else { //NO
					me.habilitarCampo(fechaValidacionBc);
					me.campoObligatorio(fechaValidacionBc);
					me.habilitarCampo(comboValidacionBC);
					me.campoObligatorio(comboValidacionBC);
					me.habilitarCampo(fechaPropuesta);
					me.campoObligatorio(fechaPropuesta);
					me.habilitarCampo(observacionesBC);
					me.campoNoObligatorio(observacionesBC);
				}
			});
		} else {
			me.deshabilitarCampo(comboQuitar);
			me.ocultarCampo(comboQuitar);
		}
	},
	
	T017_AgendarPosicionamientoValidacion: function() {
		var me = this;
		var fechaEnvio = me.down('[name=fechaEnvio]');
		var comboArras = me.down('[name=comboArras]');
		var mesesFianza = me.down('[name=mesesFianza]');
		var importeFianza = me.down('[name=importeFianza]');
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		var fechaPropuestaFC = me.down('[name=fechaPropuestaFC]');
		
		fechaEnvio.setValue($AC.getCurrentDate());
		me.bloquearCampo(fechaEnvio);
		me.campoObligatorio(fechaEnvio);
		
		var idExp = me.up('tramitesdetalle').getViewModel().get('tramite.idExpediente');
		
        var url =  $AC.getRemoteUrl('expedientecomercial/getUltimoPosicionamientoSinContestar');
		Ext.Ajax.request({
			url: url,
			params: {idExpediente : idExp},
		    success: function(response, opts) {
		    	var data = Ext.decode(response.responseText);
		    	var dto = data.data;
		    	if(!Ext.isEmpty(dto.fechaPosicionamiento)){		
		    		var fechaPosicionamiento = new Date(dto.fechaPosicionamiento);
			    	var campoPosicionamiento = me.down('[name=fechaPropuestaFC]');
			    	campoPosicionamiento.setValue(Ext.Date.format(fechaPosicionamiento, 'd/m/Y'));
			    	me.bloquearCampo(campoPosicionamiento);
					me.campoObligatorio(campoPosicionamiento);
		    	}
		    }
		});
		
		if (CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.habilitarCampo(comboArras);
			me.campoObligatorio(comboArras);
			me.habilitarCampo(mesesFianza);
			me.campoObligatorio(mesesFianza);
			me.habilitarCampo(importeFianza);
			me.campoObligatorio(importeFianza);
			comboArras.setValue('02');
			
			me.down('[name=comboArras]').addListener('change', function(combo) {
				if (combo.value == '01') { //SI
					me.habilitarCampo(mesesFianza);
					me.campoObligatorio(mesesFianza);
					me.habilitarCampo(importeFianza);
					me.campoObligatorio(importeFianza);
					me.deshabilitarCampo(fechaPropuestaFC);
					me.borrarCampo(fechaPropuestaFC);
				} else { //NO
					me.deshabilitarCampo(mesesFianza);
					me.borrarCampo(mesesFianza);
					me.deshabilitarCampo(importeFianza);
					me.borrarCampo(importeFianza);
					me.habilitarCampo(fechaPropuestaFC);
					me.campoObligatorio(fechaPropuestaFC);
				}
			});
		} else {
			me.deshabilitarCampo(comboArras);
			me.ocultarCampo(comboArras);
			me.deshabilitarCampo(mesesFianza);
			me.ocultarCampo(mesesFianza);
			me.deshabilitarCampo(importeFianza);
			me.ocultarCampo(importeFianza);
		}
		
	},
	
	T017_ConfirmarFechaEscrituraValidacion: function() {
		var me = this;
		var  fechaPropuesta = me.down('[name=fechaPropuesta]');
		var comboValidacionBC = me.down('[name=comboValidacionBC]');
		var  fechaValidacionBc = me.down('[name=fechaRespuesta]');
		var observacionesBC = me.down('[name=observacionesBC]');
		
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');		
		var comboArras = me.down('[name=comboArras]');
		var mesesFianza = me.down('[name=mesesFianza]');
		var importeFianza = me.down('[name=importeFianza]');
		
		me.bloquearCampo(fechaPropuesta);
		me.campoObligatorio(fechaPropuesta);
		me.bloquearCampo(fechaValidacionBc);
		me.campoObligatorio(fechaValidacionBc);
		me.bloquearCampo(comboValidacionBC);
		me.campoObligatorio(comboValidacionBC);
		me.bloquearCampo(observacionesBC);

		
		var idExp = me.up('tramitesdetalle').getViewModel().get('tramite.idExpediente');
		var url =  $AC.getRemoteUrl('expedientecomercial/getConfirmacionBCPosicionamiento');
		Ext.Ajax.request({
			url: url,
			params: {idExpediente : idExp},
		    success: function(response, opts) {
		    	var data = Ext.decode(response.responseText);
		    	var dto = data.data;
		    	if(!Ext.isEmpty(dto)){
		    		fechaPropuesta.setValue(Ext.Date.format(new Date(dto.fechaPosicionamiento), 'd/m/Y'));
		    		fechaValidacionBc.setValue(Ext.Date.format(new Date(dto.fechaValidacionBCPos), 'd/m/Y'));
		    		comboValidacionBC.setValue(dto.validacionBCPosi);
		    		observacionesBC.setValue(dto.observacionesBcPos);
		    	}
		    }
		});
		
		if (CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.habilitarCampo(comboArras);
			me.campoObligatorio(comboArras);
			me.habilitarCampo(mesesFianza);
			me.campoObligatorio(mesesFianza);
			me.habilitarCampo(importeFianza);
			me.campoObligatorio(importeFianza);
			comboArras.setValue('02');
			
			me.down('[name=comboArras]').addListener('change', function(combo) {
				if (combo.value == '01') { //SI
					//me.deshabilitarCampo(comboValidacionBC);
					me.campoNoObligatorio(fechaValidacionBc);
					me.habilitarCampo(mesesFianza);
					me.campoObligatorio(mesesFianza);
					me.habilitarCampo(importeFianza);
					me.campoObligatorio(importeFianza);
				} else { //NO
					//me.habilitarCampo(comboValidacionBC);
					me.campoObligatorio(fechaValidacionBc);					
					me.deshabilitarCampo(mesesFianza);
					me.borrarCampo(mesesFianza);
					me.deshabilitarCampo(importeFianza);
					me.borrarCampo(importeFianza);
				}
			});
		} else {
			me.deshabilitarCampo(comboArras);
			me.ocultarCampo(comboArras);
			me.deshabilitarCampo(mesesFianza);
			me.ocultarCampo(mesesFianza);
			me.deshabilitarCampo(importeFianza);
			me.ocultarCampo(importeFianza);
		}
	},
	
	T017_BloqueoScreeningValidacion: function(){
		var me = this;
		
		var idTarea = me.idTarea;
		var motivoBloqueado = me.down('[name=motivoBloqueado]');
		var motivoDesbloqueado = me.down('[name=motivoDesbloqueado]');
		var observacionesBloqueado = me.down('[name=observacionesBloqueado]');
		var observacionesDesbloqueado = me.down('[name=observacionesDesbloqueado]');
		var comboResultado = me.down('[name=comboResultado]');
		
		motivoBloqueado.setReadOnly(true);
		motivoDesbloqueado.setReadOnly(true);
		observacionesBloqueado.setReadOnly(true);
		observacionesDesbloqueado.setReadOnly(true);
		comboResultado.setReadOnly(true);
		
		var url =  $AC.getRemoteUrl('expedientecomercial/getValoresTareaBloqueoScreening');
		Ext.Ajax.request({
			url: url,
			params: {idTarea : idTarea},
		    success: function(response, opts) {
		    	var data = Ext.decode(response.responseText);
		    	var dto = data.data;
		    	
		    	if(!Ext.isEmpty(dto)){
		    		motivoBloqueado.setValue(dto.motivoBloqueado);
		    		motivoDesbloqueado.setValue(dto.motivoDesbloqueado);
		    		observacionesBloqueado.setValue(dto.observacionesBloqueado);
		    		observacionesDesbloqueado.setValue(dto.observacionesDesbloqueado);
		    		comboResultado.setValue(dto.comboResultado);
		    		
		    	}
		    }
		});
		
	
		
	},
	
	T015_BloqueoScreeningValidacion: function(){
		var me = this;
		
		var idTarea = me.idTarea;
		var motivoBloqueado = me.down('[name=motivoBloqueado]');
		var motivoDesbloqueado = me.down('[name=motivoDesbloqueado]');
		var observacionesBloqueado = me.down('[name=observacionesBloqueado]');
		var observacionesDesbloqueado = me.down('[name=observacionesDesbloqueado]');
		var comboResultado = me.down('[name=comboResultado]');
		
		motivoBloqueado.setReadOnly(true);
		motivoDesbloqueado.setReadOnly(true);
		observacionesBloqueado.setReadOnly(true);
		observacionesDesbloqueado.setReadOnly(true);
		comboResultado.setReadOnly(true);
		
		var url =  $AC.getRemoteUrl('expedientecomercial/getValoresTareaBloqueoScreening');
		Ext.Ajax.request({
			url: url,
			params: {idTarea : idTarea},
		    success: function(response, opts) {
		    	var data = Ext.decode(response.responseText);
		    	var dto = data.data;
		    	
		    	if(!Ext.isEmpty(dto)){
		    		motivoBloqueado.setValue(dto.motivoBloqueado);
		    		motivoDesbloqueado.setValue(dto.motivoDesbloqueado);
		    		observacionesBloqueado.setValue(dto.observacionesBloqueado);
		    		observacionesDesbloqueado.setValue(dto.observacionesDesbloqueado);
		    		comboResultado.setValue(dto.comboResultado);
		    		
		    	}
		    }
		});
		
	
		
	},
	
	T015_SolicitarGarantiasAdicionalesValidacion: function(){
		

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
			me.habilitarCampo(comboResultado);
			me.campoObligatorio(comboResultado);
			me.habilitarCampo(motivoAplazamiento);
			me.campoObligatorio(motivoAplazamiento);
			tipoArras.setValue(CONST.TIPO_ARRAS['CODIGO_PENITENCIALES']);
			me.bloquearCampo(tipoArras);
			me.habilitarCampo(comboQuitar);
			me.campoObligatorio(comboQuitar);
			comboQuitar.setValue('02');
			
	        me.down('[name=comboResultado]').addListener('change', function(combo) {
	            if (combo.value == '01') { //SI
	            	me.habilitarCampo(motivoAplazamiento);
					me.campoObligatorio(motivoAplazamiento);
					me.deshabilitarCampo(fechaEnvio);
					me.borrarCampo(fechaEnvio);

	            } else { //NO
					me.deshabilitarCampo(motivoAplazamiento);
					me.borrarCampo(motivoAplazamiento);
					me.habilitarCampo(fechaEnvio);
					me.campoObligatorio(fechaEnvio);
	            }
        	});
	        
	        me.down('[name=comboQuitar]').addListener('change', function(combo) {
	            if (combo.value == '01') { //SI
	            	me.deshabilitarCampo(comboResultado);
					me.borrarCampo(comboResultado);
	            	me.deshabilitarCampo(motivoAplazamiento);
					me.borrarCampo(motivoAplazamiento);
					me.deshabilitarCampo(tipoArras);
					me.borrarCampo(tipoArras);
					me.deshabilitarCampo(fechaEnvio);
					me.borrarCampo(fechaEnvio);

	            } else { //NO
					me.habilitarCampo(comboResultado);
					me.habilitarCampo(motivoAplazamiento);
					me.habilitarCampo(tipoArras);
					me.habilitarCampo(fechaEnvio);
					tipoArras.setValue(CONST.TIPO_ARRAS['CODIGO_PENITENCIALES']);
					me.bloquearCampo(tipoArras);
	            }
        	});
			
		}else{
			//SI NO ES CAIXA/BANKIA
			me.deshabilitarCampo(comboResultado);
			me.ocultarCampo(comboResultado);
			me.deshabilitarCampo(motivoAplazamiento);
			me.ocultarCampo(motivoAplazamiento);
		}
	},
	T017_FirmaContratoValidacion: function() {
		var me = this;
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
				
		var comboArras = me.down('[name=comboArras]');
		var mesesFianza = me.down('[name=mesesFianza]');
		var importeFianza = me.down('[name=importeFianza]');
		
		var comboResultado = me.down('[name=comboResultado]');
		var motivoAplazamiento = me.down('[name=motivoAplazamiento]');
		
		var comboFirma = me.down('[name=comboFirma]');
		var fechaFirma = me.down('[name=fechaFirma]');
		var numeroProtocolo = me.down('[name=numeroProtocolo]');
		
		if (CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.habilitarCampo(comboResultado);
			me.campoObligatorio(comboResultado);
			me.habilitarCampo(motivoAplazamiento);
			me.campoObligatorio(motivoAplazamiento);
			
			me.habilitarCampo(comboArras);
			me.campoObligatorio(comboArras);
			me.habilitarCampo(mesesFianza);
			me.campoObligatorio(mesesFianza);
			me.habilitarCampo(importeFianza);
			me.campoObligatorio(importeFianza);
			comboArras.setValue('02');
						
			me.down('[name=comboArras]').addListener('change', function(combo) {
				if (combo.value == '01') { //SI
					me.deshabilitarCampo(motivoAplazamiento);
					me.campoNoObligatorio(motivoAplazamiento);
					me.deshabilitarCampo(comboFirma);
					me.borrarCampo(comboFirma);
					me.deshabilitarCampo(fechaFirma);
					me.borrarCampo(fechaFirma);
					me.deshabilitarCampo(numeroProtocolo);
					me.borrarCampo(numeroProtocolo);
					me.deshabilitarCampo(comboResultado);
					me.borrarCampo(comboResultado);
					me.deshabilitarCampo(comboFirma);
					me.borrarCampo(comboFirma);
					me.deshabilitarCampo(fechaFirma);
					me.borrarCampo(fechaFirma);
					me.deshabilitarCampo(numeroProtocolo);
					me.borrarCampo(numeroProtocolo);
					me.borrarCampo(motivoAplazamiento);
					
					me.habilitarCampo(comboArras);
					me.campoObligatorio(comboArras);
					me.habilitarCampo(mesesFianza);
					me.campoObligatorio(mesesFianza);
					me.habilitarCampo(importeFianza);
					me.campoObligatorio(importeFianza);
				} else { //NO
					me.habilitarCampo(motivoAplazamiento);
					me.campoObligatorio(motivoAplazamiento);
					me.borrarCampo(motivoAplazamiento);
					me.habilitarCampo(comboFirma);
					me.campoNoObligatorio(comboFirma);					
					me.habilitarCampo(fechaFirma);
					me.campoNoObligatorio(fechaFirma);
					me.habilitarCampo(numeroProtocolo);
					me.campoNoObligatorio(numeroProtocolo);
					me.habilitarCampo(comboResultado);
					me.campoObligatorio(comboResultado);
					me.deshabilitarCampo(comboFirma);
					me.borrarCampo(comboFirma);
					me.deshabilitarCampo(fechaFirma);
					me.borrarCampo(fechaFirma);
					me.deshabilitarCampo(numeroProtocolo);
					me.borrarCampo(numeroProtocolo);
					
					
					//me.deshabilitarCampo(motivoAplazamiento);
					//me.borrarCampo(comboArras);
					me.deshabilitarCampo(mesesFianza);
					me.borrarCampo(mesesFianza);
					me.deshabilitarCampo(importeFianza);
					me.borrarCampo(importeFianza);
				}
			});
			me.down('[name=comboResultado]').addListener('change', function(combo) {
				if (combo.value == '01') { //SI
					me.habilitarCampo(motivoAplazamiento);
					me.campoObligatorio(motivoAplazamiento);
					me.deshabilitarCampo(comboFirma);
					me.borrarCampo(comboFirma);
					me.deshabilitarCampo(fechaFirma);
					me.borrarCampo(fechaFirma);
					me.deshabilitarCampo(numeroProtocolo);
					me.borrarCampo(numeroProtocolo);
					//me.borrarCampo(comboArras);
					me.deshabilitarCampo(mesesFianza);
					me.borrarCampo(mesesFianza);
					me.deshabilitarCampo(importeFianza);
					me.borrarCampo(importeFianza);
					
				} else { //NO
					me.deshabilitarCampo(motivoAplazamiento);
					me.borrarCampo(motivoAplazamiento);
					me.habilitarCampo(comboFirma);
					me.campoNoObligatorio(comboFirma);					
					me.habilitarCampo(fechaFirma);
					me.campoNoObligatorio(fechaFirma);
					me.habilitarCampo(numeroProtocolo);
					me.campoNoObligatorio(numeroProtocolo);					
					//me.habilitarCampo(comboArras);
					me.campoObligatorio(comboArras);
					me.deshabilitarCampo(mesesFianza);
					me.borrarCampo(mesesFianza);
					me.deshabilitarCampo(importeFianza);
					me.borrarCampo(importeFianza);
				}
			});
			
		} else { //SI NO ES CAIXA/BANKIA
			me.deshabilitarCampo(comboResultado);
			me.ocultarCampo(comboResultado);
			me.deshabilitarCampo(motivoAplazamiento);
			me.ocultarCampo(motivoAplazamiento);
			
			me.deshabilitarCampo(comboArras);
			me.ocultarCampo(comboArras);
			me.deshabilitarCampo(mesesFianza);
			me.ocultarCampo(mesesFianza);
			me.deshabilitarCampo(importeFianza);
			me.ocultarCampo(importeFianza);
		}
	},
	T017_PBCReservaValidacion: function(){
		var me = this;
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		
		var comboRespuesta = me.down('[name=comboRespuesta]');
		var comboQuitar = me.down('[name=comboQuitar]');
		
		if (CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.habilitarCampo(comboQuitar);
			me.campoNoObligatorio(comboQuitar);
			comboQuitar.setValue('02');
			
			me.down('[name=comboQuitar]').addListener('change', function(combo) {
				if (combo.value == '01') { //SI
					me.deshabilitarCampo(comboRespuesta);
					me.borrarCampo(comboRespuesta);
				} else { //NO
					me.habilitarCampo(comboRespuesta);
					me.campoObligatorio(comboRespuesta);
				}
			});
		} else {
			me.deshabilitarCampo(comboQuitar);
			me.ocultarCampo(comboQuitar);
		}
		
	},
	
	T017_PBCVentaValidacion: function(){
		var me = this;
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		
		var comboArras = me.down('[name=comboArras]');
		var mesesFianza = me.down('[name=mesesFianza]');
		var importeFianza = me.down('[name=importeFianza]');
		var comboRespuesta = me.down('[name=comboRespuesta]');
		
		if (CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.habilitarCampo(comboArras);
			me.campoObligatorio(comboArras);
			me.habilitarCampo(mesesFianza);
			me.campoObligatorio(mesesFianza);
			me.habilitarCampo(importeFianza);
			me.campoObligatorio(importeFianza);
			comboArras.setValue('02');
			
			me.down('[name=comboArras]').addListener('change', function(combo) {
				if (combo.value == '01') { //SI
					me.deshabilitarCampo(comboRespuesta);
					me.borrarCampo(comboRespuesta);
					me.habilitarCampo(mesesFianza);
					me.campoObligatorio(mesesFianza);
					me.habilitarCampo(importeFianza);
					me.campoObligatorio(importeFianza);
				} else { //NO
					me.habilitarCampo(comboRespuesta);
					me.campoObligatorio(comboRespuesta);
					me.deshabilitarCampo(mesesFianza);
					me.borrarCampo(mesesFianza);
					me.deshabilitarCampo(importeFianza);
					me.borrarCampo(importeFianza);
				}
			});
		} else {
			me.deshabilitarCampo(comboArras);
			me.ocultarCampo(comboArras);
			me.deshabilitarCampo(mesesFianza);
			me.ocultarCampo(mesesFianza);
			me.deshabilitarCampo(importeFianza);
			me.ocultarCampo(importeFianza);
		}
	},
	
	T015_AgendarFechaFirmaValidacion: function(){
		var me = this;
		var comboRespuesta = me.down('[name=comboResultado]');
		var fechaFirma = me.down('[name=fechaFirma]');
		var lugarFirma = me.down('[name=lugarFirma]');

		
		me.deshabilitarCampo(fechaFirma);
		me.deshabilitarCampo(lugarFirma);
		comboRespuesta.addListener('change', function(combo) {
			if(CONST.COMBO_SIN_SINO['SI'] === comboRespuesta.getValue()){
				me.habilitarCampo(fechaFirma);
				me.habilitarCampo(lugarFirma);
			}else{
				me.deshabilitarCampo(fechaFirma);
				me.deshabilitarCampo(lugarFirma);
				fechaFirma.setValue('');
				lugarFirma.setValue('');
			}

        })
	},
	
	
	T018_AnalisisBcValidacion: function(){
		var me = this;
		var comboRespuesta = me.down('[name=comboResultado]');
		var comboTipoOferta = me.down('[name=tipoOfertaAlquiler]');
		var comboIsVulnerable = me.down('[name=isVulnerable]');
		var comboIsVulnerableAnalisisT = me.down('[name=isVulnerableAnalisisT]');
		var idExpediente = me.up('tramitesdetalle').getViewModel().get('tramite.idExpediente');
		
		me.bloquearObligatorio(comboTipoOferta);
		me.bloquearObligatorio(comboIsVulnerable);
		me.deshabilitarCampo(comboIsVulnerableAnalisisT);

		var url =  $AC.getRemoteUrl('expedientecomercial/getInfoCaminosAlquilerNoComercial');
		Ext.Ajax.request({
			url: url,
			params: {idExpediente : idExpediente},
		    success: function(response, opts) {
		    	var data = Ext.decode(response.responseText);
		    	var dto = data.data;
		    	if(!Ext.isEmpty(dto)){			    		
		    		comboTipoOferta.setValue(dto.codigoTipoAlquiler);
		    		comboIsVulnerable.setValue(dto.isVulnerable);
		    	}
		    }
		});
		
		comboRespuesta.addListener('change', function(combo) {
			if(CONST.COMBO_SIN_SINO['SI'] === comboRespuesta.getValue()){
				if(CONST.TIPO_OFERTA_ALQUILER_NO_COMERCIAL['CODIGO_ALQUILER_SOCIAL'] === comboTipoOferta.getValue() && CONST.COMBO_SIN_SINO['SI'] === comboIsVulnerable.getValue()){
					me.habilitarCampo(comboIsVulnerableAnalisisT);
					me.campoObligatorio(comboIsVulnerableAnalisisT);
				}
			}else{
				me.deshabilitarCampo(comboIsVulnerableAnalisisT);
				me.borrarCampo(comboIsVulnerableAnalisisT)
			}

        });				
	},
	
	T018_ScoringValidacion: function(){
		var me = this;
		var comboRespuesta = me.down('[name=comboResultado]');
		var comboMotivoAnulacion = me.down('[name=motivoAnulacion]');
	
		me.deshabilitarCampo(comboMotivoAnulacion);

		comboRespuesta.addListener('change', function(combo) {
			if(CONST.TIPO_RESOLUCION_DUDAS['APRUEBA'] !== comboRespuesta.getValue()){
				me.habilitarCampo(comboMotivoAnulacion);
				me.campoObligatorio(comboMotivoAnulacion);

			}else{
				me.deshabilitarCampo(comboMotivoAnulacion);
			}
        });
	},
	
	T018_ScoringBcValidacion: function(){
		var me = this;
		var comboRespuesta = me.down('[name=comboResultado]');
		var comboMotivoAnulacion = me.down('[name=motivoAnulacion]');
	
		me.deshabilitarCampo(comboMotivoAnulacion);
		comboRespuesta.addListener('change', function(combo) {
			if(CONST.COMBO_SIN_SINO['NO'] === comboRespuesta.getValue()){
				me.habilitarCampo(comboMotivoAnulacion);
				me.campoObligatorio(comboMotivoAnulacion);

			}else{
				me.deshabilitarCampo(comboMotivoAnulacion);
			}
        });
	},
	
	T018_ResolucionComiteValidacion: function(){
		var me = this;
		var comboRespuesta = me.down('[name=comboResultado]');
		var comboMotivoAnulacion = me.down('[name=motivoAnulacion]');
	
		me.deshabilitarCampo(comboMotivoAnulacion);
		comboRespuesta.addListener('change', function(combo) {
			if(CONST.COMBO_SIN_SINO['NO'] === comboRespuesta.getValue()){
				me.habilitarCampo(comboMotivoAnulacion);
				me.campoObligatorio(comboMotivoAnulacion);

			}else{
				me.deshabilitarCampo(comboMotivoAnulacion);
			}
        });
	},
	
	T018_DefinicionOfertaValidacion: function(){
		var me = this;
		var comboTipoOferta = me.down('[name=tipoOfertaAlquiler]');
		var comboIsVulnerable = me.down('[name=isVulnerable]');
		var textExpedienteAnterior = me.down('[name=expedienteAnterior]');
		
		me.deshabilitarCampo(textExpedienteAnterior);
		me.deshabilitarCampo(comboIsVulnerable);

		comboTipoOferta.addListener('change', function(combo) {
			if(CONST.TIPO_OFERTA_ALQUILER_NO_COMERCIAL['CODIGO_ALQUILER_SOCIAL'] === comboTipoOferta.getValue()){
				me.habilitarCampo(comboIsVulnerable);
				me.campoObligatorio(comboIsVulnerable);
				me.deshabilitarCampo(textExpedienteAnterior);
			}else if(CONST.TIPO_OFERTA_ALQUILER_NO_COMERCIAL['CODIGO_RENOVACION'] === comboTipoOferta.getValue()){
				me.habilitarCampo(textExpedienteAnterior);
				textExpedienteAnterior.allowBlank = false;	
				me.deshabilitarCampo(comboIsVulnerable);
			}
        });
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
    ocultarCampo: function(campo) {
        var me = this;
        campo.setHidden(true);
    },
    desocultarCampo: function(campo) {
        var me = this;
        campo.setHidden(false);
    },
    
    setFechaActual: function(campo){
    	var fecha = new Date();
		campo.setValue(Ext.Date.format(fecha, 'd/m/Y'));
    },
    
    ocultaryHacerNoObligatorio: function(campo){
    	var me = this;
        campo.setHidden(true);
        campo.allowBlank = true;
    },
    
    bloquearObligatorio: function(campo){
    	var me = this;
        campo.setReadOnly(true);
        campo.allowBlank = false;
    },
    editableyNoObligatorio: function(campo){
    	var me = this;
        campo.setReadOnly(false);
        campo.allowBlank = true;
    }
});

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

                if (me.json.errorValidacionGuardado) {
                    me.getViewModel().set("errorValidacionGuardado", me.json.errorValidacionGuardado);
                    me.unmask();
                } else {
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
        me.deshabilitarCampo(me.down('[name=comboAseguradoras]'));
        me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
        if (esTarifaPlana) {
            me.bloquearCampo(me.down('[name=comboTarifa]'));
        }


        me.down('[name=comboTramitar]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
                me.habilitarCampo(me.down('[name=comboCubierto]'));
                if (me.down('[name=comboCubierto]').value == '01') {
                    me.habilitarCampo(me.down('[name=comboAseguradoras]'));
                }
                me.habilitarCampo(me.down('[name=comboTarifa]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
                me.deshabilitarCampo(me.down('[name=comboCubierto]'));
                me.deshabilitarCampo(me.down('[name=comboAseguradoras]'));
                me.deshabilitarCampo(me.down('[name=comboTarifa]'));
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
        
        me.down('[name=fechaTope]').allowBlank = true;
        me.down('[name=fechaConcreta]').allowBlank = true;
        me.down('[name=horaConcreta]').allowBlank = true;
        
        if (me.down('[name=fechaTope]').value != null) {
            me.down('[name=fechaConcreta]').reset();
            me.down('[name=horaConcreta]').reset();
        } else if (me.down('[name=fechaConcreta]').value != null) {
            me.down('[name=fechaTope]').reset();
        } else {
            
        }

        me.down('[name=fechaTope]').addListener('focus', function(campo) {
            me.down('[name=fechaConcreta]').reset();
            me.down('[name=horaConcreta]').reset();
            me.down('[name=fechaConcreta]').setValue('');
            me.down('[name=horaConcreta]').setValue('');
        });

        me.down('[name=fechaConcreta]').addListener('focus', function(campo) {
            me.down('[name=fechaTope]').reset();
            me.down('[name=fechaTope]').setValue('');
        });

        me.down('[name=horaConcreta]').addListener('focus', function(campo) {
            me.down('[name=fechaTope]').reset();
            me.down('[name=fechaTope]').setValue('');
        })
    },


    T004_ResultadoNoTarificadaValidacion: function() {
        var me = this;

        me.deshabilitarCampo(me.down('[name=fechaFinalizacion]'));

        me.down('[name=comboModificacion]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=fechaFinalizacion]'));
            } else {
                me.habilitarCampo(me.down('[name=fechaFinalizacion]'));
            }
        })


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

        me.down('[name=comboTramitar]').addListener('change', function(combo) {
            if (combo.value == '01') {
                me.deshabilitarCampo(me.down('[name=motivoDenegacion]'));
            } else {
                me.habilitarCampo(me.down('[name=motivoDenegacion]'));
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
        me.ocultarCampo(me.down('[name=comboDatosIguales]'));

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
		if(CONST.CARTERA['BANKIA'] == codigoCartera) {
			me.desocultarCampo(comiteSuperior);
		}else{
			me.ocultarCampo(comiteSuperior);
		}
		
		if(CONST.CARTERA['LIBERBANK'] == codigoCartera) {
			me.bloquearCampo(comite);
		} else {
			me.desbloquearCampo(comite);
		}
	},
	T013_DocumentosPostVentaValidacion: function() {
		var me = this;
		var fechaIngreso = me.down('[name=fechaIngreso]');
		var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');
		fechaIngreso.setMaxValue($AC.getCurrentDate());

		if(!Ext.isEmpty(fechaIngreso.getValue())) {
			me.deshabilitarCampo(me.down('[name=checkboxVentaDirecta]'));
			me.bloquearCampo(me.down('[name=fechaIngreso]'));
		} else {
			me.habilitarCampo(me.down('[name=checkboxVentaDirecta]'));
			me.deshabilitarCampo(me.down('[name=fechaIngreso]'));
		}

		me.down('[name=checkboxVentaDirecta]').addListener('change', function(checkbox, newValue, oldValue, eOpts) {
			if(CONST.CARTERA['LIBERBANK'] != codigoCartera){
				if (newValue) {
	            	me.habilitarCampo(me.down('[name=fechaIngreso]'));
	            	me.down('[name=fechaIngreso]').allowBlank = false;
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
		
        me.down('[name=comboResolucion]').addListener('change', function(combo) {
            if (combo.value == '03') {
                me.habilitarCampo(me.down('[name=numImporteContra]'));
            } else {
                me.deshabilitarCampo(me.down('[name=numImporteContra]'));
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
    },

    T013_ResolucionExpedienteValidacion: function() {
        var me = this;
        var tipoArras = me.down('[name=tipoArras]');
        var estadoReserva = me.down('[name=estadoReserva]');
        var codigoCartera = me.up('tramitesdetalle').getViewModel().get('tramite.codigoCartera');

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
    	
    	me.campoObligatorio(me.down('[name=tipoInquilino]'));
    	me.campoObligatorio(me.down('[name=tipoTratamiento]'));

    	me.deshabilitarCampo(me.down('[name=nMesesFianza]'));
    	me.deshabilitarCampo(me.down('[name=importeFianza]'));
    	me.deshabilitarCampo(me.down('[name=deposito]'));
    	me.deshabilitarCampo(me.down('[name=nMeses]'));
    	me.deshabilitarCampo(me.down('[name=importeDeposito]'));
    	me.deshabilitarCampo(me.down('[name=fiadorSolidario]'));
    	me.deshabilitarCampo(me.down('[name=nombreFS]'));
    	me.deshabilitarCampo(me.down('[name=documento]'));
    	me.deshabilitarCampo(me.down('[name=tipoImpuesto]'));
    	me.deshabilitarCampo(me.down('[name=porcentajeImpuesto]'));

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
 
    },
    
    T015_FirmaValidacion: function(){
    	var me = this;
    	
    	me.down('[name=fechaFirma]').noObligatorio=false;
    	me.campoObligatorio(me.down('[name=fechaFirma]'));
    },
    
    T015_VerificarScoringValidacion: function(){
    	var me = this;
    	
    	me.campoObligatorio(me.down('[name=resultadoScoring]'));
    	me.deshabilitarCampo(me.down('[name=nMeses]'));
    	me.deshabilitarCampo(me.down('[name=importeDeposito]'));
    	me.deshabilitarCampo(me.down('[name=nombreFS]'));
    	me.deshabilitarCampo(me.down('[name=documento]'));
    	
    	
    	me.down('[name=resultadoScoring]').addListener('change', function() {
    		var resultadoScoring = me.down('[name=resultadoScoring]');
    		if(resultadoScoring.value == '01'){
    			
    			me.down('[name=nMesesFianza]').noObligatorio=false;
    			me.down('[name=importeFianza]').noObligatorio=false;
    			me.down('[name=nExpediente]').noObligatorio=false;
    			
    			me.habilitarCampo(me.down('[name=nMesesFianza]'));
    			me.habilitarCampo(me.down('[name=importeFianza]'));
    			me.habilitarCampo(me.down('[name=motivoRechazo]'));
    			
    			me.campoObligatorio(me.down('[name=nMesesFianza]'));
    			me.campoObligatorio(me.down('[name=importeFianza]'));
    			me.campoObligatorio(me.down('[name=nExpediente]'));
    			
    			me.down('[name=motivoRechazo]').noObligatorio=true;
            	me.deshabilitarCampo(me.down('[name=motivoRechazo]'));
            	me.borrarCampo(me.down('[name=motivoRechazo]'));
            	me.campoNoObligatorio(me.down('[name=motivoRechazo]'));

    			
    		}else{
    			me.down('[name=nMesesFianza]').noObligatorio=true;
    			me.down('[name=importeFianza]').noObligatorio=true;
    			me.down('[name=motivoRechazo]').noObligatorio=false;
    			me.down('[name=nExpediente]').noObligatorio=true;

            	me.deshabilitarCampo(me.down('[name=nMesesFianza]'));
            	me.deshabilitarCampo(me.down('[name=importeFianza]'));
    			
            	me.habilitarCampo(me.down('[name=motivoRechazo]'));
            	
            	me.borrarCampo(me.down('[name=nMesesFianza]'));
            	me.borrarCampo(me.down('[name=importeFianza]'));
    			
            	me.campoNoObligatorio(me.down('[name=nMesesFianza]'));
            	me.campoNoObligatorio(me.down('[name=importeFianza]'));
            	me.campoNoObligatorio(me.down('[name=nExpediente]'));
            	
    			me.campoObligatorio(me.down('[name=motivoRechazo]'));

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
    	
    	me.campoObligatorio(me.down('[name=resultadoRentas]'));
    	me.campoObligatorio(me.down('[name=aseguradora]'));
    	
    	me.deshabilitarCampo(me.down('[name=nMeses]'));
    	me.deshabilitarCampo(me.down('[name=importeDeposito]'));
    	me.deshabilitarCampo(me.down('[name=nombreFS]'));
    	me.deshabilitarCampo(me.down('[name=documento]'));
    	me.deshabilitarCampo(me.down('[name=nMesesFianza]'));
    	me.deshabilitarCampo(me.down('[name=importeFianza]'));
    	
    	me.down('[name=resultadoRentas]').addListener('change', function() {
    		var resultadoRentas = me.down('[name=resultadoRentas]');

    		if(resultadoRentas.value == '01'){
    			
    			me.down('[name=nMesesFianza]').noObligatorio=false;
    			me.down('[name=importeFianza]').noObligatorio=false;
    			
    			me.habilitarCampo(me.down('[name=nMesesFianza]'));
    			me.habilitarCampo(me.down('[name=importeFianza]'));
    			
    			me.campoObligatorio(me.down('[name=nMesesFianza]'));
    			me.campoObligatorio(me.down('[name=importeFianza]'));
    		}else{
    			me.down('[name=nMesesFianza]').noObligatorio=true;
    			me.down('[name=importeFianza]').noObligatorio=true;
    			
            	me.deshabilitarCampo(me.down('[name=nMesesFianza]'));
            	me.deshabilitarCampo(me.down('[name=importeFianza]'));
            	
            	me.borrarCampo(me.down('[name=nMesesFianza]'));
            	me.borrarCampo(me.down('[name=importeFianza]'));
    			
            	me.campoNoObligatorio(me.down('[name=nMesesFianza]'));
            	me.campoNoObligatorio(me.down('[name=importeFianza]'));
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

    	me.campoObligatorio(me.down('[name=resolucionOferta]'));
    	
    	me.deshabilitarCampo(me.down('[name=motivoAnulacion]'));
		me.deshabilitarCampo(me.down('[name=comite]'));
		me.deshabilitarCampo(me.down('[name=fechaElevacion]'));
		
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

    		if(resolucionOferta.value == '01'){

        		me.down('[name=motivoAnulacion]').noObligatorio=true;
    			me.down('[name=fechaElevacion]').noObligatorio=false;
    			me.down('[name=comite]').noObligatorio=true;
    			
    			me.deshabilitarCampo(me.down('[name=motivoAnulacion]'));
    			me.habilitarCampo(me.down('[name=comite]'));
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
    			
    		}
    	});
    	
    },
    
    
    T015_ResolucionExpedienteValidacion: function(){
    	var me = this;
    	me.deshabilitarCampo(me.down('[name=motivo]'));
    	me.deshabilitarCampo(me.down('[name=importeContraoferta]'));
    	
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
    			
    			me.down('[name=motivo]').noObligatorio=true;
    			me.down('[name=importeContraoferta]').noObligatorio=true;
    			
    			me.habilitarCampo(me.down('[name=motivo]'));
    			me.deshabilitarCampo(me.down('[name=importeContraoferta]'));

    		}

    	});
    	
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
    	
    	me.down('[name=ncontratoPrinex]').addListener('change', function(){
    		var ncontratoPrinex = me.down('[name=ncontratoPrinex]');

    		if(ncontratoPrinex.value.length < 9){
    			if(ncontratoPrinex.value.length == 4){
        			ncontratoPrinex.setValue(ncontratoPrinex.value + '-'); 
        		}
    		}else{
    			me.down('[name=ncontratoPrinex]').noObligatorio=true;
    			me.campoNoObligatorio(me.down('[name=ncontratoPrinex]'));
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
    }

});

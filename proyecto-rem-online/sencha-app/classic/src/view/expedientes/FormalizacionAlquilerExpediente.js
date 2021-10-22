Ext.define('HreRem.view.expedientes.FormalizacionAlquilerExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'formalizacionalquilerexpediente',
    cls: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'formalizacionalquilerexpediente',
    scrollable: 'y',
    recordName : "resolucionalquiler",
	recordClass : "HreRem.model.ExpedienteFormalizacionAlquilerResolucion",
	requires : ['HreRem.model.ExpedienteFormalizacionAlquilerResolucion'],
	refreshAfterSave: true,
	listeners : {
		boxready : function() {
			var me = this;
			me.lookupController().cargarTabData(me);
		}
	},

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.formalizacion'));
        
        var coloredRender = function (value, meta, record) {
            var borrado = record.get('fechaFinPosicionamiento');
            if (value) {
                if (borrado) {
                    return '<span style="color: #DF0101;">' + value + '</span>';
                } else {
                    return value;
                }
            } else {
                return '-';
            }
        };

        var dateColoredRender = function (value, meta, record) {
            var valor = dateRenderer(value);
            return coloredRender(valor, meta, record);
        };

        var hourColoredRender = function (value, meta, record) {
            var valor = hourRenderer(value);
            return coloredRender(valor, meta, record);
        };

        var dateRenderer = function (value, rec) {
            if (!Ext.isEmpty(value)) {
                var newDate = new Date(value);
                var formattedDate = Ext.Date.format(newDate, 'd/m/Y');
                return formattedDate;
            } else {
                return value;
            }
        };

        var hourRenderer = function (value, rec) {
            if (!Ext.isEmpty(value)) {
                var newDate = new Date(value);
                var formattedDate = Ext.Date.format(newDate, 'H:i');
                return formattedDate;
            } else {
                return value;
            }
        };

        var items = [
            // Apartado Posicionamiento y Firma.
            {
                xtype : 'fieldset',
                collapsible : true,
                defaultType : 'displayfieldbase',
                cls : 'panel-base shadow-panel',
                title : HreRem.i18n('title.publicaciones.alquiler'),
                items : [{
					xtype : 'datefieldbase',
					fieldLabel : HreRem.i18n('header.fecha.inicio'),
					bind : {
						value : '{resolucionalquiler.fechaInicioCnt}'
					}
				},
				{
					xtype : 'datefieldbase',
					fieldLabel : HreRem.i18n('header.fecha.fin'),
					maxValue: null,
					bind : {
						value : '{resolucionalquiler.fechaFinCnt}'
					}
				},{
                    xtype : 'gridBaseEditableRow',
                    title : HreRem.i18n('title.posicionamiento'),
                    reference : 'listadoPosicionamiento',
                    idPrincipal : 'expediente.id',
                    topBar : true,
                    removeButton: false,
                    editOnSelect: true,
                    bind : {
                        store : '{storePosicionamientos}',
                        topBar : '{!esExpedienteBloqueado}'
                    },
                    listeners : {
                        rowdblclick : 'comprobacionesDobleClickAlquiler',
                        beforeedit : 'comprobarCamposFechasAlquiler',
                        rowclick : 'onRowClickPosicionamientoAlquiler'
                    },
                    columns : [{
                                text : HreRem.i18n('fieldlabel.fecha.alta'),
                                dataIndex : 'fechaAlta',
                                // formatter: 'date("d/m/Y")',
                                flex : 1,
                                renderer : dateColoredRender
                            }, {
                                text : HreRem.i18n('fieldlabel.fecha.firma'),
                                dataIndex : 'fechaPosicionamiento',
                                //formatter: 'date("d/m/Y")',
                                flex : 1,
                                editor : {
                                    xtype : 'datefield',
                                    reference : 'fechaFirmaRef',
                                    allowBlank : false,
                                    listeners : {
                                        change : 'changeFecha'
                                    }
                                },
                                renderer : dateColoredRender
                            }, {
                                text : HreRem.i18n('fieldlabel.hora.firma'),
                                dataIndex : 'horaPosicionamiento',
                                // formatter: 'date("H:i")',
                                hidden : true,
								hideable: false,
                                flex : 0.5,
                                editor : {
                                    xtype : 'timefieldbase',
                                    addUxReadOnlyEditFieldPlugin : false,
                                    labelWidth : 150,
                                    format : 'H:i',
                                    increment : 15,
                                    reference : 'horaFirmaRef',
                                    disabled : true,
                                    allowBlank : true/*,
                                    listeners : {
                                        change : 'changeHora'
                                    }*/
                                },
                                renderer : hourColoredRender
                            }, {
                                text : HreRem.i18n('fieldlabel.formalizacion.lugar.firma'),
                                dataIndex : 'lugarFirma',
                                flex : 1,
                                editor : {
                                    xtype : 'textfieldbase',
                                    addUxReadOnlyEditFieldPlugin : false,
                                    reference : 'lugarFirmaRef'
                                    //allowBlank : false
                                },
                                renderer : coloredRender
                            }, {
                                text : HreRem.i18n('fieldlabel.motivo.aplazamiento'),
                                dataIndex : 'motivoAplazamiento',
                                flex : 1,
                                editor : {
                                    xtype : 'textarea',
                                    reference : 'motivoAplazamientoRef'
                                    //allowBlank : false
                                },
                                bind:{
                                    hidden: '{esBankia}'
                                },
                                renderer : coloredRender
                            },
                            {
                                text : HreRem.i18n('fieldlabel.motivo.aplazamiento'),
                                dataIndex : 'motivoAnulacionBc',
                                flex : 1,
                                editor: {
                                    xtype: 'combobox',
									reference : 'motivoAplazamientoBcRef',
                                    store: new Ext.data.Store({
                                        model: 'HreRem.model.ComboBase',
                                        proxy: {
                                            type: 'uxproxy',
                                            remoteUrl: 'generic/getDiccionario',
                                            extraParams: {diccionario: 'motivoAnulacionBc'}
                                        },
                                        autoLoad: true
                                    }),
                                    displayField: 'descripcion',
                                    valueField: 'codigo',
                                    listeners : {
                                        change : 'changeMotivoAplazamientoAlquiler'
                                    }
                                },
                                bind:{
                                    hidden: '{!esBankia}'
                                },
                                renderer : coloredRender
                            },
                            {
								dataIndex : 'fechaHoraFirma',
								formatter : 'date("d/m/Y H:i")',
								hidden : true,
								hideable: false,
								resizble : false,
								width : 0/*,
								editor : {
									xtype : 'timefieldbase',
									hidden : true,
									format : 'd/m/Y H:i',
									reference : 'fechaHoraFirmaRef'
								}*/
							},
                            {//este campo se pone para evitar un error que mataba la app
                                dataIndex : 'fechaHoraPosicionamiento',
                                formatter : 'date("d/m/Y H:i")',
                                hidden : true,
                                resizble : false,
                                width : 0,
                                editor : {
                                    xtype : 'timefieldbase',
                                    hidden : true,
                                    format : 'd/m/Y H:i',
                                    reference : 'fechaHoraPosicionamientoRef'
                                }
                            }],

                            dockedItems : [{
                                xtype : 'pagingtoolbar',
                                dock : 'bottom',
                                displayInfo : true,
                                bind : {
                                    store : '{storePosicionamientos}'
                                }
                    }],

                    saveSuccessFn : function() {
                        var grid = this;
                        me.funcionRecargar();
                        me.funcionReloadExp();

                        grid.lookupController().quitarAllowBlankMotivoAplazamientoAlquiler(grid);
                        grid.lookupController().onClickEnviarGestionLlaves();
                        
                    },
                    deleteSuccessFn : function() {
                        var me = this;
                        me.up('form')
                          .down('gridBaseEditableRow[reference=listadoPosicionamiento]')
                          .getStore().load();
                    },
                    onDeleteClick : function(btn) {
                        var me = this, seleccionados = btn.up('grid')
                                .getSelection(), gridStore = btn.up('grid')
                                .getStore();

                                Ext.Msg.show({
                                    title : HreRem.i18n("title.ventana.eliminar.posicionamiento"),
                                    message : HreRem.i18n("text.ventana.eliminar.posicionamiento"),
                                    buttons : Ext.Msg.YESNO,
                                    icon : Ext.Msg.QUESTION,
                                    fn : function(btn) {
                                        if (btn === 'yes') {

                                            me.selection.erase({
                                                params : {
                                                    id : me.selection.data.id
                                                },
                                                success : function(a, operation, c) {
                                                    me.fireEvent("infoToast",HreRem.i18n("msg.operacion.ok"));
                                                    me.deleteSuccessFn();
                                                    me.getStore().reload();
                                                },
                                                failure : function(a, operation) {
                                                    var data = {};
                                                    try {
                                                        data = Ext.decode(operation._response.responseText);
                                                    } catch (e) {};
                                                    if (!Ext.isEmpty(data.msg)) {
                                                        me.fireEvent("errorToast",data.msg);
                                                    } else {
                                                        me.fireEvent("errorToast",HreRem.i18n("msg.operacion.ko"));
                                                    }
                                                    me.deleteSuccessFn()
                                                }
                                            });
                                        }
                                    }
                                });
                    }
                    
                },
                {
				   xtype: 'checkboxfieldbase',
				   fieldLabel: HreRem.i18n('fieldlabel.cesion.remate'),
				   reference: 'cesionremateref',
				   bind : {
			     		value: '{resolucionalquiler.cesionRemate}',
			     		hidden: '{!esBankia}'
				   }
				},
				{
				   xtype: 'checkboxfieldbase',
				   fieldLabel: HreRem.i18n('fieldlabel.contrato.privado'),
				   reference: 'contratoprivadoref',
				   bind : {
			     		value: '{resolucionalquiler.contratoPrivado}',
			     		hidden: '{!esBankia}'
				   }
				}]
            },
            // Apartado Alquiler.
            {
                xtype : 'fieldset',
                collapsible : true,
                defaultType : 'displayfieldbase',
                title : HreRem.i18n('title.trabajo.adecuacion'),
                layout : {
                    type : 'hbox',
                    align : 'stretch'
                },
                items : [{
                    xtype : 'container',
                    layout : {
                        type : 'table',
                        columns : 2
                    },
                    items :[
                        {
                        	xtype : 'textfieldbase',
                            fieldLabel : HreRem.i18n('fieldlabel.numero.trabajo'),
                            bind: {
                            	value: '<div style="color: #26607c">' + '{expediente.numTrabajo}' + '</div>'
                            },
                            colspan : 2,
                            style: 'background: transparent; border: none;',
                            handleMouseEvents: true,
							listeners: {
   								'render': function() { 
   									this.getEl().on('mousedown', 'enlaceAbrirTrabajo');
   									new Ext.tip.ToolTip({
    								target: this.getEl(),
    								html: HreRem.i18n('fieldlabel.numero.trabajo.click')
									});
   								}
							}
                        },{
                            xtype : 'textfieldbase',
                            width : '100%',
                            readOnly: true,
                            fieldLabel : HreRem.i18n('fieldlabel.formalizacion.estado.trabajo'),
                            bind : {
                                value : '{expediente.estadoTrabajo}'
                            },
                            colspan : 1
                        },{
                            xtype : 'textfieldbase',
                            width : '100%',
                            readOnly: true,
                            fieldLabel : HreRem.i18n('fieldlabel.formalizacion.motivo.anulacion'),
                            bind : {
                                value : '{expediente.motivoAnulacionTrabajo}'
                            },
                            colspan : 1
                        }, {
                            xtype : 'button',
                            reference : 'btnCorreoGestionLlaves',
                            text : HreRem.i18n('btn.generar.reenviar.correo.gestion.llaves'),
                            handler : 'onClickEnviarGestionLlaves',
                            margin : '10 10 10 10',
                            colspan : 2,
                            bind: {
                            	disabled : '{!expediente.fechaPosicionamiento}'
                        	}
                        }
                    ]}
                ]
            }];

    me.addPlugin({
        ptype: 'lazyitems',
        items: items
    });
    me.callParent();
},

funcionRecargar: function () {
    var me = this;
    me.recargar = false;
	Ext.Array.each(me.query('grid'), function(grid) {
			grid.getStore().load();
		});	
},

funcionReloadExp: function () {
    var me = this;
    me.recargar = false;
    me.lookupController().refrescarExpediente(true);
}
});
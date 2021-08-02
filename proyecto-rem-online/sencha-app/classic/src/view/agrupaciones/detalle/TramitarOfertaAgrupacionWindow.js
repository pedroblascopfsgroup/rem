Ext.define('HreRem.view.agrupaciones.detalle.TramitarOfertaAgrupacionWindow', {
    extend: 'HreRem.view.common.WindowBase',
    xtype: 'crearofertawindow',
    layout: 'fit',
    width: 500,
    height: 300,
    reference: 'crearofertawindowref',
    controller: 'agrupaciondetalle',
    viewModel: {
        type: 'agrupaciondetalle'
    },

    requires: ['HreRem.model.Agrupaciones', 'HreRem.view.agrupaciones.detalle.AgrupacionDetalleModel'],

    editor: null,
    grid: null,
    context: null,
    esAgrupacion: null,

    listeners: {

        boxready: function(window) {

            var me = this;

            Ext.Array.each(window.down('form').query('field[isReadOnlyEdit]'),
                function(field, index) {
                    field.fireEvent('edit');
                    if (index == 0) field.focus();
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

        me.setTitle(HreRem.i18n("title.tramitar.oferta"));

        me.buttonAlign = 'left';

        me.buttons = [{
            itemId: 'btnGuardar',
            text: 'Tramitar',
            handler: 'onClickCrearOfertaTramitada'
        }, {
            itemId: 'btnCancelar',
            text: 'Cancelar',
            handler: 'hideWindowCrearOferta'
        }];

        me.items = [{
            xtype: 'formBase',
            collapsed: false,
            reference: 'formventanacrearoferta',
            scrollable: 'y',
            cls: '',
            recordName: "agrupacion",

            recordClass: "HreRem.model.Agrupaciones",
            defaults: {
                padding: 10
            },
            items: [{
                    xtype: 'checkboxfieldbase',
                    fieldLabel: HreRem.i18n('fieldlabel.venta.cartera'),
                    width: '100%',
                    colspan: 1,
                    reference: 'checkVentaCartera'
                },
                {
                    xtype: 'checkboxfieldbase',
                    fieldLabel: HreRem.i18n('fieldlabel.oferta.especial'),
                    width: '100%',
                    colspan: 1,
                    reference: 'checkOfertaEspecial'
                },
                {
                    xtype: 'checkboxfieldbase',
                    fieldLabel: HreRem.i18n('fieldlabel.venta.sobre.plano'),
                    width: '100%',
                    colspan: 1,
                    reference: 'checkVentaSobrePlano'
                },
                {
                    xtype: 'comboboxfieldbase',
                    fieldLabel: HreRem.i18n('fieldlabel.riesgo.operacion'),
                    reference: 'tipoRiesgoOperacionRef',
                    allowBlank: false,
                    width: '100%',
                    colspan: 1,
                    bind: {
                        store: '{comboRiesgoOperacion}'
                    }
                }

            ]
        }];

        me.callParent();

    },

    resetWindow: function() {

        var me = this,
        form = me.down('formBase');

        form.setBindRecord(form.getModelInstance());
        form.reset();
    }


});
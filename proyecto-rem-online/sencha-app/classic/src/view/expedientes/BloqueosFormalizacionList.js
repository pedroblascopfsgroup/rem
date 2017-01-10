Ext.define('HreRem.view.expedientes.BloqueosFormalizacionList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'bloqueosformalizacionlist',
    editOnSelect: false,
	topBar		: true,
	idPrincipal : 'expediente.id',
    bind		: {
        store: '{storeBloqueosFormalizacion}'
    },

    initComponent: function () {
     	var me = this;

     	me.deleteSuccessFn = function() {
        	var me = this;
        	me.getStore().reload();
        	return true;
        };

        me.listeners = {
     			rowclick: function() {
     				var me = this;
     				var selection = me.getSelection();
     				if(Ext.isEmpty(selection)) {
     					return;
     				}
     				var fechaBaja = selection[0].getData().fechaBaja;
     				var usuBaja = selection[0].getData().usuarioBaja;

     				if(!Ext.isEmpty(fechaBaja) || !Ext.isEmpty(usuBaja)) {
     					me.disableRemoveButton(true);
     				} else {
     					me.disableRemoveButton(false);
     				}
     			}
        };

		me.columns = [
		        {
		        	dataIndex: 'id',
		        	text: HreRem.i18n('fieldlabel.proveedores.id'),
		        	flex:0.5,
		        	hidden:true
		        },
		        {
		        	xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('expedientedetallemain').getViewModel().getStore('comboAreaBloqueo').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
		            dataIndex: 'areaBloqueoCodigo',
		            text: HreRem.i18n('header.area.bloqueo'),
		            flex: 1,
		            editor: {
			            xtype: 'comboboxfieldbase',
			            addUxReadOnlyEditFieldPlugin: false,
			            allowBlank: false,
			            listeners: {
							select: function(combo , record , eOpts) {
								// Obtener columna automáticamente por 'dataindex = tipoBloqueoCodigo'.
								var comboEditorTipoBloqueo = me.columns[Ext.Array.indexOf(Ext.Array.pluck(me.columns, 'dataIndex'), 'tipoBloqueoCodigo')].getEditor();
					        	if(!Ext.isEmpty(comboEditorTipoBloqueo)) {
					        		comboEditorTipoBloqueo.setDisabled(false);
					        		comboEditorTipoBloqueo.getStore().getProxy().setExtraParams({'areaCodigo': record.getData().codigo});    
					        		comboEditorTipoBloqueo.getStore().load();
					        	}
							}
						},
			            bind: {
			            	store: '{comboAreaBloqueo}'
			            },
			            reference: 'cbDDColAreaBloqueo'
			        }
		        },
		        {
		        	xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('expedientedetallemain').getViewModel().getStore('comboTipoBloqueoGrid').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
		        	dataIndex: 'tipoBloqueoCodigo',
		            text: HreRem.i18n('header.tipo.bloqueo'),
		            flex: 1,
		            editor: {
		            	xtype: 'comboboxfieldbase',
			            addUxReadOnlyEditFieldPlugin: false,
			            allowBlank: false,
			            disabled: true,
			            bind: {
			            	store: '{comboTipoBloqueo}'
			            },
			            reference: 'cbDDColTipoBloqueo'
			        }
		        },
		        {
		            dataIndex: 'fechaAlta',
		            text: HreRem.i18n('header.fecha.alta'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'usuarioAlta',
		            text: HreRem.i18n('title.publicaciones.condiciones.usuarioalta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaBaja',
		            text: HreRem.i18n('header.fecha.baja'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'usuarioBaja',
		            text: HreRem.i18n('title.publicaciones.condiciones.usuariobaja'),
		            flex: 1
		        }
		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{storeBloqueosFormalizacion}'
		            }
		        }
		    ];

		    me.callParent();
   }
});
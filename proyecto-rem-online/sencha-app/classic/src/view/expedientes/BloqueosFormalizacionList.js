Ext.define('HreRem.view.expedientes.BloqueosFormalizacionList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'bloqueosformalizacionlist',
    scrollable: 'y',
    editOnSelect: true,
	topBar		: true,
	idPrincipal : 'expediente.id',
    idSecundaria : 'activoExpedienteSeleccionado.idActivo',
    bind		: {
        store: '{storeBloqueosFormalizacion}',
        topBar: '{!esExpedienteBloqueado}'
    },

    initComponent: function () {
     	var me = this;
     	
     	me.coloredRender = function (value, meta, record) {
    		var fechaBaja = record.get('fechaBaja');
    		if(value){
	    		if (fechaBaja) {
	    			return '<span style="color: #DF0101;">'+value+'</span>';
	    		} else {
	    			return value;
	    		}
    		} else {
	    		return '-';
	    	}
    	};
    	
    	me.dateColoredRender = function (value, meta, record) {
    		var valor = me.dateRenderer(value);
    		return me.coloredRender(valor, meta, record);
    	};

        me.dateRenderer = function(value, rec) {
			if(!Ext.isEmpty(value)) {
				var newDate = new Date(value);
				var formattedDate = Ext.Date.format(newDate, 'd/m/Y');
				return formattedDate;
			} else {
				return value;
			}
		};

     	me.deleteSuccessFn = function() {
        	var me = this;
        	me.getStore().reload();
        	me.up().funcionRecargar();
        	return true;
        };
        
        me.saveSuccessFn = function() {
        	var me = this;
        	me.up().funcionRecargar();
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
     			},
     			
     			rowdblclick: function(a, record, element, rowIndex, e, eOpts){
     				var columnaArea= a.grid.columns[Ext.Array.indexOf(Ext.Array.pluck(me.columns, 'dataIndex'), 'areaBloqueoCodigo')].getEditor();
     				var columnaTipo= a.grid.columns[Ext.Array.indexOf(Ext.Array.pluck(me.columns, 'dataIndex'), 'tipoBloqueoCodigo')].getEditor();
     				var columnaAcuerdo= a.grid.columns[Ext.Array.indexOf(Ext.Array.pluck(me.columns, 'dataIndex'), 'acuerdoCodigo')].getEditor();
     				
     				columnaArea.setDisabled(true);
     				columnaTipo.setDisabled(true);
     				if(!Ext.isEmpty(columnaAcuerdo.getSelection()) && columnaAcuerdo.getSelection().get('codigo')==0){
     					columnaAcuerdo.setDisabled(true);
     				}
     				else{
     					columnaAcuerdo.setDisabled(false);
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
		        	dataIndex: 'numActivo',
		        	text: HreRem.i18n('header.numero.activo'),
		        	flex:0.5,
	                renderer: me.coloredRender
		        },
		        {
		        	xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('expedientedetallemain').getViewModel().getStore('comboAreaBloqueo').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			        	return me.coloredRender(descripcion, metaData, record);
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
			            return me.coloredRender(descripcion, metaData, record);
			        },
		        	dataIndex: 'tipoBloqueoCodigo',
		            text: HreRem.i18n('header.tipo.bloqueo'),
		            flex: 1,
		            editor: {
		            	xtype: 'comboboxfieldbase',
			            addUxReadOnlyEditFieldPlugin: false,
			            allowBlank: false,
			           // disabled: true,
			            bind: {
			            	store: '{comboTipoBloqueo}'
			            },
			            reference: 'cbDDColTipoBloqueo'
			        }
		        },
		        
		        
		        {
		        	xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {

			            var foundedRecord = this.up('expedientedetallemain').getViewModel().getStore('comboAcuerdo').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			        	return me.coloredRender(descripcion, metaData, record);
			        },
		            dataIndex: 'acuerdoCodigo',
		            text: HreRem.i18n('header.acuerdo'),
		            flex: 1,
		            editor: {
			            xtype: 'comboboxfieldbase',
			            addUxReadOnlyEditFieldPlugin: false,
			            allowBlank: false,
			            listeners: {
							select: function(combo , record , eOpts) {
								
							}
						},
			            bind: {
			            	store: '{comboAcuerdo}'
			            },
			            reference: 'cbDDAcuerdo'
			        }
		        },
		        
		        
		        
		        {
		            dataIndex: 'fechaAlta',
		            text: HreRem.i18n('header.fecha.alta'),
		            flex: 0.5,
	                renderer: me.dateColoredRender
		        },
		        {
		            dataIndex: 'usuarioAlta',
		            text: HreRem.i18n('title.publicaciones.condiciones.usuarioalta'),
		            flex: 1,
	                renderer: me.coloredRender
		        },
		        {
		            dataIndex: 'fechaBaja',
		            text: HreRem.i18n('header.fecha.baja'),
		            flex: 0.5,
	                renderer: me.dateColoredRender
		        },
		        {
		            dataIndex: 'usuarioBaja',
		            text: HreRem.i18n('title.publicaciones.condiciones.usuariobaja'),
		            flex: 1,
	                renderer: me.coloredRender
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
   },
   
   onAddClick: function(btn){
		var me = this;
		var columnaArea= me.columns[Ext.Array.indexOf(Ext.Array.pluck(me.columns, 'dataIndex'), 'areaBloqueoCodigo')].getEditor();
		var columnatipo= me.columns[Ext.Array.indexOf(Ext.Array.pluck(me.columns, 'dataIndex'), 'tipoBloqueoCodigo')].getEditor();
		var columnaAcuerdo= me.columns[Ext.Array.indexOf(Ext.Array.pluck(me.columns, 'dataIndex'), 'acuerdoCodigo')].getEditor();
		columnaArea.setDisabled(false);
		columnatipo.setDisabled(false);
		columnaAcuerdo.setDisabled(false);
		
		var rec = Ext.create(me.getStore().config.model);
		me.getStore().sorters.clear();
		me.editPosition = 0;
        me.getStore().insert(me.editPosition, rec);
        me.rowEditing.isNew = true;
        me.rowEditing.startEdit(me.editPosition, 0);
        me.disableAddButton(true);
        me.disablePagingToolBar(true);
        me.disableRemoveButton(true);
	}
   
});
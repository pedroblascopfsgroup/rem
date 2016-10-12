Ext.define('HreRem.view.agrupaciones.AgrupacionesList', {
   	extend: 'HreRem.view.common.GridBaseEditableRow',
    xtype: 'agrupacioneslist',
    reference: 'agrupacioneslistgrid',
	editOnSelect : false,
    topBar: true,

    bind: {
		store: '{agrupaciones}'
	},

	secFunToEdit: 'EDITAR_LIST_AGRUPACIONES',
	
	secButtons: {
		secFunPermToEnable : 'EDITAR_LIST_AGRUPACIONES'
	},
    
    initComponent: function () {
     	var me = this;
     	
     	me.setTitle(HreRem.i18n('title.listado.agrupaciones'));
     	
     	me.listeners = {
     			rowdblclick: 'onAgrupacionesListDobleClick',
     			beforeedit: function(editor, gridNfo) {
     				var grid = this;
				    var gridColumns = grid.headerCt.getGridColumns();
				    
				    for (var i = 0; i < gridColumns.length; i++) {
					    if (gridColumns[i].dataIndex == 'fechaInicioVigencia' || gridColumns[i].dataIndex == 'fechaFinVigencia') {
					    	var comboEditor = this.columns && this.columns[i].getEditor ? this.columns[i].getEditor() : this.getEditor ? this.getEditor():null;
		     				if(!Ext.isEmpty(comboEditor)){
		     					comboEditor.setDisabled(true);
		     				}
					    }
				    }
     			}
     	}

     	me.columns = [
		  				{
			            	text	 : HreRem.i18n('header.numero.agrupacion'),
			                flex	 : 1,
			                dataIndex: 'numAgrupacionRem'
			            },
			            {
				            dataIndex: 'tipoAgrupacion',
				            text: HreRem.i18n('header.tipo'),
							width: 250, 
				            renderer: function (value) {
				            	return Ext.isEmpty(value) ? "" : value.descripcion;
				            },
				            editor: {
			        			xtype: 'combobox',
			        			bind: {
				            		store: '{comboTipoAgrupacion}',
				            		value: '{tipoAgrupacion.codigo}'
				            	},					            	
				            	displayField: 'descripcion',
								valueField: 'codigo',
								listeners: {
									select: function(combo , record , eOpts) {
										var comboEditorFechaInicio = me.columns && me.columns[9].getEditor ? me.columns[9].getEditor() : me.getEditor ? me.getEditor():null;
										var comboEditorFechaFin = me.columns && me.columns[10].getEditor ? me.columns[10].getEditor() : me.getEditor ? me.getEditor():null;
							        	if(!Ext.isEmpty(comboEditorFechaInicio) && !Ext.isEmpty(comboEditorFechaFin)) {
							        		if(record.getData().codigo != CONST.TIPOS_AGRUPACION['ASISTIDA']) {
							        			comboEditorFechaInicio.reset();
							        			comboEditorFechaInicio.setDisabled(true);
							        			comboEditorFechaInicio.allowBlank = true;
							        			comboEditorFechaFin.reset();
							        			comboEditorFechaFin.setDisabled(true);
							        			comboEditorFechaFin.allowBlank = true;
							        		} else {
							        			comboEditorFechaInicio.setDisabled(false);
							        			comboEditorFechaInicio.allowBlank = false;
							        			comboEditorFechaInicio.validateValue(comboEditorFechaInicio.getValue()); // Forzar update para mostrar requerido.
							        			comboEditorFechaFin.setDisabled(false);
							        			comboEditorFechaFin.allowBlank = false;
							        			comboEditorFechaFin.validateValue(comboEditorFechaFin.getValue()); // Forzar update para mostrar requerido.
							        		}
							        	}
									}
								}
				        	}		            
				        },
			            {
			         		text	 : HreRem.i18n('header.nombre'),
			                flex	 : 1,
			                dataIndex: 'nombre',
							editor: {xtype:'textfield'}
			            },
			            {
			            	text	 : HreRem.i18n('header.descripcion'),
			                flex	 : 1,
			                dataIndex: 'descripcion',
			                editor: {xtype:'textfield'}
			            },
			            {
				            dataIndex: 'localidad',
				            text: HreRem.i18n('header.provincia'),
				            renderer: function (value) {
				            	return Ext.isEmpty(value) ? "" : value.provincia.descripcion;
				            }
				        },
				        {
				            dataIndex: 'localidad',
				            text: HreRem.i18n('header.municipio'),
				            renderer: function (value) {
				            	return Ext.isEmpty(value) ? "" : value.descripcion;
				            }
				        },
				        {
			            	text	 : HreRem.i18n('header.direccion'),
			                flex	 : 1,
			                dataIndex: 'direccion',
			                editor: {xtype:'textfield'}
			            },
			            {   
			            	text	 : HreRem.i18n('header.fecha.alta'),
			                dataIndex: 'fechaAlta',
					        formatter: 'date("d/m/Y")',
					        width: 120
					    },
					    {   
			            	text	 : HreRem.i18n('header.fecha.baja'),
			                dataIndex: 'fechaBaja',
					        formatter: 'date("d/m/Y")',
					        width: 120
					    },
					    {   
			            	text	 : HreRem.i18n('header.fecha.inicio.vigencia'),
			                dataIndex: 'fechaInicioVigencia',
					        formatter: 'date("d/m/Y")',
					        width: 120,
					        editor: {
					        	xtype:'datefield'
			        		}
					    },
					    {   
			            	text	 : HreRem.i18n('header.fecha.fin.vigencia'),
			                dataIndex: 'fechaFinVigencia',
					        formatter: 'date("d/m/Y")',
					        width: 120,
					        editor: {
					        	xtype:'datefield'
			        		}
					    },
			            {
			            	text	 : HreRem.i18n('header.numero.activos.incluidos'),
			                flex	 : 1,
			                dataIndex: 'activos'
			            },
			            {
			            	text	 : HreRem.i18n('header.numero.activos.publicados'),
			                flex	 : 1,
			                dataIndex: 'publicados'
			            }
		
			        ];
			        
			me.dockedItems = [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            itemId: 'agrupacionesPaginationToolbar',
			            displayInfo: true,
			            bind: {
			                store: '{agrupaciones}'
			            }
			        }
			    ];
		    
			me.callParent();
		}
});
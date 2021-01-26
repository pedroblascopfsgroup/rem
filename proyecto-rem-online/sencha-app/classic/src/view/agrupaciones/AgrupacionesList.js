Ext.define('HreRem.view.agrupaciones.AgrupacionesList', {
   	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'agrupacioneslist',
    reference	: 'agrupacioneslistgrid',
	editOnSelect : false,
    topBar		: true,
    bind		: {
		store: '{agrupaciones}'
	},

	secFunToEdit: 'EDITAR_LIST_AGRUPACIONES',

	secButtons: {
		secFunPermToEnable : 'EDITAR_LIST_AGRUPACIONES'
	},

    initComponent: function () {
     	var me = this;

     	me.setTitle(HreRem.i18n('title.listado.agrupaciones'));
     	
     	var carteraRenderer =  function(value) {
     		var temp = CONST.NOMBRE_CARTERA[value];
     		if (temp != null){
     		var src = CONST.IMAGENES_CARTERA[temp.toUpperCase()];
     		}
        	alt = temp;
        	if(Ext.isEmpty(src)) {
        		if(temp != null){
        			return '<div class="min-text-logo-cartera">'+temp.toUpperCase()+'</div>';
        		}
        	}else {
        		return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="50px"></div>';        		
        	}
        };

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
					        	xtype:'datefield',
					        	validationEvent: 'change',
	                            validator: function(value){
	                            	me.endValidityDate=value;
	                            	return this.up('agrupacionesmain').getController().validateFechas(this, value);
	                            }
			        		}
					    },
					    {   
			            	text	 : HreRem.i18n('header.fecha.fin.vigencia'),
			                dataIndex: 'fechaFinVigencia',
					        formatter: 'date("d/m/Y")',
					        width: 120,
					        editor: {
					        	xtype:'datefield',
					        	validationEvent: 'change',
	                            validator: function(value){
	                            	me.endValidityDate=value;
	                            	return this.up('agrupacionesmain').getController().validateFechas(this, value);
	                            }
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
			            },
			            {
				            dataIndex: 'cartera',
				            text: HreRem.i18n('header.entidad.propietaria'),
				            width: 70,
				            renderer: carteraRenderer
				        }
		
			        ];
	    	
			me.onDeleteClick= function (btn) {
				var me= this;
				var numAgrupacionRem= me.getSelection()[0].get('numAgrupacionRem');
				Ext.Ajax.request({
		    		url: $AC.getRemoteUrl('agrupacion/permiteEliminarAgrupacion'),
		    		params: {numAgrupacionRem: numAgrupacionRem},
		    		success: function(response, opts){
		    			var record = JSON.parse(response.responseText);
		    			if(record.success === 'true') {
		    				if(record.data == 'true'){
		    					Ext.Msg.show({
								   title: HreRem.i18n('title.confirmar.eliminacion'),
								   msg: HreRem.i18n('msg.desea.eliminar'),
								   buttons: Ext.MessageBox.YESNO,
								   fn: function(buttonId) {
								        if (buttonId == 'yes') {
								        	me.mask(HreRem.i18n("msg.mask.espere"));
								    		me.rowEditing.cancelEdit();
								            var sm = me.getSelectionModel();
								            sm.getSelection()[0].erase({
								            	success: function (a, operation, c) {
					                                me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
													me.unmask();
													me.deleteSuccessFn();
					                            },
					                            
					                            failure: function (a, operation) {
					                            	var data = {};
					                            	try {
					                            		data = Ext.decode(operation._response.responseText);
					                            	}
					                            	catch (e){ };
					                            	if (!Ext.isEmpty(data.msg)) {
					                            		me.fireEvent("errorToast", data.msg);
					                            	} else {
					                            		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					                            	}
													me.unmask();
													me.deleteFailureFn();
					                            }
					                        }
								            	
								            	
								            );
								            if (me.getStore().getCount() > 0) {
								                sm.select(0);
								            }
								        }
								   }
							});
		    				}
		    				else {
		    					me.fireEvent("errorToastLong", HreRem.i18n("activo.aviso.agrupacion.con.trabajo.oferta"));
		    				}
		    			}
		    			else{
		    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    			}
		    		},
				 	failure: function(record, operation) {
				 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				    }
		    	});
			};
			
			me.editFuncion=function(editor, context){
			   		
			   		var me= this;
					me.mask(HreRem.i18n("msg.mask.espere"));

						if (me.isValidRecord(context.record)) {				
						
			        		context.record.save({

			                    params: {
			                        idEntidad: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal),
			                        idEntidadPk: Ext.isEmpty(me.idSecundaria) ? "" : this.up('{viewModel}').getViewModel().get(me.idSecundaria)	
			                    },
			                    success: function (a, operation, c) {
			                        if (context.store.load) {
			                        	context.store.load();
			                        }
			                        me.unmask();
			                        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));																			
									me.saveSuccessFn();	
									
									me.lookupController().abrirDetalleAgrupacion(context.record);
									
									
			                    },
			                    
								failure: function (a, operation) {
			                    	
			                    	context.store.load();
			                    	try {
			                    		var response = Ext.JSON.decode(operation.getResponse().responseText)
			                    		
			                    	}catch(err) {}
			                    	
			                    	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msg)) {
			                    		me.fireEvent("errorToast", response.msg);
			                    	} else {
			                    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			                    	}                        	
									me.unmask();
			                    }
			                });	                            
			        		me.disableAddButton(false);
			        		me.disablePagingToolBar(false);
			        		me.getSelectionModel().deselectAll();
			        		editor.isNew = false;
			        		
						}
			        
			   };
			        
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
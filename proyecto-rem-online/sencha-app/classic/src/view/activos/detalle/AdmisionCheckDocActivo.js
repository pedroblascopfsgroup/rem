Ext.define('HreRem.view.activos.detalle.AdmisionCheckDocActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'admisioncheckdocactivo',  
    cls	: 'panel-base shadow-panel',
    scrollable	: 'y',
    flex: 1,

    initComponent: function () {

        var me = this;
        
        
		var coloredRender = function (value, meta, record) {
    		var gestorCodigoDocumento = record.get('gestorCodigo');
    		
    		if(value){    			
	    		if (gestorCodigoDocumento == 'GADM'){
	    			//return '<span style="color: #DF0101; font-weight: bold;">'+value+'</span>';
	    			return '<span style="color: #0a94d6;">'+value+'</span>';
	    		}
	    		else{
	    			if (gestorCodigoDocumento == 'GACT') {
	    				return '<span style="color: #FA9200;">'+value+'</span>';
	    			}else{
	    				return '<span style="color: #000000;">(*) '+value+'</span>';
	    			}
	    		}
    		}else{
	    		return '-';
	    	}
    	};
    	
    	
        me.items = [
					
			{
				xtype		: 'gridBaseEditableRow',
				reference	: 'listadoAdmisionCheckDoc',
				cls			: 'grid-no-seleccionable',
				flex		: 1,
				bind		: {
								store: '{storeAdmisionCheckDocumentos}'
				},
				secFunToEdit: 'EDITAR_CHECKING_DOC_ADMISION',
				
				secButtons: {
					secFunPermToEnable : 'EDITAR_CHECKING_DOC_ADMISION'
				},
				columns		: {
								items:[
				
									    {   
								        	dataIndex: 'descripcionTipoDoc',
								        	flex: 4,
								        	cls: 'grid-no-seleccionable-primera-col',
								        	tdCls: 'grid-no-seleccionable-td',
							                renderer: coloredRender
								        	
								        },
								        {   text: 'Aplica', 
								        	align: 'center',
								        	dataIndex: 'aplica',
								        	flex: 1,
								        	cls: 'grid-no-seleccionable-col',
								        	tdCls: 'grid-no-seleccionable-td',
								        	editor: {
								        		xtype: 'combobox',
								        		cls: 'grid-no-seleccionable-field-editor',
								        		bind: {
								            		store: '{comboSiNoRem}'
								            	},
								            	displayField: 'descripcion',
    											valueField: 'codigo',
    											listeners: {								        		
								        			select : function(combo, selection) {							
								        				if(selection.data.codigo == "0") {
								    						Ext.Msg.show({
															    title:'Aplica documento',
															    message: 'Al modificar un documento a NO aplica se borrarán los datos existentes. ¿Desea continuar?',
															    buttons: Ext.Msg.YESNO,
															    icon: Ext.Msg.QUESTION,
															    fn: function(btn) {
															        if (btn === 'no') {
															             combo.setValue("1");
															        }
															    }
															});
								        				}        				
								        			}
							    				}							        		
								        	},							        							        	
								        	renderer: function(value) {								        		
								        		return value == "0" ? "No" : value == "1" ? eval(String.fromCharCode(34,83,237,34)) : "";
								        	}
								        },	
										{
								            text: 'Estado',
								            dataIndex: 'estadoDocumento',
								            flex: 2,
								            cls: 'grid-no-seleccionable-col',
								            tdCls: 'grid-no-seleccionable-td',
								            editor: {
								        		xtype: 'combobox',
								        		cls: 'grid-no-seleccionable-field-editor',
								        		store: Ext.create('Ext.data.Store',{								        		
								        			model: 'HreRem.model.ComboBase',
													proxy: {
														type: 'uxproxy',
														remoteUrl: 'generic/getDiccionario',
														extraParams: {diccionario: 'estadoDocumento'}
													},
													autoLoad: true
												}),								            	
								            	displayField: 'descripcion',
    											valueField: 'codigo'    											
								        	},
								        	renderer: function(value) {								        		
								        		var me = this,
								        		comboEditor = me.columns && me.columns[2].getEditor ? me.columns[2].getEditor() : me.getEditor ? me.getEditor():null;
								        		if(!Ext.isEmpty(comboEditor)) {
									        		store = comboEditor.getStore(),							        		
									        		record = store.findRecord("codigo", value);
									        		if(!Ext.isEmpty(record)) {								        			
									        			return record.get("descripcion");								        		
									        		} else {
									        			comboEditor.setValue(value);								        			
									        		}
								        		}
								        	}
								        },
								        {   
								        	text: HreRem.i18n('fieldlabel.fecha.solicitud'),
								        	dataIndex: 'fechaSolicitud',
								        	formatter: 'date("d/m/Y")',
								        	flex: 2,
								        	cls: 'grid-no-seleccionable-col',
								        	tdCls: 'grid-no-seleccionable-td',
								        	editor: {
								        		xtype: 'datefield',
								        		cls: 'grid-no-seleccionable-field-editor'
								        	}
								        },
								        {   
								        	text: HreRem.i18n('fieldlabel.fecha.obtencion'),
								        	dataIndex: 'fechaObtencion',
								        	formatter: 'date("d/m/Y")',
								        	flex: 2,
								        	cls: 'grid-no-seleccionable-col',
								        	tdCls: 'grid-no-seleccionable-td',
								        	editor: {
								        		xtype: 'datefield',
								        		cls: 'grid-no-seleccionable-field-editor'
								        	}
								        },
								        {   
								        	text: HreRem.i18n('fieldlabel.fecha.validacion'),
								        	dataIndex: 'fechaVerificado',
								        	formatter: 'date("d/m/Y")',
								        	flex: 2,
								        	cls: 'grid-no-seleccionable-col',
								        	tdCls: 'grid-no-seleccionable-td',
								        	editor: {
								        		xtype: 'datefield',
								        		cls: 'grid-no-seleccionable-field-editor'
								        	}
								        }
			       	        
			    				],
			    				defaults: {
			    					menuDisabled: true,
			    					sortable: false
			    				}
				}/*
				
				selModel: 'cellmodel',
			    plugins: {
			        ptype: 'cellediting',
			        clicksToEdit: 1
			    },*/
			    /*dockedItems : [
						        {
						            xtype: 'pagingtoolbar',
						            dock: 'bottom',
						            displayInfo: false,
						            bind: {
						                store: '{storeAdmisionCheckDocumentos}'
						            }
						        }
			    ]*/
			    
			    
			},{
				xtype: 'label',
				html: '(*) No se lanza trámite <span style="color: #FA9200; padding-left: 100px;">Gestor de Activo</span> <span style="color: #0a94d6; padding-left: 20px;">Gestor de admisión</span>'
			}       
        
        
        ];
        
        
   	 	me.callParent();    	
    	
    }, 
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
});
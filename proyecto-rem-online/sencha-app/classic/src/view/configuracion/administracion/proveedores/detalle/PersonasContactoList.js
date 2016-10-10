Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.PersonasContactoList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'personascontactolist',
    reference: 'personascontactolistref',
	topBar: true,
	idPrincipal : 'proveedor.id',
	
    bind: {
        store: '{personasContacto}'
    },
    
    initComponent: function () {
     	
     	var me = this;
     	
     	var colCargoText = Ext.create('Ext.grid.column.Column', {
     		text: HreRem.i18n('fieldlabel.cargo'),
     		dataIndex: 'cargo',
            flex: 1,
            editor: {
            	xtype: 'textfield',
            	maxLength: 50
            }
 		});
     	
     	var colCargoCombobox = Ext.create('Ext.grid.column.Column', {
     		xtype: 'gridcolumn',
	        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
	            var foundedRecord = this.up('proveedoresdetalletabpanel').getViewModel().getStore('comboCargo').findRecord('codigo', value);
	            var descripcion;
	        	if(!Ext.isEmpty(foundedRecord)) {
	        		descripcion = foundedRecord.getData().descripcion;
	        	}
	            return descripcion;
	        },
	        dataIndex: 'cargo',
	        text: HreRem.i18n('fieldlabel.cargo'),
            flex: 1,
            editor: {
	            xtype: 'combobox',
	            displayField: 'descripcion',
	            valueField: 'codigo',
	            bind: {
	            	store: '{comboCargo}'
	            },
	            reference: 'cbDDColCargo'
	        }
 		});
		
     	var colCargoOptions = '{proveedor.isEntidad}' ?  colCargoCombobox : colCargoText;
     	
		me.columns = [
		        {
		        	dataIndex: 'id',
		        	text: HreRem.i18n('fieldlabel.proveedores.id'),
		        	flex:0.4,
		        	hidden:true
		        },
		        {
			        xtype: 'actioncolumn',
			        reference: 'personaPrincipal',
			        flex:0.5,
			        align: 'center',
			        text: HreRem.i18n('header.principal'),
					hideable: false,
					items: [
				        	{
					            getClass: function(v, meta, rec) {
					                if (rec.get('personaPrincipal') != 1) {
					                	this.items[0].handler = 'onMarcarPrincipalClick';
					                    return 'fa fa-check';
					                } else {
			            				this.items[0].handler = 'onMarcarPrincipalClick';
					                    return 'fa fa-check green-color';
					                }
					            }
				        	}
					 ]
	    		},
		        {
		        	
		            dataIndex: 'nombreApellidos',
		            text: HreRem.i18n('header.personas.contacto.nombre.apellidos'),
		            flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 100,
		            	disabled: true
		            }
		        },
		        colCargoOptions,
		        {
		            dataIndex: 'nif',
		            text: HreRem.i18n('fieldlabel.proveedores.nif'),
		            flex: 1,
		            bind: {
		            	hidden: '{!proveedor.isEntidad}'
		            },
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 20,
		            	disabled: true
		            }
		        },
		        {
		            dataIndex: 'codigoUsuario',
		            text: HreRem.i18n('header.personas.contacto.codigo.usuario'),
		            flex: 0.8,
		            editor: {
		            	xtype: 'textfield',
		            	maskRe: /[0-9]/,
		            	stripCharsRe: /[^0-9]/,
		            	maxLength: 16
		            }
		        },
		        {
		            dataIndex: 'telefono',
		            text: HreRem.i18n('header.telefono'),
		            flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 20
		            }
		        },
		        {
		            dataIndex: 'email',
		            text: HreRem.i18n('header.email'),
		            flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 300
		            }
		        },
		        {
		            dataIndex: 'direccion',
		            text: HreRem.i18n('fieldlabel.direccion'),
		            flex: 1,
		            bind: {
		            	hidden: '{!proveedor.isEntidad}'
		            },
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 250
		            }
		        },
		        {
		            dataIndex: 'fechaAlta',
		            text: HreRem.i18n('header.personas.contacto.fechaAlta'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")',
	            	editor: {
		            	xtype: 'datefield'
		            }
		        },
		        {
		            dataIndex: 'fechaBaja',
		            text: HreRem.i18n('header.personas.contacto.fechaBaja'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")',
	            	editor: {
		            	xtype: 'datefield'
		            }
		        },
		        {
		            dataIndex: 'observaciones',
		            text: HreRem.i18n('header.proveedorer.observaciones'),
		            flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 200
		            }
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
		                store: '{personasContacto}'
		            }
		        }
		    ];
		    
		    me.callParent();
   },
   
   editFuncion: function(editor, context){
  		var me= this;
		me.mask(HreRem.i18n("msg.mask.espere"));

			if (me.isValidRecord(context.record)) {
				var idDireccionDelegacionSelected = '';
				var selection = me.up('fichaproveedor').down('direccionesdelegacioneslist').getSelectionModel().getSelection();
				if(!Ext.isEmpty(selection)) {
					idDireccionDelegacionSelected = selection[0].id;
				}
				
	       		context.record.save({
	
	                   params: {
	                       idEntidad: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal),
	                       delegacion: idDireccionDelegacionSelected
	                   },
	                   
	                   success: function (a, operation, c) {
	                       context.store.load();
	                       me.unmask();
	                       me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));																			
	                       me.saveSuccessFn();											
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
  }

});
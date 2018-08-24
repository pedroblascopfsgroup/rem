Ext.define('HreRem.view.trabajos.detalle.SeleccionTarifasTrabajo', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'selecciontarifastrabajo',
    layout: {
        type: 'vbox',
        align : 'stretch',
        pack  : 'start'
    },
    width	: Ext.Element.getViewportWidth() / 1.1,    
    //height	: Ext.Element.getViewportHeight() > 600 ? 600 : Ext.Element.getViewportHeight() - 50 ,
    closable: true,		
    closeAction: 'hide',
    		
    controller: 'trabajodetalle',
    viewModel: {
        type: 'trabajodetalle'
    },
    
    idTrabajo: null,
    
    carteraCodigo: null,
    
    tipoTrabajoCodigo: null,
    
    subtipoTrabajoCodigo: null,
    
    codigoTarifaTrabajo: null,
    
    descripcionTarifaTrabajo: null,
    
    parent: null, 
    
    listeners: {

// HREOS-1811 Errores modalwindow seleccion tarifas por esconder la ventana y abrir entre 2 trabajos distintos
//		show: function() {			
//			var me = this;
//			me.resetWindow();			
//		},
		
		boxready: function(window) {
			
			var me = this;
			
			Ext.Array.each(window.down('fieldset').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
					}
			);
			
			me.getViewModel().set('trabajo.id', me.idTrabajo);
	    	me.getViewModel().set('trabajo.carteraCodigo', me.carteraCodigo);
	    	me.getViewModel().set('trabajo.tipoTrabajoCodigo', me.tipoTrabajoCodigo);
	    	me.getViewModel().set('trabajo.subtipoTrabajoCodigo', me.subtipoTrabajoCodigo);
	    	me.getViewModel().set('trabajo.codigoTarifaTrabajo', me.codigoTarifaTrabajo);
	    	me.getViewModel().set('trabajo.descripcionTarifaTrabajo', me.descripcionTarifaTrabajo);
	    	
	    	// Refresca el combo y el grid para los nuevos parametros
	    	me.lookupReference("comboSubtipoTrabajoTarificadoRef").getStore().load();
	    	me.lookupReference("gridselecciontarifas").getStore().load();
		}
		
	},
    
	initComponent: function() {
    	
    	var me = this;
    	
    	me.setTitle(HreRem.i18n('title.seleccion.tarifa'));
    	me.items = [
    		   {
	            	xtype: 'fieldsettable',
	            	defaultType: 'comboboxfieldbase',
	            	items: [
						{
							fieldLabel:  HreRem.i18n('fieldlabel.entidad.propietaria'),
							flex: 1,
							readOnly: true,
							//width: 		260,
							bind: {
			            		store: '{comboEntidadPropietaria}',
			            		value: '{trabajo.carteraCodigo}'
			            	},
			            	displayField: 'descripcion',
    						valueField: 'codigo'
						},
						{
							fieldLabel:  HreRem.i18n('fieldlabel.tipo.trabajo'),
							flex: 1,
							//width: 		260,
							readOnly: true,
							bind: {
			            		store: '{comboTipoTrabajo}',
			            		value: '{trabajo.tipoTrabajoCodigo}'
			            	},
			            	displayField: 'descripcion',
    						valueField: 'codigo'
						},
						{
							fieldLabel:  HreRem.i18n('fieldlabel.subtipo.trabajo'),
							reference: 'comboSubtipoTrabajoTarificadoRef',
							flex: 1,
							//width: 		260,
							bind: {
			            		store: '{comboSubtipoTrabajoTarificado}',
			            		value: '{trabajo.subtipoTrabajoCodigo}'
			            	},
			            	/*listeners: {
								select: 'refreshStoreSeleccionTarifas'
    						},*/
			            	displayField: 'descripcion',
    						valueField: 'codigo'
						},
						{
							fieldLabel:  HreRem.i18n('fieldlabel.proveedores.codigo'),
							reference: 'textfieldCodigoTarifaTrabajoRef',
							flex: 1,
							xtype: 'textfield',
							bind: {
			            		value: '{trabajo.codigoTarifaTrabajo}'
			            	}
						},
						{
							fieldLabel:  HreRem.i18n('header.descripcion'),
							reference: 'textfieldDescripcionTarifaTrabajoRef',
							flex: 1,
							xtype: 'textfield',
							bind: {
			            		value: '{trabajo.descripcionTarifaTrabajo}'
			            	}
						},
						{
							text: 'Filtrar',
							reference: 'botonFiltrar',
							flex: 0.5,
							xtype: 'button',
							handler: 'onClickBotonFiltrar'
						}
	            	]
	            },
	            {
	            	xtype		: 'gridBase',
	            	reference: 'gridselecciontarifas',
					layout:'fit',
					minHeight: 150,
					flex: 1,
					cls	: 'panel-base shadow-panel',
					height: '90%',
					bind: {
						store: '{storeSeleccionTarifas}'
					},
					columns: [
					    {   text: HreRem.i18n('header.codigo.tarifa'),
				        	dataIndex: 'codigoTarifa',
				        	editable: false,
				        	flex: 1
				        },
				        {   text: HreRem.i18n('header.descripcion'),
				        	dataIndex: 'descripcion',
				        	editable: false,
				        	flex: 1
				        },	
				        {   text: HreRem.i18n('header.precio.unitario'),
				        	dataIndex: 'precioUnitario',
				        	editable: false,
				        	flex: 1 
				        }
				    ],
				    dockedItems : [
				        {
				            xtype: 'pagingtoolbar',
				            dock: 'bottom',
				            displayInfo: true,
				            bind: {
				                store: '{storeSeleccionTarifas}'
				            }
				        }
				    ],
				    listeners : [
				    	{rowdblclick: 'onSeleccionTarifasListDobleClick'}
				    ]
	            }
    	];
    	
    	me.callParent();
    },
  
// HREOS-1811 Errores modalwindow seleccion tarifas por esconder la ventana y abrir entre 2 trabajos distintos    
//    resetWindow: function() {
//    	var me = this;
//    	//me.getViewModel().set('trabajo.idTrabajo', me.idTrabajo);
//    	me.getViewModel().set('trabajo.carteraCodigo', me.carteraCodigo);
//    	me.getViewModel().set('trabajo.tipoTrabajoCodigo', me.tipoTrabajoCodigo);
//    	me.getViewModel().set('trabajo.subtipoTrabajoCodigo', me.subtipoTrabajoCodigo);
//    	
//    	// Refresca el combo y el grid para los nuevos parametros
//    	me.lookupReference("comboSubtipoTrabajoTarificadoRef").getStore().load();
//    	me.lookupReference("gridselecciontarifas").getStore().load();
//    	
//    },
    
    closeWindow: function() {
    	var me = this;
    	me.close();
    	me.destroy;
    }
});
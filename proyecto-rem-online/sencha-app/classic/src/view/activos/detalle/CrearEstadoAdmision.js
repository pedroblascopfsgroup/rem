Ext.define('HreRem.view.activos.detalle.CrearEstadoAdmision', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'crearestadoadmisionwindow',
    layout	: 'fit',
    width	: 500,    
    height	: 400,
	reference: 'crearestadoadmisionwindowref',
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    requires: ['HreRem.model.Activo', 'HreRem.view.activos.detalle.ActivoDetalleModel'],
    
    idActivo: null,
    
    codCartera: null,
    codEstadoAdmision: null,
    codSubestadoAdmision: null,
    estadoAdmisionDesc: null,
    subestadoAdmisionDesc: null,
    
    
	listeners: {

		boxready: function(window) {
			
			var me = this;
			
			Ext.Array.each(window.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
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

    	me.setTitle(HreRem.i18n("title.estado.admision.activo"));
    	
    	me.buttonAlign = 'left'; 
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickCrearEstadoAdmision'},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'hideWindowCrearActivoAdmision'}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				collapsed: false,
	    				reference: 'formEstadoAdmision',
	   			 		scrollable	: 'y',
	    				cls:'',	    				
					    recordName: "activo",
						
						recordClass: "HreRem.model.Activo",
						defaults: {
									padding: 10
								},
    					items: [
    						{ 
					        	xtype: 'textfieldbase',
					        	readOnly: true,
					        	fieldLabel: HreRem.i18n('fieldlabel.estado.admision.estado.actual'),
								reference: 'estadoAdmisionRef',
								width: 		'100%',
								colspan: 1,
					        	bind: {
				            		value: me.estadoAdmisionDesc
				            	}
					        },
					        { 
					        	xtype: 'textfieldbase',
					        	readOnly: true,
					        	fieldLabel: HreRem.i18n('fieldlabel.estado.admision.subestado.actual'),
								reference: 'subestadoAdmisionRef',
								width: 		'100%',
								colspan: 1,
					        	bind: {
				            		value: me.subestadoAdmisionDesc
				            	}
					        },
					        { 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.estado.admision.estado.nuevo'),
								reference: 'estadoAdmisionNuevo',
								width: 		'100%',
								colspan: 1,
					        	bind: {
				            		store: '{comboEstadoAdmision}',
				            		value: '{activo.estadoAdmisionCodigoNuevo}'
				            	},
	    						listeners: {
				                	select: 'setSubestadoAdmisionAllowBlank'
				                	
				            	},
				            	chainedStore: 'comboSubestadoAdmisionNuevoFiltrado',
								chainedReference: 'subestadoAdmisionNuevo',
								allowBlank: false
					        },
					        { 
					        	xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.estado.admision.subestado.nuevo'),
								reference: 'subestadoAdmisionNuevo',
								   bind : {
								     store : '{comboSubestadoAdmisionNuevoFiltrado}',
								     value: '{activo.subestadoAdmisionCodigoNuevo}'
								   }


							},
							{
			                	xtype: 'textareafieldbase',
			                	fieldLabel: HreRem.i18n('fieldlabel.estado.admision.observaciones'),
			                	name: 'observacionesAdmision',
			                	reference: 'observacionesEstadoAdmisionNuevo',
			                	bind: {
			                		value: '{activo.observacionesAdmision}'
			                	},
			                	width:'100%',
			                	colspan: 1,
			                	maxLength: 256
        	                }
					        
					]
    			}
    	]


    	
    	
    	
    	me.callParent();
    	
    },
    
    resetWindow: function() {

    	var me = this,    	
    	form = me.down('formBase');     	

		form.setBindRecord(form.getModelInstance());
		form.reset();
		me.lookupReference('subestadoAdmisionNuevo').setDisabled(true);
		me.lookupReference('estadoAdmisionRef').setValue(me.estadoAdmisionDesc);
		me.lookupReference('subestadoAdmisionRef').setValue(me.subestadoAdmisionDesc);
    }


});
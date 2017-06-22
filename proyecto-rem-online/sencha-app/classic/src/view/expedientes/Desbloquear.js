Ext.define('HreRem.view.expedientes.Desbloquear', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'desbloquearwindow',
    layout	: 'fit',
    width	: 500,    
    height	: 250,
	reference: 'desbloquearwindowref',
    controller: 'expedientedetalle',
    collapsed: false,
    modal	: true,
    modoEdicion: true, // Inicializado para evitar errores.
    viewModel: {
        type: 'expedientedetalle'
    },
    
    requires: [],
    
    idExpediente: null,
    
    
	listeners: {

		boxready: function(window) {
		
		},
		
		show: function() {			
			var me = this;
			me.resetWindow();			
		}
		
	},
	
    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n("title.desbloquear.exp"));
    	
    	me.buttonAlign = 'center';    	
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: HreRem.i18n("title.desbloquear.exp"), handler: 'sendDesbloquearExpediente'},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'hideWindow', scope: this}];

    	me.items = [
    	        	{
	    				xtype: 'formBase', 
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		recordName: "comprador",
						recordClass: "HreRem.model.FichaComprador",
	    				cls:'',
	    				listeners: {
		    				boxready: function(window){
		    					var me = this;								
								Ext.Array.each(window.query('field[isReadOnlyEdit]'),
									function (field, index) 
										{ 								
											field.fireEvent('edit');
											//if(index == 0) field.focus();
											field.setReadOnly(!me.up('desbloquearwindow').modoEdicion);
										}
								);
							}
	    				},
					    
    					items: [
									{    
									    
										xtype:'fieldsettable',
										collapsible: false,
										defaultType: 'textfieldbase',
										margin: '10 10 10 10',
										layout: {
									        type: 'table',
									        columns: 1,
									        tdAttrs: {width: '55%'}
										},
										items :
											[
												{ 
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('title.publicaciones.condiciones.motivo'),
													reference: 'motivo',
													margin: '10 0 10 0',
													name: 'motivo',
													bind: {
														store: '{comboMotivoDesbloqueo}',
														value: ''
													},
													allowBlank: false,
													
												},
												{ 
								                	xtype: 'textarea',
								                	fieldLabel: HreRem.i18n('header.descripcion'),
							                        name: 'motivoDescLibre',
							                        itemId: 'motivoDescLibre',
							                        reference: 'motivoDescLibre',
							                        width: 400
								                }
												
											
											]
									}
									
    					      ]
    	        	}
    	          ];
    	
    	me.callParent();    	
    
    },
    
    resetWindow: function() {
    	
    	
    }


});
Ext.define('HreRem.view.activos.detalle.VentanaCrearAgendaRevisionTitulo', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'ventanaCrearAgendaRevisionTitulo',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3.5,
    resizable: false,
	reference: 'ventanaCrearAgendaRevisionTituloRef',
	recordClass: "HreRem.model.AgendaRevisionTributoGridModel",

    entidad: null,
    
    parent: null,
    
    idEntidad: null,
 

    initComponent: function() {
    	
    	var me = this;
    	
    	me.setTitle(HreRem.i18n("fieldlabel.crear.agenda.revision.titulo"));

    	me.buttonAlign = 'right';

    	var comboSubtipologias = new Ext.data.Store({
    		model: 'HreRem.model.ComboBase',
    		autoLoadOnValue: true,
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtipologias'}
			}
    	});
		
    	
    	me.buttons = [ 
    		{ formBind: true, itemId: 'btnGuardar', text: 'Crear', handler: 'onClickCrearAgendaRevisionTitulo', scope: this},
    		{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'closeWindow', scope: this}
    	];

    	me.items = [
        	
	    	{
	    		xtype: 'formBase',
	    		cls: 'anyadir-agenda-revision-titulo-form',
	    		layout: 'fit',			    		
	    		collapsed: false,	  				
				recordName: "agendaRevisionTituloNuevo",
				reference: 'ventanaCrearAgendaRevisionTituloFormRef',

			    items : [
					{
						xtype:'fieldset',
						cls: 'x-fieldset-anyadir-agenda-revision-titulo-form',
						flex: 1,
						layout: {
						        type: 'table',
						        // The total column count must be specified here
						        columns: 1,
						        trAttrs: {height: '45px', width: '100%'},
						        tableAttrs: {
						            style: {
						                width: '100%'
									}
						        }
						},
						defaultType: 'textfieldbase',
						collapsed: false,
						scrollable	: 'y', 
						align:'left',
				        items: [
							{											 
								xtype: 'combobox',
								fieldLabel:   HreRem.i18n('fieldlabel.agenda.revision.titulo.subtipologia'),
								reference: 'elegirSubtipologias',
								name: 'elegirSubtipologias',
								displayField	: 'descripcion',
							    valueField		: 'codigo',	
								store: comboSubtipologias,
			                	allowBlank: false,
								width: '90%',
								cls: 'searchfield-input sf-con-borde'
								
			                },
			                {
			                	xtype: 'textarea',
			                	reference: 'observaciones',
			                	name:'observaciones',
			                	fieldLabel: HreRem.i18n('fieldlabel.agenda.revision.titulo.observaciones'),	                	
			                	allowBlank: false,
			                	width: '90%'
			                }
			            	  
			            ]
		
	    			}	
	    		]
	
	    	}
	  ];

    	me.callParent();
    },
    
    onClickCrearAgendaRevisionTitulo :function (btn){
    		var me =this;
    		var window= btn.up('window');
    		var form = window.down('[reference=ventanaCrearAgendaRevisionTituloFormRef]');
    		var grid = window.parent;
    		var ventanaAplicacion  = grid.lookupController();

    		if(form.isFormValid() && !form.disableValidation || form.disableValidation) {
    			grid.lookupController().getView().mask(HreRem.i18n("msg.mask.loading"));
    			var idActivo =  window.idEntidad;
    			var subtipologias = null;
    			var observaciones = null;
    			window.mask(HreRem.i18n("msg.mask.loading"));
					if(window.down('[reference=elegirSubtipologias]') != null){
						subtipologias= window.down('[reference=elegirSubtipologias]').getValue();
					}
					if(window.down('[reference=observaciones]') != null){
						observaciones= window.down('[reference=observaciones]').getValue();
					}
    	    	var url = $AC.getRemoteUrl('admision/createAgendaRevisionTitulo');
    			Ext.Ajax.request({
    	    		url: url,
    	    		method : 'GET',
    	    		params: {
    	    			idActivo:idActivo,
    	    			subtipologias:subtipologias,
    	    			observaciones:observaciones
    	    		},
    	    		
    	    		success: function(response, opts){
    	    			grid.getStore().load();
    	    			ventanaAplicacion.fireEvent("infoToast",HreRem.i18n("msg.operacion.ok"));
    	    			ventanaAplicacion.getView().unmask();
    	    			window.close();
    	    		},
    			 	failure: function(record, operation) {
    			 		ventanaAplicacion.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
    			    },
    			    callback: function(record, operation) {   	
    			    	ventanaAplicacion.getView().unmask();	
    			    }
    	    	});
			 
    		} else {
    			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
    		}
    	}
});







   	


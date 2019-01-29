Ext.define('HreRem.view.agenda.TareaNotificacion', {
    extend		: 'HreRem.view.common.TareaBase',
    xtype		: 'tareaNotificacion',
    reference	: 'windowTareaNotificacion',
    title : "Notificación",
    controller: 'tarea',
    viewModel: {
        type: 'tarea'
    },
	//modal: false,
    
     /**
     * Párametro para saber que componente abre la ventana, y poder refrescarlo después.
     * @type Component
     */
    parent: null,
           
	initComponent : function() {
    	
    	var me = this;
    	
    	me.items = [
                    
    	            {
    				    xtype: 'form',
    				    reference: 'formTareaNotificacion',
    				    layout: 'column',    
    				    defaults: {
    				        layout: 'form',
    				        xtype: 'container',
    				        defaultType: 'textfield',
    				        style: 'width: 98%'
    				    },
    				    
    				    items: [{
    		        		xtype:'fieldset',
    						collapsible: false,
    						defaultType: 'textfield',
    						layout: 'vbox',
    					
    						items :
    							[{
    				                	xtype:'container',
    									collapsible: false,
    									defaultType: 'textfield',
    									margin: '0 0 20 0',
    									layout: 'hbox',							
    									items :
    										[
//    											{ 
//    												xtype: 'combobox',
//    												fieldLabel: 'Destinatorio',
//    												store : new Ext.data.SimpleStore({
//    													data : [[29626, 'GSUPLI'], 
//    													        [29366, 'LETRADO']],
//    													fields : ['id', 'descripcion']
//    												}),
//    												valueField : 'id',
//    												displayField : 'descripcion',
//    												triggerAction : 'all',
//    												name: 'destinatarioNotificacion',
//    												itemId: 'destinatarioNotificacion',
//    												margin: '0 20 0 0',
//    												editable : false,
//    									    		allowBlank: false
//    											}
    						                ]
    				                },	
//    				                {
//    				                	xtype:'container',
//    									collapsible: false,
//    									defaultType: 'textfield',
//    									margin: '0 0 20 0',
//    									layout: 'hbox',							
//    									items :
//    										[
//    											{ 
//    												xtype: 'textfield',
//    												fieldLabel: 'Título',
//    												valueField : 'id',
//    												displayField : 'descripcion',
//    												triggerAction : 'all',
//    												name: 'tituloNotificacion',
//    												itemId: 'tituloNotificacion',
//    												margin: '0 20 0 0',
//    												value: me.titulo,
//    												editable : false,
//    									    		allowBlank: false
//    											}
//    						                ]
//    				                },
    				                {

    									xtype : 'container',
    									layout : {
    										type : 'table',
    										 columns: 2,
    										 tableAttrs : {
    											style : {
    												width : '100%'
    											}
    										}
    									},

    									items : [
    										{	xtype: 'textfield',
    	    				                	fieldLabel: 'Num. Activo / Agrupación',
    	    				                	value: me.numActivo,
    	    				                	editable: false
    	    				                },
    	    				                {
    	    									xtype : 'button',
    	    									tooltip: 'Ver Activo',
    	    									cls : 'app-list-ico ico-ver-activov2',
    	    									//handler: 'enlaceAbrirActivo'
    	    									handler: 'enlaceAbrirActivoNotificacion' //.createDelegate(this, [{foo:'two', bar:2}], true)
    	    								}
    									]
    								},
    								
    								
    				                
    				                {
    				                	xtype:'container',
    									collapsible: false,
    									defaultType: 'textfield',
    									margin: '0 0 20 0',
    									layout: 'hbox',					
    									
    									items :
    										[
    											{ 
    												xtype: 'textfield',
    												fieldLabel: 'Fecha',
    												name: 'fechaNotificacion',
    												margin: '0 20 0 0',
    												value: me.fecha,
    												allowBlank: false,
    												editable : false
    											}
    						                ]
    				                },			        
    	    						{ 
    				                	xtype: 'textarea',
    				                	fieldLabel: 'Descripción',
    			                        name: 'descripcionNotificacion',
    			                        itemId: 'descripcionNotificacion',
    			                        value: me.descripcion,
    			                        width: Ext.Element.getViewportWidth() /2 -80,
    			                        editable : false
    				                },
    	    						{ 
    				                	xtype: 'textarea',
    				                	fieldLabel: 'Respuesta',
    			                        name: 'respuesta',
    			                        itemId: 'respuesta',
    			                        value: me.respuesta,
    			                        width: Ext.Element.getViewportWidth() /2 -80,
    			                        editable: !me.tareaFinalizable,
    			                        hidden: !me.respuesta && me.tareaFinalizable
//    			                        bind: {	
//			                        		editable: !{me.tareaFinalizable}
//			                        	  }
    			                       // editable : true
    				                },
    				                {
    				                	xtype: 'textfield',
    				                	fieldLabel: 'idTarea',
    				                	name: 'idTarea',
    				                	itemId: 'idTarea',
    				                	value: me.idTarea,
    				                	hidden: true
    				                },
    				                {
    				                	xtype: 'textfield',
    				                	fieldLabel: 'idAsunto',
    				                	name: 'idAsunto',
    				                	itemId: 'idAsunto',
    				                	value: me.idAsunto,
    				                	hidden: true
    				                },
    				                {
    				                	xtype: 'textfield',
    				                	fieldLabel: 'codUg',
    				                	name: 'codUg',
    				                	itemId: 'codUg',
    				                	value: me.codUg,
    				                	hidden: true
    				                }		    			
    							 ]
    			    		}
    				    		
    				    ]
    						
    	    	}];
    	
    	me.callParent();
    
    },
    
    showMotivo: function( cmp, newValue, oldValue ) {
    	
    	var campo = cmp.up("form").down("[itemId=motivoRechazoOferta]");    	
    	var campoObs = cmp.up("form").down("[itemId=obsVerificarOferta]");
    	
    	if(newValue == 1){
    		campo.setVisible(true);
    		campo.allowBlank = false;
    		campoObs.allowBlank = false;
    	}else{
    		campo.setVisible(false);
    		campo.allowBlank = true;
    		campoObs.allowBlank = true;
    		cmp.up("form").isValid();
    	}
    	
    },	
    
    evaluar: function() {
    
		var me = this;

		var parametros = me.down("form").getValues();

		var url = $AC.getRemoteUrl('notificacion/saveNotificacionRespuesta');
		Ext.Ajax.request({
			url : url,
			params : parametros,
			success : function(response, opts) {
    				me.unmask();
    				me.destroy();

			},
			callback:  function(response, opts, success) {
				me.unmask();
				me.destroy();
			}
		});
    	
    }
});
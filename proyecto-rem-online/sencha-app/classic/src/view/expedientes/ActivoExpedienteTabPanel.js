Ext.define('HreRem.view.expedientes.ActivoExpedienteTabPanel', {
	extend		: 'Ext.tab.Panel',
	cls: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    xtype		: 'activoExpedienteTabPanel',
    requires	: ['HreRem.view.expedientes.ActivoExpedienteCondiciones','HreRem.view.expedientes.ActivoExpedienteJuridico'],
    flex		: 1,
    bloqueado: false,
    controller	: 'expedientedetalle',
    viewModel	: {
        type: 'expedientedetalle'
    },
    
    procesado: false,
     
     listeners	: {
     	     	
     	boxready: function (tabPanel) {   
     		var me = this;
    		
			me.checkProceso(tabPanel);
			
    	},
    	     	
    	beforetabchange: function (tabPanel, tabNext, tabCurrent) {
    		var me = this;
    		
			me.checkProceso(tabPanel);
    	}
    	
    },
    
    tabBar: {
		items: [
        		{
        			xtype: 'tbfill'
        		},
        		{
					xtype: 'buttontab',
        			itemId: 'botoneditar',
        		    handler	: 'onClickBotonEditar',
        		    iconCls: 'edit-button-color',
        		    bind: {hidden: '{editing}'},
        		    disabled: true
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botonguardar',
        		    handler	: 'onClickBotonGuardarActivoExpediente', 
        		    iconCls: 'save-button-color',
        		    hidden: true,
        		    bind: {hidden: '{!editing}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botoncancelar',
        		    handler	: 'onClickBotonCancelar', 
        		    iconCls: 'cancel-button-color',
        		    hidden: true,
        		    bind: {hidden: '{!editing}'}
        		}
        ]
    },
   
    initComponent: function () {
    	
        var me = this;
       
        me.items = [];
        me.items.push({xtype: 'activoexpedientecondiciones', reference: 'activoexpedientecondiciones'});
        me.items.push({xtype: 'activoexpedientejuridico', reference: 'activoexpedientejuridico'});
        
        me.callParent(); 
       
    },
    evaluarBotonesEdicion: function(tab) {
		var me = this;
		me.bloquearExpediente(tab,me.bloqueado);
	},
    bloquearExpediente: function(tab,bloqueado) {  
    	var me = this;
		me.bloqueado = bloqueado;
		me.down("[itemId=botoneditar]").setVisible(false);
		var editionEnabled = function() {
			if ($AU.userIsRol('HAYACONSU') || $AU.userIsRol('PERFGCCLIBERBANK')) {
				me.down("[itemId=botoneditar]").setVisible(false);
			} else {
				me.down("[itemId=botoneditar]").setVisible(true);
			}
		}
		
		if(!bloqueado){
			// Si la pestaña recibida no tiene asignados roles de edicion 
			if(Ext.isEmpty(tab.funPermEdition)) {
				editionEnabled();
			} else {
				$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
			}
		}else{
			me.down("[itemId=botoneditar]").setVisible(false);
		}
	},
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    },
    
    checkProceso: function(tabPanel){  
    	var me = this;
		me.lookupController().comprobarProcesoAsincrono(tabPanel, me);    	
    }
    
});
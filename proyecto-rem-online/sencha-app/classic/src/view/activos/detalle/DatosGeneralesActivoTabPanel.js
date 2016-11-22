
Ext.define('HreRem.view.activos.detalle.DatosGeneralesActivoTabPanel', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'datosgeneralesactivotabpanel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'tabpanelDatosGeneralesActivo',
    requires: ['Ext.plugin.LazyItems','HreRem.ux.panel.GMapPanel', 'HreRem.view.activos.detalle.DatosBasicosActivo', 'HreRem.view.activos.detalle.DatosComunidadActivo', 
    	'HreRem.view.activos.detalle.TituloInformacionRegistralActivo', 'HreRem.view.activos.detalle.InformacionAdministrativaActivo', 'HreRem.view.activos.detalle.CargasActivo',
    	'HreRem.view.activos.detalle.ValoracionesActivo','HreRem.view.activos.detalle.SituacionPosesoriaActivo','HreRem.view.activos.detalle.InformacionComercialActivo'],

	listeners: {
			    	
    	boxready: function (tabPanel) {   		
    		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}
			
			if(tab.ocultarBotonesEdicion) {
				tabPanel.down("[itemId=botoneditar]").setVisible(false);
			} else {		
            	tabPanel.evaluarBotonesEdicion(tab);
			}
		},
			    	
        beforetabchange: function (tabPanel, tabNext, tabCurrent) {

        	tabPanel.down("[itemId=botoneditar]").setVisible(false);	            	
        	// Comprobamos si estamos editando para confirmar el cambio de pestaña
        	if (tabCurrent != null)
        	{
            	if (tabPanel.lookupController().getViewModel().get("editing"))
            	{	
            		Ext.Msg.show({
            			   title: HreRem.i18n('title.descartar.cambios'),
            			   msg: HreRem.i18n('msg.desea.descartar'),
            			   buttons: Ext.MessageBox.YESNO,
            			   fn: function(buttonId) {
            			        if (buttonId == 'yes') {
            			        	var btn = tabPanel.down('button[itemId=botoncancelar]');
            			        	Ext.callback(btn.handler, btn.scope, [btn, null], 0, btn);
            			        	tabPanel.getLayout().setActiveItem(tabNext);
            			        	// Si la pestaña necesita botones de edición
									if(!tabNext.ocultarBotonesEdicion) {
					            		tabPanel.evaluarBotonesEdicion(tabNext);
									}
            			        }
            			   }
        			});
            		
            		return false;
            	}
            	// Si la pestaña necesita botones de edición
				if(!tabNext.ocultarBotonesEdicion) {
            		tabPanel.evaluarBotonesEdicion(tabNext);
				}
            	return true;
        	}
        }
    },
	layout: 'fit',
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
        		    bind: {hidden: '{editing}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botonguardar',
        		    handler	: 'onClickBotonGuardar', 
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
    }
			     
	,initComponent: function() {
		
		var me = this;
		
		me.items = [{xtype: 'datosbasicosactivo', funPermEdition: ['EDITAR_DATOS_BASICOS_ACTIVO']}];

		$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'tituloinformacionregistralactivo', funPermEdition: ['EDITAR_TITULO_INFO_REGISTRAL_ACTIVO']})}, ['TAB_ACTIVO_TITULO_INFO_REGISTRAL']);
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'informacionadministrativaactivo', funPermEdition: ['EDITAR_INFO_ADMINISTRATIVA_ACTIVO']})}, ['TAB_ACTIVO_INFO_ADMINISTRATIVA']);
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'cargasactivo',ocultarBotonesEdicion: true})}, ['TAB_ACTIVO_CARGAS']);
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'situacionposesoriaactivo', funPermEdition: ['EDITAR_SITU_POSESORIA_ACTIVO']})}, ['TAB_ACTIVO_SITU_POSESORIA']);
    	// Pasa a ser Precios, pestaña de primer nivel 
    	//$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'valoracionesactivo',ocultarBotonesEdicion: true})}, ['TAB_ACTIVO_VALORACIONES']);
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'informacioncomercialactivo',ocultarBotonesEdicion: true})}, ['TAB_ACTIVO_INFO_COMERCIAL']);
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'datoscomunidadactivo',ocultarBotonesEdicion: true, funPermEdition: ['EDITAR_DATOS_COMUNIDAD_ACTIVO']})}, ['TAB_ACTIVO_DATOS_COMUNIDAD']);
		
     	me.callParent(); 		

     },
     
     evaluarBotonesEdicion: function(tab) {    	
		var me = this;
		me.down("[itemId=botoneditar]").setVisible(false);
		var editionEnabled = function() {
			me.down("[itemId=botoneditar]").setVisible(true);
		}
		
		//HREOS-846 Si NO esta dentro del perimetro, no se habilitan los botones de editar
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="true") {
			// Si la pestaña recibida no tiene asignadas funciones de edicion 
			if(Ext.isEmpty(tab.funPermEdition)) {
	    		editionEnabled();
	    	} else {
	    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
	    	} 
		}
    }
    
});
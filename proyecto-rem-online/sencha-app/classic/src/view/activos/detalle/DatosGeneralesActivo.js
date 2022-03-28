
Ext.define('HreRem.view.activos.detalle.DatosGeneralesActivo', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'datosgeneralesactivo',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'datosGeneralesActivo',
    requires	: ['Ext.plugin.LazyItems','HreRem.ux.panel.GMapPanel', 'HreRem.view.activos.detalle.DatosBasicosActivo', 'HreRem.view.activos.detalle.DatosComunidadActivo',
    	'HreRem.view.activos.detalle.TituloInformacionRegistralActivo', 'HreRem.view.activos.detalle.InformacionAdministrativaActivo',
    	'HreRem.view.activos.detalle.ValoracionesActivo','HreRem.view.activos.detalle.SituacionPosesoriaActivo','HreRem.view.activos.detalle.InformacionComercialActivo',
    	'HreRem.view.activos.detalle.SuministrosActivo'],

    layout: 'fit',
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
    },

    initComponent: function() {
		var me = this;
		me.setTitle(HreRem.i18n('title.ficha'));
		//HREOS-1964: Restringir los activos financieros (asistidos) para que solo puedan ser editables por los perfiles de IT y Gestor�a PDV
		var ocultarDatosbasicosactivo = false;		
	    if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
	    	ocultarDatosbasicosactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
	    			&& $AU.userHasFunction('EDITAR_DATOS_BASICOS_ACTIVO'));
	    }else{
	    	ocultarDatosbasicosactivo = !$AU.userHasFunction('EDITAR_DATOS_BASICOS_ACTIVO');
	    }
	    
	    var ocultarTituloinformacionregistralactivo = false;		
	    if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
	    	ocultarTituloinformacionregistralactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
	    			&& $AU.userHasFunction('EDITAR_TITULO_INFO_REGISTRAL_ACTIVO'));
	    }else{
	    	ocultarTituloinformacionregistralactivo = !$AU.userHasFunction('EDITAR_TITULO_INFO_REGISTRAL_ACTIVO');
	    }
	    
	    var ocultarInformacionadministrativaactivo = false;		
	    if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
	    	ocultarInformacionadministrativaactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
	    			&& $AU.userHasFunction('EDITAR_INFO_ADMINISTRATIVA_ACTIVO'));
	    }else{
	    	ocultarInformacionadministrativaactivo = !$AU.userHasFunction('EDITAR_INFO_ADMINISTRATIVA_ACTIVO');
	    }
	    
	    var ocultarSituacionposesoriaactivo = false;
	    var tipoTituloCodigo = me.lookupController().getViewModel().get('activo').get('tipoTituloCodigo');
	    var subtipoClaseActivoCodigo = me.lookupController().getViewModel().get('activo').get('subtipoClaseActivoCodigo') == null ? true : me.lookupController().getViewModel().get('activo').get('subtipoClaseActivoCodigo') == '02';
	    if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
	    	ocultarSituacionposesoriaactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL']) 
	    			|| ($AU.userIsRol(CONST.PERFILES['ASSET_MANAGEMENT']) && ((CONST.TIPO_TITULO_ACTIVO['PDV'] === tipoTituloCodigo || CONST.TIPO_TITULO_ACTIVO['COLATERAL'] === tipoTituloCodigo) || subtipoClaseActivoCodigo === true))) 
	    			&& $AU.userHasFunction('EDITAR_SITU_POSESORIA_ACTIVO'));
	    }else{
	    	if (!(($AU.userHasFunction('EDITAR_SITU_POSESORIA_ACTIVO') && !$AU.userIsRol(CONST.PERFILES['ASSET_MANAGEMENT']))
	    			|| ($AU.userHasFunction('EDITAR_SITU_POSESORIA_ACTIVO') && ($AU.userIsRol(CONST.PERFILES['ASSET_MANAGEMENT'])	 
	    					&& ((CONST.TIPO_TITULO_ACTIVO['PDV'] === tipoTituloCodigo || CONST.TIPO_TITULO_ACTIVO['COLATERAL'] === tipoTituloCodigo) || subtipoClaseActivoCodigo === true))))) {
				ocultarSituacionposesoriaactivo = true;
	    	}
	    }
	    
	    var ocultarDatoscomunidadactivo = false;		
	    if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
	    	ocultarDatoscomunidadactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
	    			&& $AU.userHasFunction('EDITAR_DATOS_COMUNIDAD_ACTIVO'));
	    }else{
	    	ocultarDatoscomunidadactivo = !$AU.userHasFunction('EDITAR_DATOS_COMUNIDAD_ACTIVO');
	    }
	    
	    /* var edicionCargasCarteraCajamar= me.lookupController().getViewModel().get('activo').get('isCarteraCajamar');
	    if(Ext.isEmpty(edicionCargasCarteraCajamar)){
	    	edicionCargasCarteraCajamar= false;
	    } */

	    var items = [];
	    if($AU.userIsRol(CONST.PERFILES['CARTERA_BBVA'])) {
	    	items = me.tabsBBVA(items, ocultarDatosbasicosactivo, ocultarTituloinformacionregistralactivo, ocultarInformacionadministrativaactivo);
	    }else{
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datosbasicosactivo', ocultarBotonesEdicion:ocultarDatosbasicosactivo })}, ['TAB_DATOS_BASICOS_ACTIVO']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'tituloinformacionregistralactivo', ocultarBotonesEdicion:ocultarTituloinformacionregistralactivo})}, ['TAB_ACTIVO_TITULO_INFO_REGISTRAL']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'informacionadministrativaactivo', ocultarBotonesEdicion: ocultarInformacionadministrativaactivo})}, ['TAB_ACTIVO_INFO_ADMINISTRATIVA']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'situacionposesoriaactivo', ocultarBotonesEdicion: ocultarSituacionposesoriaactivo})}, ['TAB_ACTIVO_SITU_POSESORIA']);
			//$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'informacioncomercialactivo',ocultarBotonesEdicion: true})}, ['TAB_ACTIVO_INFO_COMERCIAL']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datoscomunidadactivo',ocultarBotonesEdicion: false})}, ['TAB_ACTIVO_DATOS_COMUNIDAD']); 
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'suministrosactivo',ocultarBotonesEdicion: true})}, ['TAB_ACTIVO_SUMINISTROS']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'informefiscalactivo', ocultarBotonesEdicion:true })}, ['TAB_DATOS_BASICOS_ACTIVO']);
	    }

    	me.addPlugin({ptype: 'lazyitems', items: items});
     	me.callParent();
     },
     
     funcionRecargar: function() {
 		var me = this; 
 		me.recargar = false;		
 		me.getActiveTab().funcionRecargar();
     },
     
     evaluarBotonesEdicion: function(tab) {
     	var me = this;
		me.down("[itemId=botoneditar]").setVisible(false);
		var editionEnabled = function() {
			me.down("[itemId=botoneditar]").setVisible(true);
		}
		var userValidAndTramite = false;
		//HREOS-846 Si NO esta dentro del perimetro, no se habilitan los botones de editar
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="true" && !me.lookupController().getViewModel().get('activo').get('isActivoEnTramite')) {
			// Si la pestaña recibida no tiene asignadas funciones de edicion 
			if(Ext.isEmpty(tab.funPermEdition)) {
	    		editionEnabled();
	    	} else {
	    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
	    	} 
		}
		userValidAndTramite = (
				$AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) ||
				$AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']) || 
				$AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION']) ||
				$AU.userIsRol(CONST.PERFILES['HAYASUPER'])
				) &&  me.lookupController().getViewModel().get('activo').get('isActivoEnTramite');
	
		if(userValidAndTramite) {
			editionEnabled();
		}
    },
    
    tabsBBVA: function(items, ocultarDatosbasicosactivo, ocultarTituloinformacionregistralactivo, ocultarInformacionadministrativaactivo ){
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datosbasicosactivo', ocultarBotonesEdicion:ocultarDatosbasicosactivo })}, ['TAB_DATOS_BASICOS_ACTIVO']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'tituloinformacionregistralactivo', ocultarBotonesEdicion:ocultarTituloinformacionregistralactivo})}, ['TAB_ACTIVO_TITULO_INFO_REGISTRAL']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'informacionadministrativaactivo', ocultarBotonesEdicion: ocultarInformacionadministrativaactivo})}, ['TAB_ACTIVO_INFO_ADMINISTRATIVA']);
		
		return items;
    }
});

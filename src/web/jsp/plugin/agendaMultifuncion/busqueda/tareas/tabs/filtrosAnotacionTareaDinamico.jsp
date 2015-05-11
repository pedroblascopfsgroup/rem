<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

(function(){

	var labelStyle = 'width:200px;';

    //Template para el combo de usuarios
    var usuarioTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{nombre}</p>',
            '<p align="right"><i>{username}</i></p>',
        '</div></tpl>'
    );
    
    
    //Store del combo de usuarios
    var usuariosComboStore = page.getStore({
        flow:'recoveryagendamultifuncionanotacion/getUsuariosInstant'
        ,remoteSort:false
        ,autoLoad: false
        ,reader : new Ext.data.JsonReader({
            root:'data'
            ,fields:['id', 'nombre','username']
        })
    });    
    
    //Combo de usuarios
    var usuarioDestinoTarea = new Ext.form.ComboBox({
        name: 'usuarioDestinoTarea' 
        ,store:usuariosComboStore
        ,width:300
        ,fieldLabel: '<s:message code="tareas.busqueda.filtro.usuarioDestinoTarea" text="**Usuario destino tarea"/>'
        ,tpl: usuarioTemplate  
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,allowBlank:true
        ,enableKeyEvents: true
        ,typeAhead: false
        ,hideTrigger:true     
        ,minChars: 3
        ,displayField:'nombre'
        ,valueField:'username'
        //,hidden:false
        ,maxLength:256 
        ,itemSelector: 'div.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
	                buscarFunc();
	            }  
	        } 
		}
    });
    
    //Combo de usuarios
    var usuarioOrigenTarea = new Ext.form.ComboBox({
        name: 'usuarioOrigenTarea' 
        ,store:usuariosComboStore
        ,width:300
        ,fieldLabel: '<s:message code="tareas.busqueda.filtro.usuarioOrigenTarea" text="**Usuario origen tarea"/>'
        ,tpl: usuarioTemplate  
        ,forceSelection:true
        //,style:'padding:0px;margin:0px;'
        ,allowBlank:true
        ,enableKeyEvents: true
        ,typeAhead: false
        ,hideTrigger:true     
        ,minChars: 3
        ,displayField:'nombre'
        ,valueField:'username'
        //,hidden:false
        ,maxLength:256 
        ,itemSelector: 'div.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
	                buscarFunc();
	            }  
	        } 
		}
    });
    
      var optionsTipoTarea = page.getStore({
        flow:'recoveryagendamultifuncionanotacion/obtenerTiposAnotaciones'
        ,remoteSort:false
        ,autoLoad: true
        ,reader : new Ext.data.JsonReader({
            root:'diccionario'
            ,fields:['codigo','descripcion']
        })
    });
    

	var comboTipoTarea = new Ext.form.ComboBox({
        name: 'comboTipoTarea' 
        ,mode:'local'
        ,store:optionsTipoTarea
         ,width:300
        ,fieldLabel : '<s:message code="tareas.busqueda.filtro.tipoTarea" text="**Tipo de tarea"/>'
        ,triggerAction: 'all'
         ,emptyText:'---'
		,labelStyle:labelStyle
		,valueField: 'codigo'
    	,displayField: 'descripcion'
    	,listeners:{
			specialkey: function(f,e){  
	           if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
	                buscarFunc();
	            }  
	        } 
		}
    });
     
     //Campo correoEviado
     var checkEnvioCorreo = new Ext.form.Checkbox({
         fieldLabel: '<s:message code="tareas.busqueda.filtro.envioCorreo" text="**Solo asuntos con envios de correos"/>'
         ,inputValue: '1'
     });   
     
	
	var validarEmptyForm = function(){

		if (usuarioDestinoTarea.getValue() != ''){
			return true;
		}
		if (usuarioOrigenTarea.getValue() != '' ){
			return true;
		}
		if (comboTipoTarea.getValue() != '' ){
			return true;
		}
		if (checkEnvioCorreo.getValue() == true ){
            return true;
        }
		
		return false;
			
	}
	

	var getParametros = function() {
		return {
			params: 'usuarioDestinoTarea'    + ':' + usuarioDestinoTarea.getValue() +';'
				+ 'usuarioOrigenTarea'     + ':' + usuarioOrigenTarea.getValue()  +';'
				+ 'tipoAnotacion'          + ':' + comboTipoTarea.getValue()      +';'
				+ 'flagEnvioCorreo' + ':' + checkEnvioCorreo.getValue()
		};
	};
	
	var panel=new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,layout:'form'
		,title : '<s:message code="asuntos.busqueda.filtros.tabs.anotacion.title" text="**Anotaciones" />'
		,layoutConfig:{columns:2}
	    ,header: false
	    ,border:false
		//,titleCollapse : true
		//,collapsible:true
		,bodyStyle:'padding:10px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px',labelStyle: labelStyle}
		,items: [usuarioOrigenTarea, usuarioDestinoTarea,comboTipoTarea, checkEnvioCorreo]
		,listeners:{	
			getParametros: function(anadirParametros, hayError) {
		        if (validarEmptyForm()){
    	                anadirParametros(getParametros());
    	        }
			}
    		,limpiar: function() {
    		   app.resetCampos([      
    		           usuarioDestinoTarea, usuarioOrigenTarea, comboTipoTarea, checkEnvioCorreo
	           ]); 
    		}
    		,exportar: function() {
    		    var flow='asuntos/exportAsuntos';
                if (validarEmptyForm()){
                    if (validaMinMax()){
                        var params=getParametros();
                        params.tipoSalida='<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.SALIDA_XLS" />';
                        app.openBrowserWindow(flow,params);
                    }else{
                        Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
                    }
                }else{
                    Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
                }
    		}
		}
	});

  Ext.onReady(
	 	function(){
	 		optionsTipoTarea.webflow();
	 	}
	);


    return panel;
    
})()
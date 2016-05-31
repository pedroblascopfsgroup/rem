<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(page,entidad){

	var panel=new Ext.Panel({
		title:'<s:message code="cliente.tabaccionesfsr.tab.title" text="**Acciones FSR"/>'
		,autoScroll:true
		,width:770
		,autoHeight:true
		//,autoWidth : true
		,layout:'table'
		,bodyStyle:'padding:5px;margin:5px'
		,border : false
	    ,layoutConfig: {
	        columns: 1
	    }
		,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
		,nombreTab : 'tabDatosFSR'
	});


	fsrFieldSet =  new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:20px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title: '<s:message code="cliente.tabaccionesfsr.tab.panel.title" text="**FSR"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : []
		});

    panel.add(fsrFieldSet);


    panel.getValue = function(){}
   
	panel.setValue = function(){
	
		var labelStyle = 'width:375; font-size: 10px;';
		
		panel.items.items[0].removeAll( true );
	
		var resultado = data.allAccionesFSR;
		for(i=0; i < resultado.length; i++){
			
			accion = resultado[i];

			ischecked = panel.esActivo(accion.codigo);
			
			var check = new Ext.form.Checkbox({
				name : 'accionFSR-'+ accion.codigo 
				,value : accion.descripcion
				,boxLabel: '<span style="font-size: 11px;">' + accion.descripcion + '</span>'
				,disabled : true
				,checked : ischecked
				,labelStyle: 'font-weight:bold;'
				,disabledClass :''
				,style: {
                	marginLeft: '14px'
            	}
			});

			panel.items.items[0].add(check);
		}
		
		panel.doLayout();

	}
	
	panel.esActivo = function(codigo){
		var accionesMarcadas = data.accionesPersonaFSRActivas;
		for(n=0; n < accionesMarcadas.length; n++){
			accionMarcada = accionesMarcadas[n];
			if(accionMarcada.codigo == codigo){
				return true;
			}
		}
		return false;
	}
	
	

	return panel;

})

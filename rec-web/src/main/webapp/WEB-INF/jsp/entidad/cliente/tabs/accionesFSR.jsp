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

	function label(id,text){
		return app.creaLabel(text,"",  {id:'entidad-cliente-'+id});
	}

	function fieldSet(title,items){
		return new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title: title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : items
		});
	}



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
		,nombreTab : 'tabDatosCliente'
	});




   var fechaConstitucion =  label('fechaConstitucion','<s:message code="menu.clientes.consultacliente.datosTab.fechaConstitucion" text="**fecha nacimiento" />');
   var fechaConstitucion1 =  label('fechaConstitucion1','<s:message code="menu.clientes.consultacliente.datosTab.fechaConstitucion1" text="**fecha constitucion" />');
 
   
 

	var fsrFieldSet = fieldSet( '<s:message code="cliente.tabaccionesfsr.tab.panel.title" text="**FSR"/>'
			,[ {items:[fechaConstitucion,fechaConstitucion1]}]);	

	<%--var datosPersonalesFieldSet = fieldSet('<s:message code="menu.clientes.consultacliente.menu.DatosPersonales" text="**Datos Personales"/>'
			   , [{items:[fechaConstitucion,nacionalidad,paisNacimiento,numEmpleados, sexo]}, {items:[esEmpleado, volumenFacturacion,fechaVolumenFacturacion, cnae]} ] ); --%>


   panel.add(fsrFieldSet);


    panel.getValue = function(){}
   
	panel.setValue = function(){

		entidad.setLabel("fechaConstitucion", "rrrr");
		entidad.setLabel("fechaConstitucion1", "asdasda");

	}

	return panel;

})

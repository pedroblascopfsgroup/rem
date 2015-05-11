<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	<pfs:textfield name="nombre" labelKey="plugin.recobroConfig.cartera.nombre"
		label="**Nombre" value="${cartera.nombre}"  readOnly="true"/>

	<pfs:textfield name="descripcion" labelKey="plugin.recobroConfig.cartera.descripcion"
		label="**Descripción" value="${cartera.descripcion}"  readOnly="true"/>
	
	<pfs:textfield name="idRegla"
		labelKey="plugin.recobroConfig.cartera.paqueteReglas" label="**Paquete de reglas"
		value="${cartera.regla.name}" readOnly="true"/>
		
	function fieldSet(title,items){
		return new Ext.form.FieldSet({
			autoHeight:true
			,width:675
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:350}
		    ,items : items
		});
	}
	
	var datosBasicosFieldSet = fieldSet( ''
                ,[{items:[nombre,descripcion]} ,{items : [idRegla]} ]);
	
	var panel = new Ext.Panel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items :datosBasicosFieldSet	
	});		
	
	page.add(panel);

</fwk:page>
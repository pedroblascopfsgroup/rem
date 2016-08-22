<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="value" required="false" type="java.lang.String"%>

//TODO agregar los parametros para que puedan especificarse dia mínimo y máximo
/*
	var endDate = new Date(fechaVencimiento.substring(6),(fechaVencimiento.substring(3,5))-1,fechaVencimiento.substring(0,2));	
	var maxDate = endDate;
	maxDate = maxDate.add(Date.DAY,10);
	
	var today = new Date();
	if (today>endDate){
		endDate = today;
	}
	
	var ${name} = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="solicitarprorroga.fecha" text="**Nueva Fecha" />'
		,labelStyle:'font-weight:bolder'
		,minValue : endDate
		//dias maximo de prorroga
		,maxValue : maxDate
		,name:'fechaPropuesta'
	});
	
*/	
			

	var ${name} = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="${label}" text="**Nueva Fecha" />'
    	,labelStyle:'font-weight:bolder'
    	//,minValue : new Date()
    	//,maxValue : new Date().add(Date.DAY,10)
    	<c:if test="${value!=null}">
			,value="${value}"
		</c:if>
	});
	
	
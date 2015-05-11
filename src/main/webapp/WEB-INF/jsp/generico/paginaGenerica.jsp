<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.procedimiento.model.ComponenteGenerico" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="gen" tagdir="/WEB-INF/tags/generico" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%
	pageContext.setAttribute("text",ComponenteGenerico.TIPO_TEXTFIELD);
	pageContext.setAttribute("combo",ComponenteGenerico.TIPO_COMBO);
	pageContext.setAttribute("number",ComponenteGenerico.TIPO_NUMBER);
	pageContext.setAttribute("textArea",ComponenteGenerico.TIPO_TEXTAREA);
	pageContext.setAttribute("date",ComponenteGenerico.TIPO_FECHA);
%>
<fwk:page>
		
	var pageItems = new Array();	
		
	<c:forEach items="${elementos}" var="elemento">
		<c:choose>
			<c:when test="${elemento.codigo==text}">
				<gen:text name="${elemento.nombre}" label="${elemento.etiqueta}"/>
			</c:when>
			<c:when test="${elemento.codigo==combo}">
				<gen:combo source="${elemento.origen}" name="${elemento.nombre}"  label="${elemento.etiqueta}"/>
			</c:when>
			<c:when test="${elemento.codigo==date}">
				<gen:date name="${elemento.nombre}"  label="${elemento.etiqueta}"/>
			</c:when>
		</c:choose>
		pageItems[pageItems.length] = ${elemento.nombre};
	</c:forEach>
	
	
		
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
				page.webflow({
					flow : 'generico/genericSubmit'
					,event: 'save'
					,params : {
									<c:forEach items="${elementos}" var="elemento" varStatus="status">
									    <c:if test="${status.index>0}">
											,				    
									    </c:if>
									    ${elemento.nombre}:${elemento.nombre}.getValue() 
									</c:forEach>
							 }
					,success :function(){
						page.fireEvent(app.event.DONE);  	
					}
			
				});
			}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	
	var panel = new Ext.form.FormPanel({
		bodyStyle : 'padding:5px'
		,layout:'anchor'
		,autoHeight : true
		,defaults:{
			border:false
			,cellCls:'vtop'
		}
		,items : [
		 	{ xtype : 'errorList', id:'errL' }
		 	,{
		 		layout:'table'
		 		,autoHeight:true
		 		,border:false
		 		,layoutConfig:{columns:2}
		 		,defaults:{border:false,xtype:'fieldset',autoHeight:true,width:330}
		 		,items:[
		 			{items:pageItems}
		 		]
		 	}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});


	page.add(panel);

</fwk:page>
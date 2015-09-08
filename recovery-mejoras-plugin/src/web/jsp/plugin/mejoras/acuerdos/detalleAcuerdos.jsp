<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>
		
		var acuerdo = '${acuerdo.id}';
		<%@ include file="/WEB-INF/jsp/acuerdos/actuacionesRealizadasAcuerdo.jsp" %>
		var actuacionesRealizadas=crearActuacionesRealizadas();
	
		<%@ include file="/WEB-INF/jsp/acuerdos/analisisAcuerdo.jsp" %>
		var analisis = crearAnalisis();
	
		<%@ include file="/WEB-INF/jsp/acuerdos/actuacionesAExplorarAcuerdo.jsp" %>
		var actAExpl = crearActuacionesAExplorar();
	
<%-- 		<%@ include file="/WEB-INF/jsp/plugin/mejoras/acuerdos/conclusionesAcuerdo.jsp" %>	 --%>
<!-- 		var conclusiones = crearConclusiones(); -->
		
		
<%-- 		<%@ include file="listadoCumplimientoAcuerdo.jsp" %>	 --%>
<!-- 		var cumplimiento = crearCumplimiento(); -->
 


	   var panel3 = new Ext.Panel({
		style:'padding: 5px'
		,defaults:{
		    style:'margin:5px'
		}
		,border : false
		,autoHeight:true 
		,autoWidth:true
	      ,items:[
<!-- 		   cumplimiento -->
		    actuacionesRealizadas
		    ,actAExpl]
	   });

	  var panel4 = new Ext.Panel({
		style:'padding: 5px'
		,defaults:{
		    style:'margin:5px'
		}
		,border : false
		,autoHeight:true
		,autoWidth:true
	      ,items:[analisis]
	   });

	  var panel5 = new Ext.Panel({
		style:'padding: 5px'
		,layout:'table'
		,layoutConfig: {columns:2}
		,items:[panel3,panel4]
		,defaults:{
		    style:'margin:5px'
		}
		,autoHeight:true
		,autoWidth:true
		,border : false
	   });

	page.add(panel5);

	/* page.add(cumplimiento);
	page.add(actuacionesRealizadas);
	page.add(analisis);
	page.add(actAExpl);
	page.add(conclusiones); */

</fwk:page>
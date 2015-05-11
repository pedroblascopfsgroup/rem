<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>
		
	
		var acuerdo = '${acuerdo.id}';
		<%@ include file="actuacionesRealizadasAcuerdo.jsp" %>
		var actuacionesRealizadas=crearActuacionesRealizadas();
	
		<%@ include file="analisisAcuerdo.jsp" %>
		var analisis = crearAnalisis();
	
		<%@ include file="actuacionesAExplorarAcuerdo.jsp" %>
		var actAExpl = crearActuacionesAExplorar();
	
		<%@ include file="conclusionesAcuerdo.jsp" %>	
		var conclusiones = crearConclusiones();


   /*var panel = new Ext.Panel({
        title:'<s:message code="acuerdos.titulo" text="**detalle"/>'
        ,style:'padding: 10px'
        ,defaults:{
            style:'margin:10px'
        }
        ,autoHeight:true
        ,items:[
            actuacionesRealizadas
            ,analisis
            ,actAExpl
            ,conclusiones
      	]
   });

	page.add(panel);   */
	page.add(actuacionesRealizadas);
	page.add(analisis);
	page.add(actAExpl);
	page.add(conclusiones);

</fwk:page>
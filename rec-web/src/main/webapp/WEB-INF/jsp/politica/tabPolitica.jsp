<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


var createTabPoliticaPanel = function() {
// Cada una de las partes del tab estan en los .jsp importados.
    
    var isSuperusuario = false;
    <sec:authorize ifAllGranted="POLITICA_SUPER">    
    	isSuperusuario = true;
	</sec:authorize>    	
    
    
    
    <%@ include file="tabPoliticaHistPoliticas.jsp" %>
    <%@ include file="tabPoliticaDatosPolitica.jsp" %>
    <%@ include file="tabPoliticaDatosObjetivos.jsp" %>

    var histPoliticaGrid = createHistorialPoliticasPanel();
    var panelPolitica = createDatosPoliticaPanel();
    var objetivosGrid = createDatosObjetivosPanel();

    var panel = new Ext.Panel({
        title: '<s:message code="politica.titulo" text="**Políticas" />'
        ,autoHeight: true
        ,bodyStyle: 'padding:10px'
        ,items: [histPoliticaGrid, panelPolitica, objetivosGrid]
    });

    return panel;
};
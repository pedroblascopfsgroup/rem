﻿<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(page,entidad) {
// Cada una de las partes del tab estan en los .jsp importados.
    
    var isSuperusuario = false;
    <sec:authorize ifAllGranted="POLITICA_SUPER">    
    	isSuperusuario = true;
	</sec:authorize>    	
    
    var panel = new Ext.Panel({
        title: '<s:message code="politica.titulo" text="**Políticas" />'
        ,autoHeight: true
        ,bodyStyle: 'padding:10px'
        ,nombreTab : 'politicaPanel'
    });
    

   panel.getPersonaId = function(){
      var data= entidad.get("data");
      return data.id;
   }

    
	panel.on('render', function() {
	    <%@ include file="politicaHistorico.jsp" %>
	    <%@ include file="politicaDatos.jsp" %>
	    <%@ include file="politicaDatosObjetivos.jsp" %>
	
	    var histPoliticaGrid = createHistorialPoliticasPanel();
	    var panelPolitica = createDatosPoliticaPanel();
	    var objetivosGrid = createDatosObjetivosPanel();



		panel.add(histPoliticaGrid);
		panel.add(panelPolitica);
		panel.add(objetivosGrid);


      entidad.cacheStore(histPoliticaGrid.getStore());
      entidad.cacheStore(objetivosGrid.getStore());
   
      panel.getValue = function(){}

      panel.setValue = function(){
         var data= entidad.get("data");
      
         entidad.cacheOrLoad(data, histPoliticaGrid.getStore(), { id : data.id} );
//         entidadcacheOrLoad(data, objetivosGrid.getStore(), { idPolitica : data.id} );
      }
	});


    return panel;
})

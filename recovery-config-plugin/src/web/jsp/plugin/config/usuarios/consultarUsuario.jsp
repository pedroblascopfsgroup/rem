<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>

<fwk:page>

	
	
	<pfslayout:includetab name="tabCabecera">
		<%@ include file="tabCabeceraUsuario.jsp" %>
	</pfslayout:includetab>
	
	
	<pfslayout:includetab name="tabPerfiles">
		<%@ include file="tabPerfilesUsuario.jsp" %>
	</pfslayout:includetab>
	
	<%-- PRODUCTO-1369 - En vez de la despachos supervisados por el usuario, se ha sustitudo por despachos Asociados al User
	Pero no lo he borrado, si se requiere en un futuro, solo habrá que descomentar esta lina y ponerle otro name
	<pfslayout:includetab name="tabDespachos">
		<%@ include file="tabDespachosUsuario.jsp" %>
	</pfslayout:includetab>
	--%>
	<pfslayout:includetab name="tabDespachos">
		<%@ include file="tabDespachosAsociadosUsuario.jsp" %>
	</pfslayout:includetab>
	
	<pfslayout:includetab name="tabGrupos">
		<%@ include file="tabGruposUsuario.jsp" %>
	</pfslayout:includetab>
	
	<c:if test="${usuario.usuarioExterno == false }">
		<pfslayout:tabpanel name="tabsUsuario" tabs="tabCabecera,tabPerfiles,tabDespachos,tabGrupos"/>
	</c:if>
	
	<c:if test="${usuario.usuarioExterno == true }">
		<pfslayout:tabpanel name="tabsUsuario" tabs="tabCabecera,tabPerfiles,tabGrupos"/>
	</c:if>
	
	<sec:authorize ifAllGranted="ROLE_DESACTIVAR_DEPENDENCIA_USU_EXTERNO">
		<pfslayout:tabpanel name="tabsUsuario" tabs="tabCabecera,tabPerfiles,tabDespachos,tabGrupos"/>
	</sec:authorize>
	

	
	page.add(tabsUsuario);
	
	
	Ext.Ajax.request({
		url: page.resolveUrl('plugin/config/usuarios/ADMlistadoCentrosPerfiles')
		,params: {id: '${usuario.id}'}
		,method: 'POST'
		,success: function (result, request){
			var r = Ext.util.JSON.decode(result.responseText);
			var perfiles = r.perfiles;
			if (perfiles.length == 0){
				Ext.Msg.show({  
					title: '<s:message code="plugin.config.usuarios.consulta.message.sinzonificacion.title" text="**Zonificacion"/>',  
					msg: '<s:message code="plugin.config.usuarios.consulta.message.sinzonificacion.text" text="**El usuario no tiene zonificacion"/>',  
					width: 500,  
					icon: Ext.MessageBox.WARNING,
					buttons: Ext.MessageBox.OK
				});
			}
	}});
	
</fwk:page>
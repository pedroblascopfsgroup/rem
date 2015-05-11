<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

var asuntoNdTabs = <app:includeArray files="${tabs}" />;

var buttonsR_asuntoNd = <app:includeArray files="${buttonsRight}" />;
var buttonsL_asuntoNd = <app:includeArray files="${buttonsLeft}" />;

var asuntoNdToolbar = <%@ include file="../../plugin/gestionJudicial/entidad/asuntoNoDinerario/toolbar.jsp" %>;

app.abreAsuntoNdFast = function(id,nombre,tabAceptacion,nombreTab, acuerdos){
	if (!app.entidad.fastMode){
		var acepta = tabAceptacion?true:false;
		var options = {id:id,aceptacion:acepta,acuerdos:(acuerdos?true:false)};
		if (nombreTab) options.nombreTab = nombreTab;
		this.openTab(nombre, 'asuntos/consultaAsunto', options , {id:'asunto'+id,iconCls:'icon_asuntos'});
	}else{
		if(!app.asuntoNd){
			app.asuntoNd = new app.entidad( 'asuntoNd', asuntoNdTabs, asuntoNdToolbar, '/pfs/plugin/gestionJudicial/consultaAsuntoNdFast.htm', 'icon_asuntos');
		}
		app.asuntoNd.abrir(id,nombre);
	}
	this.addFavorite(id, nombre, app.constants.FAV_TIPO_ASUNTOND);
}
app.abreAsuntoNd = function(id,nombre,tab,acuerdos){
	app.abreAsuntoNdFast(id,nombre,tab,false, acuerdos);
}
app.AbreAsuntoNdTab = function(id,nombre,nombreTab){
	app.abreAsuntoNdFast(id,nombre,false,nombreTab,false);
}

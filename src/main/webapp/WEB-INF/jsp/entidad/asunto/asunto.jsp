<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

var asuntoTabs = <app:includeArray files="${tabs}" />;

var buttonsR_asunto = <app:includeArray files="${buttonsRight}" />;
var buttonsL_asunto = <app:includeArray files="${buttonsLeft}" />;

var asuntoToolbar = <%@ include file="toolbar.jsp" %>;

app.abreAsuntoFast = function(id,nombre,tabAceptacion,nombreTab, acuerdos){
	if (!app.entidad.fastMode){
		var acepta = tabAceptacion?true:false;
		var options = {id:id,aceptacion:acepta,acuerdos:(acuerdos?true:false)};
		if (nombreTab) options.nombreTab = nombreTab;
		this.openTab(nombre, 'asuntos/consultaAsunto', options , {id:'asunto'+id,iconCls:'icon_asuntos'});
	}else{
		if(!app.asunto){
			app.asunto = new app.entidad( 'asunto', asuntoTabs, asuntoToolbar, '/pfs/asuntos/consultaAsuntoFast.htm', 'icon_asuntos');
		}
		app.asunto.abrir(id, nombre, nombreTab);
	}
	this.addFavorite(id, nombre, this.constants.FAV_TIPO_ASUNTO);
}
app.abreAsunto = function(id,nombre,tab,acuerdos){
	app.abreAsuntoFast(id,nombre,tab,false, acuerdos);
}
app.abreAsuntoTab = function(id,nombre,nombreTab){
	app.abreAsuntoFast(id,nombre,false,nombreTab,false);
}

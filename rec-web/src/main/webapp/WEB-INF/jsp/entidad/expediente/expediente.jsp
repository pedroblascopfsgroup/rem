<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

var expedienteTabs = <app:includeArray files="${tabs}" />;

var buttonsR_expediente = <app:includeArray files="${buttonsRight}" />;
var buttonsL_expediente = <app:includeArray files="${buttonsLeft}" />;

var expedienteToolbar = <%@ include file="toolbar.jsp" %>;

app.abreExpedienteFast = function(id,nombre,params){
	
	if (params && typeof(params)=="object")
		var nombreTab = params.nombreTab
	else
		var nombreTab = params
		
	if (!app.entidad.fastMode){
		var options = {id:id};
		if (nombreTab) options.nombreTab = nombreTab;
		this.openTab(nombre||'Cliente', 'expedientes/consultaExpediente', options, {id:'exp'+id,iconCls:'icon_expedientes'} );
	}else{
		if(!app.expediente){
			app.expediente = new app.entidad('expediente', expedienteTabs, expedienteToolbar, '/pfs/expedientes/consultaExpedienteFast.htm', 'icon_expedientes');
		}
		app.expediente.abrir(id,nombre,nombreTab);
	}
	this.addFavorite(id, nombre, this.constants.FAV_TIPO_EXPEDIENTE);
}

app.abreExpediente = function(id,nombre,params, config){
	if (params && typeof(params)=="object"){
		app.abreExpedienteFast(id,nombre,params);
		return;
	}
	app.abreExpedienteTab(id,nombre,false);
}

app.abreExpedienteTab = function(id,nombre,nombreTab){
	app.abreExpedienteFast(id,nombre,nombreTab);
}

/*
app.entidad.interceptores['procedimientos/consultaProcedimiento'] = {
   method : app.abreProcedimiento
   ,scope : app 
};
*/
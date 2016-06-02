<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

var procedimientoTabs = <app:includeArray files="${tabs}" />;

var buttonsR_procedimiento = <app:includeArray files="${buttonsRight}" />;
var buttonsL_procedimiento = <app:includeArray files="${buttonsLeft}" />;

var procedimientoToolbar = <%@ include file="toolbar.jsp" %>;

app.abreProcedimientoFast = function(id,nombre,params){
	if (params && typeof(params)=="object")
		var nombreTab = params.nombreTab
	else
		var nombreTab = params
		
	if (!app.entidad.fastMode){
		var options = {id:id};
		if (nombreTab) options.nombreTab = nombreTab;
		this.openTab(nombre, 'procedimientos/consultaProcedimiento', options , {id:'procedimiento'+id,iconCls:'icon_procedimiento'});
	}else{
		if(!app.procedimiento){
			app.procedimiento = new app.entidad( 'procedimiento', procedimientoTabs, procedimientoToolbar, '/pfs/procedimiento/consultaProcedimientoFast.htm', 'icon_procedimiento');
		}
		app.procedimiento.abrir(id,nombre, params);
	}
	this.addFavorite(id, nombre, this.constants.FAV_TIPO_PROCEDIMIENTO);
}

app.abreProcedimiento = function(id,nombre,params, config){
	if (params && typeof(params)=="object"){
		app.abreProcedimientoFast(id,nombre,params);
		return;
	}
	app.abreProcedimientoFast(id,nombre,false);
}

app.abreProcedimientoTab = function(id,nombre,nombreTab){
	app.abreProcedimientoFast(id,nombre,nombreTab);
}

app.entidad.interceptores['procedimientos/consultaProcedimiento'] = {
   method : app.abreProcedimiento
   ,scope : app 
};

<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

var clienteTabs = <app:includeArray files="${tabs}" />;

var buttonsR_cliente = <app:includeArray files="${buttonsRight}" />;
var buttonsL_cliente = <app:includeArray files="${buttonsLeft}" />;

var clienteToolbar = <%@ include file="toolbar.jsp" %>;

app.abreClienteTab = function(id, nombre,nombreTab){
	if (app.entidad.fastMode){
		if (!app.cliente){
			app.cliente = new app.entidad('cliente', clienteTabs, clienteToolbar, '/pfs/clientes/consultaClienteFast.htm');
		}
		var params = {id:id,nombreTab:nombreTab};
        app.cliente.abrir(id,nombre,params);
		
	}
	else{
		this.openTab(nombre||'Cliente', 'clientes/consultaCliente', {id : id,nombreTab:nombreTab}, {id:'cliente'+id,iconCls:'icon_cliente'} );
	}
	
	this.addFavorite(id, nombre, this.constants.FAV_TIPO_CLIENTE);
};

app.abreCliente=app.abreClienteTab;
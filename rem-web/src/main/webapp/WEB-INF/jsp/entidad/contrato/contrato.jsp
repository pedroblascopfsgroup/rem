<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

var contratoTabs = <app:includeArray files="${tabs}" />;

var buttonsR_contrato = <app:includeArray files="${buttonsRight}" />;
var buttonsL_contrato = <app:includeArray files="${buttonsLeft}" />;

var contratoToolbar = <%@ include file="toolbar.jsp" %>;

app.abreContrato = function(id,nombre,tabAceptacion,acuerdos){
  if (!app.entidad.fastMode) {
      tabAceptacion=tabAceptacion?true:false; 
      acuerdos=acuerdos?true:false;
      this.openTab(nombre,'asuntos/consultaContrato',{id:id, aceptacion:tabAceptacion, acuerdos:acuerdos}, {id:'asunto'+id,iconCls:'icon_contratos'});
  }else{
	if (!app.contrato){
		app.contrato = new app.entidad('contrato', contratoTabs, contratoToolbar, '/pfs/contratos/consultaContratoFast.htm','icon_contratos');
	}
	app.contrato.abrir(id,nombre);
  }
  this.addFavorite(id, nombre, this.constants.FAV_TIPO_CONTRATO);
}

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="parameters" required="true" type="java.lang.String"%>
<%@ attribute name="store_ref" required="true" type="java.lang.String"%>

<%@ attribute name="colapsePanel" required="false" type="java.lang.String"%>

var ${name}_validarAntesDeBuscar = function(){
	${name}_buscarFunc(false);
};


var ${name}_buscarFunc = function(v){
		var valido = (v == null) ? true : v;
		if (! valido){
			valido = ${parameters}_validarForm();
		}
		if (valido){
                var params= ${parameters}();

                params.start=0;

                params.limit=${store_ref}.limit;

                ${store_ref}.webflow(params);

				<c:if test="${colapsePanel != null}">
				${colapsePanel}.collapse(true);
				</c:if>

		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
		}
	};


var ${name} = app.crearBotonBuscar({
		handler : ${name}_validarAntesDeBuscar
});
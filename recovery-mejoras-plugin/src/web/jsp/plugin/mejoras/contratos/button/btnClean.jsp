<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			if (tabDatos){
        			txtContrato.reset();
        			comboEstadoContrato.reset();
        			comboTiposProducto.reset();
        			txtCodRecibo.reset();
        			txtCodEfecto.reset();
        			txtCodDisposicion.reset();
        			comboMotivoGestionHRE.reset();
        			comboSituacionGestion.reset();
        		}
        	if(tabRelaciones){
        			txtNombre.reset();
        			txtApellido1.reset();
					<%--txtApellido2.reset(); --%>
					txtNIF.reset();
					<c:if test="${busquedaOrInclusion!='inclusion'}">
		 				txtExpediente.reset();		
						txtAsunto.reset();
					</c:if>
        		}
        	if (tabEconomicos){
        			comboEstadoFinanciero.reset();
        			mmRiesgoTotal.max.reset();
					mmRiesgoTotal.min.reset();
					mmSVencido.max.reset();
					mmSVencido.min.reset();
					mmDVencido.min.reset();
					mmDVencido.max.reset();
        		}
        	if (tabJerarquia){
        			comboZonas.reset();
    				comboJerarquia.reset();
    				optionsZonasStore.webflow({id:0});
    				comboZonasAdm.reset();
    				comboJerarquiaAdministrativa.reset();
    				optionsZonasAdmStore.webflow({id:0});
    				zonasStore.removeAll();
    				zonasAdmStore.removeAll();
        		} 
			contratosGrid2.collapse(true);
		}
	})
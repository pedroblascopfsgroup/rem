<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>



<fwk:page>
	Ext.util.CSS.createStyleSheet("button.icon_copiar { background-image: url('../img/plugin/itinerarios/copia.png');}");

	var codigoSeguimientoSistematico = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SISTEMATICO"/>';
	var codigoSeguimientoSintomatico = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SINTOMATICO"/>';
	var tipo = "${itinerario.dDtipoItinerario.codigo}";
	
	
	<pfsforms:textfield name="nombre" labelKey="plugin.itinerarios.alta.nombre" 
		label="**Nombre" value="${itinerario.nombre}" readOnly="true" />
	<pfsforms:textfield name="tipoItinerario" labelKey="plugin.itinerarios.alta.tipoItinerario" 
		label="**Tipo de Itinerario" value="${itinerario.dDtipoItinerario.descripcion}" readOnly="true"  />
	
	<pfsforms:textfield name="ambitoExpediente" labelKey="plugin.itinerarios.alta.ambitoExpediente" 
		label="**Ámbito del Expediente" value="${itinerario.ambitoExpediente.descripcion}" 
		readOnly="true" width="500"/>
	
		
	<pfsforms:textfield name="prePolitica" labelKey="plugin.itinerarios.alta.prePolitica" 
		label="**PrePolítica" value="${itinerario.prePolitica.descripcion}" 
		readOnly="true" width="500"/>		
		
	
	<pfs:defineParameters name="parametros" paramId="${itinerario.id}" />
	
	var recargar = function (){
		app.openTab('${itinerario.nombre}'
					,'plugin/itinerarios/plugin.itinerarios.consultaItinerario'
					,{id:${itinerario.id}}
					,{id:'ItinerarioRT${itinerario.id}'}
				)
	};
	
	<pfs:buttonedit flow="itinerarios/plugin.itinerarios.editarItinerario" name="btEditar" 
		windowTitleKey="plugin.itinerarios.consulta.modificar" parameters="parametros" windowTitle="**Modificar"
		on_success="recargar"/>
	
	<pfs:button name="btCopiaItinerario" caption="**Crear una copia"  captioneKey="plugin.itinerarios.consulta.copiar" iconCls="icon_copiar">
		Ext.Msg.show({
				title: '<s:message code="plugin.itinerarios.consulta.copiar" text="**Crear una copia" />'
				,msg: '<s:message code="plugin.itinerarios.consulta.seguroCopia" text="**¿Está seguro que desea crear una copia de este itinerario?" arguments="${itinerario.nombre}"/>'
				,buttons: Ext.Msg.YESNO
				,fn : function(bt,text){
					if (bt == 'yes'){
						page.webflow({
							flow: 'plugin/itinerarios/plugin.itinerarios.copiaItinerario'
							,params: parametros
							,success : Ext.Msg.alert('<s:message code="plugin.itinerarios.consulta.copiaCreada" text="**La copia del itinerario ha sido creada correctamente" arguments="${itinerario.nombre}"/>')
						});
					}
				}
			});
		
		
	</pfs:button>
	if((tipo==codigoSeguimientoSistematico) || (tipo==codigoSeguimientoSintomatico)){
		<pfs:panel name="panel1" columns="2" collapsible="true" bbar="btEditar, btCopiaItinerario" tbar="">
			<pfs:items items="nombre, tipoItinerario " width="300" />
			<pfs:items items="ambitoExpediente,prePolitica" width="600" />
		</pfs:panel>
	}
	else{
		<pfs:panel name="panel1" columns="2" collapsible="true" bbar="btEditar, btCopiaItinerario" tbar="">
			<pfs:items items="nombre, tipoItinerario " width="300" />
			<pfs:items items="ambitoExpediente" width="600" />
		</pfs:panel>
	}

	<pfslayout:includetab name="tabEstados" >
		<%@ include file="tabEstadosItinerario.jsp" %>
	</pfslayout:includetab>
	
		
	<pfslayout:includetab name="tabTelecobro">
		<%@ include file="tabTelecobroItinerario.jsp" %>
	</pfslayout:includetab>
	
	
	
	<pfslayout:includetab name="tabDCA">
		<%@ include file="tabDecisionComiteAuto.jsp" %>
	</pfslayout:includetab>
	

	
	<pfslayout:includetab name="tabTRE">
		<%@ include file="tabTipoReglasElevacion.jsp" %>
	</pfslayout:includetab>
	
	
	<pfslayout:includetab name="tabTRV">
		<%@ include file="tabTipoReglasVigencia.jsp" %>
	</pfslayout:includetab>
	
		<%-- --%>	
		
	<pfslayout:includetab name="tabComites">
		<%@ include file="tabComitesItinerario.jsp" %>
	</pfslayout:includetab>
	
	
	
	<c:if test="${itinerario.dDtipoItinerario.codigo=='REC'}">
		<sec:authorize ifAllGranted="ROLE_PUEDE_VER_TAB_TELECOBRO_ITI">
			<pfslayout:tabpanel name="tabsItinerario" tabs="tabEstados,tabTelecobro,tabDCA,tabTRE,tabComites" />
		</sec:authorize>
		<sec:authorize ifNotGranted="ROLE_PUEDE_VER_TAB_TELECOBRO_ITI">
			<pfslayout:tabpanel name="tabsItinerario" tabs="tabEstados,tabDCA,tabTRE,tabComites" />
		</sec:authorize>
	</c:if>
	<c:if test="${itinerario.dDtipoItinerario.codigo!='REC'}">
		<pfslayout:tabpanel name="tabsItinerario" tabs="tabEstados,tabTRE,tabTRV,tabComites" />
	</c:if>
	 
	
	
	var compuesto = new Ext.Panel({
	    items : [
	    		{items:[panel1],border:false,style:'margin-top: 7px; margin-left:5px'}
	    		,{items:[tabsItinerario],border:false,style:'margin-top: 7px; margin-left:5px'}
	    	]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
	page.add(compuesto);
	
	
</fwk:page>
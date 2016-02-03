<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<fwk:page>

	var recargar = function (){
		app.openTab('${plazo.tareaProcedimiento.descripcion}'
					,'plugin.plazosExterna.consultarPlazoTarea'
					,{id:${plazo.id}}
					,{id:'PlazosTareasRT${plazo.id}'}
				)
	};
	
	<pfsforms:textfield name="nombreProcedimiento" 
		labelKey="plugin.plazosExterna.busqueda.procedimiento" 
		label="**Tipo procedimiento" 
		value="${plazo.tareaProcedimiento.tipoProcedimiento.descripcion}"
		readOnly="true"/>
	
	<pfsforms:textfield name="nombreTarea" 
		labelKey="plugin.plazosExterna.busqueda.tipoTarea" 
		label="**Tipo de Tarea" 
		value="${plazo.tareaProcedimiento.descripcion}"
		readOnly="true"/>
		
	<pfsforms:textfield name="nombreJuzgado" 
		labelKey="plugin.plazosExterna.busqueda.tipoJuzgado" 
		label="**Plaza" 
		value="${plazo.tipoJuzgado.descripcion}"
		readOnly="true"/>
		
	<pfsforms:textfield name="nombrePlaza" 
		labelKey="plugin.plazosExterna.busqueda.tipoPlaza" 
		label="**Plaza" 
		value="${plazo.tipoPlaza.descripcion}"
		readOnly="true"/>
	
	<%--
	<pfsforms:textfield name="scriptPlazo" labelKey="plugin.plazosExterna.editarPlazo.plazo"
		label="**Script de plazo" value="**Script de plazo" width="600" readOnly="true"/>
		--%>
		
	var scriptPlazo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code='plugin.plazosExterna.editarPlazo.scriptPlazo' text='**Script de plazo}' />'
		,value : "${plazo.scriptPlazo}"
		,name : 'scriptPlazo'
		,labelStyle:'font-weight:bolder'
		,width : 600 
	});
	
	<%--scriptPlazo.setValue(${plazo.scriptPlazo });--%>
	
	<pfsforms:textfield name="observaciones" labelKey="plugin.plazosExterna.busqueda.observaciones"
		label="**Observaciones" value="${plazo.observaciones}" readOnly="true"/>
	
	<pfsforms:check labelKey="plugin.plazosExterna.busqueda.editable" 
		label="**Editable" name="absoluto" value="${plazo.absoluto}"/>
		
	absoluto.setDisabled(true);
	
	
	<pfs:hidden name="idPlazo" value="${plazo.id}"/>
	<pfs:defineParameters name="parametros" paramId="${plazo.id}" idPlazo="idPlazo"/>
	<pfs:buttonedit flow="plugin.plazosExterna.editarPlazo" 
		name="btEditar" 
		windowTitleKey="plugin.plazosExterna.listado.editar" 
		parameters="parametros" 
		windowTitle="**Modificar"
		on_success="recargar"/>
		
	btEditar.hide()
	<sec:authorize ifAllGranted="ROLE_EDITPLAZOSEXT">
		btEditar.show();
	</sec:authorize>
	 
	<pfs:panel name="panel1" columns="2" collapsible="false" bbar="btEditar" >
		<pfs:items items="nombreProcedimiento, nombreTarea, nombreJuzgado,nombrePlaza " />
		<pfs:items items="absoluto,scriptPlazo,observaciones" />
	</pfs:panel>
	
	var compuesto = new Ext.Panel({
	    items : [
	    		{items:[panel1],border:false,style:'margin-top: 7px; margin-left:5px'}
				]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
	page.add(compuesto);
	
</fwk:page>
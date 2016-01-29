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

	<pfsforms:textfield name="descripcion"
			labelKey="plugin.plazasJuzgados.altaPlaza.descripcion" label="**Descripción"
			value="${juzgado.plaza.descripcion}" readOnly="true" />
	
	<pfsforms:textfield name="descripcionLarga"
			labelKey="plugin.plazasJuzgados.altaPlaza.descripcionLarga" label="**Descripción larga"
			value="${juzgado.plaza.descripcionLarga}" readOnly="true" />
	
	<pfsforms:textfield name="codigo"
			labelKey="plugin.plazasJuzgados.altaPlaza.codigo" label="**Código"
			value="${juzgado.plaza.codigo}" readOnly="true" />
	
	 
	var recargar = function (){
		app.openTab('${juzgado.descripcion}'
					,'plugin/plazasJuzgados/plugin.plazasJuzgados.consultaPlaza'
					,{id:${juzgado.id}}
					,{id:'JuzgadosRT${juzgado.id}'}
				)
	};
	<pfs:defineParameters name="plazaParams" paramId="${juzgado.plaza.id}" />
	
	<pfs:buttonedit flow="plugin.plazasJuzgados.editarPlaza" name="btEditarPlaza" 
		windowTitleKey="plugin.plazasJuzgados.consultaPlaza.modificar" parameters="plazaParams" windowTitle="**Modificar"
		on_success="recargar"/>
		
	<pfs:panel name="panelPlaza" columns="2" collapsible="true" bbar="btEditarPlaza" title="**Plaza" titleKey="plugin.plazasJuzgados.consultaPlaza.plaza">
		<pfs:items items="descripcion,descripcionLarga"  />
		<pfs:items items="codigo" />
	</pfs:panel>
	
	
	btEditarPlaza.hide();
	<sec:authorize ifAllGranted="ROLE_EDITPLAZA">
		btEditarPlaza.show();
	</sec:authorize>
	
	<pfsforms:textfield name="descripcionJuzgado"
			labelKey="plugin.plazasJuzgados.altaPlaza.descripcion" label="**Descripción"
			value="${juzgado.descripcion}" readOnly="true" />
	
	<pfsforms:textfield name="descripcionLargaJuzgado"
			labelKey="plugin.plazasJuzgados.altaPlaza.descripcionLarga" label="**Descripción larga"
			value="${juzgado.descripcionLarga}" readOnly="true" />
	
	<pfsforms:textfield name="codigoJuzgado"
			labelKey="plugin.plazasJuzgados.altaPlaza.codigo" label="**Código"
			value="${juzgado.codigo}" readOnly="true" />
	
	<pfsforms:textfield name="plazaJuzgado"
			labelKey="plugin.plazasJuzgados.consultaPlaza.plaza" label="**Plaza"
			value="${juzgado.plaza.descripcion}" readOnly="true" />
	
	 
	<pfs:defineParameters name="juzgadoParams" paramId="${juzgado.id}" />
	
	<pfs:buttonedit flow="plugin.plazasJuzgados.editarJuzgado" name="btEditarJuzgado" 
		windowTitleKey="plugin.plazasJuzgados.consultaPlaza.modificar" parameters="juzgadoParams" windowTitle="**Modificar"
		on_success="recargar"/>
		
	<pfs:panel name="panelJuzgado" columns="2" collapsible="true" bbar="btEditarJuzgado" 
		title="**Juzgado" titleKey="plugin.plazasJuzgados.consultaPlaza.juzgado">
		<pfs:items items="descripcionJuzgado,descripcionLargaJuzgado"  />
		<pfs:items items="codigoJuzgado,plazaJuzgado" />
	</pfs:panel>
	
	
	btEditarJuzgado.hide();
	<sec:authorize ifAllGranted="ROLE_EDITJUZGADO">
		btEditarJuzgado.show();
	</sec:authorize>
	
	var compuesto = new Ext.Panel({
	    items : [
	    		{items:[panelPlaza],border:false,style:'margin-top: 7px; margin-left:5px'}
	    		,{items:[panelJuzgado],border:false,style:'margin-top: 7px; margin-left:5px'}
	    	]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
	page.add(compuesto);
	

</fwk:page>
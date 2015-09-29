<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>



<fwk:page>

	<pfsforms:textfield name="nombre" labelKey="plugin.arquetipos.modelo.nombre" label="**Nombre" value="${arquetipo.nombre}" readOnly="true"/>
	<pfsforms:textfield name="paquete" labelKey="plugin.arquetipos.consulta.paquetes" label="**Paquete Asociado" value="${arquetipo.rule.name}" readOnly="true"/>
	<pfsforms:textfield name="gestion" labelKey="plugin.arquetipos.listado.gestion" label="**Gestión" value="${arquetipo.gestion}" readOnly="true"/>
	<pfsforms:textfield name="plazoDisparo" labelKey="plugin.arquetipos.listado.plazoDisparo" label="**Plazo de disparo" value="${arquetipo.plazoDisparo}" readOnly="true"/>
	<pfsforms:textfield name="tipoSalto" labelKey="plugin.arquetipos.listado.tipoSaltoNivel" label="**Tipo de salto" value="${arquetipo.tipoSaltoNivel.descripcion}" readOnly="true"/>
	
	<pfs:hidden name="idArquetipo" value="${arquetipo.id}"/>
	<pfs:defineParameters name="parametros" paramId="${arquetipo.id}" idArquetipo="idArquetipo"/>

	var recargar = function (){
		app.openTab('${arquetipo.nombre}'
					,'arquetipos/ARQconsultaArquetipo'
					,{id:${arquetipo.id}}
					,{id:'ArquetipoRT'+${arquetipo.id}
					,iconCls:'icon_arquetipo'});	
	};
	
	


	<pfs:buttonedit flow="arquetipos/ARQeditarArquetipo" name="btEditar" windowTitleKey="plugin.arquetipos.busqueda.modificar" parameters="parametros" windowTitle="**Modificar" on_success="recargar"/>
	
	<pfs:panel name="panel1" columns="2" collapsible="false" bbar="btEditar">
		<pfs:items items="nombre, paquete, gestion " width="300" />
		<pfs:items items="plazoDisparo, tipoSalto" width="300"/>
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
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
		app.openTab('${instruccion.tareaProcedimiento.descripcion}'
					,'plugin.instruccionesExterna.consultarInstruccionTarea'
					,{id:${instruccion.id}}
					,{id:'InstruccionesTareasRT${instruccion.id}'}
				)
	}; 
	
	<pfsforms:textfield name="tipoProcedimiento" 
		labelKey="plugin.instruccionesExterna.editar.procedimiento" 
		label="**Tipo de Procedimiento" 
		value="${instruccion.tareaProcedimiento.tipoProcedimiento.descripcion}"
		readOnly="true"
		width="700"/>
	
	<pfsforms:textfield name="tareaProcedimiento" 
		labelKey="plugin.instruccionesExterna.editar.tarea" 
		label="**Tarea" 
		value="${instruccion.tareaProcedimiento.descripcion}"
		readOnly="true"
		width="700"/>
	
	Ext.QuickTips.init();
	
	var instruccionEdit = new Ext.form.HtmlEditor({
		fieldLabel : '<s:message code='plugin.instruccionesExterna.edtiar.instrucciones' text='**Instrucciones' />',
    	hideLabel:true,
    	labelSeparator:'',
    	readOnlu:true
    	,hideParent:true
		,enableColors: false
       	,enableAlignments: false
       	,enableFont:false
       	,enableFontSize:false
       	,enableFormat:false
       	,enableLinks:false
       	,enableLists:false
       	,enableSourceEdit:false
    	,width: 500,
    	height: 300,
    	value:'<s:message text="${instruccion.label}" javaScriptEscape="true" />'
	});
	 
	
	 
	<pfs:hidden name="idInstruccion" value="${instruccion.id}"/>
	<pfs:defineParameters name="parametros" paramId="${instruccion.id}" idPlazo="idInstruccion"/>
	<pfs:buttonedit flow="plugin.instruccionesExterna.editarInstrucciones" 
		name="btEditar" 
		windowTitleKey="plugin.instruccionesExterna.busqueda.modificar" 
		parameters="parametros" 
		windowTitle="**Modificar"
		on_success="recargar"
		/>
		
	
	<pfs:panel name="panel1" columns="1" collapsible="false" bbar="btEditar" >
		<pfs:items items="tipoProcedimiento,tareaProcedimiento,instruccionEdit" />
	</pfs:panel>
	btEditar.hide()
	<sec:authorize ifAllGranted="ROLE_EDITINSTRUCCIONESEXT">
		btEditar.show();
	</sec:authorize>
	
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
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
	<%--
	var instruccionEdit = new Ext.Panel({
    	title: 'HTML Editor',
    	id:'instruccionEdit',
   	 	width: 600,
    	height: 300,
    	frame: true,
    	layout: 'fit',
    	items: {
        	xtype: 'htmleditor',
        	enableColors: false,
        	enableAlignments: false,
        	value:'${instruccion.label}',
        	name:'instruccionEdit'
    	}
	});
	instruccionEdit.setValue('${instruccion.label}');
	var consulta = encodeURIComponent(valorInstruccionEdit); 
	var valorInstruccionEdit = Ext.getCmp('instruccionEdit').getValue(); --%>
	var instruccionEdit = new Ext.form.HtmlEditor({
		fieldLabel : '<s:message code='plugin.instruccionesExterna.edtiar.instrucciones' text='**Instrucciones' />',
    	hideLabel:true,
    	labelSeparator:'',
    	width: 500,
    	height: 300,
    	value:'<s:message text="${instruccion.label}" javaScriptEscape="true" />'
	});
	 
	  
		
	<pfs:defineParameters name="parametros" paramId="${instruccion.id}"
		label="instruccionEdit"
		/>
		
	<pfs:editForm saveOrUpdateFlow="plugin.instruccionesExterna.guardaInstrucciones"
				leftColumFields="tipoProcedimiento,tareaProcedimiento,instruccionEdit"
				parameters="parametros" 
			/>

</fwk:page>
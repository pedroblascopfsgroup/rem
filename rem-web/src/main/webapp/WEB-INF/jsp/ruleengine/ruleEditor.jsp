<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>


	var jsonrule = app.crearTextArea('json rule', '',false,'','ruleDefinition',{width:400, height:200});
	var results = app.crearTextArea('result', '',false,'','ruleDefinition',{width:400, height:200});
	 
	var ruleId = app.creaText( 'ruleId','ruleId','');
	var name = app.creaText('name','name','');

	var boton = new Ext.Button({
			text : 'enviar',
			handler : function(){
				page.webflow({
					flow : 'ruleengine/ruleExecute'
					,formPanel : panelRule
					,params : {ruleDefinition : jsonrule.getValue(), value:1}
					,success : function(data){
						results.setValue("rowsAffected="+data.rowsModified);
					} 
					});
			}
	});

	var panelRule = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:5px'
		,border : false
		,items : [jsonrule]
	});

	var panel = new Ext.Panel({
		bodyStyle : 'padding : 5px'
		,autoHeight : true
		,items : [ panelRule , results ]
		,bbar : [boton]
		,id:'cli-'+'${persona.id}' 
	});
	
	page.add(panel);
	
	
	
</fwk:page>
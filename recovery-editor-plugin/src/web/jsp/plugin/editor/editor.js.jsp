<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


Ext.onReady( function(){
        Ext.QuickTips.init();
		
        canvas = new Canvas();
		debug = new Debug();
        
        
       <%--@ include file="TODO/oficinas.js" --%>
       
        var oficinas =   <%@ include file="TODO/oficinas.js" %>;
        
        <%--@ include file="TODO/editors.js" --%>
        <%--{type : 'genericEditor',titulo:"Generico", ruleid:0, tab : 'Generico'}  --%>
        
        var editors = <json:array name="tareas" items="${data}" var="rule">
						<json:object>
								<json:property name="type" value="${rule.type}Editor"/>
								<json:property name="titulo" value="${rule.title}"/>
								<json:property name="ruleid" value="${rule.id}"/>
								<json:property name="tab" value="${rule.tab}"/>
								<json:array name="values" items="${rule.values}" var="value">
									<json:object>
										<json:property name="id" value="${value.id}"/>
										<json:property name="desc" value="${value.descripcion}"/>
									</json:object>		
								</json:array>
						</json:object>
					</json:array>;

        
        editor =    new Editor(editors);

        var viewport = new Ext.Viewport({
            layout : 'border'
            ,items : [ new Ext.BoxComponent({
                region : 'north'
                ,el : 'header'
                ,height : 2
                })
                ,editor
                ,canvas
		,debug
            ]
        });

        canvas.ready();
        canvas.initHandlers();
        var idReglaSeleccionada = '${id}';
       
        if (idReglaSeleccionada !=''){ 
        	Ext.Ajax.request({
    		 						url : '/pfs/editor/loadRule.htm'
    		 						,params : {id : idReglaSeleccionada}
    		 						,success : function(response){
    		 							var datos = Ext.decode(response.responseText);
    		 							canvas.setXML(datos.xml);		
    		 							canvas.setArquetipo(datos.id, datos.name, datos.nameLong);
    		 							var editable = datos.editable;
    									if (!editable){
    										canvas.disableTopToolbar(true,editable);
    									} else {
    										canvas.disableTopToolbar(false,editable);
    									}
    		 						}
    							});	
    	}						

        canvas.on('conditionSelected', editor.editCondition, editor);
        editor.on('setCondition', canvas.setCondition, canvas);
});


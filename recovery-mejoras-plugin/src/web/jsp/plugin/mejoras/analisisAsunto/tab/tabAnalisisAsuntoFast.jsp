<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


(function(page,entidad){

 	var observaciones = new Ext.form.HtmlEditor({
    	hideParent:true
		,enableColors: false
       	,enableAlignments: false
       	,enableFont:false
       	,enableFontSize:false
       	,enableFormat:false
       	,enableLinks:false
       	,enableLists:false
       	,enableSourceEdit:false
       	,fieldLabel:'<s:message code="plugin.mejoras.analisisAsunto.observaciones" text="**Observaciones" />'
       	,hideLabel:true
       	,height:550
       	,readOnly:true
 	});
	
	var btModificar = new Ext.Button({
		text : '<s:message code="pfs.tags.buttonedit.modificar" text="**Modificar" />'
		,iconCls : 'icon_edit'
		,handler : 	function() {
			var allowClose= false;
			var w= app.openWindow({
				flow: 'plugin.mejoras.analisisAsunto.updateAnalisis'
				,closable: allowClose
				,title : '<s:message code="plugin.mejoras.analisisAsunto.updateAnalisis.window.title" text="**Modificar observaciones" />'
				,params: {id: panel.getAsuntoId()}
			});
			w.on(app.event.DONE, function(){
				w.close();
				recargar();
			});
			w.on(app.event.CANCEL, function(){
				 w.close(); 
			});
		}	
	});
	
	var recargar = function(){		
		Ext.Ajax.request({
			url: page.resolveUrl('plugin.mejoras.analisisAsunto.getAnalisis')
			,params: {id: panel.getAsuntoId()}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				observaciones.setValue(Ext.util.Format.htmlDecode(r.analisis.observacion));
			}
		}
	)};

    var panel = new Ext.Panel({
        title:'<s:message code="plugin.mejoras.analisisAsunto.titulo" text="**Analisis"/>'
        ,bodyStyle:'padding:10px'   
        ,items:[{layout: 'form',items: [observaciones], border: false}]
        ,autoHeight:true
        ,autoWidth:true
        <sec:authorize ifNotGranted="SOLO_CONSULTA">
        ,bbar: [btModificar]
        </sec:authorize>
    });
   
    observaciones.setWidth(1200);
    
    panel.getAsuntoId = function(){
		return entidad.get("data").id;
	}
	
	panel.setValue = function(){
		recargar();
	}
	
	panel.getValue = function(){
	}

	return panel;
 	
})
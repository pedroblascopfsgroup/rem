<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
new Ext.Button({
	text:'<s:message code="app.ayuda" text="**Ayuda" />'
	,iconCls:'icon_ayuda'
	,handler:function(){
	
		var _url = '/${appProperties.appName}/ayuda/html.htm?item=analisis_mapa_global';
	 	var win = new Ext.Window({
         	width:750
        	,id:'autoload-win'
        	,height:590
        	,bodyStyle:'padding:10px; background-color:#ffffff'
        	,autoScroll:true
        	,autoLoad:{
	            url:_url
        	}
        	,title:'<s:message code="app.ayuda.mapaGlobal" text="**Ayuda mapa global" />'
        	<%--,tbar:[{
             	text:'Reload'
            	,handler:function() {
	                win.load(win.autoLoad.url + '?' + (new Date).getTime());
            	}
        	}] --%>
        	,listeners:{show:function() {
	            this.loadMask = new Ext.LoadMask(this.body, {
                	msg:'<s:message code="app.ayuda.wait" text="**Espere" />'
            	});
        	}}
    	});
    	win.show();
	
		<%--var w= app.openWindow({
								flow: 'ayuda/mostrar'
								,closable: true
								,width : 750
								,title : '<s:message code="app.ayuda.generica" text="**Ayuda gen�rica de Recovery" />'
								,params: {item:'generica'}
					});--%>
	}	
})
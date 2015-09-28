<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="flow" required="true" type="java.lang.String"%>
<%@ attribute name="datagrid" required="true" type="java.lang.String"%>
<%@ attribute name="paramId" required="true" type="java.lang.String"%>
<%@ attribute name="novalueMsgKey" required="true" type="java.lang.String"%>
<%@ attribute name="novalueMsg" required="true" type="java.lang.String"%>
<%@ attribute name="parameters" required="false" type="java.lang.String"%>
<%@ attribute name="onSuccess" required="false" type="java.lang.String"%>

var ${name}= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,handler : function(){
			if (${datagrid}.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					<c:if test="${parameters != null}">var parms = ${parameters}();</c:if>
    					<c:if test="${parameters == null}">var parms = {};</c:if>
    					parms.${paramId} = ${datagrid}.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: '${flow}'
							,params: parms
							,success : function(){ 
								${datagrid}.store.webflow(parms);
								<c:if test="${onSuccess != null}">${onSuccess}();</c:if>
							}
						});
    				}
				});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="${novalueMsgKey}" text="${novalueMsg}" />');
			}
		}
});

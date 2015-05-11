<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ tag body-content="scriptless"%>
<%@ tag dynamic-attributes="dynattrs" %>
<%@ tag import="java.util.*" %>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="columns" required="true" type="java.lang.Integer"%>
<%@ attribute name="collapsible" required="true" type="java.lang.Boolean"%>

<%@ attribute name="title" required="false" type="java.lang.String"%>
<%@ attribute name="titleKey" required="false" type="java.lang.String"%>
<%@ attribute name="tbar" required="false" type="java.lang.String"%>
<%@ attribute name="bbar" required="false" type="java.lang.String"%>
<%@ attribute name="autoexpand" required="false" type="java.lang.String"%>
<%@ attribute name="hideBorder" required="false" type="java.lang.Boolean"%>


var ${name} = new Ext.Panel({
		layout:'table'
		<c:if test="${(titleKey != null) || (title != null)}">,title : '<s:message code="${titleKey}" text="${title}" />'</c:if>
		,collapsible : ${collapsible}
		,titleCollapse : ${collapsible}
		,layoutConfig : {
			columns:${columns + 1}
		}
		//,autoWidth:true
		,style:'margin-right:20px;margin-left:10px'
		<c:if test="${hideBorder}">,border:false</c:if><c:if test="${!hideBorder}">,bodyStyle:'padding:5px;cellspacing:20px;padding-bottom: 0px;'</c:if>
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{width:'0px'}
			<jsp:doBody />
		]
		<c:if test="${tbar != null}">
		,tbar : [${tbar}]
		</c:if>
		<c:if test="${bbar != null}">
		,bbar : [${bbar}]
		</c:if>
		<c:if test="${autoexpand != null}">
		,listeners:{	
			beforeExpand:function(){
				${autoexpand}.collapse(true);
				${autoexpand}.setHeight(200);				
			}
			,beforeCollapse:function(){
				${autoexpand}.expand(true);
				${autoexpand}.setHeight(475);
			}
		}
		</c:if>
	});
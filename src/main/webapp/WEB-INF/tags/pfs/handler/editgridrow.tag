<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="titleField" required="true" type="java.lang.String"%>
<%@ attribute name="flow" required="true" type="java.lang.String"%>
<%@ attribute name="paramId" required="true" type="java.lang.String"%>
<%@ attribute name="tabId" required="true" type="java.lang.String"%>
<%@ attribute name="iconCls" required="false" type="java.lang.String"%>


var ${name} = function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var title=rec.get('${titleField}');
		var id=rec.get('id');
		app.openTab(title, '${flow}', {${paramId} : id}, {id:'${tabId}'+id<c:if test="${iconCls != null}">,iconCls:'${iconCls}'</c:if>} );
    };
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="source" required="true" type="java.lang.String"%>
<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="value" required="false" type="java.lang.String"%>

	var theRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsStore = page.getStore({
       flow: 'generico/genericData'
       ,reader: new Ext.data.JsonReader({
    	 root : 'diccionario'
    	}
    	, theRecord)
	});
	
	var ${name} = new Ext.form.ComboBox({
		store:optionsStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,triggerAction: 'all'
		,local:false
		,fieldLabel : "<s:message code="${label}"/>"
		<c:if test="${value!=null}">
			,value="${value}"
		</c:if>
	});
	
	optionsStore.webflow({origen:'${source}'});

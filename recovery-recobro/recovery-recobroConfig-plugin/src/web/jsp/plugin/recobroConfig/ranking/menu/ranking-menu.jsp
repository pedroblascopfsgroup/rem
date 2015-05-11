<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.recobroConfig.ranking.menu" text="**Modelos de ranking" />' 
		,iconCls : 'icon_ranking'	
		,handler : function(){
			app.openTab("<s:message code="plugin.recobroConfig.ranking.menu" text="**Modelos de ranking"/>", 
			"recobromodeloderanking/openABMModeloRanking",
			{},
			{id:'plugin-recobroConfig-ranking-abm',iconCls : 'icon_ranking'});
		}
		
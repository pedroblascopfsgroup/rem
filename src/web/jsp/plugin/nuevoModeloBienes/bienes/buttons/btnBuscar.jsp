<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
app.crearBotonBuscar({
		handler : function(){
			panelFiltros.collapse(true);				
				var params= getParametros();
        		params.start=0;
        		params.limit=limit;
				bienesStore.webflow(params);
				pagingBar.show();
	}
})



		
		
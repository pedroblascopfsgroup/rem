<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text : 'Recovery-BI' 
	,handler : function(){
		var accesoBIHaya = false;
		var accesoBI = false;
		<sec:authorize ifAllGranted="ROLE_RECOVERY_BI_HAYA">
			accesoBIHaya = true;
		</sec:authorize>
		<sec:authorize ifAllGranted="ROLE_RECOVERY_BI">
			accesoBI = true;
		</sec:authorize>

		cartera = "";
		if (document.getElementById('comboEntidad') != null) {
			cartera = document.getElementById('comboEntidad').value;
		}
		if (cartera != "" && (accesoBIHaya || accesoBI)) {
		   openRecBIHayaMulti(cartera);
		} else {
			if(accesoBIHaya) {
				openRecBIHaya();
			}else if(accesoBI){
				openRecBI();
			}
		}
	}
	
	<sec:authorize ifNotGranted="ROLE_RECOVERY_BI, ROLE_RECOVERY_BI_HAYA">
		,hidden:true
	</sec:authorize>	

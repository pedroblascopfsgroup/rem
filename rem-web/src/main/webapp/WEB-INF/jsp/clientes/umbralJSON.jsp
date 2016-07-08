<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:object name="data" >
		<json:property name="persona.importeUmbral" value="${personaUmbral.importeUmbral}" />
		<json:property name="persona.fechaUmbral">
			<fwk:date value="${personaUmbral.fechaUmbral}" />
		</json:property>
		<json:property name="persona.comentarioUmbral" value="${personaUmbral.comentarioUmbral}" />
	</json:object>
</fwk:json>

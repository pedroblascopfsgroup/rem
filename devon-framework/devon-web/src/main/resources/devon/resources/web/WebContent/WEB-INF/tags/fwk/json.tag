<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ tag body-content="scriptless" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<json:object>
	<jsp:doBody />
	<json:object name="fwk">
		<c:if test="${fwk.fwkUserExceptions!=null}">
			<json:array name="fwkUserExceptions" items="${fwk.fwkUserExceptions}"/> 
		</c:if>
		<c:if test="${fwk.fwkExceptions!=null}">
			<json:array name="fwkExceptions" items="${fwk.fwkExceptions}"/>
		</c:if>
		<c:if test="${uuid!=null}">
			<json:array name="uuid" items="${fwk.uuid}"/>
		</c:if>
		<c:if test="${flowExecutionKey!=null}">
			<json:property name="flowExecutionKey" value="${fwk.flowExecutionKey}"/>
		</c:if>
		<c:if test="${fwk.events!=null}">
			<json:array name="events" items="${fwk.events}" var="event">
				<json:object>
					<json:property name="type" value="${event.type}" />
					<c:if test="${event.params!=null}" >
						<json:property name="params">
							<c:forEach var="param" items="${event.params}">
								<json:property name="${param.key}" value="${param.value}" />
							</c:forEach>
						</json:property>
					</c:if>			
				</json:object>
			</json:array>
		</c:if>
	</json:object>
	<json:property name="success" value="${fwk.success}" />
	<c:if test="${errors!=null}">
		<json:object name="errors">
			<c:forEach var="e" items="${errors}">
				<json:property name="${e.key}" value="${e.value}" />
			</c:forEach>
		</json:object>
	</c:if>
</json:object>
<%
//eliminamos la excepción de la request puesto que ya ha sido tratada. Si no, el tomcat la tratará de manejar
request.removeAttribute("javax.servlet.error.exception");
%>

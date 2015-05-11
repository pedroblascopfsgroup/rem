<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<fwk:json>

	<%--   Input result: es.capgemini.pfs.dynamicDto.DtoDynamicRow     --%>

	<%--  Array data:     datos                       --%>
	<%--  Array metaData: definición del recordset    --%>
	<%--  Array columns:  definición del ColumnModel  --%>

	<%--   http://extjs.com/forum/showthread.php?t=30268   --%>


	<json:array name="data" items="${result.rows}" var="row">
		<json:object>
			<c:forEach items="${row.cells}" var="cell">
				<json:property name="${cell.name}" value="${cell.value}" />
			</c:forEach>
			<c:if test="${result.tieneSubdata}">
				<json:array name="subdata" items="${row.subdata}" var="subdata">
					<json:object>
						<c:forEach items="${subdata.cells}" var="subcell">
							<json:property name="${subcell.processedName}" value="${subcell.processedValue}" />
						</c:forEach>
					</json:object>
				</json:array>
			</c:if>
		</json:object>
	</json:array>


	<json:object name="metaData">
		<json:property name="root" value="data" />
		<json:array name="fields">
			<c:forEach items="${result.metadata}" var="field">
				<json:object>
					<json:property name="name" value="${field.name}" />
				</json:object>
			</c:forEach>
			<c:if test="${result.tieneSubdata}">
				<json:object>
					<json:property name="name" value="subdata" />
				</json:object>
			</c:if>
		</json:array>
	</json:object>

	<json:array name="columns">
		<c:forEach items="${result.metadata}" var="column">
			<json:object>
				<json:property name="dataIndex" value="${column.name}" />
				<json:property name="header" escapeXml="false">
					${column.header}
				</json:property>
			</json:object>
		</c:forEach>
	</json:array>

</fwk:json>

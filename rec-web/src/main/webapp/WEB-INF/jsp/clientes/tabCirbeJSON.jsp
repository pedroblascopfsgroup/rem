<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fwk:json>

	<%--  Array data:     datos                       --%>
	<%--  Array metaData: definición del recordset    --%>
	<%--  Array columns:  definición del ColumnModel  --%>


	<json:array name="data" items="${result.rows}" var="dto">
		<json:object>
			<json:property name="tipoOperacion" escapeXml="false">
				<c:if test="${dto.subTotalizador}">
					<span style="font-weight:bolder;">
						<s:message code="cirbe.subtotal" text="**SUBTOTAL" />
					</span>
				</c:if>
				<c:if test="${!dto.subTotalizador}">
					${dto.codigoOperacion.descripcion}
				</c:if>
			</json:property>
			<json:property name="vencimiento" escapeXml="false">
				<c:if test="${dto.totalizador}">
					<span style="font-weight:bolder;">
				</c:if>
					${dto.tipoVencimiento.descripcion}
				<c:if test="${dto.totalizador}">
					</span>
				</c:if>
			</json:property>
			<json:property name="garantia" escapeXml="false">
				<c:if test="${dto.totalizador}">
					<span style="font-weight:bolder;">
				</c:if>
					${dto.tipoGarantia.descripcion}
				<c:if test="${dto.totalizador}">
					</span>
				</c:if>
			</json:property>
			<json:property name="situacion" escapeXml="false">
				<c:if test="${dto.totalizador}">
					<span style="font-weight:bolder;">
				</c:if>
					${dto.tipoSituacion.descripcion}
				<c:if test="${dto.totalizador}">
					</span>
				</c:if>
			</json:property>
			<json:property name="dispuesto1"		value="${dto.dispuestoFecha1}" />
			<json:property name="disponible1"		value="${dto.disponibleFecha1}" />
			<c:if test="${result.fecha2!=null && result.fecha2!=result.fecha1}">
				<json:property name="dispuesto2"	value="${dto.dispuestoFecha2}" />
				<json:property name="disponible2"	value="${dto.disponibleFecha2}" />
			</c:if>
			<c:if test="${result.fecha3!=null && result.fecha3!=result.fecha2}">
				<json:property name="dispuesto3"	value="${dto.dispuestoFecha3}" />
				<json:property name="disponible3"	value="${dto.disponibleFecha3}" />
			</c:if>
			<c:if test="${dto.subTotalizador}">
				<json:property name="rowbody" escapeXml="false">
					<span style="font-weight:bolder;">&nbsp;&nbsp;&nbsp;${dto.codigoOperacion.descripcion}</span>
				</json:property>
			</c:if>
		</json:object>
	</json:array>


	<json:object name="metaData">

		<json:property name="root" value="data" />

		<json:array name="fields">
			<json:object>
				<json:property name="name" value="tipoOperacion" />
			</json:object>
			<json:object>
				<json:property name="name" value="vencimiento" />
			</json:object>
			<json:object>
				<json:property name="name" value="garantia" />
			</json:object>
			<json:object>
				<json:property name="name" value="situacion" />
			</json:object>
			<json:object>
				<json:property name="name" value="dispuesto1" />
			</json:object>
			<json:object>
				<json:property name="name" value="disponible1" />
			</json:object>
			<c:if test="${result.fecha2!=null && result.fecha2!=result.fecha1}">
				<json:object>
					<json:property name="name" value="dispuesto2" />
				</json:object>
				<json:object>
					<json:property name="name" value="disponible2" />
				</json:object>
			</c:if>
			<c:if test="${result.fecha3!=null && result.fecha3!=result.fecha2}">
				<json:object>
					<json:property name="name" value="dispuesto3" />
				</json:object>
				<json:object>
					<json:property name="name" value="disponible3" />
				</json:object>
			</c:if>
			<json:object>
				<json:property name="name" value="rowbody" />
			</json:object>
		</json:array>

	</json:object>


	<json:array name="columns">
		<json:object>
			<json:property name="header" escapeXml="false">
				<s:message code="cirbe.grid.tipoOperacion" text="**Tipo Operación" />
			</json:property>
			<json:property name="dataIndex" value="tipoOperacion" />
		</json:object>
		<json:object>
			<json:property name="header">
				<s:message code="cirbe.grid.vencimiento" text="**Vencimiento" />
			</json:property>
			<json:property name="dataIndex" value="vencimiento" />
		</json:object>
		<json:object>
			<json:property name="header">
				<s:message code="cirbe.grid.garantia" text="**Garantía" />
			</json:property>
			<json:property name="dataIndex" value="garantia" />
		</json:object>
		<json:object>
			<json:property name="header">
				<s:message code="cirbe.grid.situacion" text="**Situación" />
			</json:property>
			<json:property name="dataIndex" value="situacion" />
		</json:object>
		<json:object>
			<json:property name="header" escapeXml="false">
				<s:message code="cirbe.grid.dispuesto" text="**Dispuesto" /><br /><fmt:formatDate value="${result.fecha1}" pattern="dd/MM/yyyy"/>
			</json:property>
			<json:property name="dataIndex" value="dispuesto1" />
			<json:property name="renderer" value="moneyRenderer" />
			<json:property name="align" value="right" />
		</json:object>
		<json:object>
			<json:property name="header" escapeXml="false">
				<s:message code="cirbe.grid.disponible" text="**Disponible" /><br /><fmt:formatDate value="${result.fecha1}" pattern="dd/MM/yyyy"/>
			</json:property>
			<json:property name="dataIndex" value="disponible1" />
			<json:property name="renderer" value="moneyRenderer" />
			<json:property name="align" value="right" />
		</json:object>
		<c:if test="${result.fecha2!=null && result.fecha2!=result.fecha1}">
			<json:object>
				<json:property name="header" escapeXml="false">
					<s:message code="cirbe.grid.dispuesto" text="**Dispuesto" /><br /><fmt:formatDate value="${result.fecha2}" pattern="dd/MM/yyyy"/>
				</json:property>
				<json:property name="dataIndex" value="dispuesto2" />
				<json:property name="renderer" value="moneyRenderer" />
				<json:property name="align" value="right" />
			</json:object>
			<json:object>
				<json:property name="header" escapeXml="false">
					<s:message code="cirbe.grid.disponible" text="**Disponible" /><br /><fmt:formatDate value="${result.fecha2}" pattern="dd/MM/yyyy"/>
				</json:property>
				<json:property name="dataIndex" value="disponible2" />
				<json:property name="renderer" value="moneyRenderer" />
				<json:property name="align" value="right" />
			</json:object>
		</c:if>
		<c:if test="${result.fecha3!=null && result.fecha3!=result.fecha2}">
			<json:object>
				<json:property name="header" escapeXml="false">
					<s:message code="cirbe.grid.dispuesto" text="**Dispuesto" /><br /><fmt:formatDate value="${result.fecha3}" pattern="dd/MM/yyyy"/>
				</json:property>
				<json:property name="dataIndex" value="dispuesto3" />
				<json:property name="renderer" value="moneyRenderer" />
				<json:property name="align" value="right" />
			</json:object>
			<json:object>
				<json:property name="header" escapeXml="false">
					<s:message code="cirbe.grid.disponible" text="**Disponible" /><br /><fmt:formatDate value="${result.fecha3}" pattern="dd/MM/yyyy"/>
				</json:property>
				<json:property name="dataIndex" value="disponible3" />
				<json:property name="renderer" value="moneyRenderer" />
				<json:property name="align" value="right" />
			</json:object>
		</c:if>
	</json:array>

</fwk:json>

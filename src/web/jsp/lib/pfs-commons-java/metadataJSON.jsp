<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>

<fwk:json>
	<json:object name="metaData">
		<json:array name="fields" items="${metadataDto.fields}" var="f">
			<json:object>
				<json:property name="name" value="${f.name}" />
				<json:property name="fieldLabel">
					<s:message code="${f.fieldLabelCode}" text="${f.fieldLabel}" />
				</json:property>
				<c:if test="${f.editor != null}">
					<json:object name="editor">
						<c:if test="${f.editor.xtype != null}"><json:property name="xtype" value="${f.editor.xtype}" /></c:if>
						<c:if test="${f.editor.allowBlank != null}"><json:property name="allowBlank" value="${f.editor.allowBlank == 'true'}" /></c:if>
						<c:if test="${f.editor.format != null}"><json:property name="format" value="${f.editor.format}" /></c:if>
						<c:if test="${f.editor.width != null}"><json:property name="width" value="${f.editor.width}" /></c:if>
						<c:if test="${f.editor.data != null}">
							<json:array name="data" items="${metadataDto.dictionary[f.editor.data]}" var="d">
								<json:object>
									<json:property name="codigo" value="${d.codigo}" />
									<json:property name="descripcion" value="${d.descripcion}" />
								</json:object>
							</json:array>
						</c:if>
					</json:object>
				</c:if>
			</json:object>
		</json:array>
		<c:if test="${metadataDto.topHtml != null}">
			<json:object name="topHtml" escapeXml="false">
				<json:property name="html" value="${metadataDto.topHtml.html}" />
				<json:property name="border" value="${metadataDto.topHtml.border}" />	
				<json:property name="style" value="${metadataDto.topHtml.style}" />
			</json:object>
		</c:if>
		<json:object name="formConfig">
			<json:property name="labelAlign" value="${metadataDto.formConfig.labelAlign}" />
			<json:property name="columnCount" value="${metadataDto.formConfig.columnCount}" />
			<json:property name="labelWidth" value="${metadataDto.formConfig.labelWidth}" />
			<json:property name="width" value="${metadataDto.formConfig.width}" />
			<json:property name="height" value="${metadataDto.formConfig.height}" />
			<json:property name="wtitle" value="${metadataDto.formConfig.title}" />
			<json:property name="readOnly" value="${metadataDto.formConfig.readOnly}" />
		</json:object>
	</json:object>
	<json:object name="data">
		<c:forEach var="d" items="${metadataDto.data}">
			<json:property name="${d.key}">
				<pfsformat:normalize value="${d.value}" />
			</json:property>
		</c:forEach>
	</json:object>


</fwk:json>
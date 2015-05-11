<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="expedientes" items="${pagina.results}" var="exp">
      <json:object>
         <json:property name="id" value="${exp.id}" />
         <json:property name="codigo" value="${exp.id}" />
         <json:property name="descripcion" value="${exp.descripcionExpediente}" />
         <json:property name="fecha"><fwk:date value="${exp.auditoria.fechaCrear}"/></json:property>             
         <json:property name="estado" value="${exp.estadoAsString}" />         
         <json:property name="vre" value="${exp.volumenRiesgoAbsoluto}" />
         <json:property name="oficina" value="${exp.oficina.nombre}" />
         <json:property name="asuntos" value="${exp.cantidadAsuntos}" />
         <json:property name="contratos" value="${exp.cantidadContratos}" />
         <json:property name="decidido" value="${exp.estaDecidido}" />
      </json:object>
   </json:array>
</fwk:json>

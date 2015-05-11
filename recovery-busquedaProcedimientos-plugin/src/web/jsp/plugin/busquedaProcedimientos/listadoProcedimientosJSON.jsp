<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
    <json:property name="total" value="${procedimientos.totalCount}" />
    <json:array name="procedimientos" items="${procedimientos.results}" var="proc">
        <json:object>
        	
        	<json:property name="id" value="${proc.id}" />
        	 <%--
        	<json:property name="codigoInterno" value="${proc.id}" />
        	<json:property name="estadoProcedimiento" value="${proc.estadoProcedimiento.descripcion}" />
        	<json:property name="asunto" value="${proc.asunto.nombre}" />
        	<json:property name="codigoProcedimientoEnJuzgado" value="${proc.codigoProcedimientoEnJuzgado}" />
        	<json:property name="tipoProcedimiento" value="${proc.tipoProcedimiento.descripcion}" />
        	<json:property name="juzgado" value="${proc.juzgado.descripcion}" />
        	 <json:property name="plaza" value="${proc.juzgado.plaza.descripcion}" />
        	 <json:property name="fechaCrear" >
            	<fwk:date value="${proc.auditoria.fechaCrear}"/>
            </json:property>
            <json:property name="despacho" value="${proc.asunto.gestor.despachoExterno.despacho}" />
        	<json:property name="gestor" value="${proc.asunto.gestor.usuario.apellidoNombre}" /> 
        	<json:property name="supervisor" value="${proc.asunto.supervisor.usuario.apellidoNombre}" />
        	<json:property name="saldoRecuperacion" value="${proc.saldoRecuperacion}" /> 
        	<json:property name="procedimientoPadre" value="${proc.procedimientoPadre.tipoProcedimiento.descripcion}" />
        	
        	
        	<json:object name="p">  
	        	<json:object name="asunto">        	
	        		<json:property name="nombre" value="${proc.asunto.nombre}" />
	        		  <json:object name="gestor">
		        		<json:object name="despachoExterno">
		        		     <json:property name="despacho" value="${proc.asunto.gestor.despachoExterno.despacho}" />
		        		</json:object>
	        		  </json:object>	        		
	        	 </json:object>
	        	<json:object name="tipoProcedimiento">        	
	        		<json:property name="descripcion" value="${proc.tipoProcedimiento.descripcion}" />
	        	</json:object>
	        	<json:object name="juzgado">        	
	        		<json:property name="descripcion" value="${proc.juzgado.descripcion}" />
	        		<json:object name="plaza">
	        			<json:property name="descripcion" value="${proc.juzgado.plaza.descripcion}" />
	        		</json:object>											        		
	        	</json:object>	        		        		        	 
        	</json:object>
        	
        	
        	  
        	 --%>
        	<json:property name="DD_EPR_ID" value="${proc.estadoProcedimiento.descripcion}" />        		                	          	
        	<json:property name="PRC_COD_PROC_EN_JUZGADO" value="${proc.codigoProcedimientoEnJuzgado}" />        	        	                	         	        	        	
        	<json:property name="DD_TPO_ID" value="${proc.tipoProcedimiento.descripcion}" />        	
        	<json:property name="DD_JUZ_ID" value="${proc.juzgado.descripcion}" />      	        
            <json:property name="DD_PLA_ID" value="${proc.juzgado.plaza.descripcion}" />
            <json:property name="DES_ID" value="${proc.asunto.gestor.despachoExterno.despacho}" />
            
            <json:object name="p">
                <json:object name="asunto">
        			<json:property name="nombre" value="${proc.asunto.nombre}" />
        		</json:object>
	            <json:object name="auditoria">
		            <json:property name="fechaCrear" >
		            	<fwk:date value="${proc.auditoria.fechaCrear}"/>
		            </json:property> 
		        </json:object>
	        </json:object>           
             
            <json:property name="PRC_ID" value="${proc.id}" />
            <json:property name="GAS_ID" value="${proc.asunto.gestor.usuario.apellidoNombre}" />
            <json:property name="SUP_ID" value="${proc.asunto.supervisor.usuario.apellidoNombre}" />
            <json:property name="PRC_SALDO_RECUPERACION" value="${proc.saldoRecuperacion}" />  
            <json:property name="PRC_PRC_ID" value="${proc.procedimientoPadre.tipoProcedimiento.descripcion}" />
              
        </json:object>
    </json:array>
</fwk:json> 


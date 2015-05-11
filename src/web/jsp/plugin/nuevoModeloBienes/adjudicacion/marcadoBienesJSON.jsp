<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="bienes" items="${bienes}" var="bie">
		<json:object>
			<json:property name="id" value="${bie.id}" />
			<json:property name="idBien" value="${bie.id}" />
			<json:property name="codigo" value="${bie.codigoInterno}" />
			<json:property name="numeroActivo" value="${bie.numeroActivo}" />
			<json:property name="origen" value="${bie.origen.descripcion}" />
			<json:property name="descripcion" value="${bie.descripcionBien}" />
			<json:property name="habitual" value="${bie.viviendaHabitual}" />
			<json:property name="idAdjudicacion" value="${bie.adjudicacion.idAdjudicacion}" />
			<json:property name="fechaDecretoNoFirme">
				<fwk:date value="${bie.adjudicacion.fechaDecretoNoFirme}" />
			</json:property>
			
			<json:property name="fechaDecretoFirme"> 
				<fwk:date value="${bie.adjudicacion.fechaDecretoFirme}" />
			</json:property>
			
			<json:property name="fechaEntregaGestor"> 
				<fwk:date value="${bie.adjudicacion.fechaEntregaGestor}" />
			</json:property>
			
			<json:property name="fechaPresentacionHacienda"> 
				<fwk:date value="${bie.adjudicacion.fechaPresentacionHacienda}" />
			</json:property>
			
			<json:property name="fechaSegundaPresentacion">
				<fwk:date value="${bie.adjudicacion.fechaSegundaPresentacion}" />
			</json:property>
			
			<json:property name="fechaRecepcionTitulo">
				<fwk:date value="${bie.adjudicacion.fechaRecepcionTitulo}" />
			</json:property>
			
			<json:property name="fechaInscripcionTitulo"> 
				<fwk:date value="${bie.adjudicacion.fechaInscripcionTitulo}" />
			</json:property>
			
			<json:property name="fechaEnvioAdicion"> 
				<fwk:date value="${bie.adjudicacion.fechaEnvioAdicion}" />
			</json:property>
			
			<json:property name="fechaPresentacionRegistro"> 
				<fwk:date value="${bie.adjudicacion.fechaPresentacionRegistro}" />
			</json:property>
			
			<json:property name="fechaSolicitudPosesion"> 
				<fwk:date value="${bie.adjudicacion.fechaSolicitudPosesion}" />
			</json:property>
			
			<json:property name="fechaSenalamientoPosesion"> 
				<fwk:date value="${bie.adjudicacion.fechaSenalamientoPosesion}" />
			</json:property>
			
			<json:property name="fechaRealizacionPosesion"> 
				<fwk:date value="${bie.adjudicacion.fechaRealizacionPosesion}" />
			</json:property>
			
			<json:property name="fechaSolicitudLanzamiento"> 
				<fwk:date value="${bie.adjudicacion.fechaSolicitudLanzamiento}" />
			</json:property>
			
			<json:property name="fechaSenalamientoLanzamiento" >
				<fwk:date value="${bie.adjudicacion.fechaSenalamientoLanzamiento}" />
			</json:property>
			
			<json:property name="fechaRealizacionLanzamiento"> 
				<fwk:date value="${bie.adjudicacion.fechaRealizacionLanzamiento}" />
			</json:property>
			
			<json:property name="fechaSolicitudMoratoria" >
				<fwk:date value="${bie.adjudicacion.fechaSolicitudMoratoria}" />
			</json:property>
			
			<json:property name="fechaResolucionMoratoria" >
				<fwk:date value="${bie.adjudicacion.fechaResolucionMoratoria}" />
			</json:property>
			
			<json:property name="fechaContratoArrendamiento" >
				<fwk:date value="${bie.adjudicacion.fechaContratoArrendamiento}" />
			</json:property>
			
			<json:property name="fechaCambioCerradura" >
				<fwk:date value="${bie.adjudicacion.fechaCambioCerradura}" />
			</json:property>
			
			<json:property name="fechaEnvioLLaves" >
				<fwk:date value="${bie.adjudicacion.fechaEnvioLLaves}" />
			</json:property>
			
			<json:property name="fechaRecepcionDepositario"> 
				<fwk:date value="${bie.adjudicacion.fechaRecepcionDepositario}" />
			</json:property>
			
			<json:property name="fechaEnvioDepositario"> 
				<fwk:date value="${bie.adjudicacion.fechaEnvioDepositario}" />
			</json:property>
			
			<json:property name="fechaRecepcionDepositarioFinal"> 
				<fwk:date value="${bie.adjudicacion.fechaRecepcionDepositarioFinal}" />
			</json:property>
			
			<json:property name="ocupado" value="${bie.adjudicacion.ocupado}" />
			<json:property name="posiblePosesion"
				value="${bie.adjudicacion.posiblePosesion}" />
			<json:property name="ocupantesDiligencia"
				value="${bie.adjudicacion.ocupantesDiligencia}" />
			<json:property name="lanzamientoNecesario"
				value="${bie.adjudicacion.lanzamientoNecesario}" />
			<json:property name="entregaVoluntaria"
				value="${bie.adjudicacion.entregaVoluntaria}" />
			<json:property name="necesariaFuerzaPublica"
				value="${bie.adjudicacion.necesariaFuerzaPublica}" />
			<json:property name="existeInquilino"
				value="${bie.adjudicacion.existeInquilino}" />
			<json:property name="llavesNecesarias"
				value="${bie.adjudicacion.llavesNecesarias}" />
			<c:if test="${bie.adjudicacion.gestoriaAdjudicataria != null}">
				<json:property name="gestoriaAdjudicataria"
					value="${bie.adjudicacion.gestoriaAdjudicataria.id}" />
			</c:if>	
			<json:property name="nombreArrendatario"
				value="${bie.adjudicacion.nombreArrendatario}" />
			<json:property name="nombreDepositario"
				value="${bie.adjudicacion.nombreDepositario}" />
			<json:property name="nombreDepositarioFinal"
				value="${bie.adjudicacion.nombreDepositarioFinal}" />
			<c:if test="${bie.adjudicacion.fondo != null}">
				<json:property name="fondo"
					value="${bie.adjudicacion.fondo.descripcion}" />
			</c:if>
			<c:if test="${bie.adjudicacion.entidadAdjudicataria != null}">
				<json:property name="entidadAdjudicataria"
					value="${bie.adjudicacion.entidadAdjudicataria.descripcion}" />
			</c:if>
			<c:if test="${bie.adjudicacion.situacionTitulo != null}">
				<json:property name="situacionTitulo"
					value="${bie.adjudicacion.situacionTitulo.descripcion}" />
			</c:if>
			<c:if test="${bie.adjudicacion.resolucionMoratoria != null}">
				<json:property name="resolucionMoratoria"
					value="${bie.adjudicacion.resolucionMoratoria.descripcion}" />
			</c:if>
			<json:property name="fechaRevisarPropuestaCancelacion"> 
				 <fwk:date value="${bie.adjudicacion.fechaRevisarPropuestaCancelacion}"/>
			</json:property>
			<json:property name="fechaPropuestaCancelacion"> 
				 <fwk:date value="${bie.adjudicacion.fechaPropuestaCancelacion}"/>
			</json:property>
			<json:property name="fechaRevisarCargas"> 
				 <fwk:date value="${bie.adjudicacion.fechaRevisarCargas}"/>
			</json:property>
			<json:property name="fechaPresentacionInsEco"> 
				 <fwk:date value="${bie.adjudicacion.fechaPresentacionInsEco}"/>
			</json:property>
			<json:property name="fechaPresentacionIns"> 
				 <fwk:date value="${bie.adjudicacion.fechaPresentacionIns}"/>
			</json:property>
			<json:property name="fechaCancelacionRegEco"> 
				 <fwk:date value="${bie.adjudicacion.fechaCancelacionRegEco}"/>
			</json:property>
			<json:property name="fechaCancelacionReg"> 
				 <fwk:date value="${bie.adjudicacion.fechaCancelacionReg}"/>
			</json:property>
			<json:property name="fechaCancelacionEco"> 
				 <fwk:date value="${bie.adjudicacion.fechaCancelacionEco}"/>
			</json:property>
			<json:property name="fechaLiquidacion"> 
				 <fwk:date value="${bie.adjudicacion.fechaLiquidacion}"/>
			</json:property>
			<json:property name="fechaRecepcion"> 
				 <fwk:date value="${bie.adjudicacion.fechaRecepcion}"/>
			</json:property>
			<json:property name="fechaCancelacion"> 
				 <fwk:date value="${bie.adjudicacion.fechaCancelacion}"/>
			</json:property>			
		</json:object>
	</json:array>
</fwk:json>




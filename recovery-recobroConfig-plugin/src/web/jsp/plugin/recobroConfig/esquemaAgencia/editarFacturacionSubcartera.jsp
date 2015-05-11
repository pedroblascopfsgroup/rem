<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	<pfs:textfield name="subcartera" labelKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.nombre"
		label="**Subcartera" value="${subcartera.nombre}" readOnly="true" />
	
	<pfs:textfield name="tipoReparto" labelKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.tipoReparto"
		label="**Tipo reparto" value="${subcartera.tipoRepartoSubcartera.descripcion}" readOnly="true" />

	<pfs:textfield name="particion" labelKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.particion"
		label="**Particion" value="${subcartera.particion}" readOnly="true" />
			
	<pfsforms:ddCombo name="modeloFacturacion"
		labelKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.modeloFacturacion" label="**Facturacion"
		value="${subcartera.modeloFacturacion.id}" dd="${modelosFacturacion}" propertyCodigo="id" propertyDescripcion="nombre"/>	
	
	<pfsforms:ddCombo name="itinerariosMetasVolantes"
		labelKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.itinerarioMetasVolantes" label="**Metas volantes"
		value="${subcartera.itinerarioMetasVolantes.id}" dd="${itinerariosMetasVolantes}" propertyCodigo="id" propertyDescripcion="nombre"/>	
	
	<pfsforms:ddCombo name="politicasDeAcuerdo"
		labelKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.politicaAcuerdos" label="**Política de acuerdos"
		value="${subcartera.politicaAcuerdos.id}" dd="${politicasDeAcuerdo}" propertyCodigo="id" propertyDescripcion="nombre"/>	

	<pfsforms:ddCombo name="modelosDeRanking"
		labelKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.modelosDeRanking" label="**Modelos de ranking"
		value="${subcartera.modeloDeRanking.id}" dd="${modelosDeRanking}" propertyCodigo="id" propertyDescripcion="nombre"/>	
	
	<pfs:defineParameters name="parametros" paramId="${subcartera.id}" 
		modeloFacturacion="modeloFacturacion"
		itinerarioMetasVolantes="itinerariosMetasVolantes"
		politicaDeAcuerdo="politicasDeAcuerdo"
		modeloDeRanking="modelosDeRanking"
		/>
		
	<pfs:editForm saveOrUpdateFlow="recobroesquema/guardarModelosSubcartera"
		leftColumFields="subcartera, tipoReparto, particion"
		rightColumFields="modeloFacturacion, itinerariosMetasVolantes, politicasDeAcuerdo, modelosDeRanking"
		parameters="parametros" 
		/>
				
</fwk:page>
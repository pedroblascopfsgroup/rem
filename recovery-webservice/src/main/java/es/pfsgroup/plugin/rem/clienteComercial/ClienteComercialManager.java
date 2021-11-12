package es.pfsgroup.plugin.rem.clienteComercial;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import es.pfsgroup.plugin.rem.model.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.api.ClienteComercialApi;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.IsNumber;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Lista;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.UniqueKey;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.clienteComercial.dao.ClienteComercialDao;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOcupacion;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ClienteDto;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;
import es.pfsgroup.plugin.rem.service.InterlocutorCaixaService;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;
import net.sf.json.JSONObject;

@Service("clienteComercialManager")
public class ClienteComercialManager extends BusinessOperationOverrider<ClienteComercialApi>
		implements ClienteComercialApi {

	protected static final Log logger = LogFactory.getLog(ClienteComercialManager.class);

	@Autowired
	private RestApi restApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ClienteComercialDao clienteComercialDao;

	@Autowired
	private InterlocutorCaixaService interlocutorCaixaService;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Override
	public String managerName() {
		return "clienteComercialManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Override
	public ClienteComercial getClienteComercialById(Long id) {
		ClienteComercial cliente = null;

		try {

			cliente = clienteComercialDao.get(id);

		} catch (Exception ex) {
			logger.error("Error clientecomercialmanager ",ex);
		}

		return cliente;
	}

	@Override
	public ClienteComercial getClienteComercialByIdClienteWebcomOrIdClienteRem(ClienteDto clienteDto) {
		ClienteComercial cliente = null;
		List<ClienteComercial> lista = null;

		try {
			if (clienteDto.getIdClienteWebcom() != null || clienteDto.getIdClienteRem() != null) {
				lista = clienteComercialDao.getListaClientes(clienteDto);
				if (!Checks.esNulo(lista) && lista.size() > 0) {
					cliente = lista.get(0);
				}
			}

		} catch (Exception ex) {
			logger.error("Error clientecomercialmanager ",ex);
		}

		return cliente;
	}
	
	@Override
	public ClienteComercial getClienteComercialByDocumento(String documento) {
		ClienteComercial cliente = null;
		List<ClienteComercial> lista = null;

		try {
			if (documento != null) {
				lista = clienteComercialDao.getListaClientesByDocumento(documento);
				if (!Checks.esNulo(lista) && lista.size() > 0) {
					cliente = lista.get(0);
				}
			}

		} catch (Exception ex) {
			logger.error("Error clientecomercialmanager ",ex);
		}

		return cliente;
	}

	@Override
	public ClienteComercial getClienteComercialByIdClienteRem(Long idClienteRem) {
		ClienteComercial cliente = null;
		List<ClienteComercial> lista = null;
		ClienteDto clienteDto = null;

		try {

			if (Checks.esNulo(idClienteRem)) {
				throw new Exception("El parámetro idClienteRem es obligatorio.");

			} else {

				clienteDto = new ClienteDto();
				clienteDto.setIdClienteRem(idClienteRem);

				lista = clienteComercialDao.getListaClientes(clienteDto);
				if (!Checks.esNulo(lista) && lista.size() > 0) {
					cliente = lista.get(0);
				}
			}

		} catch (Exception ex) {
			logger.error("Error clientecomercialmanager ",ex);
		}

		return cliente;
	}

	@Override
	public ClienteComercial getClienteComercialByIdWebcomIdRem(Long idClienteWebcom, Long idClienteRem)
			throws Exception {
		ClienteComercial cliente = null;
		List<ClienteComercial> lista = null;
		ClienteDto clienteDto = null;

		if (Checks.esNulo(idClienteWebcom)) {
			throw new Exception("El parámetro idClienteWebcom es obligatorio.");

		} else if (Checks.esNulo(idClienteRem)) {
			throw new Exception("El parámetro idClienteRem es obligatorio.");

		} else {

			clienteDto = new ClienteDto();
			clienteDto.setIdClienteRem(idClienteRem);
			clienteDto.setIdClienteWebcom(idClienteWebcom);

			lista = clienteComercialDao.getListaClientes(clienteDto);
			if (!Checks.esNulo(lista) && lista.size() > 0) {
				cliente = lista.get(0);
			}
		}

		return cliente;
	}

	@Override
	public List<ClienteComercial> getListaClienteComercial(ClienteDto clienteDto) {
		List<ClienteComercial> lista = null;

		try {

			lista = clienteComercialDao.getListaClientes(clienteDto);

		} catch (Exception ex) {
			logger.error("Error clientecomercialmanager ",ex);
		}

		return lista;
	}

	
	@Override
	public ClienteComercial saveClienteComercial(ClienteDto clienteDto)  throws Exception{
		ClienteComercial cliente = null; 
		ClienteGDPR clienteGDPR = null; //HREOS-4937
		cliente = new ClienteComercial();			
		beanUtilNotNull.copyProperties(cliente, clienteDto);
		cliente.setIdClienteRem(clienteComercialDao.getNextClienteRemId());					

		if (!Checks.esNulo(clienteDto.getIdUsuarioRemAccion())) {
			Usuario user = (Usuario) genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdUsuarioRemAccion()));
			if (!Checks.esNulo(user)) {
				cliente.setUsuarioAccion(user);
			}
		}
		if (!Checks.esNulo(clienteDto.getCodTipoDocumento())) {
			DDTipoDocumento tipoDoc = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumento()));
			if (!Checks.esNulo(tipoDoc)) {
				cliente.setTipoDocumento(tipoDoc);
			}
		}
		if (!Checks.esNulo(clienteDto.getCodTipoDocumentoRepresentante())) {
			DDTipoDocumento tipoDocRep = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class, genericDao
					.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumentoRepresentante()));
			if (!Checks.esNulo(tipoDocRep)) {
				cliente.setTipoDocumentoRepresentante(tipoDocRep);
			}
		}
		if (!Checks.esNulo(clienteDto.getIdProveedorRemPrescriptor())) {
			ActivoProveedor prescriptor = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", clienteDto.getIdProveedorRemPrescriptor()));
			if (!Checks.esNulo(prescriptor)) {
				cliente.setProvPrescriptor(prescriptor);
			}
		}
		if (!Checks.esNulo(clienteDto.getIdProveedorRemResponsable())) {
			ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", clienteDto.getIdProveedorRemResponsable()));
			if (!Checks.esNulo(apiResp)) {
				cliente.setProvApiResponsable(apiResp);
			}
		}
		if (!Checks.esNulo(clienteDto.getCodTipoVia())) {
			DDTipoVia tipovia = (DDTipoVia) genericDao.get(DDTipoVia.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoVia()));
			if (!Checks.esNulo(tipovia)) {
				cliente.setTipoVia(tipovia);
			}
		}
		if (!Checks.esNulo(clienteDto.getCodMunicipio())) {
			Localidad localidad = (Localidad) genericDao.get(Localidad.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipio()));
			if (!Checks.esNulo(localidad)) {
				cliente.setMunicipio(localidad);
			}
		}
		if (!Checks.esNulo(clienteDto.getCodProvincia())) {
			DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvincia()));
			if (!Checks.esNulo(provincia)) {
				cliente.setProvincia(provincia);
			}
		}
		if (!Checks.esNulo(clienteDto.getCodPedania())) {
			DDUnidadPoblacional pedania = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPedania()));
			if (!Checks.esNulo(pedania)) {
				cliente.setUnidadPoblacional(pedania);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getCodTipoPersona())) {
			DDTiposPersona tipoPersona = (DDTiposPersona) genericDao.get(DDTiposPersona.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoPersona()));
			if (!Checks.esNulo(tipoPersona)) {
				cliente.setTipoPersona(tipoPersona);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getCodEstadoCivil())) {
			DDEstadosCiviles estadoCivil = (DDEstadosCiviles) genericDao.get(DDEstadosCiviles.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodEstadoCivil()));
			if (!Checks.esNulo(estadoCivil)) {
				cliente.setEstadoCivil(estadoCivil);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getCodRegimenMatrimonial())) {
			DDRegimenesMatrimoniales regimen = (DDRegimenesMatrimoniales) genericDao.get(DDRegimenesMatrimoniales.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodRegimenMatrimonial()));
			if (!Checks.esNulo(regimen)) {
				cliente.setRegimenMatrimonial(regimen);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getNombreCalle())) {
			cliente.setDireccion(clienteDto.getNombreCalle());
		}
		
		if (!Checks.esNulo(clienteDto.getNumeroCalle())) {
			cliente.setNumeroCalle(clienteDto.getNumeroCalle());
		}
		
		if (!Checks.esNulo(clienteDto.getEscalera())) {
			cliente.setEscalera(clienteDto.getEscalera());
		}
		
		if (!Checks.esNulo(clienteDto.getPlanta())) {
			cliente.setPlanta(clienteDto.getPlanta());
		}
		
		if (!Checks.esNulo(clienteDto.getPuerta())) {
			cliente.setPuerta(clienteDto.getPuerta());
		}
		
		if (!Checks.esNulo(clienteDto.getCodigoPostal())) {
			cliente.setCodigoPostal(clienteDto.getCodigoPostal());
		}
		
		if (!Checks.esNulo(clienteDto.getConyugeTipoDocumento())) {
			DDTipoDocumento doc = genericDao.get(DDTipoDocumento.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getConyugeTipoDocumento()));
			if (!Checks.esNulo(doc)) {
				cliente.setTipoDocumentoConyuge(doc);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getConyugeDocumento())) {
			cliente.setDocumentoConyuge(clienteDto.getConyugeDocumento());
		}
		
		if (!Checks.esNulo(clienteDto.getCodPais())) {
			DDPaises pais = genericDao.get(DDPaises.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPais()));
			if (!Checks.esNulo(pais)) {
				cliente.setPais(pais);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getDireccionRepresentante())) {
			cliente.setDireccionRepresentante(clienteDto.getDireccionRepresentante());
		}
		
		if (!Checks.esNulo(clienteDto.getCodProvinciaRepresentante())) {
			DDProvincia provincia = genericDao.get(DDProvincia.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvinciaRepresentante()));
			if (!Checks.esNulo(provincia)) {
				cliente.setProvinciaRepresentante(provincia);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getCodMunicipioRepresentante())) {
			Localidad localidad = genericDao.get(Localidad.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipioRepresentante()));
			if (!Checks.esNulo(localidad)) {
				cliente.setMunicipioRepresentante(localidad);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getCodPaisRepresentante())) {
			DDPaises pais = genericDao.get(DDPaises.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPaisRepresentante()));
			if (!Checks.esNulo(pais)) {
				cliente.setPaisRepresentante(pais);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getCodigoPostalRepresentante())) {
			cliente.setCodigoPostalRepresentante(clienteDto.getCodigoPostalRepresentante());
		}
		
		if (!Checks.esNulo(clienteDto.getCodOcupacion()) && cliente.getTipoPersona() != null 
				&& DDTipoPersona.CODIGO_TIPO_PERSONA_FISICA.equals(cliente.getTipoPersona().getCodigo())) {
			DDTipoOcupacion tipoOcupacion = (DDTipoOcupacion) genericDao.get(DDTipoOcupacion.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodOcupacion()));
			if (!Checks.esNulo(tipoOcupacion)) {
				cliente.setTipoOcupacion(tipoOcupacion);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getNombreRepresentante())) {
			cliente.setNombreRepresentante(clienteDto.getNombreRepresentante());
		}
		
		if (!Checks.esNulo(clienteDto.getApellidosRepresentante())) {
			cliente.setApellidosRepresentante(clienteDto.getApellidosRepresentante());
		}
	   
		if (!Checks.esNulo(clienteDto.getTelefonoRepresentante())) {
			cliente.setTelefonoRepresentante(clienteDto.getTelefonoRepresentante());
		}

		if (!Checks.esNulo(clienteDto.getTelefonoRepresentante2())) {
			cliente.setTelefonoRepresentante2(clienteDto.getTelefonoRepresentante2());
		}
	    
		if (!Checks.esNulo(clienteDto.getTelefonoRepresentante3())) {
			cliente.setTelefonoRepresentante3(clienteDto.getTelefonoRepresentante3());
		}

		if (!Checks.esNulo(clienteDto.getEmailRepresentante())) {
			cliente.setEmailRepresentante(clienteDto.getEmailRepresentante());
		}

		if (!Checks.esNulo(clienteDto.getEmailRepresentante2())) {
			cliente.setEmailRepresentante2(clienteDto.getEmailRepresentante2());
		}

		if (!Checks.esNulo(clienteDto.getEmailRepresentante3())) {
			cliente.setEmailRepresentante3(clienteDto.getEmailRepresentante3());
		}

		if (!Checks.esNulo(clienteDto.getNombreContacto())) {
			cliente.setNombreContacto(clienteDto.getNombreContacto());
		}
		
		if (!Checks.esNulo(clienteDto.getApellidosContacto())) {
			cliente.setApellidosContacto(clienteDto.getApellidosContacto());
		}
	    
		if (!Checks.esNulo(clienteDto.getCodTipoDocumentoContacto())) {
			DDTipoDocumento tipoDocumentoContacto = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumentoContacto()));
			if (!Checks.esNulo(tipoDocumentoContacto)) {
				cliente.setTipoDocumentoContacto(tipoDocumentoContacto);
			}
		}

		if (!Checks.esNulo(clienteDto.getDocumentoContacto())) {
			cliente.setDocumentoContacto(clienteDto.getDocumentoContacto());
		}
	    
		if (!Checks.esNulo(clienteDto.getTelefonoContacto())) {
			cliente.setTelefonoContacto(clienteDto.getTelefonoContacto());
		}

		if (!Checks.esNulo(clienteDto.getTelefonoContacto2())) {
			cliente.setTelefonoContacto2(clienteDto.getTelefonoContacto2());
		}

		if (!Checks.esNulo(clienteDto.getTelefonoContacto3())) {
			cliente.setTelefonoContacto3(clienteDto.getTelefonoContacto3());
		}

		if (!Checks.esNulo(clienteDto.getEmailContacto())) {
			cliente.setEmailContacto(clienteDto.getEmailContacto());
		}

		if (!Checks.esNulo(clienteDto.getEmailContacto2())) {
			cliente.setEmailContacto2(clienteDto.getEmailContacto2());
		}

		if (!Checks.esNulo(clienteDto.getEmailContacto3())) {
			cliente.setEmailContacto3(clienteDto.getEmailContacto3());
		}

		if (!Checks.esNulo(clienteDto.getIdClienteRemRepresentante())) {
			cliente.setIdClienteRemRepresentante(clienteDto.getIdClienteRemRepresentante());
		}
		
		if (!Checks.esNulo(clienteDto.getIdClienteContacto())) {
			cliente.setIdClienteContacto(clienteDto.getIdClienteContacto());
		}
		if (!Checks.esNulo(clienteDto.getCodPaisNacimiento())) {
			cliente.setPaisNacimiento(genericDao.get(DDPaises.class,genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPaisNacimiento())));
		}
		if (!Checks.esNulo(clienteDto.getCodPaisNacimientoRepresentante())) {
			cliente.setPaisNacimientoRep(genericDao.get(DDPaises.class,genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPaisNacimientoRepresentante())));
		}
		if (!Checks.esNulo(clienteDto.getCodMunicipioNacimiento())) {
			cliente.setLocalidadNacimiento(genericDao.get(Localidad.class,genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipioNacimiento())));
		}
		if (!Checks.esNulo(clienteDto.getCodMunicipioNacimientoRepresentante())) {
			cliente.setLocalidadNacimientoRep(genericDao.get(Localidad.class,genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipioNacimientoRepresentante())));
		}
		if(clienteDto.getFechaNacimiento() != null) {
			cliente.setFechaNacimiento(clienteDto.getFechaNacimiento());
		}
		if(clienteDto.getFechaNacimientoRepresentante() != null) {
			cliente.setFechaNacimientoRep(clienteDto.getFechaNacimientoRepresentante());
		}
		
		if (!Checks.esNulo(clienteDto.getCodProvinciaNacimiento())) {
			DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvinciaNacimiento()));
			if (!Checks.esNulo(provincia)) {
				cliente.setProvinciaNacimiento(provincia);
			}
		}
		
		
		if (!Checks.esNulo(clienteDto.getCodProvinciaNacimientoRepresentante())) {
			DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvinciaNacimientoRepresentante()));
			if (!Checks.esNulo(provincia)) {
				cliente.setProvinciaNacimientoRep(provincia);
			}
		}

		InfoAdicionalPersona iap = interlocutorCaixaService.getIapCaixaOrDefault(cliente.getInfoAdicionalPersona(),cliente.getIdPersonaHayaCaixa(),cliente.getIdPersonaHaya());

		if(iap == null) {
			String idPersonaHaya = cliente.getIdPersonaHaya();
			if(idPersonaHaya == null && cliente.getDocumento() != null) {
				MaestroDePersonas maestroDePersonas = new MaestroDePersonas(OfertaApi.CLIENTE_HAYA);
				idPersonaHaya = maestroDePersonas.getIdPersonaHayaByDocumento(cliente.getDocumento());
				cliente.setIdPersonaHaya(idPersonaHaya);
			}
			if (cliente.getIdPersonaHaya() != null) {
				iap = genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya", idPersonaHaya));
			}
			if(iap == null && idPersonaHaya != null) {
				iap = new InfoAdicionalPersona();
				iap.setAuditoria(Auditoria.getNewInstance());
				iap.setIdPersonaHaya(idPersonaHaya);
			}
		}
		
		if(iap != null) {
			if(clienteDto.getEsPRP() != null) {
				iap.setPrp(clienteDto.getEsPRP());
			}
			cliente.setInfoAdicionalPersona(iap);	
			genericDao.save(InfoAdicionalPersona.class, iap);
		}

		InfoAdicionalPersona iapRep = null;

		if (cliente.getDocumentoRepresentante() != null)
		iapRep = interlocutorCaixaService.getIapCaixaOrDefault(cliente.getInfoAdicionalPersonaRep(),cliente.getIdPersonaHayaCaixaRepresentante(),null);

		if(iapRep == null && cliente.getDocumentoRepresentante() != null) {
			MaestroDePersonas maestroDePersonas = new MaestroDePersonas(OfertaApi.CLIENTE_HAYA);
			String idPersonaHayaRep = maestroDePersonas.getIdPersonaHayaByDocumento(cliente.getDocumentoRepresentante()); 
			iapRep = genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya", idPersonaHayaRep));
			if(iapRep == null && idPersonaHayaRep != null) {
				iapRep = new InfoAdicionalPersona();
				iapRep.setAuditoria(Auditoria.getNewInstance());
				iapRep.setIdPersonaHaya(idPersonaHayaRep);
			}
			
				
		}
		
		if(iapRep != null) {
			if(clienteDto.getEsPRPRepresentante() != null) {
				iapRep.setPrp(clienteDto.getEsPRPRepresentante());
			}
			cliente.setInfoAdicionalPersonaRep(iapRep);
			genericDao.save(InfoAdicionalPersona.class, iapRep);
		}

		if(!Checks.esNulo(clienteDto.getAceptacionOfertaTPrincipal())) {
			if(clienteDto.getAceptacionOfertaTPrincipal()) {
				DDSinSiNo diccionarioSiNo = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI));
				cliente.setAceptacionOferta(diccionarioSiNo);
			}else {
				DDSinSiNo diccionarioSiNo = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO));
				cliente.setAceptacionOferta(diccionarioSiNo);
			}
		}

		clienteComercialDao.save(cliente);
		
		// HREOS-4937 GDPR
		clienteGDPR = new ClienteGDPR();
		clienteGDPR.setCliente(cliente);
		beanUtilNotNull.copyProperties(clienteGDPR, clienteDto);

		if (!Checks.esNulo(clienteDto.getCodTipoDocumento())) {
			DDTipoDocumento tipoDoc = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumento()));
			if (!Checks.esNulo(tipoDoc)) {
				clienteGDPR.setTipoDocumento(tipoDoc);
			}
		}
		if (!Checks.esNulo(clienteDto.getDocumento())) {
			clienteGDPR.setNumDocumento(clienteDto.getDocumento());
		}

		genericDao.save(ClienteGDPR.class, clienteGDPR);

		return cliente;
	}

	@Override
	public void updateClienteComercial(ClienteComercial cliente, ClienteDto clienteDto, Object jsonFields) throws Exception{

		boolean isRelevanteBC = interlocutorCaixaService.esClienteInvolucradoBC(cliente);
		DtoInterlocutorBC oldData = new DtoInterlocutorBC();
		DtoInterlocutorBC newData = new DtoInterlocutorBC();

		if (isRelevanteBC){
			oldData.clienteToDto(cliente);
		}

		if (((JSONObject) jsonFields).containsKey("idClienteWebcom")) {
			if(clienteDto.getIdClienteWebcom() != null) {
				cliente.setIdClienteWebcom(clienteDto.getIdClienteWebcom());
			}
		}
		if (((JSONObject) jsonFields).containsKey("razonSocial")) {
			cliente.setRazonSocial(clienteDto.getRazonSocial());
		}
		if (((JSONObject) jsonFields).containsKey("nombre")) {
			cliente.setNombre(clienteDto.getNombre());
		}
		if (((JSONObject) jsonFields).containsKey("apellidos")) {
			cliente.setApellidos(clienteDto.getApellidos());
		}
		if (((JSONObject) jsonFields).containsKey("idUsuarioRem")) {
			if (!Checks.esNulo(clienteDto.getIdUsuarioRemAccion())) {
				Usuario user = (Usuario) genericDao.get(Usuario.class,
						genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdUsuarioRemAccion()));
				if (!Checks.esNulo(user)) {
					cliente.setUsuarioAccion(user);
				}
			} else {
				cliente.setUsuarioAccion(null);
			}
		}
		if (((JSONObject) jsonFields).containsKey("codTipoDocumento")) {
			if (!Checks.esNulo(clienteDto.getCodTipoDocumento())) {
				DDTipoDocumento tipoDoc = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumento()));
				if (!Checks.esNulo(tipoDoc)) {
					cliente.setTipoDocumento(tipoDoc);
				}
			} else {
				cliente.setTipoDocumento(null);
			}
		}
		if (((JSONObject) jsonFields).containsKey("documento")) {
			cliente.setDocumento(clienteDto.getDocumento());
		}
		if (((JSONObject) jsonFields).containsKey("codTipoDocumentoRepresentante")) {
			if (!Checks.esNulo(clienteDto.getCodTipoDocumentoRepresentante())) {
				DDTipoDocumento tipoDocRep = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo",
								clienteDto.getCodTipoDocumentoRepresentante()));
				if (!Checks.esNulo(tipoDocRep)) {
					cliente.setTipoDocumentoRepresentante(tipoDocRep);
				}
			} else {
				cliente.setTipoDocumentoRepresentante(null);
			}
		}
		if (((JSONObject) jsonFields).containsKey("documentoRepresentante")) {
			cliente.setDocumentoRepresentante(clienteDto.getDocumentoRepresentante());
		}
		if (((JSONObject) jsonFields).containsKey("telefono1")) {
			cliente.setTelefono1(clienteDto.getTelefono1());
		}
		if (((JSONObject) jsonFields).containsKey("telefono2")) {
			cliente.setTelefono2(clienteDto.getTelefono2());
		}
		if (((JSONObject) jsonFields).containsKey("telefono3")) {
			cliente.setTelefono3(clienteDto.getTelefono3());
		}
		if (((JSONObject) jsonFields).containsKey("email")) {
			cliente.setEmail(clienteDto.getEmail());
		}
		if (((JSONObject) jsonFields).containsKey("email2")) {
			cliente.setEmail2(clienteDto.getEmail2());
		}
		if (((JSONObject) jsonFields).containsKey("email3")) {
			cliente.setEmail3(clienteDto.getEmail3());
		}
		if (((JSONObject) jsonFields).containsKey("idProveedorRemPrescriptor")) {
			if (!Checks.esNulo(clienteDto.getIdProveedorRemPrescriptor())) {
				ActivoProveedor prescriptor = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao
						.createFilter(FilterType.EQUALS, "codigoProveedorRem", clienteDto.getIdProveedorRemPrescriptor()));
				if (!Checks.esNulo(prescriptor)) {
					cliente.setProvPrescriptor(prescriptor);
				}
			} else {
				cliente.setProvPrescriptor(null);
			}
		}
		if (((JSONObject) jsonFields).containsKey("idProveedorRemResponsable")) {
			if (!Checks.esNulo(clienteDto.getIdProveedorRemResponsable())) {
				ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao
						.createFilter(FilterType.EQUALS, "codigoProveedorRem", clienteDto.getIdProveedorRemResponsable()));
				if (!Checks.esNulo(apiResp)) {
					cliente.setProvApiResponsable(apiResp);
				}
			} else {
				cliente.setProvApiResponsable(null);
			}
		}
		if (((JSONObject) jsonFields).containsKey("codTipoVia")) {
			if (!Checks.esNulo(clienteDto.getCodTipoVia())) {
				DDTipoVia tipovia = (DDTipoVia) genericDao.get(DDTipoVia.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoVia()));
				if (!Checks.esNulo(tipovia)) {
					cliente.setTipoVia(tipovia);
				}
			} else {
				cliente.setTipoVia(null);
			}
		}
		if (((JSONObject) jsonFields).containsKey("nombreCalle")) {
			cliente.setDireccion(clienteDto.getNombreCalle());
		}
		if (((JSONObject) jsonFields).containsKey("numeroCalle")) {
			cliente.setNumeroCalle(clienteDto.getNumeroCalle());
		}
		if (((JSONObject) jsonFields).containsKey("escalera")) {
			cliente.setEscalera(clienteDto.getEscalera());
		}
		if (((JSONObject) jsonFields).containsKey("planta")) {
			cliente.setPlanta(clienteDto.getPlanta());
		}
		if (((JSONObject) jsonFields).containsKey("puerta")) {
			cliente.setPuerta(clienteDto.getPuerta());
		}
		if (((JSONObject) jsonFields).containsKey("codigoPostal")) {
			cliente.setCodigoPostal(clienteDto.getCodigoPostal());
		}
		if (((JSONObject) jsonFields).containsKey("codProvincia")) {
			if (!Checks.esNulo(clienteDto.getCodProvincia())) {
				DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvincia()));
				if (!Checks.esNulo(provincia)) {
					cliente.setProvincia(provincia);
				}
			} else {
				cliente.setProvincia(null);
			}
		}
		if (((JSONObject) jsonFields).containsKey("codMunicipio")) {
			if (!Checks.esNulo(clienteDto.getCodMunicipio())) {
				Localidad localidad = (Localidad) genericDao.get(Localidad.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipio()));
				if (!Checks.esNulo(localidad)) {
					cliente.setMunicipio(localidad);
				}
			} else {
				cliente.setMunicipio(null);
			}
		}
		if (((JSONObject) jsonFields).containsKey("codPedania")) {
			if (!Checks.esNulo(clienteDto.getCodPedania())) {
				DDUnidadPoblacional pedania = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPedania()));
				if (!Checks.esNulo(pedania)) {
					cliente.setUnidadPoblacional(pedania);
				}
			} else {
				cliente.setUnidadPoblacional(null);
			}
		}
		if (((JSONObject) jsonFields).containsKey("rechazaPublicidad")) {
			cliente.setRechazaPublicidad(clienteDto.getRechazaPublicidad());
		}
		if (((JSONObject) jsonFields).containsKey("idClienteSalesforce")) {
			cliente.setIdClienteSalesforce(clienteDto.getIdClienteSalesforce());
		}
		if (((JSONObject) jsonFields).containsKey("telefonoContactoVisitas")) {
			cliente.setTelefonoContactoVisitas(clienteDto.getTelefonoContactoVisitas());
		}
		
		if (((JSONObject) jsonFields).containsKey("codTipoPersona")) {
			if (!Checks.esNulo(clienteDto.getCodTipoPersona())) {
				DDTiposPersona tipoPersona = (DDTiposPersona) genericDao.get(DDTiposPersona.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoPersona()));
				if (!Checks.esNulo(tipoPersona)) {
					cliente.setTipoPersona(tipoPersona);
				}
			}else{
				cliente.setTipoPersona(null);
			}
		}
		
		if (((JSONObject) jsonFields).containsKey("codEstadoCivil")) {
			if (!Checks.esNulo(clienteDto.getCodEstadoCivil())) {
				DDEstadosCiviles estadoCivil = (DDEstadosCiviles) genericDao.get(DDEstadosCiviles.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodEstadoCivil()));
				if (!Checks.esNulo(estadoCivil)) {
					cliente.setEstadoCivil(estadoCivil);
				}
			}else{
				cliente.setEstadoCivil(null);
			}
		}
		
		if (((JSONObject) jsonFields).containsKey("codRegimenMatrimonial")) {
			if (!Checks.esNulo(clienteDto.getCodRegimenMatrimonial())) {
				DDRegimenesMatrimoniales regimen = (DDRegimenesMatrimoniales) genericDao.get(DDRegimenesMatrimoniales.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodRegimenMatrimonial()));
				if (!Checks.esNulo(regimen)) {
					cliente.setRegimenMatrimonial(regimen);
				}
			}else{
				cliente.setRegimenMatrimonial(null);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getConyugeTipoDocumento())) {
			DDTipoDocumento doc = genericDao.get(DDTipoDocumento.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getConyugeTipoDocumento()));
			if (!Checks.esNulo(doc)) {
				cliente.setTipoDocumentoConyuge(doc);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getConyugeDocumento())) {
			cliente.setDocumentoConyuge(clienteDto.getConyugeDocumento());
		}
		
		if (!Checks.esNulo(clienteDto.getCodPais())) {
			DDPaises pais = genericDao.get(DDPaises.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPais()));
			if (!Checks.esNulo(pais)) {
				cliente.setPais(pais);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getDireccionRepresentante())) {
			cliente.setDireccionRepresentante(clienteDto.getDireccionRepresentante());
		}
		
		if (!Checks.esNulo(clienteDto.getCodProvinciaRepresentante())) {
			DDProvincia provincia = genericDao.get(DDProvincia.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvinciaRepresentante()));
			if (!Checks.esNulo(provincia)) {
				cliente.setProvinciaRepresentante(provincia);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getCodMunicipioRepresentante())) {
			Localidad localidad = genericDao.get(Localidad.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipioRepresentante()));
			if (!Checks.esNulo(localidad)) {
				cliente.setMunicipioRepresentante(localidad);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getCodPaisRepresentante())) {
			DDPaises pais = genericDao.get(DDPaises.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPaisRepresentante()));
			if (!Checks.esNulo(pais)) {
				cliente.setPaisRepresentante(pais);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getCodigoPostalRepresentante())) {
			cliente.setCodigoPostalRepresentante(clienteDto.getCodigoPostalRepresentante());
		}
		
		if (!Checks.esNulo(clienteDto.getCodOcupacion()) && cliente.getTipoPersona() != null 
				&& DDTipoPersona.CODIGO_TIPO_PERSONA_FISICA.equals(cliente.getTipoPersona().getCodigo())) {
			DDTipoOcupacion tipoOcupacion = (DDTipoOcupacion) genericDao.get(DDTipoOcupacion.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodOcupacion()));
			if (!Checks.esNulo(tipoOcupacion)) {
				cliente.setTipoOcupacion(tipoOcupacion);
			}
		}
		
		if (!Checks.esNulo(clienteDto.getNombreRepresentante())) {
			cliente.setNombreRepresentante(clienteDto.getNombreRepresentante());
		}
		
		if (!Checks.esNulo(clienteDto.getApellidosRepresentante())) {
			cliente.setApellidosRepresentante(clienteDto.getApellidosRepresentante());
		}
	   
		if (!Checks.esNulo(clienteDto.getTelefonoRepresentante())) {
			cliente.setTelefonoRepresentante(clienteDto.getTelefonoRepresentante());
		}

		if (!Checks.esNulo(clienteDto.getTelefonoRepresentante2())) {
			cliente.setTelefonoRepresentante2(clienteDto.getTelefonoRepresentante2());
		}

		if (!Checks.esNulo(clienteDto.getTelefonoRepresentante3())) {
			cliente.setTelefonoRepresentante3(clienteDto.getTelefonoRepresentante3());
		}
	    
		if (!Checks.esNulo(clienteDto.getEmailRepresentante())) {
			cliente.setEmailRepresentante(clienteDto.getEmailRepresentante());
		}

		if (!Checks.esNulo(clienteDto.getEmailRepresentante2())) {
			cliente.setEmailRepresentante2(clienteDto.getEmailRepresentante2());
		}

		if (!Checks.esNulo(clienteDto.getEmailRepresentante3())) {
			cliente.setEmailRepresentante3(clienteDto.getEmailRepresentante3());
		}

		if (!Checks.esNulo(clienteDto.getNombreContacto())) {
			cliente.setNombreContacto(clienteDto.getNombreContacto());
		}
		
		if (!Checks.esNulo(clienteDto.getApellidosContacto())) {
			cliente.setApellidosContacto(clienteDto.getApellidosContacto());
		}
	    
		if (!Checks.esNulo(clienteDto.getCodTipoDocumentoContacto())) {
			DDTipoDocumento tipoDocumentoContacto = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumentoContacto()));
			if (!Checks.esNulo(tipoDocumentoContacto)) {
				cliente.setTipoDocumentoContacto(tipoDocumentoContacto);
			}
		}

		if (!Checks.esNulo(clienteDto.getDocumentoContacto())) {
			cliente.setDocumentoContacto(clienteDto.getDocumentoContacto());
		}
	    
		if (!Checks.esNulo(clienteDto.getTelefonoContacto())) {
			cliente.setTelefonoContacto(clienteDto.getTelefonoContacto());
		}

		if (!Checks.esNulo(clienteDto.getTelefonoContacto2())) {
			cliente.setTelefonoContacto2(clienteDto.getTelefonoContacto2());
		}

		if (!Checks.esNulo(clienteDto.getTelefonoContacto3())) {
			cliente.setTelefonoContacto3(clienteDto.getTelefonoContacto3());
		}

		if (!Checks.esNulo(clienteDto.getEmailContacto())) {
			cliente.setEmailContacto(clienteDto.getEmailContacto());
		}

		if (!Checks.esNulo(clienteDto.getEmailContacto2())) {
			cliente.setEmailContacto2(clienteDto.getEmailContacto2());
		}

		if (!Checks.esNulo(clienteDto.getEmailContacto3())) {
			cliente.setEmailContacto3(clienteDto.getEmailContacto3());
		}

		if (!Checks.esNulo(clienteDto.getIdClienteRemRepresentante())) {
			cliente.setIdClienteRemRepresentante(clienteDto.getIdClienteRemRepresentante());
		}
		
		if (!Checks.esNulo(clienteDto.getIdClienteContacto())) {
			cliente.setIdClienteContacto(clienteDto.getIdClienteContacto());
		}
		if (!Checks.esNulo(clienteDto.getCodPaisNacimiento())) {
			cliente.setPaisNacimiento(genericDao.get(DDPaises.class,genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPaisNacimiento())));
		}
		if (!Checks.esNulo(clienteDto.getCodPaisNacimientoRepresentante())) {
			cliente.setPaisNacimientoRep(genericDao.get(DDPaises.class,genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPaisNacimientoRepresentante())));
		}
		if (!Checks.esNulo(clienteDto.getCodMunicipioNacimiento())) {
			cliente.setLocalidadNacimiento(genericDao.get(Localidad.class,genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipioNacimiento())));
		}
		if (!Checks.esNulo(clienteDto.getCodMunicipioNacimientoRepresentante())) {
			cliente.setLocalidadNacimientoRep(genericDao.get(Localidad.class,genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipioNacimientoRepresentante())));
		}
		if(clienteDto.getFechaNacimiento() != null) {
			cliente.setFechaNacimiento(clienteDto.getFechaNacimiento());
		}
		if(clienteDto.getFechaNacimientoRepresentante() != null) {
			cliente.setFechaNacimientoRep(clienteDto.getFechaNacimientoRepresentante());
		}
		
		if (!Checks.esNulo(clienteDto.getCodProvinciaNacimiento())) {
			DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvinciaNacimiento()));
			if (!Checks.esNulo(provincia)) {
				cliente.setProvinciaNacimiento(provincia);
			}
		}
		
		
		if (!Checks.esNulo(clienteDto.getCodProvinciaNacimientoRepresentante())) {
			DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvinciaNacimientoRepresentante()));
			if (!Checks.esNulo(provincia)) {
				cliente.setProvinciaNacimientoRep(provincia);
			}
		}


		InfoAdicionalPersona iap = interlocutorCaixaService.getIapCaixaOrDefault(cliente.getInfoAdicionalPersona(),cliente.getIdPersonaHayaCaixa(),cliente.getIdPersonaHayaCaixa());

		if(iap == null) {
			if (cliente.getIdPersonaHaya() == null && cliente.getDocumento() != null){
				MaestroDePersonas maestroDePersonas = new MaestroDePersonas(OfertaApi.CLIENTE_HAYA);
				cliente.setIdPersonaHaya(maestroDePersonas.getIdPersonaHayaByDocumento(cliente.getDocumento()));
			}
			if (cliente.getIdPersonaHaya() != null) {
				iap = genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya", cliente.getIdPersonaHaya()));
			}
			if(iap == null ) {
				iap = new InfoAdicionalPersona();
				iap.setAuditoria(Auditoria.getNewInstance());
				iap.setIdPersonaHaya(cliente.getIdPersonaHaya());
			}
		}
			
		
		if(clienteDto.getEsPRP() != null) {
			iap.setPrp(clienteDto.getEsPRP());
		}
		
		cliente.setInfoAdicionalPersona(iap);	
		genericDao.save(InfoAdicionalPersona.class, iap);


		
		InfoAdicionalPersona iapRep = null;

		if (cliente.getDocumentoRepresentante() != null){
			iapRep = interlocutorCaixaService.getIapCaixaOrDefault(cliente.getInfoAdicionalPersonaRep(),cliente.getIdPersonaHayaCaixaRepresentante(),null);

		}
		if(iapRep == null && cliente.getDocumentoRepresentante() != null) {
			MaestroDePersonas maestroDePersonas = new MaestroDePersonas(OfertaApi.CLIENTE_HAYA);
			String idPersonaHayaRep = maestroDePersonas.getIdPersonaHayaByDocumento(cliente.getDocumentoRepresentante()); 
			iapRep = genericDao.get(InfoAdicionalPersona.class, genericDao.createFilter(FilterType.EQUALS, "idPersonaHaya", idPersonaHayaRep));
			if(iapRep == null ) {
				iapRep = new InfoAdicionalPersona();
				iapRep.setAuditoria(Auditoria.getNewInstance());
				iapRep.setIdPersonaHaya(idPersonaHayaRep);
			}
		}

		if (iapRep != null){
			if(clienteDto.getEsPRPRepresentante() != null) {
				iapRep.setPrp(clienteDto.getEsPRPRepresentante());
			}

			cliente.setInfoAdicionalPersonaRep(iapRep);

			genericDao.save(InfoAdicionalPersona.class, iapRep);
		}



		if(!Checks.esNulo(clienteDto.getAceptacionOfertaTPrincipal())) {
			if(clienteDto.getAceptacionOfertaTPrincipal()) {
				DDSinSiNo diccionarioSiNo = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI));
				cliente.setAceptacionOferta(diccionarioSiNo);
			}else {
				DDSinSiNo diccionarioSiNo = genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO));
				cliente.setAceptacionOferta(diccionarioSiNo);
			}
		}
		
		clienteComercialDao.saveOrUpdate(cliente);
		
		// HREOS-4937
		if(cliente.getTipoDocumento() != null && cliente.getDocumento() != null && !cliente.getDocumento().isEmpty()){
			List<ClienteGDPR> clienteGDPR = genericDao.getList(ClienteGDPR.class,
					genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.id", cliente.getTipoDocumento().getId()),
					genericDao.createFilter(FilterType.EQUALS, "numDocumento", cliente.getDocumento()));
			if(Checks.estaVacio(clienteGDPR)) {
				clienteGDPR = genericDao.getList(ClienteGDPR.class,
						genericDao.createFilter(FilterType.EQUALS, "cliente.id", cliente.getId()));
			}
			
			if (!Checks.estaVacio(clienteGDPR)) {
				// Primero historificamos los datos de ClienteGDPR en ClienteCompradorGDPR
				ClienteCompradorGDPR clienteCompradorGDPR = new ClienteCompradorGDPR();
				clienteCompradorGDPR.setTipoDocumento(clienteGDPR.get(0).getTipoDocumento());
				clienteCompradorGDPR.setNumDocumento(clienteGDPR.get(0).getNumDocumento());
				clienteCompradorGDPR.setCesionDatos(clienteGDPR.get(0).getCesionDatos());
				clienteCompradorGDPR.setComunicacionTerceros(clienteGDPR.get(0).getComunicacionTerceros());
				clienteCompradorGDPR.setTransferenciasInternacionales(clienteGDPR.get(0).getTransferenciasInternacionales());
				clienteCompradorGDPR.setAdjuntoComprador(clienteGDPR.get(0).getAdjuntoComprador());							

				genericDao.save(ClienteCompradorGDPR.class, clienteCompradorGDPR);

				// Despues se hace el update en ClienteGDPR
				
				for(ClienteGDPR clc: clienteGDPR){
					clc.setCliente(cliente);

					if (((JSONObject) jsonFields).containsKey("cesionDatos")) {
						clc.setCesionDatos(clienteDto.getCesionDatos());
					}
					if (((JSONObject) jsonFields).containsKey("comunicacionTerceros")) {
						clc.setComunicacionTerceros(clienteDto.getComunicacionTerceros());
					}
					if (((JSONObject) jsonFields).containsKey("transferenciasInternacionales")) {
						clc.setTransferenciasInternacionales(clienteDto.getTransferenciasInternacionales());
					}				
					if(Checks.esNulo(clc.getTipoDocumento()) && !Checks.esNulo(cliente.getTipoDocumento())) {
						clc.setTipoDocumento(cliente.getTipoDocumento());
					}
					if(Checks.esNulo(clc.getNumDocumento()) && !Checks.esNulo(cliente.getDocumento())) {
						clc.setNumDocumento(cliente.getDocumento());
					}
					genericDao.update(ClienteGDPR.class, clc);					
				}
				

			} else {
				ClienteGDPR clienteGDPRNew = new ClienteGDPR();
				clienteGDPRNew.setCliente(cliente);
				
				if (!Checks.esNulo(cliente.getTipoDocumento())) {
					clienteGDPRNew.setTipoDocumento(cliente.getTipoDocumento());
				}				
				if (!Checks.esNulo(cliente.getDocumento())) {
					clienteGDPRNew.setNumDocumento(cliente.getDocumento());
				}		
				if (((JSONObject) jsonFields).containsKey("cesionDatos")) {
					clienteGDPRNew.setCesionDatos(clienteDto.getCesionDatos());
				}
				if (((JSONObject) jsonFields).containsKey("comunicacionTerceros")) {
					clienteGDPRNew.setComunicacionTerceros(clienteDto.getComunicacionTerceros());
				}
				if (((JSONObject) jsonFields).containsKey("transferenciasInternacionales")) {
					clienteGDPRNew.setTransferenciasInternacionales(clienteDto.getTransferenciasInternacionales());
				}
				
				genericDao.save(ClienteGDPR.class, clienteGDPRNew);

			}
		}

		if (isRelevanteBC){
			newData.clienteToDto(cliente);
			interlocutorCaixaService.callReplicateClientAsync(oldData,newData,cliente);
		}

	}

	@Override
	public List<String> validateClienteDeleteRequestData(ClienteDto clienteDto) {
		List<String> listaErrores = new ArrayList<String>();
		ClienteComercial cliente = null;

		try {

			if (Checks.esNulo(clienteDto.getIdClienteWebcom())) {
				listaErrores.add("El campo IdClienteWebcom es nulo y es obligatorio.");

			} else if (Checks.esNulo(clienteDto.getIdClienteRem())) {
				listaErrores.add("El campo IdClienteRem es nulo y es obligatorio.");

			} else {
				cliente = getClienteComercialByIdWebcomIdRem(clienteDto.getIdClienteWebcom(),
						clienteDto.getIdClienteRem());
				if (Checks.esNulo(cliente)) {
					listaErrores.add("No existe en REM el cliente con idClienteWebcom: "
							+ clienteDto.getIdClienteWebcom() + " e idClienteRem: " + clienteDto.getIdClienteRem());
				}
			}

		} catch (Exception e) {
			logger.error("Error clientecomercialmanager ",e);
			listaErrores.add("Ha ocurrido un error al validar los parámetros del cliente idClienteWebcom: "
					+ clienteDto.getIdClienteWebcom() + ". Traza: " + e.getMessage());
			return listaErrores;
		}

		return listaErrores;
	}

	@Override
	@Transactional(readOnly = false)
	public List<String> deleteClienteComercial(ClienteDto clienteDto) {
		List<String> errorsList = null;
		ClienteComercial cliente = null;

		try {

			// ValidateDelete
			errorsList = validateClienteDeleteRequestData(clienteDto);
			if (errorsList.isEmpty()) {
				cliente = getClienteComercialByIdWebcomIdRem(clienteDto.getIdClienteWebcom(),
						clienteDto.getIdClienteRem());
				if (!Checks.esNulo(cliente)) {
					clienteComercialDao.delete(cliente);
				} else {
					errorsList.add("No existe en REM el cliente con idClienteWebcom: " + clienteDto.getIdClienteWebcom()
							+ " e idClienteRem: " + clienteDto.getIdClienteRem());
				}
			}

		} catch (Exception e) {
			logger.error("Error clientecomercialmanager ",e);
			errorsList.add("Ha ocurrido un error en base de datos al eliminar el cliente idClienteWebcom: "
					+ clienteDto.getIdClienteWebcom() + " e idClienteRem: " + clienteDto.getIdClienteRem() + ". Traza: "
					+ e.getMessage());
			return errorsList;
		}

		return errorsList;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> saveOrUpdate(List<ClienteDto> listaClienteDto, JSONObject jsonFields) throws Exception  {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < listaClienteDto.size(); i++) {
			HashMap<String, String> errorsList = null;
			HashMap<String, Object> map = new HashMap<String, Object>();
			ClienteDto clienteDto = listaClienteDto.get(i);
			ClienteComercial cliente = this.getClienteComercialByIdClienteWebcomOrIdClienteRem(clienteDto);
			if (Checks.esNulo(cliente)) {
				errorsList = restApi.validateRequestObject(clienteDto, TIPO_VALIDACION.INSERT);
				errorsList.putAll(validatePersonaFisicaOJuridica(clienteDto));
				if (errorsList.size() == 0) {
					cliente = this.saveClienteComercial(clienteDto);
				}

			} else {
				errorsList = restApi.validateRequestObject(clienteDto, TIPO_VALIDACION.UPDATE);
				if (errorsList.size() == 0) {
					this.updateClienteComercial(cliente, clienteDto, jsonFields.getJSONArray("data").get(i));
				}

			}
			if (!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
				
				if (cliente.getIdClienteWebcom() != null)
					map.put("idClienteWebcom", cliente.getIdClienteWebcom());
					map.put("idClienteRem", cliente.getIdClienteRem());
					map.put("success", true);
				//ofertaApi.llamadaMaestroPersonas(cliente.getDocumento(), CLIENTE_HAYA);
			} else {
				if (clienteDto.getIdClienteWebcom() != null)
					map.put("idClienteWebcom", clienteDto.getIdClienteWebcom());
				map.put("idClienteRem", clienteDto.getIdClienteRem());
				map.put("success", false);
				map.put("invalidFields", errorsList);

			}
			listaRespuesta.add(map);

		}
		return listaRespuesta;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> deleteClienteComercial(List<ClienteDto> listaClienteDto) {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < listaClienteDto.size(); i++) {

			HashMap<String, Object> map = new HashMap<String, Object>();
			ClienteDto clienteDto = listaClienteDto.get(i);
			HashMap<String, String> errorsList = restApi.validateRequestObject(clienteDto, TIPO_VALIDACION.UPDATE);

			if (!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
				this.deleteClienteComercial(clienteDto);
				map.put("idClienteWebcom", clienteDto.getIdClienteWebcom());
				map.put("idClienteRem", clienteDto.getIdClienteRem());
				map.put("success", true);
			} else {
				map.put("idClienteWebcom", clienteDto.getIdClienteWebcom());
				map.put("idClienteRem", clienteDto.getIdClienteRem());
				map.put("success", false);
				map.put("invalidFields", errorsList);
			}
			listaRespuesta.add(map);

		}
		return listaRespuesta;
	}
	
	private HashMap<String, String> validatePersonaFisicaOJuridica(ClienteDto clienteDto) {
		
		HashMap<String, String> error = new HashMap<String, String>();
		
		if (clienteDto.getCodTipoPersona() != null && DDTiposPersona.CODIGO_TIPO_PERSONA_FISICA.equals(clienteDto.getCodTipoPersona())) {
			if(clienteDto.getNombre() == null || clienteDto.getNombre().isEmpty())
				error.put("nombre", RestApi.REST_MSG_MISSING_REQUIRED);
			
			if(clienteDto.getApellidos() == null || clienteDto.getApellidos().isEmpty())
				error.put("apellidos", RestApi.REST_MSG_MISSING_REQUIRED);
			
		} else if (clienteDto.getCodTipoPersona() != null && DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA.equals(clienteDto.getCodTipoPersona()) 
				&& (clienteDto.getRazonSocial() == null || clienteDto.getRazonSocial().isEmpty())) {
			error.put("razonSocial", RestApi.REST_MSG_MISSING_REQUIRED);
		}
		
		return error;
		
	}

}

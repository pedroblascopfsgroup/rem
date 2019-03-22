package es.pfsgroup.plugin.rem.clienteComercial;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.api.ClienteComercialApi;
import es.pfsgroup.plugin.rem.clienteComercial.dao.ClienteComercialDao;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteCompradorGDPR;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ClienteDto;

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
			ex.printStackTrace();
		}

		return cliente;
	}

	@Override
	public ClienteComercial getClienteComercialByIdClienteWebcom(Long idClienteWebcom) {
		ClienteComercial cliente = null;
		List<ClienteComercial> lista = null;
		ClienteDto clienteDto = null;

		try {

			if (Checks.esNulo(idClienteWebcom)) {
				throw new Exception("El parámetro idClienteWebcom es obligatorio.");

			} else {

				clienteDto = new ClienteDto();
				clienteDto.setIdClienteWebcom(idClienteWebcom);

				lista = clienteComercialDao.getListaClientes(clienteDto);
				if (!Checks.esNulo(lista) && lista.size() > 0) {
					cliente = lista.get(0);
				}
			}

		} catch (Exception ex) {
			ex.printStackTrace();
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
			ex.printStackTrace();
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
			ex.printStackTrace();
		}

		return lista;
	}

	
	@Override
	public void saveClienteComercial(ClienteDto clienteDto) {
		ClienteComercial cliente = null; 
		ClienteGDPR clienteGDPR = null; //HREOS-4937
		try {

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

			
			
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

	}

	@Override
	public void updateClienteComercial(ClienteComercial cliente, ClienteDto clienteDto, Object jsonFields) {

		try {

			if (((JSONObject) jsonFields).containsKey("idClienteWebcom")) {
				cliente.setIdClienteWebcom(clienteDto.getIdClienteWebcom());
			}
/*			if (((JSONObject) jsonFields).containsKey("idClienteRem")) {
				cliente.setIdClienteRem(clienteDto.getIdClienteRem());
			}*/
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
			if (((JSONObject) jsonFields).containsKey("email")) {
				cliente.setEmail(clienteDto.getEmail());
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
			
			clienteComercialDao.saveOrUpdate(cliente);
			
			// HREOS-4937 
			ClienteGDPR clienteGDPR = genericDao.get(ClienteGDPR.class,
					genericDao.createFilter(FilterType.EQUALS, "tipoDocumento.id", cliente.getTipoDocumento().getId()),
					genericDao.createFilter(FilterType.EQUALS, "numDocumento", cliente.getDocumento()));
			
			if (!Checks.esNulo(clienteGDPR)) {
				// Primero historificamos los datos de ClienteGDPR en ClienteCompradorGDPR
				ClienteCompradorGDPR clienteCompradorGDPR = new ClienteCompradorGDPR();
				clienteCompradorGDPR.setTipoDocumento(clienteGDPR.getTipoDocumento());
				clienteCompradorGDPR.setNumDocumento(clienteGDPR.getNumDocumento());
				clienteCompradorGDPR.setCesionDatos(clienteGDPR.getCesionDatos());
				clienteCompradorGDPR.setComunicacionTerceros(clienteGDPR.getComunicacionTerceros());
				clienteCompradorGDPR.setTransferenciasInternacionales(clienteGDPR.getTransferenciasInternacionales());
				clienteCompradorGDPR.setAdjuntoComprador(clienteGDPR.getAdjuntoComprador());							

				genericDao.save(ClienteCompradorGDPR.class, clienteCompradorGDPR);

				// Despues se hace el update en ClienteGDPR
				clienteGDPR.setCliente(cliente);

				if (((JSONObject) jsonFields).containsKey("cesionDatos")) {
					clienteGDPR.setCesionDatos(clienteDto.getCesionDatos());
				}
				if (((JSONObject) jsonFields).containsKey("comunicacionTerceros")) {
					clienteGDPR.setComunicacionTerceros(clienteDto.getComunicacionTerceros());
				}
				if (((JSONObject) jsonFields).containsKey("transferenciasInternacionales")) {
					clienteGDPR.setTransferenciasInternacionales(clienteDto.getTransferenciasInternacionales());
				}				

				genericDao.update(ClienteGDPR.class, clienteGDPR);

			} else {
				clienteGDPR = new ClienteGDPR();
				clienteGDPR.setCliente(cliente);
				
				if (!Checks.esNulo(cliente.getTipoDocumento())) {
					clienteGDPR.setTipoDocumento(cliente.getTipoDocumento());
				}				
				if (!Checks.esNulo(cliente.getDocumento())) {
					clienteGDPR.setNumDocumento(cliente.getDocumento());
				}		
				if (((JSONObject) jsonFields).containsKey("cesionDatos")) {
					clienteGDPR.setCesionDatos(clienteDto.getCesionDatos());
				}
				if (((JSONObject) jsonFields).containsKey("comunicacionTerceros")) {
					clienteGDPR.setComunicacionTerceros(clienteDto.getComunicacionTerceros());
				}
				if (((JSONObject) jsonFields).containsKey("transferenciasInternacionales")) {
					clienteGDPR.setTransferenciasInternacionales(clienteDto.getTransferenciasInternacionales());
				}
				
				genericDao.save(ClienteGDPR.class, clienteGDPR);
			}
			

		} catch (Exception e) {
			logger.error(e.getMessage());
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
			e.printStackTrace();
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
			e.printStackTrace();
			errorsList.add("Ha ocurrido un error en base de datos al eliminar el cliente idClienteWebcom: "
					+ clienteDto.getIdClienteWebcom() + " e idClienteRem: " + clienteDto.getIdClienteRem() + ". Traza: "
					+ e.getMessage());
			return errorsList;
		}

		return errorsList;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> saveOrUpdate(List<ClienteDto> listaClienteDto, JSONObject jsonFields) {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < listaClienteDto.size(); i++) {
			HashMap<String, String> errorsList = null;
			HashMap<String, Object> map = new HashMap<String, Object>();
			ClienteDto clienteDto = listaClienteDto.get(i);
			ClienteComercial cliente = this.getClienteComercialByIdClienteWebcom(clienteDto.getIdClienteWebcom());
			if (Checks.esNulo(cliente)) {
				errorsList = restApi.validateRequestObject(clienteDto, TIPO_VALIDACION.INSERT);
				//validamos los campos que dependen del tipo de persona
				/*if (!Checks.esNulo(clienteDto.getCodTipoPersona())
						&& clienteDto.getCodTipoPersona().equals(DDTiposPersona.CODIGO_TIPO_PERSONA_FISICA)) {
					if(Checks.esNulo(clienteDto.getCodEstadoCivil())){
						errorsList.put("codEstadoCivil", RestApi.REST_MSG_MISSING_REQUIRED);
					}else if(clienteDto.getCodEstadoCivil().equals(DDEstadosCiviles.CODIGO_ESTADO_CIVIL_CASADO)){
						if(Checks.esNulo(clienteDto.getCodRegimenMatrimonial())){
							errorsList.put("codRegimenMatrimonial", RestApi.REST_MSG_MISSING_REQUIRED);
						}
					}
				}*/
				
				if (errorsList.size() == 0) {
					this.saveClienteComercial(clienteDto);
				}

			} else {
				errorsList = restApi.validateRequestObject(clienteDto, TIPO_VALIDACION.UPDATE);
				if (errorsList.size() == 0) {
					this.updateClienteComercial(cliente, clienteDto, jsonFields.getJSONArray("data").get(i));
				}

			}
			if (!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
				cliente = this.getClienteComercialByIdClienteWebcom(clienteDto.getIdClienteWebcom());
				map.put("idClienteWebcom", cliente.getIdClienteWebcom());
				map.put("idClienteRem", cliente.getIdClienteRem());
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

}

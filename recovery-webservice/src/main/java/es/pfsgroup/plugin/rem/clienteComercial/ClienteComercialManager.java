package es.pfsgroup.plugin.rem.clienteComercial;

import java.util.ArrayList;
import java.util.List;

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
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTiposColaborador;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ClienteDto;

@Service("clienteComercialManager")
public class ClienteComercialManager extends BusinessOperationOverrider<ClienteComercialApi> implements  ClienteComercialApi {
	
	
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
	public ClienteComercial getClienteComercialById(Long id){		
		ClienteComercial cliente = null;
		
		try{
			
			cliente = clienteComercialDao.get(id);
		
		} catch(Exception ex) {
			ex.printStackTrace();			
		}
		
		return cliente;
	}
	
	
	
	
	@Override
	public ClienteComercial getClienteComercialByIdClienteWebcom(Long idClienteWebcom) {		
		ClienteComercial cliente = null;
		List<ClienteComercial> lista = null;
		ClienteDto clienteDto = null;
		
		try{
			
			if(Checks.esNulo(idClienteWebcom)){
				throw new Exception("El parámetro idClienteWebcom es obligatorio.");
				
			}else{
				
				clienteDto = new ClienteDto();
				clienteDto.setIdClienteWebcom(idClienteWebcom);
				
				lista = clienteComercialDao.getListaClientes(clienteDto);		
				if(!Checks.esNulo(lista) && lista.size() > 0){
					cliente = lista.get(0);
				}
			}
			
		} catch(Exception ex) {
			ex.printStackTrace();		
		}
		
		return cliente;
	}
	
	
	
	
	
	@Override
	public ClienteComercial getClienteComercialByIdClienteRem(Long idClienteRem) {		
		ClienteComercial cliente = null;
		List<ClienteComercial> lista = null;
		ClienteDto clienteDto = null;
		
		try{
			
			if(Checks.esNulo(idClienteRem)){
				throw new Exception("El parámetro idClienteRem es obligatorio.");
				
			}else{
				
				clienteDto = new ClienteDto();
				clienteDto.setIdClienteRem(idClienteRem);
				
				lista = clienteComercialDao.getListaClientes(clienteDto);		
				if(!Checks.esNulo(lista) && lista.size() > 0){
					cliente = lista.get(0);
				}
			}
			
		} catch(Exception ex) {
			ex.printStackTrace();		
		}
		
		return cliente;
	}
	
	
	
	
	
	@Override
	public ClienteComercial getClienteComercialByIdWebcomIdRem(Long idClienteWebcom, Long idClienteRem) throws Exception{		
		ClienteComercial cliente = null;
		List<ClienteComercial> lista = null;
		ClienteDto clienteDto = null;
		
			
		if(Checks.esNulo(idClienteWebcom)){
			throw new Exception("El parámetro idClienteWebcom es obligatorio.");
			
		}else if(Checks.esNulo(idClienteRem)){
			throw new Exception("El parámetro idClienteRem es obligatorio.");
			
		}else{
			
			clienteDto = new ClienteDto();
			clienteDto.setIdClienteRem(idClienteRem);
			clienteDto.setIdClienteWebcom(idClienteWebcom);
			
			lista = clienteComercialDao.getListaClientes(clienteDto);		
			if(!Checks.esNulo(lista) && lista.size() > 0){
				cliente = lista.get(0);
			}
		}
			
		return cliente;
	}
	
	
	
	
	
	@Override
	public List<ClienteComercial> getListaClienteComercial(ClienteDto clienteDto){
		List<ClienteComercial> lista = null;
				
		try{
			
			lista = clienteComercialDao.getListaClientes(clienteDto);
		
		} catch(Exception ex) {
			ex.printStackTrace();	
		}
		
		return lista;
	}	
	
	

	
	
	@Override
	public List<String> validateClientePostRequestData(ClienteDto clienteDto, Boolean alta) {
		List<String> listaErrores = new ArrayList<String>();
		ClienteComercial cliente = null;
		
		try{
			
			if(Checks.esNulo(clienteDto.getIdClienteWebcom())){
				listaErrores.add("El campo IdClienteWebcom es nulo y es obligatorio.");
		
			}else{
			
				cliente = getClienteComercialByIdClienteWebcom(clienteDto.getIdClienteWebcom());		
				if(Checks.esNulo(cliente) && !Checks.esNulo(clienteDto.getIdClienteRem())){
					listaErrores.add("No existe en REM el idClienteWebcom: " + clienteDto.getIdClienteWebcom() + " pero si en Webcom con idClienteRem: " + clienteDto.getIdClienteRem());
					
				}
				
				if(alta){
					//Validación para el alta de clientes
					List<String> error = restApi.validateRequestObject(clienteDto);
					if (!Checks.esNulo(error) && !error.isEmpty()) {
						listaErrores.add("No se cumple la especificación de parámetros para el alta del idClienteWebcom: " + clienteDto.getIdClienteWebcom() + ".Traza: " + error);			
					}					
				}else{
					//Validación para la actualización de clientes
					cliente = getClienteComercialByIdWebcomIdRem(clienteDto.getIdClienteWebcom(), clienteDto.getIdClienteRem());
					if(Checks.esNulo(cliente)){
						listaErrores.add("No existe en REM el cliente con idClienteWebcom: " + clienteDto.getIdClienteWebcom() + " idClienteRem: " + clienteDto.getIdClienteRem());
					}
				}
				
				if(!Checks.esNulo(clienteDto.getIdUsuarioRemAccion())){
					Filter filtroUser = genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdUsuarioRemAccion());
					Usuario user = (Usuario) genericDao.get(Usuario.class, filtroUser);							
					if(Checks.esNulo(user)){
						listaErrores.add("No existe el usuario en REM especificado en el campo idUsuarioRemAccion: " + clienteDto.getIdUsuarioRemAccion());
					}
				}
				if(!Checks.esNulo(clienteDto.getCodTipoDocumento())){
					Filter filtrotipodoc = genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumento());
					DDTipoDocumento tipoDoc = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class, filtrotipodoc);							
					if(Checks.esNulo(tipoDoc)){
						listaErrores.add("No existe el tipo de documento especificado en el campo codTipoDocumento: " + clienteDto.getCodTipoDocumento());
					}
				}		
				
				if(!Checks.esNulo(clienteDto.getCodTipoDocumentoRepresentante())){
					Filter filtrotipodocrep = genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumentoRepresentante());
					DDTipoDocumento tipoDocRep = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class, filtrotipodocrep);							
					if(Checks.esNulo(tipoDocRep)){
						listaErrores.add("No existe el tipo de documento en REM especificado en el campo codTipoDocumentoRepresentante: " + clienteDto.getCodTipoDocumentoRepresentante());
					}
				}							
			/*	if(!Checks.esNulo(clienteDto.getCodTipoPrescriptor())){
					Filter filtrotipoPres = genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoPrescriptor());
					DDTiposColaborador tipoCol= (DDTiposColaborador) genericDao.get(DDTiposColaborador.class, filtrotipoPres);							
					if(Checks.esNulo(tipoCol)){
						listaErrores.add("No existe el tipo de prescriptor en REM especificado en el campo codTipoPrescriptor: " + clienteDto.getCodTipoPrescriptor());
					}
				}*/
				if(!Checks.esNulo(clienteDto.getIdProveedorRemPrescriptor())){
					Filter filtroPres = genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdProveedorRemPrescriptor());
					ActivoProveedor prescriptor= (ActivoProveedor) genericDao.get(ActivoProveedor.class, filtroPres);							
					if(Checks.esNulo(prescriptor)){
						listaErrores.add("No existe el prescriptor en REM especificado en el campo idProveedorRemPrescriptor: " + clienteDto.getIdProveedorRemPrescriptor());
					}
				}
				if(!Checks.esNulo(clienteDto.getIdProveedorRemResponsable())){
					Filter filtroApi = genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdProveedorRemResponsable());
					ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class, filtroApi);							
					if(Checks.esNulo(apiResp)){
						listaErrores.add("No existe el api responsable en REM especificado en el campo idProveedorRemResponsable: " + clienteDto.getIdProveedorRemResponsable());
					}
				}
				if(!Checks.esNulo(clienteDto.getCodTipoVia())){
					Filter filtroTvi = genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoVia());
					DDTipoVia tipovia = (DDTipoVia) genericDao.get(DDTipoVia.class, filtroTvi);							
					if(Checks.esNulo(tipovia)){
						listaErrores.add("No existe el tipo de vía en REM especificado en el campo codTipoVia: " + clienteDto.getCodTipoVia());
					}
				}
				if(!Checks.esNulo(clienteDto.getCodMunicipio())){
					Filter filtroMun = genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipio());
					Localidad localidad = (Localidad) genericDao.get(Localidad.class, filtroMun);							
					if(Checks.esNulo(localidad)){
						listaErrores.add("No existe el municipio en REM especificado en el campo codMunicipio: " + clienteDto.getCodMunicipio());
					}
				}
				if(!Checks.esNulo(clienteDto.getCodProvincia())){
					Filter filtroProv = genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvincia());
					DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, filtroProv);							
					if(Checks.esNulo(provincia)){
						listaErrores.add("No existe la provincia en REM especificado en el campo codProvincia: " + clienteDto.getCodProvincia());
					}
				}
				if(!Checks.esNulo(clienteDto.getCodPedania())){
					Filter filtroPed = genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPedania());
					DDUnidadPoblacional pedania = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, filtroPed);							
					if(Checks.esNulo(pedania)){
						listaErrores.add("No existe la pedania en REM especificada en el campo codPedania: " + clienteDto.getCodPedania());
					}
				}
			}
			
		}catch (Exception e){
			e.printStackTrace();
			listaErrores.add("Ha ocurrido un error al validar los parámetros del cliente idClienteWebcom: " + clienteDto.getIdClienteWebcom() + ". Traza: " + e.getMessage());
			return listaErrores;
		}
			
		return listaErrores;
	}
	

	
	
	
	@Override
	@Transactional(readOnly = false)
	public List<String> saveClienteComercial(ClienteDto clienteDto) {
		ClienteComercial cliente = null;
		List<String> errorsList = null;
		
		try{
		
			//ValidateAlta
			errorsList = validateClientePostRequestData(clienteDto, true);
			if(errorsList.isEmpty()){
				
				cliente = new ClienteComercial();
				beanUtilNotNull.copyProperties(cliente, clienteDto);	
				cliente.setIdClienteRem(clienteComercialDao.getNextClienteRemId());
				
				if(!Checks.esNulo(clienteDto.getIdUsuarioRemAccion())){
					Usuario user = (Usuario) genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdUsuarioRemAccion()));							
					if(!Checks.esNulo(user)){
						cliente.setUsuarioAccion(user);			
					}
				}
				if(!Checks.esNulo(clienteDto.getCodTipoDocumento())){
					DDTipoDocumento tipoDoc = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumento()));							
					if(!Checks.esNulo(tipoDoc)){
						cliente.setTipoDocumento(tipoDoc);
					}
				}							
				if(!Checks.esNulo(clienteDto.getCodTipoDocumentoRepresentante())){
					DDTipoDocumento tipoDocRep = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumentoRepresentante()));							
					if(!Checks.esNulo(tipoDocRep)){
						cliente.setTipoDocumentoRepresentante(tipoDocRep);
					}
				}							
				/*if(!Checks.esNulo(clienteDto.getCodTipoPrescriptor())){
					DDTiposColaborador tipoCol= (DDTiposColaborador) genericDao.get(DDTiposColaborador.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoPrescriptor()));							
					if(!Checks.esNulo(tipoCol)){
						cliente.setTipoColaborador(tipoCol);
					}
				}*/
				if(!Checks.esNulo(clienteDto.getIdProveedorRemPrescriptor())){
					ActivoProveedor prescriptor= (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdProveedorRemPrescriptor()));							
					if(!Checks.esNulo(prescriptor)){
						cliente.setProvPrescriptor(prescriptor);
					}
				}
				if(!Checks.esNulo(clienteDto.getIdProveedorRemResponsable())){
					ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdProveedorRemResponsable()));							
					if(!Checks.esNulo(apiResp)){
						cliente.setProvApiResponsable(apiResp);
					}
				}
				if(!Checks.esNulo(clienteDto.getCodTipoVia())){
					DDTipoVia tipovia = (DDTipoVia) genericDao.get(DDTipoVia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoVia()));							
					if(!Checks.esNulo(tipovia)){
						cliente.setTipoVia(tipovia);
					}
				}
				if(!Checks.esNulo(clienteDto.getCodMunicipio())){
					Localidad localidad = (Localidad) genericDao.get(Localidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipio()));							
					if(!Checks.esNulo(localidad)){
						cliente.setMunicipio(localidad);
					}
				}
				if(!Checks.esNulo(clienteDto.getCodProvincia())){
					DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvincia()));							
					if(!Checks.esNulo(provincia)){
						cliente.setProvincia(provincia);
					}
				}
				if(!Checks.esNulo(clienteDto.getCodPedania())){
					DDUnidadPoblacional pedania = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPedania()));							
					if(!Checks.esNulo(pedania)){
						cliente.setUnidadPoblacional(pedania);
					}
				}
				
				clienteComercialDao.save(cliente);	
			}

		}catch (Exception e){
			e.printStackTrace();
			errorsList.add("Ha ocurrido un error en base de datos al dar de alta el cliente con idClienteWebcom: " + clienteDto.getIdClienteWebcom() + ". Traza: " + e.getMessage());
			return errorsList;
		}
		
		return errorsList;	
	}
	
	
	
	
	
	
	@Override
	@Transactional(readOnly = false)
	public List<String> updateClienteComercial(ClienteComercial cliente, ClienteDto clienteDto, Object jsonFields) {
		List<String> errorsList = null;
		
		try{
			
			//ValidateUpdate
			errorsList = validateClientePostRequestData(clienteDto, false);
			if(errorsList.isEmpty()){
					
				if(((JSONObject)jsonFields).containsKey("idClienteWebcom")){
					cliente.setIdClienteWebcom(clienteDto.getIdClienteWebcom());
				}
				if(((JSONObject)jsonFields).containsKey("idClienteRem")){
					cliente.setIdClienteRem(clienteDto.getIdClienteRem());
				}
				if(((JSONObject)jsonFields).containsKey("razonSocial")){
					cliente.setRazonSocial(clienteDto.getRazonSocial());
				}
				if(((JSONObject)jsonFields).containsKey("nombre")){
					cliente.setNombre(clienteDto.getNombre());
				}
				if(((JSONObject)jsonFields).containsKey("apellidos")){
					cliente.setApellidos(clienteDto.getApellidos());
				}
				if(((JSONObject)jsonFields).containsKey("fechaAccion")){
					cliente.setFechaAccion(clienteDto.getFechaAccion());
				}
				if(((JSONObject)jsonFields).containsKey("idUsuarioRem")) {
					if(!Checks.esNulo(clienteDto.getIdUsuarioRemAccion())){
						Usuario user = (Usuario) genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdUsuarioRemAccion()));							
						if(!Checks.esNulo(user)) {
							cliente.setUsuarioAccion(user);
						}
					} else {
						cliente.setUsuarioAccion(null);
					}
				}
				if(((JSONObject)jsonFields).containsKey("codTipoDocumento")) {					
					if(!Checks.esNulo(clienteDto.getCodTipoDocumento())){
						DDTipoDocumento tipoDoc = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumento()));							
						if(!Checks.esNulo(tipoDoc)){ 
							cliente.setTipoDocumento(tipoDoc);
						}
					}else{
						cliente.setTipoDocumento(null);
					}		
				}
				if(((JSONObject)jsonFields).containsKey("documento")){
					cliente.setDocumento(clienteDto.getDocumento());
				}
				if(((JSONObject)jsonFields).containsKey("codTipoDocumentoRepresentante")) {					
					if(!Checks.esNulo(clienteDto.getCodTipoDocumentoRepresentante())){
						DDTipoDocumento tipoDocRep = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoDocumentoRepresentante()));							
						if(!Checks.esNulo(tipoDocRep)){
							cliente.setTipoDocumentoRepresentante(tipoDocRep);
						}
					}else{
						cliente.setTipoDocumentoRepresentante(null);
					}		
				}
				if(((JSONObject)jsonFields).containsKey("documentoRepresentante")){
					cliente.setDocumentoRepresentante(clienteDto.getDocumentoRepresentante());
				}
				if(((JSONObject)jsonFields).containsKey("telefono1")){
					cliente.setTelefono1(clienteDto.getTelefono1());
				}
				if(((JSONObject)jsonFields).containsKey("telefono2")){
					cliente.setTelefono2(clienteDto.getTelefono2());
				}
				if(((JSONObject)jsonFields).containsKey("email")){
					cliente.setEmail(clienteDto.getEmail());
				}
				/*if(((JSONObject)jsonFields).containsKey("codTipoPrescriptor")){
					if(!Checks.esNulo(clienteDto.getCodTipoPrescriptor())){
						DDTiposColaborador tipoCol= (DDTiposColaborador) genericDao.get(DDTiposColaborador.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoPrescriptor()));							
						if(!Checks.esNulo(tipoCol)){
							cliente.setTipoColaborador(tipoCol);
						}
					}else{
						cliente.setTipoColaborador(null);
					}
				}*/
				if(((JSONObject)jsonFields).containsKey("idProveedorRemPrescriptor")){					
					if(!Checks.esNulo(clienteDto.getIdProveedorRemPrescriptor())){
						ActivoProveedor prescriptor= (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdProveedorRemPrescriptor()));							
						if(!Checks.esNulo(prescriptor)){
							cliente.setProvPrescriptor(prescriptor);
						}
					}else{
						cliente.setProvPrescriptor(null);
					}
				}
				if(((JSONObject)jsonFields).containsKey("idProveedorRemResponsable")){
					if(!Checks.esNulo(clienteDto.getIdProveedorRemResponsable())){
						ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", clienteDto.getIdProveedorRemResponsable()));							
						if(!Checks.esNulo(apiResp)){
							cliente.setProvApiResponsable(apiResp);
						}
					}else{
						cliente.setProvApiResponsable(null);
					}
				}			
				if(((JSONObject)jsonFields).containsKey("codTipoVia")){
					if(!Checks.esNulo(clienteDto.getCodTipoVia())){
						DDTipoVia tipovia = (DDTipoVia) genericDao.get(DDTipoVia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodTipoVia()));							
						if(!Checks.esNulo(tipovia)){
							cliente.setTipoVia(tipovia);
						}
					}else{
						cliente.setTipoVia(null);
					}
				}
				if(((JSONObject)jsonFields).containsKey("nombreCalle")){
					cliente.setDireccion(clienteDto.getNombreCalle());
				}
				if(((JSONObject)jsonFields).containsKey("numeroCalle")){
					cliente.setNumeroCalle(clienteDto.getNumeroCalle());
				}
				if(((JSONObject)jsonFields).containsKey("escalera")){
					cliente.setEscalera(clienteDto.getEscalera());
				}
				if(((JSONObject)jsonFields).containsKey("planta")){
					cliente.setPlanta(clienteDto.getPlanta());
				}
				if(((JSONObject)jsonFields).containsKey("puerta")){
					cliente.setPuerta(clienteDto.getPuerta());
				}
				if(((JSONObject)jsonFields).containsKey("codigoPostal")){
					cliente.setCodigoPostal(clienteDto.getCodigoPostal());
				}
				if(((JSONObject)jsonFields).containsKey("codProvincia")){
					if(!Checks.esNulo(clienteDto.getCodProvincia())){
						DDProvincia provincia = (DDProvincia) genericDao.get(DDProvincia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodProvincia()));							
						if(!Checks.esNulo(provincia)){
							cliente.setProvincia(provincia);
						}
					}else{
						cliente.setProvincia(null);
					}
				}				
				if(((JSONObject)jsonFields).containsKey("codMunicipio")){
					if(!Checks.esNulo(clienteDto.getCodMunicipio())){
						Localidad localidad = (Localidad) genericDao.get(Localidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodMunicipio()));							
						if(!Checks.esNulo(localidad)){
							cliente.setMunicipio(localidad);
						}
					}else{
						cliente.setMunicipio(null);
					}
				}
				if(((JSONObject)jsonFields).containsKey("codPedania")){
					if(!Checks.esNulo(clienteDto.getCodPedania())){
						DDUnidadPoblacional pedania = (DDUnidadPoblacional) genericDao.get(DDUnidadPoblacional.class, genericDao.createFilter(FilterType.EQUALS, "codigo", clienteDto.getCodPedania()));							
						if(!Checks.esNulo(pedania)){
							cliente.setUnidadPoblacional(pedania);
						}
					}else{
						cliente.setUnidadPoblacional(null);
					}
				}
				if(((JSONObject)jsonFields).containsKey("observaciones")){
					cliente.setObservaciones(clienteDto.getObservaciones());
				}
			
		
				clienteComercialDao.saveOrUpdate(cliente);
			}

		}catch (Exception e){
			e.printStackTrace();
			errorsList.add("Ha ocurrido un error en base de datos al actualizar el cliente webcom: " + clienteDto.getIdClienteWebcom() + ". Traza: " + e.getMessage());
			return errorsList;
		}
		
		return errorsList;	
	}
	
	
	
	
	
	@Override
	public List<String> validateClienteDeleteRequestData(ClienteDto clienteDto) {
		List<String> listaErrores = new ArrayList<String>();
		ClienteComercial cliente = null;
		
		try{
			
			if(Checks.esNulo(clienteDto.getIdClienteWebcom())){
				listaErrores.add("El campo IdClienteWebcom es nulo y es obligatorio.");
		
			}else if(Checks.esNulo(clienteDto.getIdClienteRem())){
				listaErrores.add("El campo IdClienteRem es nulo y es obligatorio.");
				
			}else{
				cliente = getClienteComercialByIdWebcomIdRem(clienteDto.getIdClienteWebcom(), clienteDto.getIdClienteRem());		
				if(Checks.esNulo(cliente)){
					listaErrores.add("No existe en REM el cliente con idClienteWebcom: " + clienteDto.getIdClienteWebcom() + " e idClienteRem: " + clienteDto.getIdClienteRem());					
				}
			}
				
		}catch (Exception e){
			e.printStackTrace();
			listaErrores.add("Ha ocurrido un error al validar los parámetros del cliente idClienteWebcom: " + clienteDto.getIdClienteWebcom() + ". Traza: " + e.getMessage());
			return listaErrores;
		}
			
		return listaErrores;
	}
	
	
	
	
	
	@Override
	@Transactional(readOnly = false)
	public List<String> deleteClienteComercial(ClienteDto clienteDto) {
		List<String> errorsList = null;
		ClienteComercial cliente = null;
		
		try{
			
			//ValidateDelete
			errorsList = validateClienteDeleteRequestData(clienteDto);
			if(errorsList.isEmpty()){			
				cliente = getClienteComercialByIdWebcomIdRem(clienteDto.getIdClienteWebcom(), clienteDto.getIdClienteRem());		
				if(!Checks.esNulo(cliente)){
					clienteComercialDao.delete(cliente);
				}else{
					errorsList.add("No existe en REM el cliente con idClienteWebcom: " + clienteDto.getIdClienteWebcom() + " e idClienteRem: " + clienteDto.getIdClienteRem());					
				}				
			}
				
		}catch (Exception e){
			e.printStackTrace();
			errorsList.add("Ha ocurrido un error en base de datos al eliminar el cliente idClienteWebcom: " + clienteDto.getIdClienteWebcom() + " e idClienteRem: " + clienteDto.getIdClienteRem() + ". Traza: " + e.getMessage());
			return errorsList;
		}
		
		return errorsList;
	}
	
}

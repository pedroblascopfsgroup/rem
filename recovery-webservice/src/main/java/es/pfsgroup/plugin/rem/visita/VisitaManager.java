package es.pfsgroup.plugin.rem.visita;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.VisitaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisita;
import es.pfsgroup.plugin.rem.model.dd.DDSubEstadosVisita;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;

@Service("visitaManager")
public class VisitaManager extends BusinessOperationOverrider<VisitaApi> implements  VisitaApi {
	
	
	protected static final Log logger = LogFactory.getLog(VisitaManager.class);
	
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private VisitaDao visitaDao;

	@Override
	public String managerName() {
		return "visitaManager";
	}
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	
	
	
	@Override
	public Visita getVisitaById(Long id){		
		Visita visita = null;
		
		try{
			
			visita = visitaDao.get(id);
		
		} catch(Exception ex) {
			ex.printStackTrace();			
		}
		
		return visita;
	}
	
	
	
	
	@Override
	public Visita getVisitaByIdVisitaWebcom(Long idVisitaWebcom) {		
		Visita visita = null;
		List<Visita> lista = null;
		VisitaDto visitaDto = null;
		
		try{
			
			if(Checks.esNulo(idVisitaWebcom)){
				throw new Exception("El parámetro idVisitaWebcom es obligatorio.");
				
			}else{
				
				visitaDto = new VisitaDto();
				visitaDto.setIdVisitaWebcom(idVisitaWebcom);
				
				lista = visitaDao.getListaVisitas(visitaDto);		
				if(!Checks.esNulo(lista) && lista.size() > 0){
					visita = lista.get(0);
				}
			}
			
		} catch(Exception ex) {
			ex.printStackTrace();		
		}
		
		return visita;
	}
	
	
	
	
	
	@Override
	public Visita getVisitaByNumVisitaRem(Long numVisitaRem) {		
		Visita visita = null;
		List<Visita> lista = null;
		VisitaDto visitaDto = null;
		
		try{
			
			if(Checks.esNulo(numVisitaRem)){
				throw new Exception("El parámetro idVisitaRem es obligatorio.");
				
			}else{
				
				visitaDto = new VisitaDto();
				visitaDto.setIdVisitaRem(numVisitaRem);
				
				lista = visitaDao.getListaVisitas(visitaDto);		
				if(!Checks.esNulo(lista) && lista.size() > 0){
					visita = lista.get(0);
				}
			}
			
		} catch(Exception ex) {
			ex.printStackTrace();		
		}
		
		return visita;
	}
	
	
	
	
	
	@Override
	public Visita getVisitaByIdVisitaWebcomNumVisitaRem(Long idVisitaWebcom, Long numVisitaRem) throws Exception{		
		Visita visita = null;
		List<Visita> lista = null;
		VisitaDto visitaDto = null;
			
		if(Checks.esNulo(idVisitaWebcom)){
			throw new Exception("El parámetro idVisitaWebcom es obligatorio.");
			
		}else if(Checks.esNulo(numVisitaRem)){
			throw new Exception("El parámetro idVisitaRem es obligatorio.");
			
		}else{
			
			visitaDto = new VisitaDto();
			visitaDto.setIdVisitaRem(numVisitaRem);
			visitaDto.setIdVisitaWebcom(idVisitaWebcom);
			
			lista = visitaDao.getListaVisitas(visitaDto);		
			if(!Checks.esNulo(lista) && lista.size() > 0){
				visita = lista.get(0);
			}
		}
			
		return visita;
	}
	
	
	@Override
	public DtoPage getListVisitas(DtoVisitasFilter dtoVisitasFilter) {

		return visitaDao.getListVisitas(dtoVisitasFilter);
	}
	
	
	@Override
	public List<Visita> getListaVisitas(VisitaDto visitaDto){
		List<Visita> lista = null;
				
		try{
			
			lista = visitaDao.getListaVisitas(visitaDto);
		
		} catch(Exception ex) {
			ex.printStackTrace();	
		}
		
		return lista;
	}	
	
	

	
	
	@Override
	public List<String> validateVisitaPostRequestData(VisitaDto visitaDto, Object jsonFields, Boolean alta) {
		List<String> listaErrores = new ArrayList<String>();
		Visita visita = null;
		
		try{
			
			if(Checks.esNulo(visitaDto.getIdVisitaWebcom())){
				listaErrores.add("El campo IdVisitaWebcom es nulo y es obligatorio.");

			} else {
			
				visita = getVisitaByIdVisitaWebcom(visitaDto.getIdVisitaWebcom());		
				if(Checks.esNulo(visita) && !Checks.esNulo(visitaDto.getIdVisitaRem())){
					listaErrores.add("No existe en REM el idVisitaWebcom: " + visitaDto.getIdVisitaWebcom() + " pero si en Webcom con idVisitaRem: " + visitaDto.getIdVisitaRem());
					
				}
				
				if(alta){
					//Validación para el alta de visitas
					List<String> error = restApi.validateRequestObject(visitaDto);
					if (!Checks.esNulo(error) && !error.isEmpty()) {
						listaErrores.add("No se cumple la especificación de parámetros para el alta de idVisitaWebcom: " + visitaDto.getIdVisitaWebcom() + ".Traza: " + error);			
					}					
				}else{
					//Validación para la actualización de visitas
					visita = getVisitaByIdVisitaWebcomNumVisitaRem(visitaDto.getIdVisitaWebcom(), visitaDto.getIdVisitaRem());
					if(Checks.esNulo(visita)){
						listaErrores.add("No existe en REM la visita con idVisitaWebcom: " + visitaDto.getIdVisitaWebcom() + " idVisitaRem: " + visitaDto.getIdVisitaRem());
					}	
					
					if(!Checks.esNulo(jsonFields) && ((JSONObject)jsonFields).containsKey("idClienteRem") && Checks.esNulo(visitaDto.getIdClienteRem())){
						listaErrores.add("El campo idClienteRem es nulo y es obligatorio en actualizaciones.");					
					}
					
					if(!Checks.esNulo(jsonFields) && ((JSONObject)jsonFields).containsKey("idClienteRem") && Checks.esNulo(visitaDto.getIdActivoHaya())){
						listaErrores.add("El campo idActivoHaya es nulo y es obligatorio en actualizaciones.");
					}			
				}
				if(!Checks.esNulo(visitaDto.getIdClienteRem())){
					ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "idClienteRem", visitaDto.getIdClienteRem()));							
					if(Checks.esNulo(cliente)){
						listaErrores.add("No existe el cliente en REM especificado en el campo idClienteRem: " + visitaDto.getIdClienteRem());
					}
				}
				if(!Checks.esNulo(visitaDto.getIdActivoHaya())){
					Activo activo = (Activo) genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "numActivo", visitaDto.getIdActivoHaya()));							
					if(Checks.esNulo(activo)){
						listaErrores.add("No existe el activo en REM especificado en el campo idActivoHaya: " + visitaDto.getIdActivoHaya());
					}
				}
				if(!Checks.esNulo(visitaDto.getIdUsuarioRemAccion())){
					Usuario user = (Usuario) genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdUsuarioRemAccion()));							
					if(Checks.esNulo(user)){
						listaErrores.add("No existe el usuario en REM especificado en el campo idUsuarioRem: " + visitaDto.getIdUsuarioRemAccion());
					}
				}
				if(!Checks.esNulo(visitaDto.getCodEstadoVisita())){
					DDEstadosVisita estadoVis = (DDEstadosVisita) genericDao.get(DDEstadosVisita.class, genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodEstadoVisita()));							
					if(Checks.esNulo(estadoVis)){
						listaErrores.add("No existe el código del estado de la visita especificado en el campo codEstadoVisita: " + visitaDto.getCodEstadoVisita());
					}
				}				
				if(!Checks.esNulo(visitaDto.getCodDetalleEstadoVisita())){
					DDSubEstadosVisita subEstVis = (DDSubEstadosVisita) genericDao.get(DDSubEstadosVisita.class, genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodDetalleEstadoVisita()));							
					if(Checks.esNulo(subEstVis)){
						listaErrores.add("No existe el código del detalle del estado de la visita en REM especificado en el campo codDetalleEstadoVisita: " + visitaDto.getCodDetalleEstadoVisita());
					}
				}							
				if(!Checks.esNulo(visitaDto.getIdProveedorRemPrescriptor())){
					ActivoProveedor pres = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemPrescriptor()));							
					if(Checks.esNulo(pres)){
						listaErrores.add("No existe el prescriptor en REM especificado en el campo idProveedorRemPrescriptor: " + visitaDto.getIdProveedorRemPrescriptor());
					}
				}		
				if(!Checks.esNulo(visitaDto.getIdProveedorRemResponsable())){
					ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemResponsable()));							
					if(Checks.esNulo(apiResp)){
						listaErrores.add("No existe el apiResponsable en REM especificado en el campo idProveedorRemResponsable: " + visitaDto.getIdProveedorRemResponsable());
					}
				}
				if(!Checks.esNulo(visitaDto.getIdProveedorRemCustodio())){
					ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemCustodio()));							
					if(Checks.esNulo(apiResp)){
						listaErrores.add("No existe el apiCustodio en REM especificado en el campo idProveedorRemCustodio: " + visitaDto.getIdProveedorRemCustodio());
					}
				}
				if(!Checks.esNulo(visitaDto.getIdProveedorRemFdv())){
					ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemFdv()));							
					if(Checks.esNulo(fdv)){
						listaErrores.add("No existe el fdv en REM especificado en el campo idProveedorRemFdv: " + visitaDto.getIdProveedorRemCustodio());
					}
				}
				if(!Checks.esNulo(visitaDto.getIdProveedorRemVisita())){
					ActivoProveedor pveVisita = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemVisita()));							
					if(Checks.esNulo(pveVisita)){
						listaErrores.add("No existe el proveedor en REM especificado en el campo idProveedorRemVisita: " + visitaDto.getIdProveedorRemVisita());
					}
				}
			}
			
		}catch (Exception e){
			e.printStackTrace();
			listaErrores.add("Ha ocurrido un error al validar los parámetros de la visita idVisitaWebcom: " + visitaDto.getIdVisitaWebcom() + ". Traza: " + e.getMessage());
			return listaErrores;
		}
			
		return listaErrores;
	}
	

	
	
	
	@Override
	@Transactional(readOnly = false)
	public List<String> saveVisita(VisitaDto visitaDto) {
		Visita visita = null;
		List<String> errorsList = null;
		
		try{
		
			//ValidateAlta
			errorsList = validateVisitaPostRequestData(visitaDto, null, true);
			if(errorsList.isEmpty()){
				
				visita = new Visita();
				beanUtilNotNull.copyProperties(visita, visitaDto);	
				visita.setNumVisitaRem(visitaDao.getNextNumVisitaRem());
				
				if(!Checks.esNulo(visitaDto.getIdClienteRem())){
					ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "idClienteRem", visitaDto.getIdClienteRem()));							
					if(!Checks.esNulo(cliente)){
						visita.setCliente(cliente);
					}
				}
				if(!Checks.esNulo(visitaDto.getIdActivoHaya())){
					Activo activo = (Activo) genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "numActivo", visitaDto.getIdActivoHaya()));							
					if(!Checks.esNulo(activo)){
						visita.setActivo(activo);
					}
				}		
				if(!Checks.esNulo(visitaDto.getIdUsuarioRemAccion())){
					Usuario user = (Usuario) genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdUsuarioRemAccion()));							
					if(!Checks.esNulo(user)){
						visita.setUsuarioAccion(user);			
					}
				}
				if(!Checks.esNulo(visitaDto.getCodEstadoVisita())){
					DDEstadosVisita estadoVis = (DDEstadosVisita) genericDao.get(DDEstadosVisita.class, genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodEstadoVisita()));							
					if(!Checks.esNulo(estadoVis)){
						visita.setEstadoVisita(estadoVis);
					}
				}				
				if(!Checks.esNulo(visitaDto.getCodDetalleEstadoVisita())){
					DDSubEstadosVisita subEstVis = (DDSubEstadosVisita) genericDao.get(DDSubEstadosVisita.class, genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodDetalleEstadoVisita()));							
					if(!Checks.esNulo(subEstVis)){
						visita.setSubEstadoVisita(subEstVis);
					}
				}				
				if(!Checks.esNulo(visitaDto.getIdProveedorRemPrescriptor())){
					ActivoProveedor prescriptor= (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemPrescriptor()));							
					if(!Checks.esNulo(prescriptor)){
						visita.setPrescriptor(prescriptor);
					}
				}
				
				if(!Checks.esNulo(visitaDto.getIdProveedorRemResponsable())){
					ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemResponsable()));							
					if(!Checks.esNulo(apiResp)){
						visita.setApiResponsable(apiResp);
					}
				}
				
				if(!Checks.esNulo(visitaDto.getIdProveedorRemCustodio())){
					ActivoProveedor apiCust = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemCustodio()));							
					if(!Checks.esNulo(apiCust)){
						visita.setApiCustodio(apiCust);
					}
				}
				if(!Checks.esNulo(visitaDto.getIdProveedorRemFdv())){
					ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemFdv()));							
					if(!Checks.esNulo(fdv)){
						visita.setFdv(fdv);;
					}
				}			
				if(!Checks.esNulo(visitaDto.getIdProveedorRemVisita())){
					ActivoProveedor pveVisita = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemVisita()));							
					if(!Checks.esNulo(pveVisita)){
						visita.setProveedorVisita(pveVisita);
					}
				}
				
				/*if(!Checks.esNulo(visitaDto.getVisitaApiResponsable())){
					if(visitaDto.getVisitaApiResponsable().booleanValue()){
						visita.setRealizaVisitaApiResponsable(Integer.valueOf(1));
					}else{
						visita.setRealizaVisitaApiResponsable(Integer.valueOf(0));
					}
				}
				if(!Checks.esNulo(visitaDto.getVisitaPrescriptor())){
					if(visitaDto.getVisitaPrescriptor().booleanValue()){
						visita.setRealizaVisitaPrescriptor(Integer.valueOf(1));
					}else{
						visita.setRealizaVisitaPrescriptor(Integer.valueOf(0));
					}
				}
				if(!Checks.esNulo(visitaDto.getVisitaApiCustodio())){
					if(visitaDto.getVisitaApiCustodio().booleanValue()){
						visita.setRealizaVisitaApiCustodio(Integer.valueOf(1));
					}else{
						visita.setRealizaVisitaApiCustodio(Integer.valueOf(0));
					}
				}*/
				if(!Checks.esNulo(visitaDto.getCodEstadoVisita())  && !Checks.esNulo(visitaDto.getFechaAccion())){
					if(visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_ALTA)){
						visita.setFechaSolicitud(visitaDto.getFechaAccion());
					}else if(visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONCERTADA)){
						visita.setFechaConcertacion(visitaDto.getFechaAccion());
					}else if(visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONTACTO)){
						visita.setFechaContacto(visitaDto.getFechaAccion());
					}else if(visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_REALIZADA)){
						visita.setFechaVisita(visitaDto.getFechaAccion());
					}else if(visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_NO_REALIZADA)){
						visita.setFechaVisita(visitaDto.getFechaAccion());
					}
				}
				
				visitaDao.save(visita);	
			}

		}catch (Exception e){
			e.printStackTrace();
			errorsList.add("Ha ocurrido un error en base de datos al dar de alta la visita con idVisitaWebcom: " + visitaDto.getIdVisitaWebcom() + ". Traza: " + e.getMessage());
			return errorsList;
		}
		
		return errorsList;	
	}
	
	
	
	
	
	
	@Override
	@Transactional(readOnly = false)
	public List<String> updateVisita(Visita visita, VisitaDto visitaDto, Object jsonFields) {
		List<String> errorsList = null;
		
		try{
			
			//ValidateUpdate
			errorsList = validateVisitaPostRequestData(visitaDto, jsonFields, false);
			if(errorsList.isEmpty()){
					
				if(((JSONObject)jsonFields).containsKey("idVisitaWebcom")){
					visita.setIdVisitaWebcom(visitaDto.getIdVisitaWebcom());
				}
				if(((JSONObject)jsonFields).containsKey("idVisitaRem")){
					visita.setNumVisitaRem(visitaDto.getIdVisitaRem());
				}
				if(((JSONObject)jsonFields).containsKey("idClienteRem")){
					if(!Checks.esNulo(visitaDto.getIdClienteRem())){
						ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "idClienteRem", visitaDto.getIdClienteRem()));							
						if(!Checks.esNulo(cliente)){
							visita.setCliente(cliente);
						}
					}else{
						visita.setCliente(null);
					}	
				}
				if(((JSONObject)jsonFields).containsKey("idActivoHaya")){
					if(!Checks.esNulo(visitaDto.getIdActivoHaya())){
						Activo activo = (Activo) genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "numActivo", visitaDto.getIdActivoHaya()));							
						if(!Checks.esNulo(activo)){
							visita.setActivo(activo);
						}
					}else{
						visita.setActivo(null);
					}	
				}
				if(((JSONObject)jsonFields).containsKey("codEstadoVisita")){
					if(!Checks.esNulo(visitaDto.getCodEstadoVisita())){
						DDEstadosVisita estadoVis = (DDEstadosVisita) genericDao.get(DDEstadosVisita.class, genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodEstadoVisita()));							
						if(!Checks.esNulo(estadoVis)){
							visita.setEstadoVisita(estadoVis);
						}
					}else{
						visita.setEstadoVisita(null);
					}
				}
				if(((JSONObject)jsonFields).containsKey("codDetalleEstadoVisita")){
					if(!Checks.esNulo(visitaDto.getCodDetalleEstadoVisita())){
						DDSubEstadosVisita subEstVis = (DDSubEstadosVisita) genericDao.get(DDSubEstadosVisita.class, genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodDetalleEstadoVisita()));							
						if(!Checks.esNulo(subEstVis)){
							visita.setSubEstadoVisita(subEstVis);
						}
					}else{
						visita.setSubEstadoVisita(null);
					}	
				}
				if(((JSONObject)jsonFields).containsKey("idUsuarioRemAccion")) {
					if(!Checks.esNulo(visitaDto.getIdUsuarioRemAccion())){
						Usuario user = (Usuario) genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdUsuarioRemAccion()));							
						if(!Checks.esNulo(user)) {
							visita.setUsuarioAccion(user);
						}
					} else {
						visita.setUsuarioAccion(null);
					}
				}
				if(((JSONObject)jsonFields).containsKey("idProveedorRemPrescriptor")){
					if(!Checks.esNulo(visitaDto.getIdProveedorRemPrescriptor())){
						ActivoProveedor prescriptor= (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemPrescriptor()));							
						if(!Checks.esNulo(prescriptor)){
							visita.setPrescriptor(prescriptor);
						}
					}else {
						visita.setPrescriptor(null);
					}
				}
				
				if(((JSONObject)jsonFields).containsKey("idProveedorRemResponsable")){
					if(!Checks.esNulo(visitaDto.getIdProveedorRemResponsable())){
						ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemResponsable()));							
						if(!Checks.esNulo(apiResp)){
							visita.setApiResponsable(apiResp);
						}
					}else {
						visita.setApiResponsable(null);
					}
				}
				
				if(((JSONObject)jsonFields).containsKey("idProveedorRemCustodio")){
					if(!Checks.esNulo(visitaDto.getIdProveedorRemCustodio())){
						ActivoProveedor apiCust = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemCustodio()));							
						if(!Checks.esNulo(apiCust)){
							visita.setApiCustodio(apiCust);
						}
					}else {
						visita.setApiCustodio(null);
					}
				}
				
				if(((JSONObject)jsonFields).containsKey("idProveedorRemFdv")){
					if(!Checks.esNulo(visitaDto.getIdProveedorRemFdv())){
						ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemFdv()));							
						if(!Checks.esNulo(fdv)){
							visita.setFdv(fdv);
						}
					}else {
						visita.setFdv(null);
					}
				}
				
				if(((JSONObject)jsonFields).containsKey("idProveedorRemVisita")){
					if(!Checks.esNulo(visitaDto.getIdProveedorRemVisita())){
						ActivoProveedor pveVisita = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdProveedorRemVisita()));							
						if(!Checks.esNulo(pveVisita)){
							visita.setProveedorVisita(pveVisita);
						}
					}else {
						visita.setProveedorVisita(null);
					}
				}
				
				if(((JSONObject)jsonFields).containsKey("observaciones")){
					visita.setObservaciones(visitaDto.getObservaciones());
				}
			
			/*	if(((JSONObject)jsonFields).containsKey("visitaPrescriptor")){
					if(Checks.esNulo(visitaDto.getVisitaPrescriptor())){
						visita.setRealizaVisitaPrescriptor(null);
					}else if(visitaDto.getVisitaPrescriptor().booleanValue()){
						visita.setRealizaVisitaPrescriptor(Integer.valueOf(1));
					}else{
						visita.setRealizaVisitaPrescriptor(Integer.valueOf(0));
					}
				}
				if(((JSONObject)jsonFields).containsKey("visitaApiResponsable")){
					if(Checks.esNulo(visitaDto.getVisitaApiResponsable())){
						visita.setRealizaVisitaApiResponsable(null);
					}else if(visitaDto.getVisitaApiResponsable().booleanValue()){
						visita.setRealizaVisitaApiResponsable(Integer.valueOf(1));
					}else{
						visita.setRealizaVisitaApiResponsable(Integer.valueOf(0));
					}
				}
				if(((JSONObject)jsonFields).containsKey("visitaApiCustodio")){
					if(Checks.esNulo(visitaDto.getVisitaApiCustodio())){
						visita.setRealizaVisitaApiCustodio(null);
					}else if(visitaDto.getVisitaApiCustodio().booleanValue()){
						visita.setRealizaVisitaApiCustodio(Integer.valueOf(1));
					}else{
						visita.setRealizaVisitaApiCustodio(Integer.valueOf(0));
					}
				}*/
				if(((JSONObject)jsonFields).containsKey("fechaAccion")){
					if(!Checks.esNulo(visitaDto.getCodEstadoVisita()) && !Checks.esNulo(visitaDto.getFechaAccion())){
						if(visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_ALTA)){
							visita.setFechaSolicitud(visitaDto.getFechaAccion());
						}else if(visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONCERTADA)){
							visita.setFechaConcertacion(visitaDto.getFechaAccion());
						}else if(visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONTACTO)){
							visita.setFechaContacto(visitaDto.getFechaAccion());
						}else if(visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_REALIZADA)){
							visita.setFechaVisita(visitaDto.getFechaAccion());
						}else if(visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_NO_REALIZADA)){
							visita.setFechaVisita(visitaDto.getFechaAccion());
						}
					}
				}
		
				visitaDao.saveOrUpdate(visita);
			}

		}catch (Exception e){
			e.printStackTrace();
			errorsList.add("Ha ocurrido un error en base de datos al actualizar la visita con idVisitaWebcom: " + visitaDto.getIdVisitaWebcom() + ". Traza: " + e.getMessage());
			return errorsList;
		}
		
		return errorsList;	
	}
	
	
	
	
	
	@Override
	public List<String> validateVisitaDeleteRequestData(VisitaDto visitaDto) {
		List<String> listaErrores = new ArrayList<String>();
		Visita visita = null;
		
		try{
			
			if(Checks.esNulo(visitaDto.getIdVisitaWebcom())){
				listaErrores.add("El campo IdVisitaWebcom es nulo y es obligatorio.");
		
			}else if(Checks.esNulo(visitaDto.getIdVisitaRem())){
				listaErrores.add("El campo IdVisitaRem es nulo y es obligatorio.");
				
			}else{
				visita = getVisitaByIdVisitaWebcomNumVisitaRem(visitaDto.getIdVisitaWebcom(), visitaDto.getIdVisitaRem());		
				if(Checks.esNulo(visita)){
					listaErrores.add("No existe en REM la visita con idVisitaWebcom: " + visitaDto.getIdVisitaWebcom() + " e idVisitaRem: " + visitaDto.getIdVisitaRem());					
				}
			}
				
		}catch (Exception e){
			e.printStackTrace();
			listaErrores.add("Ha ocurrido un error al validar los parámetros de la visita idVisitaWebcom: " + visitaDto.getIdVisitaWebcom() + ". Traza: " + e.getMessage());
			return listaErrores;
		}
			
		return listaErrores;
	}
	
	
	
	
	
	@Override
	@Transactional(readOnly = false)
	public List<String> deleteVisita(VisitaDto visitaDto) {
		List<String> errorsList = null;
		Visita visita = null;
		
		try{
			
			//ValidateDelete
			errorsList = validateVisitaDeleteRequestData(visitaDto);
			if(errorsList.isEmpty()){			
				visita = getVisitaByIdVisitaWebcomNumVisitaRem(visitaDto.getIdVisitaWebcom(), visitaDto.getIdVisitaRem());		
				if(!Checks.esNulo(visita)){
					visitaDao.delete(visita);
				}else{
					errorsList.add("No existe en REM la visita con idVisitaWebcom: " + visitaDto.getIdVisitaWebcom() + " e idVisitaRem: " + visitaDto.getIdVisitaRem());					
				}				
			}
				
		}catch (Exception e){
			e.printStackTrace();
			errorsList.add("Ha ocurrido un error en base de datos al eliminar la visita idVisitaWebcom: " + visitaDto.getIdVisitaWebcom() + " e idVisitaRem: " + visitaDto.getIdVisitaRem() + ". Traza: " + e.getMessage());
			return errorsList;
		}
		
		return errorsList;
	}
	
	@Override
	public DtoPage getListVisitasDetalle(DtoVisitasFilter dtoVisitasFilter) {
		
		return visitaDao.getListVisitasDetalle(dtoVisitasFilter);
		
	}
	
}

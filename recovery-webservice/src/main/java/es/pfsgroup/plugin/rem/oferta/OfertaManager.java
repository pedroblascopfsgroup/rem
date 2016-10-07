package es.pfsgroup.plugin.rem.oferta;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoOferta.ActivoOfertaPk;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.OfertaTitularAdicionalDto;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Service("ofertaManager")
public class OfertaManager extends BusinessOperationOverrider<OfertaApi> implements  OfertaApi {
	
	
	protected static final Log logger = LogFactory.getLog(OfertaManager.class);
	
	@Resource
    MessageService messageServices;
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private OfertaDao ofertaDao;
	
	@Autowired
	private UpdaterStateApi updaterState;

	@Autowired
	private ParticularValidatorApi particularValidatorApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Override
	public String managerName() {
		return "ofertaManager";
	}
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	
	
	
	@Override
	public Oferta getOfertaById(Long id){		
		Oferta oferta = null;
		
		try{
			
			oferta = ofertaDao.get(id);
		
		} catch(Exception ex) {
			ex.printStackTrace();			
		}
		
		return oferta;
	}
	
	
	
	
	@Override
	public Oferta getOfertaByIdOfertaWebcom(Long idOfertaWebcom) {		
		Oferta oferta = null;
		List<Oferta> lista = null;
		OfertaDto ofertaDto = null;
		
		try{
			
			if(Checks.esNulo(idOfertaWebcom)){
				throw new Exception("El parámetro idOfertaWebcom es obligatorio.");
				
			}else{
				
				ofertaDto = new OfertaDto();
				ofertaDto.setIdOfertaWebcom(idOfertaWebcom);
				
				lista = ofertaDao.getListaOfertas(ofertaDto);		
				if(!Checks.esNulo(lista) && lista.size() > 0){
					oferta = lista.get(0);
				}
			}
			
		} catch(Exception ex) {
			ex.printStackTrace();		
		}
		
		return oferta;
	}
	
	
	
	
	
	@Override
	public Oferta getOfertaByNumOfertaRem(Long numOfertaRem) {		
		Oferta oferta = null;
		List<Oferta> lista = null;
		OfertaDto ofertaDto = null;
		
		try{
			
			if(Checks.esNulo(numOfertaRem)){
				throw new Exception("El parámetro idOfertaRem es obligatorio.");
				
			}else{
				
				ofertaDto = new OfertaDto();
				ofertaDto.setIdOfertaRem(numOfertaRem);
				
				lista = ofertaDao.getListaOfertas(ofertaDto);		
				if(!Checks.esNulo(lista) && lista.size() > 0){
					oferta = lista.get(0);
				}
			}
			
		} catch(Exception ex) {
			ex.printStackTrace();		
		}
		
		return oferta;
	}
	
	
	
	
	
	@Override
	public Oferta getOfertaByIdOfertaWebcomNumOfertaRem(Long idOfertaWebcom, Long numOfertaRem) throws Exception{		
		Oferta oferta = null;
		List<Oferta> lista = null;
		OfertaDto ofertaDto = null;
			
		if(Checks.esNulo(idOfertaWebcom)){
			throw new Exception("El parámetro idOfertaWebcom es obligatorio.");
			
		}else if(Checks.esNulo(numOfertaRem)){
			throw new Exception("El parámetro idOfertaRem es obligatorio.");
			
		}else{
			
			ofertaDto = new OfertaDto();
			ofertaDto.setIdOfertaRem(numOfertaRem);
			ofertaDto.setIdOfertaWebcom(idOfertaWebcom);
			
			lista = ofertaDao.getListaOfertas(ofertaDto);		
			if(!Checks.esNulo(lista) && lista.size() > 0){
				oferta = lista.get(0);
			}
		}
			
		return oferta;
	}
	
	
	@Override
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter) {

		return ofertaDao.getListOfertas(dtoOfertasFilter);
	}
	
	
	@Override
	public List<Oferta> getListaOfertas(OfertaDto ofertaDto){
		List<Oferta> lista = null;
				
		try{
			
			lista = ofertaDao.getListaOfertas(ofertaDto);
		
		} catch(Exception ex) {
			ex.printStackTrace();	
		}
		
		return lista;
	}	
	
	

	
	
	@Override
	public List<String> validateOfertaPostRequestData(OfertaDto ofertaDto, Object jsonFields, Boolean alta) {
		List<String> listaErrores = new ArrayList<String>();
		Oferta oferta = null;
		
		try{
			
			if(Checks.esNulo(ofertaDto.getIdOfertaWebcom())){
				listaErrores.add("El campo IdOfertaWebcom es nulo y es obligatorio.");

			} else {
			
				oferta = getOfertaByIdOfertaWebcom(ofertaDto.getIdOfertaWebcom());		
				if(Checks.esNulo(oferta) && !Checks.esNulo(ofertaDto.getIdOfertaRem())){
					listaErrores.add("No existe en REM el idOfertaWebcom: " + ofertaDto.getIdOfertaWebcom() + " pero si en Webcom con idOfertaRem: " + ofertaDto.getIdOfertaRem());
					
				}
				
				if(alta){
					//Validación para el alta de ofertas
					List<String> error = restApi.validateRequestObject(ofertaDto);
					if (!Checks.esNulo(error) && !error.isEmpty()) {
						listaErrores.add("No se cumple la especificación de parámetros para el alta de idOfertaWebcom: " + ofertaDto.getIdOfertaWebcom() + ".Traza: " + error);			
					}					
				}else{
					//Validación para la actualización de ofertas
					oferta = getOfertaByIdOfertaWebcomNumOfertaRem(ofertaDto.getIdOfertaWebcom(), ofertaDto.getIdOfertaRem());
					if(Checks.esNulo(oferta)){
						listaErrores.add("No existe en REM la oferta con idOfertaWebcom: " + ofertaDto.getIdOfertaWebcom() + " idOfertaRem: " + ofertaDto.getIdOfertaRem());
					}	
					
					if(!Checks.esNulo(jsonFields) && ((JSONObject)jsonFields).containsKey("idClienteRem") && Checks.esNulo(ofertaDto.getIdClienteRem())){
						listaErrores.add("El campo idClienteRem es nulo y es obligatorio en actualizaciones.");					
					}
					
					if(!Checks.esNulo(jsonFields) && ((JSONObject)jsonFields).containsKey("idActivoHaya") && Checks.esNulo(ofertaDto.getIdActivoHaya())){
						listaErrores.add("El campo idActivoHaya es nulo y es obligatorio en actualizaciones.");
					}
					//Mirar si hace falta validar que no se pueda modificar la oferta si ha pasado al comité
					if(!Checks.esNulo(oferta) && !Checks.esNulo(oferta.getEstadoOferta()) && !oferta.getEstadoOferta().getCodigo().equalsIgnoreCase(DDEstadoOferta.CODIGO_PENDIENTE)){
						listaErrores.add("No es posible actualizar la oferta porque se encuentra en el estado: " + oferta.getEstadoOferta().getDescripcion());
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdVisitaRem())){
					Visita visita = (Visita) genericDao.get(Visita.class, genericDao.createFilter(FilterType.EQUALS, "numVisitaRem", ofertaDto.getIdVisitaRem()));							
					if(Checks.esNulo(visita)){
						listaErrores.add("No existe la visita en REM especificado en el campo idVisitaRem: " + ofertaDto.getIdVisitaRem());
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdClienteRem())){
					ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "idClienteRem", ofertaDto.getIdClienteRem()));							
					if(Checks.esNulo(cliente)){
						listaErrores.add("No existe el cliente en REM especificado en el campo idClienteRem: " + ofertaDto.getIdClienteRem());
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdActivoHaya())){
					Activo activo = (Activo) genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "numActivo", ofertaDto.getIdActivoHaya()));							
					if(Checks.esNulo(activo)){
						listaErrores.add("No existe el activo en REM especificado en el campo idActivoHaya: " + ofertaDto.getIdActivoHaya());
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdUsuarioRemAccion())){
					Usuario user = (Usuario) genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdUsuarioRemAccion()));							
					if(Checks.esNulo(user)){
						listaErrores.add("No existe el usuario en REM especificado en el campo idUsuarioRem: " + ofertaDto.getIdUsuarioRemAccion());
					}
				}
				if(!Checks.esNulo(ofertaDto.getCodEstadoOferta())){
					//Perimetros: NO se pueden ACEPTAR Ofertas en activos que no tengan condicion comercial en el perimetro
					// Se valida lo primero pq debe hacerse aunque el diccionario tenga borrado logico del estado aceptada
					if(DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaDto.getCodEstadoOferta())){
						listaErrores.add(messageServices.getMessage("oferta.validacion.errorMensaje.perimetroSinComercial"));
					}
					DDEstadoOferta estadoOfr = (DDEstadoOferta) genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodEstadoOferta()));							
					if(Checks.esNulo(estadoOfr)){
						listaErrores.add("No existe el código del estado de la oferta especificado en el campo codEstadoOferta: " + ofertaDto.getCodEstadoOferta());
					}else{
						if(!ofertaDto.getCodEstadoOferta().equals(DDEstadoOferta.CODIGO_PENDIENTE) && !ofertaDto.getCodEstadoOferta().equals(DDEstadoOferta.CODIGO_RECHAZADA)){
							listaErrores.add("Código de estado no permitido. Valores permitidos: ".concat(DDEstadoOferta.CODIGO_PENDIENTE).concat(",").concat(DDEstadoOferta.CODIGO_RECHAZADA));
						}
					}
				}				
				if(!Checks.esNulo(ofertaDto.getCodTipoOferta())){
					DDTipoOferta tipoOfr = (DDTipoOferta) genericDao.get(DDTipoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodTipoOferta()));							
					if(Checks.esNulo(tipoOfr)){
						listaErrores.add("No existe el código del tipo de la oferta en REM especificado en el campo codTipoOferta: " + ofertaDto.getCodTipoOferta());
					}
				}							
				if(!Checks.esNulo(ofertaDto.getIdProveedorRemPrescriptor())){
					ActivoProveedor pres = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdProveedorRemPrescriptor()));							
					if(Checks.esNulo(pres)){
						listaErrores.add("No existe el prescriptor en REM especificado en el campo idProveedorRemPrescriptor: " + ofertaDto.getIdProveedorRemPrescriptor());
					}
				}	
				if(!Checks.esNulo(ofertaDto.getIdProveedorRemCustodio())){
					ActivoProveedor cust = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdProveedorRemCustodio()));							
					if(Checks.esNulo(cust)){
						listaErrores.add("No existe el apiResponsable en REM especificado en el campo idProveedorRemResponsable: " + ofertaDto.getIdProveedorRemCustodio());
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdProveedorRemResponsable())){
					ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdProveedorRemResponsable()));							
					if(Checks.esNulo(apiResp)){
						listaErrores.add("No existe el apiResponsable en REM especificado en el campo idProveedorRemResponsable: " + ofertaDto.getIdProveedorRemResponsable());
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdProveedorRemFdv())){
					ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdProveedorRemFdv()));							
					if(Checks.esNulo(fdv)){
						listaErrores.add("No existe el apiResponsable en REM especificado en el campo idProveedorRemResponsable: " + ofertaDto.getIdProveedorRemFdv());
					}
				}
				if(!Checks.esNulo(ofertaDto.getTitularesAdicionales())){					
					for(int i=0; i < ofertaDto.getTitularesAdicionales().size();i++){
						OfertaTitularAdicionalDto titDto = ofertaDto.getTitularesAdicionales().get(i);
						if(!Checks.esNulo(titDto)){
							DDTipoDocumento tpd = (DDTipoDocumento) genericDao.get(DDTipoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodTipoDocumento()));							
							if(Checks.esNulo(tpd)){
								listaErrores.add("No existe el tipo de documento en REM especificado en el campo codTipoDocumento: " + titDto.getCodTipoDocumento());
							}
						}
					}
				}
			}
			
		}catch (Exception e){
			e.printStackTrace();
			listaErrores.add("Ha ocurrido un error al validar los parámetros de la oferta idOfertaWebcom: " + ofertaDto.getIdOfertaWebcom() + ". Traza: " + e.getMessage());
			return listaErrores;
		}
			
		return listaErrores;
	}
	

	
	
	
	@Override
	@Transactional(readOnly = false)
	public List<String> saveOferta(OfertaDto ofertaDto) {
		Oferta oferta = null;
		List<String> errorsList = null;
		
		try{
		
			//ValidateAlta
			errorsList = validateOfertaPostRequestData(ofertaDto, null, true);
			if(errorsList.isEmpty()){
				
				oferta = new Oferta();
				beanUtilNotNull.copyProperties(oferta, ofertaDto);	
				if(!Checks.esNulo(ofertaDto.getIdOfertaWebcom())){
					oferta.setIdWebCom(ofertaDto.getIdOfertaWebcom());
				}				
				oferta.setNumOferta(ofertaDao.getNextNumOfertaRem());				
				if(!Checks.esNulo(ofertaDto.getImporteContraoferta())){
					oferta.setImporteContraOferta(ofertaDto.getImporteContraoferta());
				}
				if(!Checks.esNulo(ofertaDto.getIdVisitaRem())){
					Visita visita = (Visita) genericDao.get(Visita.class, genericDao.createFilter(FilterType.EQUALS, "numVisitaRem", ofertaDto.getIdVisitaRem()));							
					if(!Checks.esNulo(visita)){
						oferta.setVisita(visita);
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdClienteRem())){
					ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "idClienteRem", ofertaDto.getIdClienteRem()));							
					if(!Checks.esNulo(cliente)){
						oferta.setCliente(cliente);
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdActivoHaya())){
					ActivoOferta actOfr = null;	
					List<ActivoOferta> listaActOfr = new ArrayList<ActivoOferta>();
					List<ActivoAgrupacionActivo> listaAgrups = null;
					List<ActivoAgrupacionActivo> listaActivos = null;
					List<Activo> lact = new ArrayList<Activo>();
					
					Activo activo = (Activo) genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "numActivo", ofertaDto.getIdActivoHaya()));							
					if(!Checks.esNulo(activo)){				
						//Añadimos el activo de la oferta
						lact.add(activo);	
						actOfr = buildActivoOferta(activo, oferta, null);
						listaActOfr.add(actOfr);
						
						//Añadimos a la oferta el resto de activos de las agupaciones restringidas a las que pertenece el activo
						DtoAgrupacionFilter dtoAgrupActivo = new DtoAgrupacionFilter();
						dtoAgrupActivo.setActId(activo.getId());
						dtoAgrupActivo.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);
						listaAgrups = activoAgrupacionActivoApi.getListActivosAgrupacion(dtoAgrupActivo);
						if(!Checks.esNulo(listaAgrups) && listaAgrups.size()>0){
							//Recorremos las agrupaciones del activo						
							for(int i=0; i < listaAgrups.size();i++){
								ActivoAgrupacionActivo agrAct = listaAgrups.get(i);
								if(!Checks.esNulo(agrAct) && !Checks.esNulo(agrAct.getAgrupacion())){
									oferta.setAgrupacion(agrAct.getAgrupacion());
									DtoAgrupacionFilter dtoAgrupActivo2 = new DtoAgrupacionFilter();
									dtoAgrupActivo2.setAgrId(agrAct.getAgrupacion().getId());
									listaActivos = activoAgrupacionActivoApi.getListActivosAgrupacion(dtoAgrupActivo2);
									
									if(!Checks.esNulo(listaActivos) && listaActivos.size()>0){
										//Para cada agrupacion obtenemos los activos de la agrupacion para añadirlos a la oferta.
										for(int j=0; j < listaActivos.size();j++){
											agrAct = listaActivos.get(j);
											if(!Checks.esNulo(agrAct) && !Checks.esNulo(agrAct.getActivo()) && !Checks.esNulo(lact) && !lact.contains(agrAct.getActivo())){	
												lact.add(agrAct.getActivo());	
												actOfr = buildActivoOferta(agrAct.getActivo(), oferta, null);
												listaActOfr.add(actOfr);
											}
										}
									}
								}									
							}			
						}
						if(!Checks.esNulo(listaActOfr) && listaActOfr.size()>0){	
							oferta.setActivosOferta(listaActOfr);
						}
					}
				}		
				if(!Checks.esNulo(ofertaDto.getIdUsuarioRemAccion())){
					Usuario user = (Usuario) genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdUsuarioRemAccion()));							
					if(!Checks.esNulo(user)){
						oferta.setUsuarioAccion(user);			
					}
				}
				DDEstadoOferta estadoOfr = null;
				if(!Checks.esNulo(ofertaDto.getCodEstadoOferta())){
					estadoOfr = (DDEstadoOferta) genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodEstadoOferta()));							
					if(!Checks.esNulo(estadoOfr)){
						oferta.setEstadoOferta(estadoOfr);
					}
				}		
				if(!Checks.esNulo(ofertaDto.getCodTipoOferta())){
					DDTipoOferta tipoOfr = (DDTipoOferta) genericDao.get(DDTipoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodTipoOferta()));							
					if(!Checks.esNulo(tipoOfr)){
						oferta.setTipoOferta(tipoOfr);
					}
				}				
				if(!Checks.esNulo(ofertaDto.getIdProveedorRemPrescriptor())){
					ActivoProveedor prescriptor= (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdProveedorRemPrescriptor()));							
					if(!Checks.esNulo(prescriptor)){
						oferta.setPrescriptor(prescriptor);
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdProveedorRemCustodio())){
					ActivoProveedor cust = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdProveedorRemFdv()));							
					if(!Checks.esNulo(cust)){
						oferta.setCustodio(cust);;
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdProveedorRemResponsable())){
					ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdProveedorRemResponsable()));							
					if(!Checks.esNulo(apiResp)){
						oferta.setApiResponsable(apiResp);
					}
				}
				if(!Checks.esNulo(ofertaDto.getIdProveedorRemFdv())){
					ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", ofertaDto.getIdProveedorRemFdv()));							
					if(!Checks.esNulo(fdv)){
						oferta.setFdv(fdv);
					}
				}
				if(!Checks.esNulo(ofertaDto.getImporte())){
					oferta.setImporteOferta(ofertaDto.getImporte());
				}
				if(!Checks.esNulo(ofertaDto.getTitularesAdicionales())){
					List<TitularesAdicionalesOferta> listaTit = new ArrayList<TitularesAdicionalesOferta>();
					
					for(int i=0; i < ofertaDto.getTitularesAdicionales().size();i++){
						OfertaTitularAdicionalDto titDto = ofertaDto.getTitularesAdicionales().get(i);
						if(!Checks.esNulo(titDto)){
							TitularesAdicionalesOferta titAdi = new TitularesAdicionalesOferta();
							titAdi.setNombre(titDto.getNombre());
							titAdi.setDocumento(titDto.getDocumento());
							titAdi.setOferta(oferta);
							Auditoria auditoria = Auditoria.getNewInstance();
							titAdi.setAuditoria(auditoria);
							titAdi.setTipoDocumento((DDTipoDocumento) genericDao.get(DDTipoDocumento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", titDto.getCodTipoDocumento())));
							listaTit.add(titAdi);
						}						
					}
					oferta.setTitularesAdicionales(listaTit);

				}
				
				if(ofertaDto.getCodEstadoOferta().equals(DDEstadoOferta.CODIGO_PENDIENTE)){
					oferta.setFechaAlta(ofertaDto.getFechaAccion());
				}else if(ofertaDto.getCodEstadoOferta().equals(DDEstadoOferta.CODIGO_RECHAZADA)){
					oferta.setFechaRechazoOferta(ofertaDto.getFechaAccion());
				}
				
				ofertaDao.save(oferta);
				
				//Si la oferta tiene estado, hay que actualizar la disposicion comercial del activo
				if(!Checks.esNulo(estadoOfr)){
					this.updateStateDispComercialActivosByOferta(oferta);
				}

			}

		}catch (Exception e){
			e.printStackTrace();
			errorsList.add("Ha ocurrido un error en base de datos al dar de alta la oferta con idOfertaWebcom: " + ofertaDto.getIdOfertaWebcom() + ". Traza: " + e.getMessage());
			return errorsList;
		}
		
		return errorsList;	
	}
	
	
	
	
	
	
	@Override
	@Transactional(readOnly = false)
	public List<String> updateOferta(Oferta oferta, OfertaDto ofertaDto, Object jsonFields) {
		List<String> errorsList = null;
		try{
			
			//ValidateUpdate
			errorsList = validateOfertaPostRequestData(ofertaDto, jsonFields, false);
			if(errorsList.isEmpty()){
				
				if(((JSONObject)jsonFields).containsKey("importeContraoferta")){
					oferta.setImporteContraOferta(ofertaDto.getImporteContraoferta());
				}
				DDEstadoOferta estadoOfr = null;
				if(((JSONObject)jsonFields).containsKey("codEstadoOferta")){
					if(!Checks.esNulo(ofertaDto.getCodEstadoOferta())){
						estadoOfr = (DDEstadoOferta) genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", ofertaDto.getCodEstadoOferta()));							
						if(!Checks.esNulo(estadoOfr)){
							oferta.setEstadoOferta(estadoOfr);
						}
					}else{
						oferta.setEstadoOferta(null);
					}
				}
				if(ofertaDto.getCodEstadoOferta().equals(DDEstadoOferta.CODIGO_PENDIENTE)){
					oferta.setFechaAlta(ofertaDto.getFechaAccion());
				}else if(ofertaDto.getCodEstadoOferta().equals(DDEstadoOferta.CODIGO_RECHAZADA)){
					oferta.setFechaRechazoOferta(ofertaDto.getFechaAccion());
				}
				ofertaDao.saveOrUpdate(oferta);
				
				//Si la oferta tiene estado, hay que actualizar la disposicion comercial del activo
				if(!Checks.esNulo(estadoOfr)){
					this.updateStateDispComercialActivosByOferta(oferta);
				}
			}

		}catch (Exception e){
			e.printStackTrace();
			errorsList.add("Ha ocurrido un error en base de datos al actualizar la oferta con idOfertaWebcom: " + ofertaDto.getIdOfertaWebcom() + ". Traza: " + e.getMessage());
			return errorsList;
		}
		
		return errorsList;	
	}
	
	
	
	private ActivoOferta buildActivoOferta(Activo activo, Oferta oferta, Double importe) {
		ActivoOfertaPk pk = new ActivoOfertaPk();
		ActivoOferta activoOferta = new ActivoOferta();
		pk.setActivo(activo);
		pk.setOferta(oferta);
		
		activoOferta.setPrimaryKey(pk);
		activoOferta.setImporteActivoOferta(importe);
		return activoOferta;
	}

	@Override
	public DDEstadoOferta getDDEstadosOfertaByCodigo(String codigo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		return genericDao.get(DDEstadoOferta.class, filtro);
	}
	
	@Override
	@Transactional
	public void updateStateDispComercialActivosByOferta(Oferta oferta) {
		
		for(ActivoOferta activoOferta : oferta.getActivosOferta()) {
			Activo activo = activoOferta.getPrimaryKey().getActivo();
			updaterState.updaterStateDisponibilidadComercial(activo);
		}
	}
	
	@Override
	public Oferta getOfertaAceptadaByActivo(Activo activo){
		List<ActivoOferta> listaOfertas = activo.getOfertas();
		
		for(ActivoOferta activoOferta : listaOfertas){
			Oferta oferta = activoOferta.getPrimaryKey().getOferta();
			if(DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo()))
					return oferta;
		}
		return null;
	}
	
	@Override
	public boolean checkDeDerechoTanteo(TareaExterna tareaExterna){
		return false;
	}
	
	
	@Override
	public boolean checkReserva(TareaExterna tareaExterna){
		Trabajo trabajo = trabajoApi.tareaExternaToTrabajo(tareaExterna);
		if(!Checks.esNulo(trabajo)){
			Activo activo = trabajo.getActivo();
			if(!Checks.esNulo(activo)){
				Oferta ofertaAceptada = getOfertaAceptadaByActivo(activo);
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				return !Checks.esNulo(expediente.getReserva());
			}
		}
		return false;
	}
	
}

package es.pfsgroup.plugin.rem.activo;

import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.api.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoAutorizacionTramitacionOfertas;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.AgrupacionesVigencias;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecificaAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoEstadoDisponibilidadComercial;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.model.DtoTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoVActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoVigenciaAgrupacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VActivosAfectosGencatAgrupacion;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacionLil;
import es.pfsgroup.plugin.rem.model.VListaActivosAgrupacionVSCondicionantes;
import es.pfsgroup.plugin.rem.model.VSubdivisionesAgrupacion;
import es.pfsgroup.plugin.rem.model.VTramitacionOfertaAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDDescripcionFotoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAutorizacionTramitacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PLANO;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PRINCIPAL;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PROPIEDAD;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SITUACION;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SUELOS;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.TIPO;
import es.pfsgroup.plugin.rem.rest.dto.ActivosLoteOfertaDto;
import es.pfsgroup.plugin.rem.rest.dto.File;
import es.pfsgroup.plugin.rem.rest.dto.FileListResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileSearch;
import es.pfsgroup.recovery.api.UsuarioApi;
import javassist.expr.NewArray;

import org.springframework.transaction.support.DefaultTransactionDefinition;

import javax.annotation.Resource;

@Service("activoAgrupacionManager")
public class ActivoAgrupacionManager implements ActivoAgrupacionApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

	protected static final Log logger = LogFactory.getLog(ActivoAgrupacionManager.class);

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoAgrupacionDao activoAgrupacionDao;

	@Autowired
	GestorDocumentalFotosApi gestorDocumentalFotos;

	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private UsuarioManager usuarioApi;
	
	@Autowired
	private ActivoAgrupacionFactoryApi activoAgrupacionFactoryApi;
	
	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	private String USUARIO_IT = "HAYASUPER";
	private String GESTOR_COMERCIAL_ALQUILER = "HAYAGESTCOM";  
	private String SUPERVISOR_COMERCIAL_ALQUILER = "HAYASUPCOM";

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.get")
	public ActivoAgrupacion get(Long id) {
		return activoAgrupacionDao.get(id);
	}

	public Long getAgrupacionIdByNumAgrupRem(Long numAgrupRem) {
		return activoAgrupacionDao.getAgrupacionIdByNumAgrupRem(numAgrupRem);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.saveOrUpdate")
	@Transactional
	public boolean saveOrUpdate(ActivoAgrupacion activoAgrupacion) {
		activoAgrupacionDao.saveOrUpdate(activoAgrupacion);
		return true;
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.deleteById")
	@Transactional
	public boolean deleteById(Long id) {
		activoAgrupacionDao.deleteById(id);
		return true;
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.getListAgrupaciones")
	public Page getListAgrupaciones(DtoAgrupacionFilter dto, Usuario usuarioLogado) {
		return activoAgrupacionDao.getListAgrupaciones(dto, usuarioLogado);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.getListActivosAgrupacionById")
	public Page getListActivosAgrupacionById(DtoAgrupacionFilter dto, Usuario usuarioLogado,Boolean little) {
		return activoAgrupacionDao.getListActivosAgrupacionById(dto, usuarioLogado,little);
	}
	

	@SuppressWarnings("unchecked")
	public DtoEstadoDisponibilidadComercial getListActivosAgrupacionByIdActivo(DtoAgrupacionFilter dto, Usuario usuarioLogado) {
		
		DtoEstadoDisponibilidadComercial dtoEstadoDispcom = new DtoEstadoDisponibilidadComercial();
		List<DtoVActivosAgrupacion> listaDto = new ArrayList<DtoVActivosAgrupacion>();
		List<VActivosAgrupacionLil> lAgrupaActivos =  (List<VActivosAgrupacionLil>) activoAgrupacionDao.getListActivosAgrupacionById(dto, usuarioLogado,true).getResults();
		 
		for(VActivosAgrupacionLil actAgrup : lAgrupaActivos) {
			DtoVActivosAgrupacion dtoVActAgrup = new DtoVActivosAgrupacion();	
			VListaActivosAgrupacionVSCondicionantes vCondicionante = genericDao.get(VListaActivosAgrupacionVSCondicionantes.class, genericDao.createFilter(FilterType.EQUALS, "activoId",actAgrup.getActivoId()), genericDao.createFilter(FilterType.EQUALS, "agrId", actAgrup.getAgrId()));
			if(!Checks.esNulo(vCondicionante)) {
				if(vCondicionante.getConCargas() || vCondicionante.getDivHorizontalNoInscrita() || vCondicionante.getIsCondicionado() || vCondicionante.getObraNuevaEnConstruccion() ||
						vCondicionante.getObraNuevaSinDeclarar() || vCondicionante.getOcupadoConTitulo() || vCondicionante.getOcupadoSinTitulo() || vCondicionante.getPendienteInscripcion() ||
						vCondicionante.getPortalesExternos() || vCondicionante.getProindiviso() || vCondicionante.getRuina() || vCondicionante.getSinInformeAprobado() ||
						vCondicionante.getSinTomaPosesionInicial() || vCondicionante.getTapiado() || vCondicionante.getVandalizado()) {
					
					dtoVActAgrup.setEstadoSituacionComercial(true);
					
				}else {
					dtoVActAgrup.setEstadoSituacionComercial(false);
				}
			}
			
			listaDto.add(dtoVActAgrup);
		}
		 
		dtoEstadoDispcom.setListado(listaDto);
		dtoEstadoDispcom.setTotalCount(lAgrupaActivos.size());
		
		return  dtoEstadoDispcom;
	}

	@Override
	public Long getNextNumAgrupacionRemManual() {
		return activoAgrupacionDao.getNextNumAgrupacionRemManual();
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.haveActivoPrincipal")
	public Long haveActivoPrincipal(Long id) {
		return activoAgrupacionDao.haveActivoPrincipal(id);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.haveActivoRestringidaAndObraNueva")
	public Long haveActivoRestringidaAndObraNueva(Long id) {
		return activoAgrupacionDao.haveActivoRestringidaAndObraNueva(id);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.uploadFotos")
	@Transactional(readOnly = false)
	public String uploadFotos(List<WebFileItem> webFileItemList) {

		for(WebFileItem webFileItem : webFileItemList) {
			Long idAgrupacion = Long.parseLong(webFileItem.getParameter("idEntidad"));
			ActivoAgrupacion agrupacion = this.get(idAgrupacion);
			SUELOS suelos = Boolean.valueOf(webFileItem.getParameter("suelos")) ? SUELOS.SI : SUELOS.NO;
			PLANO plano = Boolean.valueOf(webFileItem.getParameter("plano")) ? PLANO.SI : PLANO.NO;
			if(agrupacion != null) {
				Integer orden = activoApi.getMaxOrdenFotoByIdSubdivision(idAgrupacion, null) + 1;
				ActivoFoto activoFoto = null;
				FileResponse fileReponse = null;
				try {
					if (gestorDocumentalFotos.isActive()) {
						
						if (webFileItem.getParameter("codigoDescripcionFoto") != null) {
							
							DDDescripcionFotoActivo descripcionFoto = genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("codigoDescripcionFoto")));
							
							if (descripcionFoto != null ) {
								fileReponse = gestorDocumentalFotos.upload(webFileItem.getFileItem().getFile(),webFileItem.getFileItem().getFileName(),
										PROPIEDAD.AGRUPACION, idAgrupacion, null, descripcionFoto.getDescripcion(), null, null, orden, suelos, plano);
							}
						}
						activoFoto = new ActivoFoto(fileReponse.getData());
		
					} else {
						activoFoto = new ActivoFoto(webFileItem.getFileItem());
						activoFoto.setOrden(orden);
					}
		
					activoFoto.setAgrupacion(agrupacion);
					activoFoto.setTamanyo(webFileItem.getFileItem().getLength());
					activoFoto.setNombre(webFileItem.getFileItem().getFileName());
					activoFoto.setDescripcion(genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("codigoDescripcionFoto"))).getDescripcion());
					activoFoto.setDescripcionFoto(genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("codigoDescripcionFoto"))));
					activoFoto.setPrincipal(true);
					activoFoto.setSuelos(suelos == SUELOS.SI ? true : false);
					activoFoto.setPlano(plano == PLANO.SI ? true : false);
					activoFoto.setFechaDocumento(new Date());
					Auditoria.save(activoFoto);
					agrupacion.getFotos().add(activoFoto);
		
					activoAgrupacionDao.save(agrupacion);
				} catch (Exception e) {
		
				}
			}
		}
		
		return "success";

	}

	@Override
	@Transactional(readOnly = false)
	public String uploadFoto(File fileItem) throws Exception {
		if (fileItem.getMetadata().get("id_agrupacion_haya") == null) {
			throw new Exception("La foto no tiene agrupacion");
		}

		Long agrupacionId = Long.parseLong(fileItem.getMetadata().get("id_agrupacion_haya"));
		Long subdivisionId = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", agrupacionId);
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);
		try {
			if (agrupacion != null) {
				ActivoFoto activoFoto = activoAdapter.getFotoActivoByRemoteId(fileItem.getId());
				if (activoFoto == null) {
					activoFoto = new ActivoFoto(fileItem);
				}

				activoFoto.setAgrupacion(agrupacion);
				
				if (fileItem.getMetadata().get("id_subdivision") != null) {
					subdivisionId = Long.parseLong(fileItem.getMetadata().get("id_subdivision"));
					activoFoto.setSubdivision(subdivisionId); 
				}

				activoFoto.setNombre(fileItem.getBasename());
				
				String descripcion = null;
				String codigoSubtipoActivo = DDSubtipoActivo.CODIGO_EN_CONSTRUCCION;
				
				if (subdivisionId != null) {
					codigoSubtipoActivo = genericDao.get(VSubdivisionesAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "id", subdivisionId),
							genericDao.createFilter(FilterType.EQUALS, "agrupacionId", agrupacionId)).getCodigoSubtipoActivo();
				}
				DDDescripcionFotoActivo descripcionFoto = null;

				if (fileItem.getMetadata().containsKey("descripcion")) {
					descripcion = fileItem.getMetadata().get("descripcion");
					if (descripcion != null && codigoSubtipoActivo != null) {
						descripcionFoto = genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "descripcion", descripcion), 
							genericDao.createFilter(FilterType.EQUALS, "subtipoActivo.codigo", codigoSubtipoActivo));
					}
					if (descripcionFoto != null) {
						activoFoto.setDescripcion(descripcionFoto.getDescripcion());
						activoFoto.setDescripcionFoto(descripcionFoto);
					}
				}

				activoFoto.setPrincipal(false);

				Date fechaSubida = new Date();
				if (fileItem.getMetadata().containsKey("fecha_subida")) {
					try {
						fechaSubida = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
								.parse(fileItem.getMetadata().get("fecha_subida"));
					} catch (Exception e) {
						logger.error("El webservice del Gestor documental ha enviado una fecha sin formato");
					}
				}

				activoFoto.setFechaDocumento(fechaSubida);
				
				Integer orden = null;
				if (fileItem.getMetadata().containsKey("orden") && fileItem.getMetadata().get("orden") != null) {
					String ordenCadena = fileItem.getMetadata().get("orden");
					if(ordenCadena.matches("^[-+]?[0-9]+$") ) { 
						try {
							orden = Integer.valueOf(ordenCadena);
						}catch(NumberFormatException ex) {
							orden = null;
						}
						
					}
				}
				if (orden == null && agrupacionId != null) {
					orden = activoApi.getMaxOrdenFotoByIdSubdivision(agrupacionId, subdivisionId) + 1;
				}
				activoFoto.setOrden(orden);
				
				if (fileItem.getMetadata().containsKey("plano") 
						&& fileItem.getMetadata().get("plano") != null) {
					if (fileItem.getMetadata().get("plano").equals("1")) {
						activoFoto.setPlano(true);
					} else {
						activoFoto.setPlano(false);
					}
				}
				
				if (fileItem.getMetadata().containsKey("suelos") 
						&& fileItem.getMetadata().get("suelos") != null) {
					if (fileItem.getMetadata().get("suelos").equals("1")) {
						activoFoto.setSuelos(true);
					} else {
						activoFoto.setSuelos(false);
					}
				}
				
				genericDao.save(ActivoFoto.class, activoFoto);

			} else {
				throw new Exception("La foto esta asociada a una agrupacion inexistente");
			}
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return "success";
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.uploadFotosSubdivision")
	@Transactional(readOnly = false)
	public String uploadFotosSubdivision(List<WebFileItem> webFileItemList) {

		for(WebFileItem webFileItem : webFileItemList) {
			Long subdivisionId = Long.parseLong(webFileItem.getParameter("id"));
			Long agrupacionId = Long.parseLong(webFileItem.getParameter("agrId"));
			Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			DDTipoFoto tipoFoto = genericDao.get(DDTipoFoto.class, filtroTipo);
			TIPO tipo = null;
			SITUACION situacion;
			PRINCIPAL principal = null;
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", agrupacionId);
			ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);
			FileResponse fileReponse = null;
			ActivoFoto activoFoto = null;
			Integer orden = activoApi.getMaxOrdenFotoByIdSubdivision(agrupacionId, subdivisionId);
			orden++;
			try {
				//el gestor documental no esta activo en local/inte, para probar negarlo
				if (gestorDocumentalFotos.isActive()) {
					
					if (tipoFoto.getCodigo().equals("01")) {
						tipo = TIPO.WEB;
					} else if (tipoFoto.getCodigo().equals("02")) {
						tipo = TIPO.TECNICA;
					} else if (tipoFoto.getCodigo().equals("03")) {
						tipo = TIPO.TESTIGO;
					}
					if (Boolean.valueOf(webFileItem.getParameter("principal"))) {
						principal = PRINCIPAL.SI;
					} else {
						principal = PRINCIPAL.NO;
					}
					if (Boolean.valueOf(webFileItem.getParameter("interiorExterior"))) {
						situacion = SITUACION.INTERIOR;
					} else {
						situacion = SITUACION.EXTERIOR;
					}
					
					if (webFileItem.getParameter("codigoDescripcionFoto") != null) {
					
						fileReponse = gestorDocumentalFotos.uploadSubdivision(webFileItem.getFileItem().getFile(),
								webFileItem.getFileItem().getFileName(), subdivisionId, agrupacion,
								genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("codigoDescripcionFoto"))).getDescripcion(),
								tipo,principal,situacion, orden);
						
					}
						 
					activoFoto = new ActivoFoto(fileReponse.getData());

				} else {
					activoFoto = new ActivoFoto(webFileItem.getFileItem());
					activoFoto.setOrden(orden);
				}

				activoFoto.setSubdivision(subdivisionId);
				activoFoto.setAgrupacion(agrupacion);
				activoFoto.setTamanyo(webFileItem.getFileItem().getLength());
				activoFoto.setNombre(webFileItem.getFileItem().getFileName());				
				activoFoto.setDescripcion(genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("codigoDescripcionFoto"))).getDescripcion());
				activoFoto.setDescripcionFoto(genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("codigoDescripcionFoto"))));
				activoFoto.setPrincipal(Boolean.valueOf(webFileItem.getParameter("principal")));			
				activoFoto.setTipoFoto(tipoFoto);			
				activoFoto.setInteriorExterior(Boolean.valueOf(webFileItem.getParameter("interiorExterior")));
				activoFoto.setFechaDocumento(new Date());			
				Auditoria.save(activoFoto);
				agrupacion.getFotos().add(activoFoto);

				genericDao.save(ActivoAgrupacion.class, agrupacion);
				
			} catch (Exception e) {
				logger.error(e);
			}
		}
		
		return "success";
	}

	@Transactional(readOnly = false)
	public String uploadFotoSubdivision(File fileItem) throws Exception {
		if (fileItem.getMetadata().get("id_subdivision") == null) {
			throw new Exception("La foto no tiene subdivision");
		}
		if (fileItem.getMetadata().get("id_agrupacion_haya") == null) {
			throw new Exception("La foto no tiene agrupacion");
		}
		Long subdivisionId = Long.parseLong(fileItem.getMetadata().get("id_subdivision"));
		Long agrupacionId = Long.parseLong(fileItem.getMetadata().get("id_agrupacion_haya"));
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", agrupacionId);
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);
		try {
			if (agrupacion != null) {
				ActivoFoto activoFoto;
				activoFoto = activoAdapter.getFotoActivoByRemoteId(fileItem.getId());
				if (activoFoto == null) {
					activoFoto = new ActivoFoto(fileItem);
				}

				activoFoto.setSubdivision(subdivisionId);

				activoFoto.setAgrupacion(agrupacion);

				activoFoto.setNombre(fileItem.getBasename());
				
				String descripcion = null;
				String codigoSubtipoActivo = null;
				VSubdivisionesAgrupacion subdivision = genericDao.get(VSubdivisionesAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "id", subdivisionId),
						genericDao.createFilter(FilterType.EQUALS, "agrupacionId", agrupacion.getId()));
				if(subdivision != null) {
					codigoSubtipoActivo = subdivision.getCodigoSubtipoActivo();
				}
				DDDescripcionFotoActivo descripcionFoto = null;

				if (fileItem.getMetadata().containsKey("descripcion")) {
					descripcion = fileItem.getMetadata().get("descripcion");
					if (descripcion != null && codigoSubtipoActivo != null) {
						descripcionFoto = genericDao.get(DDDescripcionFotoActivo.class, genericDao.createFilter(FilterType.EQUALS, "descripcion", descripcion), 
							genericDao.createFilter(FilterType.EQUALS, "subtipoActivo.codigo", codigoSubtipoActivo));
					}
					if (descripcionFoto != null) {
						activoFoto.setDescripcion(descripcionFoto.getDescripcion());
						activoFoto.setDescripcionFoto(descripcionFoto);
					}				
				}

				activoFoto.setPrincipal(false);

				Date fechaSubida = new Date();
				if (fileItem.getMetadata().containsKey("fecha_subida")) {
					try {
						fechaSubida = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
								.parse(fileItem.getMetadata().get("fecha_subida"));
					} catch (Exception e) {
						logger.error("El webservice del Gestor documental ha enviado una fecha sin formato");
					}
				}

				activoFoto.setFechaDocumento(fechaSubida);
				Integer orden = null;
				if (fileItem.getMetadata().containsKey("orden") && fileItem.getMetadata().get("orden") != null) {
					String ordenCadena = fileItem.getMetadata().get("orden");
					if(ordenCadena.matches("^[-+]?[0-9]+$") ) { 
						try {
							orden = Integer.valueOf(ordenCadena);
						}catch(NumberFormatException ex) {
							orden = null;
						}
						
					}
				}
				if (orden == null && agrupacionId != null) {
					orden = activoApi.getMaxOrdenFotoByIdSubdivision(agrupacionId, subdivisionId) + 1;
				}
				activoFoto.setOrden(orden);
				
				if (fileItem.getMetadata().containsKey("plano") 
						&& fileItem.getMetadata().get("plano") != null) {
					if (fileItem.getMetadata().get("plano").equals("1")) {
						activoFoto.setPlano(true);
					} else {
						activoFoto.setPlano(false);
					}
				}
				
				if (fileItem.getMetadata().containsKey("suelos") 
						&& fileItem.getMetadata().get("suelos") != null) {
					if (fileItem.getMetadata().get("suelos").equals("1")) {
						activoFoto.setSuelos(true);
					} else {
						activoFoto.setSuelos(false);
					}
				}
				genericDao.save(ActivoFoto.class, activoFoto);

			} else {
				logger.error("La foto esta asociada a una subdivision inexsitente");
			}
		} catch (Exception e) {
			logger.error("Error guardando la foto de la subdivision", e);
			throw new Exception(e.getMessage());
		}
		return "success";
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.getFotosActivosAgrupacionById")
	public List<ActivoFoto> getFotosActivosAgrupacionById(Long id) {
		return activoAgrupacionDao.getFotosActivosAgrupacionById(id);
	}

	@Override
	public boolean createAgrupacion(DtoAgrupacionesCreateDelete dtoAgrupacion) {

		if (dtoAgrupacion.getTipoAgrupacion() == null) {
			return false;
		}

		return activoAgrupacionFactoryApi.create(dtoAgrupacion);

	}

	@Override
	public Page getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter) {
		return activoAgrupacionDao.getListSubdivisionesAgrupacionById(agrupacionFilter);
	}

	@Override
	public Page getListActivosSubdivisionById(DtoSubdivisiones subdivision) {
		return activoAgrupacionDao.getListActivosSubdivisionById(subdivision);
	}

	@Override
	@Transactional(readOnly = false)
	public List<ActivoFoto> getFotosSubdivision(DtoSubdivisiones subdivision) {
		List<ActivoFoto> listaFotos = activoAgrupacionDao.getFotosSubdivision(subdivision);
		if (gestorDocumentalFotos.isActive() && (listaFotos == null || listaFotos.isEmpty())) {
			FileListResponse fileListResponse = null;
			try {
				FileSearch fileSearch = new FileSearch();
				HashMap<String, String> metadata = new HashMap<String, String>();
				metadata.put("propiedad", "subdivision");
				metadata.put("id_subdivision", String.valueOf(subdivision.getId()));

				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", subdivision.getAgrId());
				ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);
				if (agrupacion != null) {
					metadata.put("id_agrupacion_haya", String.valueOf(agrupacion.getNumAgrupRem()));
					fileSearch.setMetadata(metadata);
					fileListResponse = gestorDocumentalFotos.get(fileSearch);

					if (fileListResponse.getError() == null || fileListResponse.getError().isEmpty()) {
						for (es.pfsgroup.plugin.rem.rest.dto.File fileGD : fileListResponse.getData()) {
							this.uploadFoto(fileGD);
						}
						listaFotos = activoAgrupacionDao.getFotosSubdivision(subdivision);
					}
				}
			} catch (Exception e) {
				logger.error("Error obteniedno las fotos del CDN", e);
			}

		}
		return listaFotos;
	}

	@Override
	@Transactional(readOnly = false)
	public List<ActivoFoto> getFotosAgrupacionById(Long id) {

		List<ActivoFoto> listaFotos = activoAgrupacionDao.getFotosAgrupacionById(id);
		if (gestorDocumentalFotos.isActive() && (listaFotos == null || listaFotos.isEmpty())) {
			FileListResponse fileListResponse = null;
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
			ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);
			try {
				if (agrupacion != null) {
					fileListResponse = gestorDocumentalFotos.get(PROPIEDAD.AGRUPACION, agrupacion.getNumAgrupRem());

					if (fileListResponse.getError() == null || fileListResponse.getError().isEmpty()) {
						for (es.pfsgroup.plugin.rem.rest.dto.File fileGD : fileListResponse.getData()) {
							this.uploadFoto(fileGD);
						}
						listaFotos = activoAgrupacionDao.getFotosAgrupacionById(id);
					}
				}
			} catch (Exception e) {
				logger.error("Error obteniedno las fotos del CDN", e);
			}

		}
		return listaFotos;

	}

	@Override
	public Map<String, Double> asignarValoresTasacionAprobadoVenta(List<ActivoAgrupacionActivo> activos)
			throws Exception {

		Map<String, Double> valores = new HashMap<String, Double>();
		Double total = 0.0;

		for (ActivoAgrupacionActivo activo : activos) {
			Double valor = null;
			ActivoTasacion tasacion = activoApi.getTasacionMasReciente(activo.getActivo());
			Boolean sinTasacion = false;
			
			if (!Checks.esNulo(tasacion)) {
				if (!Checks.esNulo(tasacion.getImporteTasacionFin())) {
					valor = Double.parseDouble(tasacion.getImporteTasacionFin().toString());
				} else {
					sinTasacion = true;
				}
			} else {
				sinTasacion = true;
			}
			
			if(sinTasacion) {
				ActivoValoraciones valoracion = activoApi.getValoracionAprobadoVenta(activo.getActivo());
				if (!Checks.esNulo(valoracion)) {
					valor = valoracion.getImporte();
				} else {
					// Con que haya un activo sin valor tasacion o valor
					// aprobado venta, no se haran las asignaciones de ninguno.
					return asignarValoresCero(activos);
				}
			}
			
			if(!Checks.esNulo(valor)) {
				valores.put(activo.getActivo().getId().toString(), valor);
				total = total + valor;
			}
		}

		valores.put("total", total);
		return valores;
	}

	private Map<String, Double> asignarValoresCero(List<ActivoAgrupacionActivo> activos) {
		Map<String, Double> valores = new HashMap<String, Double>();
		Double total = 0.0;

		for (ActivoAgrupacionActivo activo : activos) {
			Double valor = 0.0;
			valores.put(activo.getActivo().getId().toString(), valor);
		}
		
		valores.put("total", total);
		return valores;
	}

	@Override
	public Float asignarPorcentajeParticipacionEntreActivos(ActivoAgrupacionActivo activo, Map<String, Double> valores,
			Double total) throws Exception {

		if (total <= 0) return (float) 0;
		
		if (!Checks.esNulo(valores.get(activo.getActivo().getId().toString()))) {
			Float porcentaje = (float) (valores.get(activo.getActivo().getId().toString()) * 100);
			return (float) (porcentaje / total);
		} else {
			return (float) 0;
		}

	}

	@Override
	public boolean descongelarOfertasActivoAgrupacion(ActivoAgrupacion agrupacion) throws Exception {
		if (agrupacion.getActivos() != null && !agrupacion.getActivos().isEmpty()) {
			for (ActivoAgrupacionActivo activo : agrupacion.getActivos()) {
				if (activo.getActivo() != null && activo.getActivo().getOfertas() != null
						&& !activo.getActivo().getOfertas().isEmpty()) {
					for (ActivoOferta activoOferta : activo.getActivo().getOfertas()) {
						Oferta oferta = activoOferta.getPrimaryKey().getOferta();
						if (oferta.getEstadoOferta() != null
								&& oferta.getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_CONGELADA)) {

							ExpedienteComercial exp = expedienteComercialApi.findOneByOferta(oferta);
							// Si tiene expediente poner oferta ACEPTADA. Si no
							// tiene poner oferta PENDIENTE
							if (!Checks.esNulo(exp)) {
								ofertaApi.descongelarOfertas(exp);
							}else if (DDCartera.isCarteraBk(activo.getActivo().getCartera()) && (Checks.esNulo(oferta.getCheckDocumentacion())
									|| !oferta.getCheckDocumentacion())) {
								oferta.setEstadoOferta(genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo",
										DDEstadoOferta.CODIGO_PDTE_DOCUMENTACION)));
								genericDao.save(Oferta.class, oferta);
								ofertaApi.llamadaPbc(oferta);
							} else {
								oferta.setEstadoOferta( genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo",
										DDEstadoOferta.CODIGO_PENDIENTE)));
								if (Checks.esNulo(oferta.getFechaOfertaPendiente())) oferta.setFechaOfertaPendiente(new Date());
								genericDao.save(Oferta.class, oferta);
							}
							ofertaApi.updateStateDispComercialActivosByOferta(oferta);
						}

					}

				}

			}
		}
		return true;
	}
	
	@Override
	public  List<AgrupacionesVigencias> getHistoricoVigenciaAgrupaciones(DtoVigenciaAgrupacion agrupacionFilter) {
		return activoAgrupacionDao.getHistoricoVigenciasAgrupacionById(agrupacionFilter);
	}

	@Override
	public Boolean estaActivoEnOtraAgrupacionVigente(ActivoAgrupacion agrupacion,Activo activo) {
		
		return activoAgrupacionDao.estaActivoEnOtraAgrupacionVigente(agrupacion,activo);
	}
	
	public List<DtoCondicionEspecifica> getCondicionEspecificaByAgrupacion(Long id) {
		ActivoAgrupacion agrupacion = activoAgrupacionDao.get(id);
		Activo activoPrincipal = agrupacion.getActivoPrincipal();
		
		return activoApi.getCondicionEspecificaByActivo(activoPrincipal.getId());
	}
	
	public Boolean createCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto) {
		ActivoAgrupacion agrupacion = activoAgrupacionDao.get(dto.getIdAgrupacion());
		List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();
		
		for(ActivoAgrupacionActivo aga : activos) {
			dto.setIdActivo(aga.getActivo().getId());
			activoApi.createCondicionEspecifica(dto);			
		}
		
		return true;
	}
	
	public Boolean saveCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto) {
		ActivoAgrupacion agrupacion = activoAgrupacionDao.get(dto.getIdAgrupacion());
		List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();
		
		for(ActivoAgrupacionActivo aga : activos) {
			dto.setIdActivo(aga.getActivo().getId());
			if(!activoApi.saveCondicionEspecifica(dto)) return false;			
		}
		
		return true;
	}
	
	public Boolean darDeBajaCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto) {
		return activoApi.darDeBajaCondicionEspecifica(dto);	
	}
	@Override
	public Usuario getGestorComercialAgrupacion(List<ActivosLoteOfertaDto> dtoActivos) {
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "GCOM"));
		Usuario gestorComercial = null;
		Usuario gestorAux = null;
				
		for (int i=0; i<dtoActivos.size(); i++) {
			Activo activo = activoApi.getByNumActivo(dtoActivos.get(i).getIdActivoHaya());
			if (i==0) {
				gestorComercial = gestorActivoApi.getGestorByActivoYTipo(activo, tipoGestor.getId());
			} else {
				gestorAux = gestorActivoApi.getGestorByActivoYTipo(activo, tipoGestor.getId());
				if (!gestorAux.equals(gestorComercial)) {
					return null;
				}
			}
		}
		return gestorComercial;
	}
	
	@Override
	public Boolean arrayComparer(Long idAgr, List<Long> agrupaciones) {
		for (int i = 0; i < agrupaciones.size(); i++) {
			if (agrupaciones.get(i).equals(idAgr)) {
				return true;
			}
		}
		return false;
	}
	
	@Override
	public List<DtoTipoAgrupacion> getComboTipoAgrupacion() {
		
		boolean perfilValido = false;
		
		List<Perfil> usu= proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getPerfiles();

		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER);
		DDTipoAgrupacion promocionAlquiler = genericDao.get(DDTipoAgrupacion.class, filtro);
		
		List <DtoTipoAgrupacion> listDtoTipoAgrupacion = new ArrayList <DtoTipoAgrupacion>();
		
		for(Perfil p : usu) {
			if(p.getCodigo().equals(USUARIO_IT) || p.getCodigo().equals(GESTOR_COMERCIAL_ALQUILER) || p.getCodigo().equals(SUPERVISOR_COMERCIAL_ALQUILER)) {
				perfilValido = true;
			}
		}

		List <DDTipoAgrupacion> listaDDTipoAgrupacion = genericDao.getList(DDTipoAgrupacion.class);
		
		if(perfilValido) {
			
			for(DDTipoAgrupacion ta : listaDDTipoAgrupacion) {
				DtoTipoAgrupacion aux = new DtoTipoAgrupacion();
				aux.setIdAgrupacion(ta.getId());
				aux.setCodigo(ta.getCodigo());
				aux.setDescripcion(ta.getDescripcion());
				aux.setDescripcionLarga(ta.getDescripcionLarga());
				listDtoTipoAgrupacion.add(aux);
			}
		}else {
			
			listaDDTipoAgrupacion.remove(promocionAlquiler);
			
			for(DDTipoAgrupacion ta : listaDDTipoAgrupacion) {
				DtoTipoAgrupacion aux = new DtoTipoAgrupacion();
				aux.setIdAgrupacion(ta.getId());
				aux.setCodigo(ta.getCodigo());
				aux.setDescripcion(ta.getDescripcion());
				aux.setDescripcionLarga(ta.getDescripcionLarga());
				listDtoTipoAgrupacion.add(aux);
			}
			
		}
		
		return  listDtoTipoAgrupacion;
	}
	
	@Override
	public List<DDTipoAgrupacion> getComboTipoAgrupacionFiltro() {
		List <DDTipoAgrupacion> listaDDTipoAgrupacion = genericDao.getList(DDTipoAgrupacion.class);
		for(Perfil p : genericAdapter.getUsuarioLogado().getPerfiles()) {
			if(USUARIO_IT.equals(p.getCodigo()) || GESTOR_COMERCIAL_ALQUILER.equals(p.getCodigo()) || SUPERVISOR_COMERCIAL_ALQUILER.equals(p.getCodigo())) {
				return  listaDDTipoAgrupacion;
			}
		}
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER);
		DDTipoAgrupacion promocionAlquiler = genericDao.get(DDTipoAgrupacion.class, filtro);	
		listaDDTipoAgrupacion.remove(promocionAlquiler);
		return  listaDDTipoAgrupacion;
	}

	@Override
    public int countActivosAfectoGENCAT(ActivoAgrupacion agrupacion) {
		int numActivos = 0;
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", agrupacion.getId());
		VActivosAfectosGencatAgrupacion activos = genericDao.get(VActivosAfectosGencatAgrupacion.class, filtro);
		
		if (!Checks.esNulo(activos)) {
			numActivos = activos.getContador();
		}
		return numActivos;

	}
	
	@Override
	public boolean isTramitable(ActivoAgrupacion agrupacion) {
		boolean tramitable = true;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", agrupacion.getId());
		VTramitacionOfertaAgrupacion agrupacionNoTramitable = genericDao.get(VTramitacionOfertaAgrupacion.class, filtro);

		if(!Checks.esNulo(agrupacionNoTramitable)) {
			tramitable = false;
		}

		return tramitable;
	}
	
	@Override
	public Date getFechaInicioBloqueo(ActivoAgrupacion activoAgrupacion) {
		Date fechaBloqueo = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", activoAgrupacion.getId());
		VTramitacionOfertaAgrupacion agrupacionNoTramitable = genericDao.get(VTramitacionOfertaAgrupacion.class, filtro);
		if(!Checks.esNulo(agrupacionNoTramitable)) {
			fechaBloqueo = agrupacionNoTramitable.getFechaPublicacion();
		}
		return fechaBloqueo;
	}

	@Override
	@Transactional
	public boolean insertarActAutoTram(DtoAgrupaciones dto, Long id) {
		Usuario usuario = usuarioApi.getUsuarioLogado();
		if (Checks.esNulo(id)) {
			return false;
		}
		ActivoAgrupacion activoAgrupacion = activoAgrupacionDao.get(id);
		try {
			DDMotivoAutorizacionTramitacion motivoTramitacion = genericDao.get(DDMotivoAutorizacionTramitacion.class,genericDao.createFilter(FilterType.EQUALS,"codigo", dto.getMotivoAutorizacionTramitacionCodigo()));
			ActivoAutorizacionTramitacionOfertas autorizacion = activoAgrupacion.getActivoAutorizacionTramitacionOfertas();
			if(Checks.esNulo(autorizacion)) {
				autorizacion = new ActivoAutorizacionTramitacionOfertas();
				beanUtilNotNull.copyProperty(autorizacion, "activoAgrupacion", activoAgrupacion);
			}
			beanUtilNotNull.copyProperty(autorizacion, "observacionesAutoTram", dto.getObservacionesAutoTram());
			beanUtilNotNull.copyProperty(autorizacion,"motivoAutorizacionTramitacion", motivoTramitacion);
			autorizacion.setUsuario(usuario);
			beanUtilNotNull.copyProperty(autorizacion,"fechIniBloq", this.getFechaInicioBloqueo(activoAgrupacion));
			beanUtilNotNull.copyProperty(autorizacion, "fechAutoTram", new Date());
			
			Auditoria auditoriaActivoAuto = autorizacion.getAuditoria();
			if (auditoriaActivoAuto != null) {
				auditoriaActivoAuto.setFechaModificar(new Date());
				auditoriaActivoAuto.setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
			}
			
			genericDao.save(ActivoAutorizacionTramitacionOfertas.class, autorizacion);
			
			for(ActivoAgrupacionActivo activoagrupacionactivo: activoAgrupacion.getActivos()) {
				Activo activo = activoagrupacionactivo.getActivo();
				Date facheInicioBloqueo = activoApi.getFechaInicioBloqueo(activo);
				if(facheInicioBloqueo != null){
					ActivoAutorizacionTramitacionOfertas activoAuto =  activo.getActivoAutorizacionTramitacionOfertas();
					if(Checks.esNulo(activoAuto)) {
						activoAuto = new ActivoAutorizacionTramitacionOfertas();
						beanUtilNotNull.copyProperty(activoAuto, "activo", activo);
					}
					beanUtilNotNull.copyProperty(activoAuto, "observacionesAutoTram", dto.getObservacionesAutoTram());
					beanUtilNotNull.copyProperty(activoAuto, "motivoAutorizacionTramitacion", motivoTramitacion);
					activoAuto.setUsuario(usuario);
					beanUtilNotNull.copyProperty(activoAuto, "fechIniBloq", activoApi.getFechaInicioBloqueo(activo));
					beanUtilNotNull.copyProperty(activoAuto, "fechAutoTram", new Date());
					
					auditoriaActivoAuto = activoAuto.getAuditoria();
					if (auditoriaActivoAuto != null) {
						auditoriaActivoAuto.setFechaModificar(new Date());
						auditoriaActivoAuto.setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
					}
					
					genericDao.save(ActivoAutorizacionTramitacionOfertas.class, activoAuto);
				}
			}
			
		} catch (IllegalAccessException e) {
			logger.error("Error en activoAgrupacionManager", e);
			return false;

		} catch (InvocationTargetException e) {
			logger.error("Error en activoAgrupacionManager", e);
			return false;
		}
		return true;
	}
	
	@Override
	public Long getIdByNumAgrupacion(Long numAgrupacion) {
	return activoAgrupacionDao.getIdByNumAgrupacion(numAgrupacion);
	}

	@Override
	public boolean estaActivoEnAgrupacionRestringidaObRem(Activo activo) {

		if(activo != null){
			List<ActivoAgrupacionActivo> agaList = genericDao.getList(ActivoAgrupacionActivo.class,
					genericDao.createFilter(FilterType.EQUALS, "activo", activo));

			if(agaList != null){
				for(ActivoAgrupacionActivo aga: agaList){
					if(aga.getAgrupacion() != null && aga.getAgrupacion().getTipoAgrupacion() != null &&
						DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(aga.getAgrupacion().getTipoAgrupacion().getCodigo())){
						return true;
					}
				}
			}
		}
		return false;
	}

	@Transactional
	public boolean anyadirActivoEnAgrupacionRestringidaDesdeObRem(Long idActivo, Long idAgrupacion){

		ActivoAgrupacion agr = genericDao.get(ActivoAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "id", idAgrupacion));

		List <ActivoAgrupacionActivo> agaEnObRem = null;

		if(idActivo != null) {
			List<ActivoAgrupacionActivo> agaList = genericDao.getList(ActivoAgrupacionActivo.class,
					genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo));

			if(agaList != null){
				for(ActivoAgrupacionActivo aga: agaList){
					if(aga.getAgrupacion() != null && aga.getAgrupacion().getTipoAgrupacion() != null &&
							DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(aga.getAgrupacion().getTipoAgrupacion().getCodigo())){
						agaEnObRem = aga.getAgrupacion().getActivos();
						break;
					}
				}
			}

			if(agaEnObRem != null){
				for(ActivoAgrupacionActivo aga: agaEnObRem){
					TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

					ActivoAgrupacionActivo activoAgrupacionActivo = new ActivoAgrupacionActivo();
					activoAgrupacionActivo.setActivo(aga.getActivo());
					activoAgrupacionActivo.setAgrupacion(agr);
					Date today = new Date();
					activoAgrupacionActivo.setFechaInclusion(today);
					activoAgrupacionActivo.setPisoPiloto(false);
					activoAgrupacionActivoApi.save(activoAgrupacionActivo);

					transactionManager.commit(transaction);
				}
			}

			return true;
		}
		return false;
	}

	@Transactional
	public boolean borrarActivoEnAgrupacionRestringidaDesdeObRem(Long idActivo, Long idAgrupacion){

		ActivoAgrupacion agr = genericDao.get(ActivoAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "id", idAgrupacion));

		List <ActivoAgrupacionActivo> agaEnObRem = null;
		if(idActivo != null) {
			List<ActivoAgrupacionActivo> agaList = genericDao.getList(ActivoAgrupacionActivo.class,
					genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo));

			if(agaList != null){
				for(ActivoAgrupacionActivo aga: agaList){
					if(aga.getAgrupacion() != null && aga.getAgrupacion().getTipoAgrupacion() != null &&
							DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(aga.getAgrupacion().getTipoAgrupacion().getCodigo())){
						agaEnObRem = aga.getAgrupacion().getActivos();
						break;
					}
				}
			}

			if(agaEnObRem != null){
				for (ActivoAgrupacionActivo obRem : agaEnObRem) {
					ActivoAgrupacionActivo obRemBorrar = genericDao.get(ActivoAgrupacionActivo.class, 
							genericDao.createFilter(FilterType.EQUALS, "activo", obRem.getActivo()), 
							genericDao.createFilter(FilterType.EQUALS, "agrupacion", agr));
					
					Auditoria.delete(obRemBorrar);
					activoAgrupacionActivoApi.save(obRemBorrar);
				}
			}

			return true;
		}
		return false;
	}
}
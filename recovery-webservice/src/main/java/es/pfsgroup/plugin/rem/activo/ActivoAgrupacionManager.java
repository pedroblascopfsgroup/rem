package es.pfsgroup.plugin.rem.activo;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.AgrupacionesVigencias;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecificaAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoEstadoDisponibilidadComercial;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.model.DtoVActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoVigenciaAgrupacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VActivosAfectosGencatAgrupacion;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.VListaActivosAgrupacionVSCondicionantes;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoFoto;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PRINCIPAL;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PROPIEDAD;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.SITUACION;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.TIPO;
import es.pfsgroup.plugin.rem.rest.dto.File;
import es.pfsgroup.plugin.rem.rest.dto.FileListResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileSearch;

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

	// @Override
	// public String managerName() {
	// return "activoAgrupacionManager";
	// }

	@Autowired
	private ActivoAgrupacionFactoryApi activoAgrupacionFactoryApi;
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

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
	public Page getListActivosAgrupacionById(DtoAgrupacionFilter dto, Usuario usuarioLogado) {
		return activoAgrupacionDao.getListActivosAgrupacionById(dto, usuarioLogado);
	}
	

	@SuppressWarnings("unchecked")
	public DtoEstadoDisponibilidadComercial getListActivosAgrupacionByIdActivo(DtoAgrupacionFilter dto, Usuario usuarioLogado) {
		
		DtoEstadoDisponibilidadComercial dtoEstadoDispcom = new DtoEstadoDisponibilidadComercial();
		List<DtoVActivosAgrupacion> listaDto = new ArrayList<DtoVActivosAgrupacion>();
		List<VActivosAgrupacion> lAgrupaActivos =  (List<VActivosAgrupacion>) activoAgrupacionDao.getListActivosAgrupacionById(dto, usuarioLogado).getResults();
		 
		for(VActivosAgrupacion actAgrup : lAgrupaActivos) {
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
	@BusinessOperation(overrides = "activoAgrupacionManager.uploadFoto")
	@Transactional(readOnly = false)
	public String uploadFoto(WebFileItem fileItem) {

		Long idAgrupacion = Long.parseLong(fileItem.getParameter("idEntidad"));
		ActivoAgrupacion agrupacion = this.get(idAgrupacion);

		ActivoFoto activoFoto = null;
		FileResponse fileReponse;
		try {
			if (gestorDocumentalFotos.isActive()) {

				fileReponse = gestorDocumentalFotos.upload(fileItem.getFileItem().getFile(),
						fileItem.getFileItem().getFileName(), PROPIEDAD.AGRUPACION, idAgrupacion, null,
						fileItem.getParameter("descripcion"), null, null, null);
				activoFoto = new ActivoFoto(fileReponse.getData());

			} else {
				activoFoto = new ActivoFoto(fileItem.getFileItem());
			}

			activoFoto.setAgrupacion(agrupacion);

			/*
			 * Filter filtro = genericDao.createFilter(FilterType.EQUALS,
			 * "codigo", fileItem.getParameter("tipo")); DDTipoFoto tipoFoto =
			 * (DDTipoFoto) genericDao.get(DDTipoFoto.class, filtro);
			 * 
			 * activoFoto.setTipoFoto(tipoFoto);
			 */

			activoFoto.setTamanyo(fileItem.getFileItem().getLength());

			activoFoto.setNombre(fileItem.getFileItem().getFileName());

			activoFoto.setDescripcion(fileItem.getParameter("descripcion"));

			activoFoto.setPrincipal(true);

			activoFoto.setFechaDocumento(new Date());

			// activoFoto.setInteriorExterior(Boolean.valueOf(fileItem.getParameter("interiorExterior")));

			/*
			 * Integer orden =
			 * activoDao.getMaxOrdenFotoById(Long.parseLong(fileItem.
			 * getParameter( "idEntidad"))); orden++;
			 * activoFoto.setOrden(orden);
			 */

			Auditoria.save(activoFoto);

			agrupacion.getFotos().add(activoFoto);

			activoAgrupacionDao.save(agrupacion);
		} catch (Exception e) {

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
		//ActivoAgrupacion agrupacion = this.get(agrupacionId);
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
					activoFoto.setSubdivision(new BigDecimal(fileItem.getMetadata().get("id_subdivision"))); 
				}

				activoFoto.setNombre(fileItem.getBasename());

				if (fileItem.getMetadata().containsKey("descripcion")) {
					activoFoto.setDescripcion(fileItem.getMetadata().get("descripcion"));
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

				// Auditoria.save(activoFoto);

				// agrupacion.getFotos().add(activoFoto);

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
	@BusinessOperation(overrides = "activoAgrupacionManager.uploadFotoSubdivision")
	@Transactional(readOnly = false)
	public String uploadFotoSubdivision(WebFileItem fileItem) {

		BigDecimal subdivisionId = new BigDecimal(fileItem.getParameter("id"));
		Long agrupacionId = Long.parseLong(fileItem.getParameter("agrId"));
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo"));
		DDTipoFoto tipoFoto = (DDTipoFoto) genericDao.get(DDTipoFoto.class, filtroTipo);
		TIPO tipo = null;
		SITUACION situacion;
		PRINCIPAL principal = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", agrupacionId);
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);
		FileResponse fileReponse;
		ActivoFoto activoFoto;
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
				if (Boolean.valueOf(fileItem.getParameter("principal"))) {
					principal = PRINCIPAL.SI;
				} else {
					principal = PRINCIPAL.NO;
				}
				if (Boolean.valueOf(fileItem.getParameter("interiorExterior"))) {
					situacion = SITUACION.INTERIOR;
				} else {
					situacion = SITUACION.EXTERIOR;
				}
				
				fileReponse = gestorDocumentalFotos.uploadSubdivision(fileItem.getFileItem().getFile(),
						fileItem.getFileItem().getFileName(), subdivisionId, agrupacion,
						fileItem.getParameter("descripcion"),tipo,principal,situacion);
				activoFoto = new ActivoFoto(fileReponse.getData());

			} else {
				activoFoto = new ActivoFoto(fileItem.getFileItem());
			}

			activoFoto.setSubdivision(subdivisionId);

			activoFoto.setAgrupacion(agrupacion);

			activoFoto.setTamanyo(fileItem.getFileItem().getLength());

			activoFoto.setNombre(fileItem.getFileItem().getFileName());
			
			activoFoto.setDescripcion(fileItem.getParameter("descripcion"));

			activoFoto.setPrincipal(Boolean.valueOf(fileItem.getParameter("principal")));
			
			activoFoto.setTipoFoto(tipoFoto);
			
			activoFoto.setInteriorExterior(Boolean.valueOf(fileItem.getParameter("interiorExterior")));

			activoFoto.setFechaDocumento(new Date());

			activoFoto.setOrden(orden);

			Auditoria.save(activoFoto);

			agrupacion.getFotos().add(activoFoto);

			genericDao.save(ActivoAgrupacion.class, agrupacion);
		} catch (Exception e) {
			logger.error(e);
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
		BigDecimal subdivisionId = new BigDecimal(fileItem.getMetadata().get("id_subdivision"));
		Long agrupacionId = Long.parseLong(fileItem.getMetadata().get("id_agrupacion_haya"));
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", agrupacionId);
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);
		try {
			if (agrupacion != null) {
				ActivoFoto activoFoto;
				Integer orden = activoApi.getMaxOrdenFotoByIdSubdivision(agrupacionId, subdivisionId);
				orden++;
				activoFoto = activoAdapter.getFotoActivoByRemoteId(fileItem.getId());
				if (activoFoto == null) {
					activoFoto = new ActivoFoto(fileItem);
				}

				activoFoto.setSubdivision(subdivisionId);

				activoFoto.setAgrupacion(agrupacion);

				activoFoto.setNombre(fileItem.getBasename());

				if (fileItem.getMetadata().containsKey("descripcion")) {
					activoFoto.setDescripcion(fileItem.getMetadata().get("descripcion"));
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

				activoFoto.setOrden(orden);

				// Auditoria.save(activoFoto);

				// agrupacion.getFotos().add(activoFoto);

				genericDao.save(ActivoFoto.class, activoFoto);

			} else {
				throw new Exception("La foto esta asociada a una subdivision inexsitente");
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
							} else {
								oferta.setEstadoOferta( genericDao.get(DDEstadoOferta.class, genericDao.createFilter(FilterType.EQUALS, "codigo",
										DDEstadoOferta.CODIGO_PENDIENTE)));
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
		ActivoAgrupacion agrupacion = activoAgrupacionDao.get(dto.getIdAgrupacion());
		List<ActivoAgrupacionActivo> activos = agrupacion.getActivos();
		
		for(ActivoAgrupacionActivo aga : activos) {
			dto.setIdActivo(aga.getActivo().getId());
			if(!activoApi.darDeBajaCondicionEspecifica(dto)) return false;			
		}
		
		return true;
	
	}
	@Override
	public Usuario getGestorComercialAgrupacion(List<Long> numActivos) {
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "GCOM"));
		Usuario gestorComercial = null;
		Usuario gestorAux = null;
				
		for (int i=0; i<numActivos.size(); i++) {
			Activo activo = activoApi.getByNumActivo(numActivos.get(i));
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
	
    public int countActivosAfectoGENCAT(ActivoAgrupacion agrupacion) {
		int numActivos = 0;
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idAgrupacion", agrupacion.getId());
		VActivosAfectosGencatAgrupacion activos = genericDao.get(VActivosAfectosGencatAgrupacion.class, filtro);
		
		if (!Checks.esNulo(activos)) {
			numActivos = activos.getContador();
		}
		return numActivos;
	}
}
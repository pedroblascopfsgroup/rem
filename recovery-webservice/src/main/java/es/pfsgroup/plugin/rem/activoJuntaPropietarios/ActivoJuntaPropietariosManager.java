package es.pfsgroup.plugin.rem.activoJuntaPropietarios;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.rem.activoJuntaPropietarios.dao.ActivoJuntaPropietariosDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoJuntaPropietariosApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoJuntas;
import es.pfsgroup.plugin.rem.model.ActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.DtoActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocJuntas;
import es.pfsgroup.plugin.rem.rest.dto.ActivoDto;


@Service("activoJuntaPropietariosManager")
public class ActivoJuntaPropietariosManager implements ActivoJuntaPropietariosApi {
	
	private static final String PESTANA_FICHA = "ficha";
	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";	
	private static final String OPERACION_ALTA = "Alta";

	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoJuntaPropietariosDao activoJuntaPropietariosDao;
	
	@Override
	public String managerName() {
		return "activoJuntaPropietariosManager";
	}
	
	protected static final Log logger = LogFactory.getLog(ActivoJuntaPropietariosManager.class);

	
	@Override
	public ActivoJuntaPropietarios findOne(Long id) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);		
		return genericDao.get(ActivoJuntaPropietarios.class, filtro );
	}

	@Override
	public DtoPage getListJuntas(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios) {	
		return activoJuntaPropietariosDao.getListJuntas(dtoActivoJuntaPropietarios);
	}
	
	private DtoActivoJuntaPropietarios juntaToDtoActivoJuntaPropietarios(ActivoJuntaPropietarios junta) {
		 
		DtoActivoJuntaPropietarios dto = new  DtoActivoJuntaPropietarios();
		 
		 if(!Checks.esNulo(junta)) {
			 dto.setId(junta.getId());
			 dto.setFechaJunta(junta.getFechaAltaJunta());
			 
			 if (!Checks.esNulo(junta.getComunidad())) {
				 dto.setComunidad(junta.getComunidad().getId());
				 dto.setCodProveedor(String.valueOf(junta.getComunidad().getCodigoProveedorRem()));
			 }
			 
			 if (!Checks.esNulo(junta.getActivo())) {
				 dto.setCartera(junta.getActivo().getCartera().getDescripcion());
				 dto.setNumActivo(junta.getActivo().getNumActivo());
				 dto.setLocalizacion(junta.getActivo().getDireccion());
			 }
			 
			 dto.setPorcentaje(junta.getPorcentaje());
			 
			 if(!Checks.esNulo(junta.getPromoMayor50())) {
				 dto.setPromoMayor50(junta.getPromoMayor50().getId());
			 }
			 
			 if(!Checks.esNulo(junta.getPromo20a50())) {
				 dto.setPromo20a50(junta.getPromo20a50().getId());
			 }
			 
			 if(!Checks.esNulo(junta.getJunta())) {
				 dto.setJunta(junta.getJunta().getDescripcion());
			 }
			 
			 if(!Checks.esNulo(junta.getJudicial())) {
				 dto.setJudicial(junta.getJudicial().getId());
			 }
			 
			 if(!Checks.esNulo(junta.getDerrama())) {
				 dto.setDerrama(junta.getDerrama().getId());
			 }
			 if(!Checks.esNulo(junta.getEstatutos())) {
				 dto.setEstatutos(junta.getEstatutos().getId());
			 }
			 
			 if(!Checks.esNulo(junta.getIte().getId())) {
				 dto.setIte(junta.getIte().getId());
			 }
			 
			 if(!Checks.esNulo(junta.getMorosos())) {
				 dto.setMorosos(junta.getMorosos().getId());
			 }
			 
			 if(!Checks.esNulo(junta.getCuota())) {
				 dto.setCuota(junta.getCuota().getId());
			 }
			 
			 dto.setOtros(junta.getOtros());
			 
			 dto.setImporte(junta.getImporte());
		 
			 if(!Checks.esNulo(junta.getCuota())) {
				 dto.setCuota(junta.getCuota().getId());
			 }
			 
			 dto.setSuministros(junta.getSuministros());
		 
			 dto.setPropuesta(junta.getPropuesta());
			 
			 dto.setVoto(junta.getVoto());
			 
			 dto.setIndicaciones(junta.getIndicaciones());
		 }
		 
		 return dto;
	}

	@Override
	public Object getTabJunta(Long id, String tab) {
		
		ActivoJuntaPropietarios junta = this.findOne(id);

		WebDto dto = null;

		if (PESTANA_FICHA.equals(tab)) {
			dto = juntaToDtoActivoJuntaPropietarios(junta);
		}
		return dto;
	}
	
	// obtener activo para una junta
	
	@Override
	public ActivoDto getActivosJuntasVista(Long idJunta) {
		
		ActivoJuntaPropietarios listaActivo = genericDao.get(ActivoJuntaPropietarios.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idJunta));
		ActivoDto dto = new ActivoDto();
		Activo activo = listaActivo.getActivo();
		try {
			
			beanUtilNotNull.copyProperty(dto, "numActivo", activo.getNumActivo());
			if (!Checks.esNulo(activo.getInfoRegistral())
					&& !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien())) {
				beanUtilNotNull.copyProperty(dto, "fincaRegistral", activo.getInfoRegistral().getInfoRegistralBien().getNumFinca());
			}
			beanUtilNotNull.copyProperty(dto, "tipoActivo", activo.getTipoActivo().getDescripcion());
			
			if (activo.getMunicipio() != null) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", activo.getMunicipio());
				Localidad localidad = genericDao.get(Localidad.class, filtro);
				beanUtilNotNull.copyProperty(dto, "municipio", localidad.getDescripcion());
				beanUtilNotNull.copyProperty(dto, "provincia", localidad.getProvincia().getDescripcion());
			}
			

			
		}catch (IllegalAccessException e) {
			logger.error("Error en activoManager", e);

		}catch (InvocationTargetException e) {
			logger.error("Error en activoManager", e);
		}

		return dto;
	
	}
	
	
	// GESTOR DOCUMENTAL
	// asociamos el documento al id de junta
	
	@Transactional(readOnly = false)
	public List<DtoAdjunto> getAdjuntosJunta(Long id)	throws GestorDocumentalException{
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		Usuario usuario = genericAdapter.getUsuarioLogado();
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			ActivoJuntaPropietarios activoJunta = findOne(id);
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosJunta(activoJunta);
				for (DtoAdjunto adj : listaAdjuntos) {
					ActivoAdjuntoJuntas adjuntoJunta = activoJunta.getAdjuntoGD(adj.getId());
					if (!Checks.esNulo(adjuntoJunta)) {
						if (!Checks.esNulo(adjuntoJunta.getNombreAdn()) && !Checks.esNulo(adjuntoJunta.getTipoDocumento())) {
							adj.setDescripcionTipo(adjuntoJunta.getTipoDocumento().getDescripcion());
						} 
						
						adj.setFechaDocumento(adjuntoJunta.getFechaAltaJunta());

						adj.setContentType(adjuntoJunta.getTipoContenido());
						if (!Checks.esNulo(adjuntoJunta.getAuditoria())) {
							adj.setGestor(adjuntoJunta.getAuditoria().getUsuarioCrear());
						}
						if (!Checks.esNulo(adjuntoJunta.getTamnyo())) {
							adj.setTamanyo(adjuntoJunta.getTamnyo());
						}
					}
				}
			} catch (GestorDocumentalException gex) {
				if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE.equals(gex.getCodigoError())) {
					
					Integer idJunta;
					try{
						idJunta = gestorDocumentalAdapterApi.crearJunta(activoJunta,usuario.getUsername());
						logger.debug("GESTOR DOCUMENTAL [ crearJunta para " + activoJunta.getId() + "]: ID JUNTA RECIBIDO " + idJunta);
					} catch (GestorDocumentalException gexc) {
						logger.error(gexc.getMessage(),gexc);
					}
					
				}
				throw gex;
			}			
		} else {
			listaAdjuntos = getAdjuntos(id, listaAdjuntos);
		}
		return listaAdjuntos;
	}
	
	
	
	public List<DtoAdjunto> getAdjuntos(Long idJunta, List<DtoAdjunto> listaAdjuntos) {
		try {
			ActivoJuntaPropietarios activoJunta = findOne(idJunta);
			
			for (ActivoAdjuntoJuntas adjunto : activoJunta.getAdjuntos()) {
				DtoAdjunto dto = new DtoAdjunto();
				BeanUtils.copyProperties(dto, adjunto);
				dto.setIdEntidad(activoJunta.getId());
				
				if (!Checks.esNulo(adjunto)) {
					if (!Checks.esNulo(adjunto.getNombreAdn())) {
						dto.setNombre(adjunto.getNombreAdn());
					}
					
					if (!Checks.esNulo(adjunto.getTipoDocumento().getDescripcion())) {
						dto.setDescripcionTipo(adjunto.getTipoDocumento().getDescripcion());		
					}
					
					if (!Checks.esNulo(adjunto.getAuditoria().getFechaCrear())) {
						dto.setFechaDocumento(activoJunta.getFechaAltaJunta());
					}
					
					if (!Checks.esNulo(adjunto.getAuditoria().getUsuarioCrear())) {
						dto.setGestor(activoJunta.getAuditoria().getUsuarioCrear());
					}					
					
					if (!Checks.esNulo(adjunto.getTamnyo())) {
						dto.setTamanyo(adjunto.getTamnyo());
					}
				}

				listaAdjuntos.add(dto);
			}

		} catch (Exception ex) {
			logger.error("error en ActivoJuntaPropietariosManager", ex);
		}
		return listaAdjuntos;
	}
	
	
	// subir documento
	
	@Override
	@BusinessOperation(overrides = "activoJuntaPropietariosManager.uploadDocumento")
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, ActivoJuntaPropietarios activoJuntaEntrada, String matricula) throws Exception {

		ActivoJuntaPropietarios activoJunta = findOne(Long.parseLong(webFileItem.getParameter("idEntidad")));
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
		DDTipoDocJuntas tipoDocumento = genericDao.get(DDTipoDocJuntas.class, filtro);

		String activos = webFileItem.getParameter("activos");
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				// subida al gestor documental
				Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoJunta(activoJunta, webFileItem,
						usuarioLogado.getUsername(), tipoDocumento.getMatriculaGD());
				
				// Subida del registro del adjunto a juntas
				CrearRelacionExpedienteDto crearRelacionExpedienteDto = new CrearRelacionExpedienteDto();
				crearRelacionExpedienteDto.setTipoRelacion(RELACION_TIPO_DOCUMENTO_EXPEDIENTE);
				String mat = tipoDocumento.getMatriculaGD();
				if (!Checks.esNulo(mat)) {
					crearRelacionExpedienteDto.setCodTipoDestino(GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES);
					crearRelacionExpedienteDto.setCodClaseDestino(GestorDocumentalConstants.CODIGO_CLASE_JUNTA);	
				}
				crearRelacionExpedienteDto.setOperacion(OPERACION_ALTA);

				gestorDocumentalAdapterApi.crearRelacionJuntas(activoJunta, idDocRestClient, activoJunta.getActivo().getNumActivo().toString(),
						usuarioLogado.getUsername(), crearRelacionExpedienteDto);		
				
				if(!Checks.esNulo(tipoDocumento.getTipoDocumentoActivo())) {
					webFileItem.putParameter("tipo", tipoDocumento.getTipoDocumentoActivo().getCodigo());
				}
			
					//Según item HREOS-2379:
					//Adjuntar el documento a la tabla de adjuntos del activo, pero sin subir el documento realmente, sólo insertando la fila.
					
				if(!Checks.esNulo(activos)) {
					Filter filtroAct = genericDao.createFilter(FilterType.EQUALS, "numActivo", Long.parseLong(webFileItem.getParameter("activos")));
					if(!Checks.esNulo(filtroAct.getPropertyValue())) {
					
						Activo activoEntrada = genericDao.get(Activo.class, filtroAct);
					
						File file = File.createTempFile("idDocRestClient["+idDocRestClient+"]", ".pdf");
						BufferedWriter out = new BufferedWriter(new FileWriter(file));
						try {
							out.write("pfs");
							out.close();					    
							FileItem fileItem = new FileItem();
							fileItem.setFile(file);
							fileItem.setFileName("idDocRestClient["+idDocRestClient+"]");
							fileItem.setLength(webFileItem.getFileItem().getLength());			
							webFileItem.setFileItem(fileItem);
							activoApi.uploadDocumento(webFileItem, idDocRestClient, activoEntrada, matricula);
						}finally {
							out.close();
						}
					}
				}
				ActivoAdjuntoJuntas adjuntoJunta = new ActivoAdjuntoJuntas();
				adjuntoJunta.setActivoJuntaPropietario(activoJunta);
				adjuntoJunta.setTipoDocumento(tipoDocumento);
				adjuntoJunta.setTipoContenido(webFileItem.getFileItem().getContentType());
				adjuntoJunta.setTamanyo(webFileItem.getFileItem().getLength());
				adjuntoJunta.setNombreAdn(webFileItem.getFileItem().getFileName());
				adjuntoJunta.setDescripcion(webFileItem.getParameter("descripcion"));
				adjuntoJunta.setFechaAltaJunta(new Date());
				adjuntoJunta.setDocumento_Rest(idDocRestClient);
				Auditoria.save(adjuntoJunta);
				activoJunta.getAdjuntos().add(adjuntoJunta);
				activoJuntaPropietariosDao.save(activoJunta);
			} catch (GestorDocumentalException gex) {
				logger.error(gex.getMessage());
				return gex.getMessage();
			}
		} else {

			if (!Checks.esNulo(tipoDocumento)) {

				// Subida a la base de datos
				ActivoAdjuntoJuntas adjuntoJunta = new ActivoAdjuntoJuntas();

				Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
				adjuntoJunta.setIdAdj(adj);

				adjuntoJunta.setActivoJuntaPropietario(activoJunta);
				adjuntoJunta.setTipoDocumento(tipoDocumento);
				adjuntoJunta.setTipoContenido(webFileItem.getFileItem().getContentType());
				adjuntoJunta.setTamanyo(webFileItem.getFileItem().getLength());
				adjuntoJunta.setNombreAdn(webFileItem.getFileItem().getFileName());
				adjuntoJunta.setDescripcion(webFileItem.getParameter("descripcion"));
				adjuntoJunta.setFechaAltaJunta(new Date());
				Auditoria.save(adjuntoJunta);
				
				activoJunta.getAdjuntos().add(adjuntoJunta);

				activoJuntaPropietariosDao.save(activoJunta);
			}
		}

		return null;

	}
	
	@Override
	@BusinessOperation(overrides = "activoJuntaPropietariosManager.deleteAdjunto")
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {

		boolean borrado = false;
		ActivoJuntaPropietarios activoJunta = findOne(dtoAdjunto.getIdEntidad());
		ActivoAdjuntoJuntas adjunto = activoJunta.getAdjunto(dtoAdjunto.getId());
		try {
			// Borramos en el gestor documental si hay
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {

				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());

				ActivoAdjuntoJuntas adjuntoGD = activoJunta.getAdjuntoGD(dtoAdjunto.getId());

				if (adjuntoGD == null) {
					borrado = false;
				}
				activoJunta.getAdjuntos().remove(adjuntoGD);
				activoJuntaPropietariosDao.save(activoJunta);

			} else {
				activoJunta.getAdjuntos().remove(adjunto);
				activoJuntaPropietariosDao.save(activoJunta);
			}
		} catch (Exception ex) {
			logger.debug(ex.getMessage());
			borrado = false;
		}

		return borrado;
	}
	
	@Override
	@BusinessOperationDefinition("activoJuntaPropietariosManager.getFileItemAdjunto")
	public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto) {

		ActivoJuntaPropietarios activoJunta = activoJuntaPropietariosDao.get(dtoAdjunto.getIdEntidad());
		ActivoAdjuntoJuntas adjunto = null;
		FileItem fileItem = null;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			try {
				fileItem = gestorDocumentalAdapterApi.getFileItem(dtoAdjunto.getId(),dtoAdjunto.getNombre());
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
		} else {
			adjunto = activoJunta.getAdjunto(dtoAdjunto.getId());
			fileItem = adjunto.getIdAdj().getFileItem();
			fileItem.setContentType(adjunto.getTipoContenido());
			fileItem.setFileName(adjunto.getNombreAdn());
		}

		return fileItem;
	}

		
}

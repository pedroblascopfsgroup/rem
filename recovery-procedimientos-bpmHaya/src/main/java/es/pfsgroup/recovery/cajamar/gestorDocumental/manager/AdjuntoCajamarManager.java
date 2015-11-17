package es.pfsgroup.recovery.cajamar.gestorDocumental.manager;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.tools.ant.taskdefs.TempFile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.adjuntos.api.AdjuntosApi;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

@Component("adjuntoManagerImpl")
public class AdjuntoCajamarManager implements AdjuntosApi {

	@Autowired
	private GestorDocumentalApi gestorDocumentalApi;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
		//return (List<? extends EXTAdjuntoDto>) listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, null);
		return null;
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		return listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		return listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		return listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
	}

	@Override
	public String upload(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return altaDocumento(Long.parseLong(uploadForm.getParameter("id")), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, null, uploadForm);
		}else{
			return null;
		}
	}

	@Override
	public String uploadPersona(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null, uploadForm);
		}else{
			return null;
		}
	}

	@Override
	public String uploadExpediente(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null, uploadForm);
		}else{
			return null;
		}
	}

	@Override
	public String uploadContrato(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null, uploadForm);
		}else{
			return null;
		}
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		return listadoDocumentos(prcId, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, null);
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		return listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		return listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		return listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id) {
		return listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		return listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);
	}
	
	@Override
	public FileItem bajarAdjuntoAsunto(Long asuntoId, Long adjuntoId) {
		return recuperacionDocumento(adjuntoId);
	}
	
	@Override
	public FileItem bajarAdjuntoExpediente(Long adjuntoId) {
		return recuperacionDocumento(adjuntoId);
	}

	@Override
	public FileItem bajarAdjuntoContrato(Long adjuntoId) {
		return recuperacionDocumento(adjuntoId);
	}

	@Override
	public FileItem bajarAdjuntoPersona(Long adjuntoId) {
		return recuperacionDocumento(adjuntoId);
	}

	
	private List<ExtAdjuntoGenericoDto> listadoDocumentosGeneric(Long idEntidad, String tipoEntidad, String tipoEntidadGrid, String tipoDocumento){
		
		final Long idFinal = idEntidad; 
		
		final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(idEntidad, tipoEntidad, tipoEntidadGrid, tipoDocumento);
		   
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();

		if (!Checks.estaVacio(listDto)) {
			Collections.sort(listDto, comparador);

			for(final AdjuntoGridDto adjDto : listDto){
				ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

					@Override
					public Long getId() {
						return adjDto.getId(); ///ENTIDAD.getId();
					}

					@Override
					public String getDescripcion() {
						return adjDto.getDescripcionEntidad();//return asunto.getExpediente().getDescripcion(); ENTIDAD.getDescripcion();
					}

					@Override
					public List getAdjuntosAsList() {
						List<AdjuntoGridDto> l = new ArrayList<AdjuntoGridDto>();
						l.add(adjDto);
						return l;
					}

					@Override
					public List getAdjuntos() {
						List<AdjuntoGridDto> l = new ArrayList<AdjuntoGridDto>();
						l.add(adjDto);
						return l;
					}
				};
				adjuntosMapeados.add(dto);
			}

		}

		return adjuntosMapeados;
		
	}
	
	private List<AdjuntoDto> listadoDocumentos(Long idEntidad, String tipoEntidad, String tipoEntidadGrid, String tipoDocumento){
		
		
		final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(idEntidad, tipoEntidad, tipoEntidadGrid, tipoDocumento);
		
		List<AdjuntoDto> adjuntosMapeados = new ArrayList<AdjuntoDto>();
		
		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");


		if (!Checks.estaVacio(listDto)) {
			Collections.sort(listDto, comparador);
			
			for(final AdjuntoGridDto adjDto: listDto){
				
				EXTAdjuntoDto dto = new EXTAdjuntoDto() {
					
					@Override
					public Boolean getPuedeBorrar() {
						if (borrarOtrosUsu /*|| adjAsun.getAuditoria().getUsuarioCrear().equals(usuario.getUsername())*/) {
							return true;
						} else {
							return false;
						}
					}
					
					@Override
					public Object getAdjunto() {
						
						EXTAdjuntoAsunto adjAsu = new EXTAdjuntoAsunto();
						adjAsu.setId(adjDto.getId());
						adjAsu.setNombre(adjDto.getNombre());
						adjAsu.setContentType(adjDto.getContentType());
						adjAsu.setLength(Long.parseLong(adjDto.getLength()));
						adjAsu.setDescripcion(adjDto.getDescripcion());
						adjAsu.getAuditoria().setFechaCrear(adjDto.getFechaSubida());
						adjAsu.setTipoFichero(genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", adjDto.getTipo())));
						adjAsu.setProcedimiento(genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", adjDto.getNumActuacion())));
						
						return adjAsu;
					}
					
					@Override
					public Long prcId() {
						return adjDto.getNumActuacion();
					}
					
					@Override
					public String getTipoDocumento() {
						return adjDto.getContentType();
					}
				};

				adjuntosMapeados.add(dto);		
			}
		
		}

		return adjuntosMapeados;
		
	}
	
	Comparator<AdjuntoGridDto> comparador = new Comparator<AdjuntoGridDto>() {
		@Override
		public int compare(AdjuntoGridDto o1, AdjuntoGridDto o2) {
			if (Checks.esNulo(o1) && Checks.esNulo(o2)) {
				return 0;
			} else if (Checks.esNulo(o1)) {
				return -1;
			} else if (Checks.esNulo(o2)) {
				return 1;
			} else {
				return o2.getFechaSubida().compareTo(o1.getFechaSubida());
			}
		}
	};
	
	private String altaDocumento(Long idEntidad, String tipoEntidadGrid, String tipoDocumento, WebFileItem uploadForm){
		return gestorDocumentalApi.altaDocumento(idEntidad, tipoEntidadGrid, tipoDocumento, uploadForm);
	}
	
	private FileItem recuperacionDocumento(Long id){
		
		if(!Checks.esNulo(id)){
			AdjuntoGridDto djDto = gestorDocumentalApi.recuperacionDocumento(id);
			File file = new File("tmp");
			FileItem fileItem = null;
			try {
				FileUtils.writeStringToFile(file, djDto.getFicheroBase64());
				fileItem = new FileItem(file);
				file.delete();
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return fileItem;
			
		}else{
			return null;
		}
		
	}

	private boolean tieneFuncion(Usuario usuario, String codigo) {
		List<Perfil> perfiles = usuario.getPerfiles();
		for (Perfil per : perfiles) {
			for (Funcion fun : per.getFunciones()) {
				if (fun.getDescripcion().equals(codigo)) {
					return true;
				}
			}
		}

		return false;
	}
}

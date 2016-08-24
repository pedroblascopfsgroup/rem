package es.pfsgroup.plugin.rem.expedienteComercial;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoDatosBasicosOferta;
import es.pfsgroup.plugin.rem.model.DtoFichaExpediente;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TextosOferta;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;


@Service("expedienteComercialManager")
public class ExpedienteComercialManager implements ExpedienteComercialApi {
	
	protected static final Log logger = LogFactory.getLog(ExpedienteComercialManager.class);
	
	public final String PESTANA_FICHA = "ficha";
	public final String PESTANA_DATOSBASICOS_OFERTA = "datosbasicosoferta";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private OfertaDao ofertaDao;
	

	@Override
	public ExpedienteComercial findOne(Long id) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);

		return expediente;
	}

	@Override
	public Object getTabExpediente(Long id, String tab) {
		
		ExpedienteComercial expediente = findOne(id);
		
		WebDto dto = null;

		try {
			
			if(PESTANA_FICHA.equals(tab)){
				dto = expedienteToDtoFichaExpediente(expediente);
			} else if (PESTANA_DATOSBASICOS_OFERTA.equals(tab)) {
				dto = expedienteToDtoDatosBasicosOferta(expediente);
			}
			

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		return dto;

	}
	
	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListTextosOfertaById (DtoTextosOferta dto, Long id) {
		
		ExpedienteComercial expediente = findOne(id);
		Oferta oferta = expediente.getOferta();
		Long idOferta = null;
		
		if(!Checks.esNulo(oferta)) {
			idOferta = oferta.getId();
		}
		
		Page page = ofertaDao.getListTextosOfertaById(dto, idOferta);
		
		List<TextosOferta> lista = (List<TextosOferta>) page.getResults();
		List<DtoTextosOferta> textos = new ArrayList<DtoTextosOferta>();
		
		for (TextosOferta textoOferta: lista) {
			
			DtoTextosOferta texto = new DtoTextosOferta();
			texto.setId(textoOferta.getId());
			texto.setCampoDescripcion(textoOferta.getTipoTexto().getDescripcion());
			texto.setCampoCodigo(textoOferta.getTipoTexto().getCodigo());
			texto.setTexto(textoOferta.getTexto());
			textos.add(texto);
		}
		
		return new DtoPage(textos, page.getTotalCount()); 

		
	}


	private DtoFichaExpediente expedienteToDtoFichaExpediente(ExpedienteComercial expediente) {

		DtoFichaExpediente dto = new DtoFichaExpediente();
		Oferta oferta = null;
		Activo activo = null;
		
		if(!Checks.esNulo(expediente)) {
			
			oferta = expediente.getOferta();
			if(!Checks.esNulo(oferta)) {
				activo = oferta.getActivoPrincipal();
			}
			
			dto.setId(expediente.getId());
		
			if(!Checks.esNulo(oferta) && !Checks.esNulo(activo)) {		
			
				dto.setNumExpediente(expediente.getNumExpediente());	
				if(!Checks.esNulo(activo.getCartera())) {
					dto.setEntidadPropietariaDescripcion(activo.getCartera().getDescripcion());
				}	
				
				if(!Checks.esNulo(oferta.getTipoOferta())) {
					dto.setTipoExpedienteDescripcion(oferta.getTipoOferta().getDescripcion());
					dto.setTipoExpedienteCodigo(oferta.getTipoOferta().getCodigo());
				}
				
				dto.setPropietario(activo.getFullNamePropietario());		
				if(!Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
					dto.setMediador(activo.getInfoComercial().getMediadorInforme().getNombre());
				}
				
				dto.setImporte(oferta.getImporteOferta());
				if(!Checks.esNulo(expediente.getCompradorPrincipal())) {
					dto.setComprador(expediente.getCompradorPrincipal().getFullName());
				}
				
				if(!Checks.esNulo(expediente.getEstado())) {
					dto.setEstado(expediente.getEstado().getDescripcion());
				}		
				dto.setFechaAlta(expediente.getFechaAlta());
				dto.setFechaAltaOferta(oferta.getFechaAlta());
				dto.setFechaSancion(expediente.getFechaSancion());
				
				if(!Checks.esNulo(expediente.getReserva())) {
					dto.setFechaReserva(expediente.getReserva().getFechaEnvio());
				}
				
				if(!Checks.esNulo(oferta.getAgrupacion())) {
					dto.setIdAgrupacion(oferta.getAgrupacion().getId());
					dto.setNumEntidad(oferta.getAgrupacion().getNumAgrupRem());
				} else {
					dto.setIdActivo(activo.getId());
					dto.setNumEntidad(activo.getNumActivo());
				}
				
				if(!Checks.esNulo(expediente.getUltimoPosicionamiento())) {
					dto.setFechaPosicionamiento(expediente.getUltimoPosicionamiento().getFechaPosicionamiento());					
				}
				
				dto.setMotivoAnulacion(expediente.getMotivoAnulacion());
				dto.setFechaAnulacion(expediente.getFechaAnulacion());
				dto.setPeticionarioAnulacion(expediente.getPeticionarioAnulacion());
				dto.setFechaContabilizacionPropietario(expediente.getFechaContabilizacionPropietario());
				dto.setFechaDevolucionEntregas(expediente.getFechaDevolucionEntregas());
				dto.setImporteDevolucionEntregas(expediente.getImporteDevolucionEntregas());

			}
		}
		
		return dto;
	}
	
	private DtoDatosBasicosOferta expedienteToDtoDatosBasicosOferta(ExpedienteComercial expediente) {
		
		DtoDatosBasicosOferta dto = new DtoDatosBasicosOferta();
		Oferta oferta = expediente.getOferta();
		
		dto.setIdOferta(oferta.getId());
		dto.setNumOferta(oferta.getNumOferta());
		if(!Checks.esNulo(oferta.getTipoOferta())) {
			dto.setTipoOfertaDescripcion(oferta.getTipoOferta().getDescripcion());
		}
		dto.setFechaNotificacion(oferta.getFechaNotificacion());
		dto.setFechaAlta(oferta.getFechaAlta());
		if(!Checks.esNulo(oferta.getEstadoOferta())) {
			dto.setEstadoDescripcion(oferta.getEstadoOferta().getDescripcion());
		}
		if(!Checks.esNulo(oferta.getPrescriptor()) && !Checks.esNulo(oferta.getPrescriptor().getTipoColaborador())) {
			dto.setPrescriptorDescripcion(oferta.getPrescriptor().getTipoColaborador().getDescripcion());
		}
		dto.setImporteOferta(oferta.getImporteOferta());
		dto.setImporteContraoferta(oferta.getImporteContraOferta());
		
		// TODO Comités sin definir
		//dto.setComite();
		
		if(!Checks.esNulo(oferta.getVisita())) {
			dto.setNumVisita(oferta.getVisita().getNumVisita());
		}
		
				
		return dto;
	}

}

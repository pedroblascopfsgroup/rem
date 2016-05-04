package es.pfsgroup.plugin.recovery.liquidaciones;

import java.sql.Date;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.tareaNotificacion.EXTDtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.liquidaciones.api.ContabilidadCobrosApi;
import es.pfsgroup.plugin.recovery.liquidaciones.api.LiquidacionesProjectContext;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.ContabilidadCobrosDao;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;
import es.pfsgroup.plugin.recovery.liquidaciones.excepciones.STAContabilidadException;
import es.pfsgroup.plugin.recovery.liquidaciones.model.ContabilidadCobros;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableConceptoEntrega;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableTipoEntrega;


/**
 * Servicio para los documentos de precontencioso.
 * @author Kevin
 */
@Service
public class ContabilidadCobrosManager implements ContabilidadCobrosApi {
	
	@Autowired ContabilidadCobrosDao contabilidadCobrosDao;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private DictionaryManager dictionary;
	
	@Autowired
	private AsuntoDao asuntoDao;
	
	@Autowired
	private AsuntoApi asuntoApi;
	
	@Autowired
	private LiquidacionesProjectContext liquidacionesProjectContext;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Override
	@Transactional(readOnly=false)
	public void saveContabilidadCobro(DtoContabilidadCobros dto) {
		ContabilidadCobros cnt = new ContabilidadCobros();
		
		/**Seteamos los valores de los campos**/
		// Comprobar si ya existe un registro e importarlo para modificar su contenido.
		if(!Checks.esNulo(dto.getId())){
			cnt = contabilidadCobrosDao.get(dto.getId());
		}
		// Obtener fechas y asignar al modelo.
		try {
			Date sqlFE = new java.sql.Date(DateFormat.toDate(dto.getFechaEntrega()).getTime());
			cnt.setFechaEntrega(sqlFE);
			Date sqlFV = new java.sql.Date(DateFormat.toDate(dto.getFechaValor()).getTime());
			cnt.setFechaValor(sqlFV);
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		// Obtener los diccionarios por su columna 'CODIGO' y asignar al modelo.
		if(dto.getTipoEntrega() != null && !dto.getTipoEntrega().equals("")){
			Dictionary tipoEntrega = dictionary.getByCode(DDAdjContableTipoEntrega.class, dto.getTipoEntrega());
			cnt.setTipoEntrega((DDAdjContableTipoEntrega) tipoEntrega);
		}
		if(dto.getConceptoEntrega() != null && !dto.getConceptoEntrega().equals("")){
			Dictionary conceptoEntrega = dictionary.getByCode(DDAdjContableConceptoEntrega.class, dto.getConceptoEntrega());
			cnt.setConceptoEntrega((DDAdjContableConceptoEntrega) conceptoEntrega);
		}
		// Asignar resto de datos al modelo.
		cnt.setAsunto(asuntoDao.get(dto.getAsunto()));
		cnt.setDemoras(dto.getDemoras());
		cnt.setGastosLetrado(dto.getGastosLetrado());
		cnt.setGastosProcurador(dto.getGastosProcurador());
		cnt.setImpuestos(dto.getImpuestos());
		cnt.setIntereses(dto.getIntereses());
		cnt.setNominal(dto.getNominal());
		cnt.setNumCheque(dto.getNumCheque());
		cnt.setNumEnlace(dto.getNumEnlace());
		cnt.setNumMandamiento(dto.getNumMandamiento());
		cnt.setObservaciones(dto.getObservaciones());
		cnt.setOtrosGastos(dto.getOtrosGastos());
		cnt.setQuitaDemoras(dto.getQuitaDemoras());
		cnt.setQuitaGastosLetrado(dto.getQuitaGastosLetrado());
		cnt.setQuitaGastosProcurador(dto.getQuitaGastosProcurador());
		cnt.setQuitaImpuestos(dto.getQuitaImpuestos());
		cnt.setQuitaIntereses(dto.getQuitaIntereses());
		cnt.setQuitaNominal(dto.getQuitaNominal());
		cnt.setQuitaOtrosGastos(dto.getQuitaOtrosGastos());
		cnt.setTotalEntrega(dto.getTotalEntrega());
		cnt.setOperacionesTramite(dto.getOperacionesTramite());
		cnt.setOperacionesEnTramite(dto.getOperacionesEnTramite());
		cnt.setQuitaOperacionesEnTramite(dto.getQuitaOperacionesEnTramite());
		cnt.setTotalQuita(dto.getTotalQuita());

		// Guardar en la DB.
		genericDao.save(ContabilidadCobros.class, cnt);
	}

	@Override
	@Transactional(readOnly=false)
	public void deleteContabilidadCobro(Long idContabilidadCobro) {
		genericDao.deleteById(ContabilidadCobros.class, idContabilidadCobro);
	}

	@Override
	public List<ContabilidadCobros> getListadoContabilidadCobros(
			DtoContabilidadCobros dto) {
		return (List<ContabilidadCobros>) contabilidadCobrosDao.getListadoContabilidadCobros(dto);
	}

	@Override
	public ContabilidadCobros getContabilidadCobroByID(DtoContabilidadCobros dto) {
		return contabilidadCobrosDao.getContabilidadCobroByID(dto);
	}

	@Override
	@Transactional(readOnly = false)
	public void crearTarea(DtoGenerarTarea dto) throws STAContabilidadException{
		// Preparar los datos de la tarea.
		EXTTareaNotificacion tarea = new EXTTareaNotificacion();
		
		Map<String, String> codigoSubtareaMap = liquidacionesProjectContext.getCodigosSubTarea();
		if(!codigoSubtareaMap.containsKey(usuarioManager.getUsuarioLogado().getEntidad().getDescripcion())){
			throw new STAContabilidadException("contabilidad.cobros.mensaje.error.staContabilidadCobros"); 
		}
		String codigoSubtarea = codigoSubtareaMap.get(usuarioManager.getUsuarioLogado().getEntidad().getDescripcion());
        SubtipoTarea subtipoTarea = genericDao.get(SubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", codigoSubtarea));
        TipoCalculo tipoCalculo = null;
        if (dto instanceof EXTDtoGenerarTarea) {
            EXTDtoGenerarTarea sandto = (EXTDtoGenerarTarea) dto;
            tipoCalculo = sandto.getTipoCalculo();
        }
        if (subtipoTarea == null) {
            throw new GenericRollbackException("tareaNotificacion.subtipoTareaInexistente", codigoSubtarea);
        }
        if (!TipoTarea.TIPO_TAREA.equals(subtipoTarea.getTipoTarea().getCodigoTarea())) {
            throw new GenericRollbackException("tareaNotificacion.subtipoTarea.notificacionIncorrecta", codigoSubtarea);
        }
        
        tarea.setEspera(false);
        tarea.setAlerta(false);
        tarea.setTarea(subtipoTarea.getDescripcion());
        tarea.setDescripcionTarea(subtipoTarea.getDescripcionLarga());
        tarea.setCodigoTarea(subtipoTarea.getTipoTarea().getCodigoTarea());
        tarea.setSubtipoTarea(subtipoTarea);
        DDTipoEntidad tipoEntidad = (DDTipoEntidad) dictionary.getByCode(DDTipoEntidad.class, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
        tarea.setTipoEntidad(tipoEntidad);
        Date ahora = new Date(System.currentTimeMillis());
        tarea.setFechaInicio(ahora);

        Map<String, Long> plazoTareaMap = liquidacionesProjectContext.getPlazoTarea();
        if(!plazoTareaMap.containsKey(usuarioManager.getUsuarioLogado().getEntidad().getDescripcion())){
			throw new STAContabilidadException("contabilidad.cobros.mensaje.error.staContabilidadCobros"); 
		}
        Long plazoTarea = plazoTareaMap.get(usuarioManager.getUsuarioLogado().getEntidad().getDescripcion());
        Date fin = new Date(System.currentTimeMillis() + plazoTarea);
        if (tipoCalculo == null) {
            tipoCalculo = TipoCalculo.TODO;
        }
        tarea.setVencimiento(VencimientoUtils.getFecha(fin, tipoCalculo));

        // Seteo la entidad en el campo que corresponda.
        Asunto asu = asuntoApi.get(dto.getIdEntidad());
        tarea.setAsunto(asu);
        tarea.setEstadoItinerario(asu.getEstadoItinerario());
        if (Checks.esNulo(asu.getGestor())) {
        	tarea.setEmisor("Automático");
        } else {
        	tarea.setEmisor(asu.getGestor().getUsuario().getApellidoNombre());
        }
        
        // Guardar la tarea.
        genericDao.save(EXTTareaNotificacion.class, tarea);
	}

}

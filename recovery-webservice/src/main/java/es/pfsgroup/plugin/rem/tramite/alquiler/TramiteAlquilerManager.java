package es.pfsgroup.plugin.rem.tramite.alquiler;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Fianzas;
import es.pfsgroup.plugin.rem.model.HistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.HistoricoReagendacion;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDRespuestaComprador;
import es.pfsgroup.plugin.rem.model.dd.DDRiesgoOperacion;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTratamiento;

@Service("tramiteAlquilerManager")
public class TramiteAlquilerManager implements TramiteAlquilerApi {
	
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	private static final String T015_VerificarScoring = "T015_VerificarScoring";
	private static final String T015_ElevarASancion = "T015_ElevarASancion";
	private static final String T015_ScoringBC = "T015_ScoringBC";
	private static final String T015_DefinicionOferta = "T015_DefinicionOferta";
	private static final String T015_VerificarSeguroRentas = "T015_VerificarSeguroRentas";
	private static final String T015_AceptacionCliente = "T015_AceptacionCliente";
	
	private static final String CAMPO_DEF_OFERTA_TIPOTRATAMIENTO = "tipoTratamiento";
	private static final String FUNCION_FUN_AVANZAR_PBC = "FUN_AVANZAR_PBC";
	private static final String FUNC_AVANZA_FORMALIZACION_ALQUILER_NC_BC = "FUNC_AVANZA_FORMALIZACION_ALQUILER_NC_BC";
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired 
	private ActivoTramiteApi activoTramiteApi;
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private ExpedienteComercialDao expedienteComercialDao;
    
    @Resource
	private MessageService messageServices;
    
    @Autowired
	private FuncionesApi funcionApi;
    
    @Autowired
	private GenericAdapter genericAdapter;
    
    @Autowired
    private ActivoDao activoDao;
    
    @Autowired
    private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;
    
    @Autowired
    private ActivoAdapter activoAdapter;
    
    @Autowired
	private GenericAdapter adapter;
		
	@Override
	public boolean haPasadoScoring(Long idTramite) {
		boolean haPasadoScoring = false;
		List<TareaProcedimiento> tareas = activoTramiteApi.getTareasByIdTramite(idTramite);
		for (TareaProcedimiento tareaProcedimiento : tareas) {
			if(T015_VerificarScoring.equals(tareaProcedimiento.getCodigo())) {
				haPasadoScoring = true;
			}
		}

		return haPasadoScoring;
	}
	
	@Override
	public boolean esDespuesElevar(Long idTramite) {
		boolean despuesDeElevar = false;
		List<TareaProcedimiento> tareas = activoTramiteApi.getTareasByIdTramite(idTramite);
		for (TareaProcedimiento tareaProcedimiento : tareas) {
			if(T015_ElevarASancion.equals(tareaProcedimiento.getCodigo())) {
				despuesDeElevar = true;
			}
		}

		return despuesDeElevar;
	}
	
	@Override
	public boolean haPasadoScoringBC(Long idTramite) {
		boolean haPasadoScoringBC = false;
		List<TareaProcedimiento> tareas = activoTramiteApi.getTareasByIdTramite(idTramite);
		for (TareaProcedimiento tareaProcedimiento : tareas) {
			if(T015_ScoringBC.equals(tareaProcedimiento.getCodigo())) {
				haPasadoScoringBC = true;
			}
		}

		return haPasadoScoringBC;
	}
	
	@Override
	public String tipoTratamientoAlquiler(Long idTramite) {
		
		String valorTipoTratamiento = null;
		TareaExterna definicionOferta = null;
		List<TareaExterna> listaTareas = activoTramiteApi.getListaTareaExternaByIdTramite(idTramite);
		for (TareaExterna tarea : listaTareas) {
			if(T015_DefinicionOferta.equals(tarea.getTareaProcedimiento().getCodigo())) {
				definicionOferta = tarea;
				break;
			}
		}
		if(definicionOferta != null) {
			List<TareaExternaValor> valores = definicionOferta.getValores();
			for (TareaExternaValor valor : valores) {
				if(CAMPO_DEF_OFERTA_TIPOTRATAMIENTO.equals(valor.getNombre())){
					valorTipoTratamiento = valor.getValor();
					break;
				}
			}
		}
		return this.devolverSaltoTipoTratamiento(valorTipoTratamiento);
	}
	
	private String devolverSaltoTipoTratamiento(String tipoTratamiento) {
		String salto = "No";
		if(DDTipoTratamiento.TIPO_TRATAMIENTO_NINGUNA.contentEquals(tipoTratamiento)) {
			salto = "SiNnguna";
		}else if(DDTipoTratamiento.TIPO_TRATAMIENTO_SCORING.contentEquals(tipoTratamiento)) {
			salto = "SiScoring";
		}else if(DDTipoTratamiento.TIPO_TRATAMIENTO_SEGURO_DE_RENTAS.contentEquals(tipoTratamiento)) {
			salto = "SiSeguroRentas";
		}
		
		return salto;
	}
	
	@Override
	public boolean haPasadoSeguroDeRentas(Long idTramite) {
		boolean haPasado = false;
		List<TareaProcedimiento> tareas = activoTramiteApi.getTareasByIdTramite(idTramite);
		for (TareaProcedimiento tareaProcedimiento : tareas) {
			if(T015_VerificarSeguroRentas.equals(tareaProcedimiento.getCodigo())) {
				haPasado = true;
				break;
			}
		}

		return haPasado;
	}
	
	@Override
	public boolean isOfertaContraOfertaMayor10K(TareaExterna tareaExterna) {

		boolean isMayor = false;
		Double diezK = (double) 10000;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if(eco != null) {
			Oferta oferta = eco.getOferta();
			if(oferta != null) {
				if(oferta.getImporteContraOferta() != null){
					if( oferta.getImporteContraOferta() >= diezK){	
						isMayor = true;
					}
				}else if(oferta.getImporteOferta() != null && oferta.getImporteOferta() >= diezK) {
					isMayor = true;
				}
			}
		}
		
		return isMayor;
	}
	
	@Override
	public boolean isMetodoActualizacionRelleno(TareaExterna tareaExterna) {
		boolean isRelleno = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if(eco != null) {
			CondicionanteExpediente coe = eco.getCondicionante();
			if(coe != null && coe.getMetodoActualizacionRenta() != null) {
				isRelleno = true;
			}
		}
		
		return isRelleno;
	}
	
	@Override
	public boolean haPasadoAceptacionCliente(Long idTramite) {
		boolean haPasadoScoringBC = false;
		List<TareaProcedimiento> tareas = activoTramiteApi.getTareasByIdTramite(idTramite);
		for (TareaProcedimiento tareaProcedimiento : tareas) {
			if(T015_AceptacionCliente.equals(tareaProcedimiento.getCodigo())) {
				haPasadoScoringBC = true;
				break;
			}
		}

		return haPasadoScoringBC;
	}
	

	@Override
	public boolean checkAvalCondiciones(TareaExterna tareaExterna) {
		boolean isRelleno = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if(eco != null) {
			CondicionanteExpediente coe = eco.getCondicionante();
			if(coe != null && coe.getAvalBc() != null && coe.getAvalBc()) {
				isRelleno = true;
			}
		}
		
		return isRelleno;
	}

	@Override
	public boolean checkSeguroRentasCondiciones(TareaExterna tareaExterna) {
		boolean isRelleno = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if(eco != null) {
			CondicionanteExpediente coe = eco.getCondicionante();
			if(coe != null && coe.getSeguroRentasBc() != null && coe.getSeguroRentasBc()) {
				isRelleno = true;
			}
		}
		
		return isRelleno;
	}
	@Override
	public boolean validarMesesImporteDeposito(TareaExterna tareaExterna) {
		boolean isRelleno = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if(eco != null) {
			CondicionanteExpediente coe = eco.getCondicionante();
			if(coe != null && coe.getImporteDeposito() != null && coe.getMesesDeposito() != null) {
				isRelleno = true;
			}
		}
		
		return isRelleno;
	}	

	@Override
	public boolean isTramiteT015Aprobado(List<String> tareasActivas){
		boolean isAprobado = false;
		String[] tareasParaAprobado = {ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_ELEVAR_SANCION, ComercialUserAssigantionService.TramiteAlquilerT015.CODIGO_T015_DEFINICION_OFERTA};
		if(!CollectionUtils.containsAny(tareasActivas, Arrays.asList(tareasParaAprobado))) {
			isAprobado = true;
		}
		
		return isAprobado;
	}
	
	@Override
	public boolean tieneRellenosCamposAnulacion(TareaExterna tareaExterna){
		boolean camposRellenos = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if(eco.getDetalleAnulacionCntAlquiler() != null && eco.getMotivoAnulacion() != null) {
			camposRellenos = true;
		}
		
		return camposRellenos;
	}

	@Override
	public void irClRod(ExpedienteComercial eco) {
		
		DDEstadosExpedienteComercial estado = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.PTE_CL_ROD);
		DDEstadoExpedienteBc estadoBC = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.PTE_CL_ROD));
		eco.setEstado(estado);
		eco.setEstadoBc(estadoBC);
		
		expedienteComercialDao.save(eco);
	}
	

	@Override
	public String checkGarantiasNinguna(TareaExterna tareaExterna, String expedienteAnterior) {
		String resultado = null;
		
		if (DDRespuestaComprador.CODIGO_NINGUNA.equals(expedienteAnterior)) {
			return resultado;
		}else if(DDRespuestaComprador.CODIGO_AVAL.equals(expedienteAnterior) && !checkAvalCondiciones(tareaExterna)){
			resultado = messageServices.getMessage("tramite.alquiler.aval");
		}else if(DDRespuestaComprador.CODIGO_SEGURO_RENTA.equals(expedienteAnterior) && !checkSeguroRentasCondiciones(tareaExterna)) {
			resultado = messageServices.getMessage("tramite.alquiler.seguro.rentas");
		}else if(DDRespuestaComprador.CODIGO_DEPOSITO.equals(expedienteAnterior) && !validarMesesImporteDeposito(tareaExterna)) {
			resultado = messageServices.getMessage("tramite.alquiler.deposito");
		}
			
		return resultado;
	}
	
	@Override
	public boolean expedienteTieneRiesgo(Long idExpediente){
		boolean riesgoAlto = false;
		ExpedienteComercial eco = expedienteComercialDao.get(idExpediente);
		Usuario usuario = genericAdapter.getUsuarioLogado();
		if(funcionApi.elUsuarioTieneFuncion(FUNCION_FUN_AVANZAR_PBC, usuario) || (eco != null && eco.getOferta() != null && eco.getOferta().getOfertaCaixa() != null
				&& eco.getOferta().getOfertaCaixa().getRiesgoOperacion() != null 
				&& DDRiesgoOperacion.CODIGO_ROP_ALTO.equals(eco.getOferta().getOfertaCaixa().getRiesgoOperacion().getCodigo()))) {
			riesgoAlto = true;
		}
		return riesgoAlto;
	}
	
	@Override
	public boolean siUsuarioTieneFuncionAvanzarPBC() {
		boolean resultado = false;
		Usuario usuario = genericAdapter.getUsuarioLogado();
		if(funcionApi.elUsuarioTieneFuncion(FUNCION_FUN_AVANZAR_PBC, usuario)) {
			resultado = true;
		}
		return resultado;
	}
	
	@Override
	public boolean getRespuestaHistReagendacionMayor(TareaExterna tareaExterna){
		boolean resultado = false;
		ExpedienteComercial eco = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if (eco != null && eco.getOferta() != null) {
			Filter filterEco =  genericDao.createFilter(FilterType.EQUALS, "oferta.id", eco.getOferta().getId());
			Fianzas fia = genericDao.get(Fianzas.class, filterEco);
			if(fia != null) {
				Filter filterFia =  genericDao.createFilter(FilterType.EQUALS, "fianza.id", fia.getId());
				List <HistoricoReagendacion> histReag = genericDao.getList(HistoricoReagendacion.class, filterFia);
				if (histReag != null && !histReag.isEmpty()) {
					if (histReag.size() >= 3) {
						resultado = true;
					}
				}
			}
		}
		
		return resultado;
	}
	
	
	@Override
	public boolean modificarFianza(ExpedienteComercial eco) {
		boolean modificarFianza = false;
		
		Fianzas fianza = genericDao.get(Fianzas.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", eco.getOferta().getId()));
		
		if(fianza == null || fianza.getFechaAgendacionIngreso() == null) {
			modificarFianza = true;
		}
		
		return modificarFianza;
	}
	
	
	
	@Override
	public void actualizarSituacionComercial(List<ActivoOferta> activosOferta, Activo activo, Long ecoId) {
		DDTipoEstadoAlquiler tipoEstadoAlquiler = genericDao.get(DDTipoEstadoAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo",DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO));
		DDSituacionComercial situacionComercial = genericDao.get(DDSituacionComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_ALQUILADO));
		DDTipoTituloActivoTPA tipoTituloActivoTPA =  genericDao.get(DDTipoTituloActivoTPA.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoTituloActivoTPA.tipoTituloSi));
		ActivoSituacionPosesoria sitpos = activo.getSituacionPosesoria();
		Usuario usu = adapter.getUsuarioLogado();

		
		for(ActivoOferta activoOferta : activosOferta){
			activo = activoOferta.getPrimaryKey().getActivo();
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, filtroActivo);
			if(!Checks.esNulo(activoPatrimonio)){
				activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
			} else{
				activoPatrimonio = new ActivoPatrimonio();
				activoPatrimonio.setActivo(activo);
				if (!Checks.esNulo(tipoEstadoAlquiler)){
					activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
				}
			}
			if (!Checks.esNulo(situacionComercial)) {
				activo.setSituacionComercial(situacionComercial);
			}
			
			if (!Checks.esNulo(activo.getSituacionPosesoria())) {
				activo.getSituacionPosesoria().setOcupado(1);
				if(!Checks.esNulo(tipoTituloActivoTPA)) {
					activo.getSituacionPosesoria().setConTitulo(tipoTituloActivoTPA);
				}
				activo.getSituacionPosesoria().setFechaUltCambioTit(new Date());
			}
			
			if(sitpos!=null && usu!=null) {			
				HistoricoOcupadoTitulo histOcupado = new HistoricoOcupadoTitulo(activo,sitpos,usu,HistoricoOcupadoTitulo.COD_OFERTA_ALQUILER,null);
				genericDao.save(HistoricoOcupadoTitulo.class, histOcupado);					
			}
			
			activoDao.validateAgrupacion(ecoId);
			genericDao.save(ActivoPatrimonio.class, activoPatrimonio);
		}
	}
	
	@Override
	public  void actualizarSituacionComercialUAs(Activo activo) {
		List<ActivoAgrupacionActivo> agrupacionesActivo = activo.getAgrupaciones();
		for(ActivoAgrupacionActivo activoAgrupacionActivo : agrupacionesActivo){
			if(!Checks.esNulo(activoAgrupacionActivo.getAgrupacion()) && !Checks.esNulo(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion())){
				if((DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER).equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())){
					Long idAgrupacion = activoAgrupacionActivo.getAgrupacion().getId();
					Activo activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(idAgrupacion);
					DDSituacionComercial alquiladoParcialmente = genericDao.get(DDSituacionComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_ALQUILADO_PARCIALMENTE));
					activoMatriz.setSituacionComercial(alquiladoParcialmente);
					activoDao.saveOrUpdate(activoMatriz);
				}
			}
		}
	}
	
	@Override
	public  void actualizarEstadoPublicacionUAs(Activo activo) {
		ActivoAgrupacion activoAgrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
		List<ActivoAgrupacionActivo> listaActivosAgrupacion = activoAgrupacion.getActivos();
		for (ActivoAgrupacionActivo activoAgrupacionActivo : listaActivosAgrupacion) {	
			activoAdapter.actualizarEstadoPublicacionActivo(activoAgrupacionActivo.getActivo().getId());
		}
	}
	
	@Override
	public boolean estanCamposRellenosParaFormalizacion(ExpedienteComercial eco) {
		
		Oferta oferta = eco.getOferta();
		CondicionanteExpediente condiciones = eco.getCondicionante();
		if(oferta == null || condiciones == null)
			return false;
		
		if(oferta.getClaseContratoAlquiler() == null ||  oferta.getRetencionImpuestos() == null 
			|| condiciones.getTipoImpuesto() == null || condiciones.getTipoAplicable() == null || condiciones.getTipoGrupoImpuesto() == null)
			return false;
		else
			return true;
		
	}
}
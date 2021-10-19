package es.pfsgroup.plugin.rem.tramite.alquiler;

import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTratamiento;

@Service("tramiteAlquilerManager")
public class TramiteAlquilerManager implements TramiteAlquilerApi {
	
	private static final String T015_VerificarScoring = "T015_VerificarScoring";
	private static final String T015_ElevarASancion = "T015_ElevarASancion";
	private static final String T015_ScoringBC = "T015_ScoringBC";
	private static final String T015_DefinicionOferta = "T015_DefinicionOferta";
	private static final String T015_VerificarSeguroRentas = "T015_VerificarSeguroRentas";
	private static final String T015_AceptacionCliente = "T015_AceptacionCliente";
	
	private static final String CAMPO_DEF_OFERTA_TIPOTRATAMIENTO = "tipoTratamiento";
	
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired 
	private ActivoTramiteApi activoTramiteApi;
	
    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private ExpedienteComercialDao expedienteComercialDao;
		
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
		DDEstadoExpedienteBc estadoBC = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoExpedienteBc.PTE_AGENDAR));
		eco.setEstado(estado);
		eco.setEstadoBc(estadoBC);
		
		expedienteComercialDao.save(eco);
	}
}
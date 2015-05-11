package es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.dao.NMBBienDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos.NMBContratoManager;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDOrigenBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto.DtoNotarios;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.ProcedimientoApi;

@Component("nmbProcedimientoManager")
public class NMBProcedimientoManager extends
		BusinessOperationOverrider<ProcedimientoApi> implements
		ProcedimientoApi {

	@Autowired
	private Executor executor;

	@Autowired
	private FuncionManager funcionManager;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ProcedimientoDao procedimientoDao;
	
	@Autowired
	private NMBBienDao bienDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private NMBContratoManager contratoManager;
	
	@Autowired
	private NMBBienDao nmbBienDao;
	
	@Override
	public String managerName() {
		return "procedimientoManager";
	}

	/**
	 * Recupera los bienes para un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            Long
	 * @return lista de bienes.
	 */
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO)
	public List<Bien> getBienesDeUnProcedimiento(Long idProcedimiento) {
		List<Bien> listaBienes = parent().getBienesDeUnProcedimiento(
				idProcedimiento);
		Usuario usuarioLogado = (Usuario) executor
				.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		try {
			// si tiene permiso para ver toda la estructura de bienes meto todos
			// los bienes
			// sino solo meto los bienes manuales
			NMBBien bien = new NMBBien();
			List<Bien> listNMBBienes = new ArrayList<Bien>();
			for (Bien b : listaBienes) {
				bien = (b instanceof NMBBien) ? (NMBBien) b : getNMBBien(b);
									
				if ( funcionManager.tieneFuncion(usuarioLogado,	"ESTRUCTURA_COMPLETA_BIENES") || NMBDDOrigenBien.ORIGEN_MANUAL.equals(bien.getOrigen().getCodigo())) {
					listNMBBienes.add(bien);
				} else {
					// si el usuario conectado es externo y el bien esta marcado
					// mostrar
					if (usuarioLogado.getUsuarioExterno() && bien.getMarcaExternos() == 1)
						listNMBBienes.add(bien);
				}
			}
			return listNMBBienes;
		} catch (Exception e) {
			return listaBienes;
		}
	}

	/**
	 * Recupera los bienes para un procedimiento.
	 * 
	 * @param idProcedimiento
	 *            Long
	 * @return lista de bienes.
	 */
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(BO_PRC_MGR_GET_BIENES_DE_PROCEDIMIENTOS)
	public List<ProcedimientoBien> getBienesDeProcedimientos(List<Long> idProcedimientos) {
		List<ProcedimientoBien> listadoBienes = nmbBienDao.getBienesPorProcedimientos(idProcedimientos);
		return listadoBienes;
	}

	private NMBBien getNMBBien(Bien b) {
		NMBBien bien;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", b.getId());
		bien = genericDao.get(NMBBien.class, f1);
		return bien;
	}

	@Override
	@BusinessOperation("NMBProcedimientoManager.getNotarios")
	public ArrayList<DtoNotarios> getNotarios() {
		ArrayList<GestorDespacho> listaGestorDespacho = new ArrayList<GestorDespacho>();
		Filter f1 = genericDao.createFilter(FilterType.EQUALS,
				"despachoExterno.despacho.tipoDespacho.codigo", "NOT");
		listaGestorDespacho = (ArrayList<GestorDespacho>) genericDao.getList(
				GestorDespacho.class, f1);
		ArrayList<DtoNotarios> listaNotarios = new ArrayList<DtoNotarios>();
		for (GestorDespacho gd : listaGestorDespacho) {
			DtoNotarios dtoNotario = new DtoNotarios();
			dtoNotario.setId(gd.getUsuario().getId());
			dtoNotario.setCodigo(gd.getUsuario().getId().toString());
			dtoNotario.setDescripcion(gd.getUsuario().getApellidoNombre());
			listaNotarios.add(dtoNotario);
		}
		return listaNotarios;
	}
	
	/**import es.capgemini.devon.hibernate.pagination.PageHibernate;
	 * Devuelve los bienes de las personas (Solvencias)
	 * @param idProcedimiento
	 * @return
	 */
	@BusinessOperation(BO_PRC_NMB_GET_SOLVENCIAS_DE_UN_PROCEDIMIENTO)
	public List<Bien> getSolvenciasDeUnProcedimiento(Long idProcedimiento) {
		return bienDao.getSolvenciasDeUnProcedimiento(idProcedimiento);		
	}


	/**
	 * Devuelve los bienes de los contratos (Garantias)
	 * @param idProcedimiento
	 * @return
	 */
	@BusinessOperation(BO_PRC_NMB_GET_GARANTIAS_DE_UN_PROCEDIMIENTO)
	public List<Bien> getGarantiasDeUnProcedimiento(Long idProcedimiento) {
		List<Bien> bienes = new ArrayList<Bien>();
		List<ExpedienteContrato> expedientesContrato = procedimientoDao.get(idProcedimiento).getExpedienteContratos();
		for (ExpedienteContrato expedienteContrato : expedientesContrato) {
			Contrato contrato = expedienteContrato.getContrato();
			if (!Checks.esNulo(contrato)) {
				List<NMBContratoBien> contratosBien = contratoManager.getBienes(contrato.getId());
				for (NMBContratoBien nmbContratoBien : contratosBien) {
					if (!bienes.contains(nmbContratoBien.getBien())) {
						bienes.add(nmbContratoBien.getBien());
					}
				}
			}
		}
		return bienes;
		
	}

}
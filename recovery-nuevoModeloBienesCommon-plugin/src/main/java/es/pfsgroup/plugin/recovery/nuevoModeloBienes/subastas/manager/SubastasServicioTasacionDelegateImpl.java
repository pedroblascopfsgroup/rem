package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.manager;

import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastasServicioTasacionDelegateApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.EditBienApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;

@Service
public class SubastasServicioTasacionDelegateImpl implements SubastasServicioTasacionDelegateApi {
	
	@Autowired
	protected ApiProxyFactory proxyFactory;

	@Autowired
	private GenericABMDao genericDao;
	
	/**
	 * Actualiza el bien con el número activo.
	 * 
	 * @param bienId
	 * @param numeroActivo
	 */
	protected void actualizaBien(Long bienId, String numeroActivo) {
		NMBBien nmbBien = proxyFactory.proxy(EditBienApi.class).getBien(bienId);
		nmbBien.setNumeroActivo(numeroActivo);
		genericDao.update(NMBBien.class, nmbBien);
	}

	/**
	 * Actualiza el la valoración activa del Bien con el valor devuelto por el servicio CD_NUITA
	 * 
	 * @param bienId
	 * @param numeroActivo
	 */
	protected void actualizaCodigoNuita(Long bienId, int codigoNuita) {
		NMBBien nmbBien = proxyFactory.proxy(EditBienApi.class).getBien(bienId);
		NMBValoracionesBien valoracion = (NMBValoracionesBien)nmbBien.getValoracionActiva();
		valoracion.setCodigoNuita(new Long(codigoNuita));
		genericDao.update(NMBValoracionesBien.class, valoracion);
	}
	
	/**
	 * Método que solicita el numero de activo de un bien a UVEM
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperation(BO_UVEM_SOLICITUD_NUMERO_ACTIVO)
	@Transactional(readOnly = false)	
	public void solicitarNumeroActivo(Long bienId) {
		/** Genera un número activo aleatorio */
		Random rnd = new Random();
		Integer randomInt = rnd.nextInt(1000);
		String numeroActivo = randomInt.toString();
		/** Fin Genera un número activo aleatorio */
		
		actualizaBien(bienId, numeroActivo);
	}
	
	/**
	 * Método que solicita la tasacion de un bien a UVEM
	 * 
	 * @param prcId
	 * @return
	 */
	@BusinessOperation(BO_UVEM_SOLICITUD_TASACION)
	@Transactional(readOnly = false)
	public void solicitarTasacion(Long bienId) {
		/** Genera un número activo aleatorio */
		Random rnd = new Random();
		Integer codNuita = rnd.nextInt(10);
		/** Fin Genera un número activo aleatorio */
		
		actualizaCodigoNuita(bienId, codNuita);
	}

	@Override
	@BusinessOperation(BO_UVEM_SOLICITUD_NUMERO_ACTIVO_BY_PRCID)
	@Transactional(readOnly = false)
	public void solicitarNumeroActivoByPrcId(Long bienId, Long prcId) {
		solicitarNumeroActivo(bienId);
		
	}

	@Override
	@BusinessOperation(BO_UVEM_SOLICITUD_TASACION_BY_PRCID)
	@Transactional(readOnly = false)
	public void solicitarTasacionByPrcId(Long bienId, Long prcId) {
		solicitarTasacion(bienId);
		
	}

	@Override
	@BusinessOperation(BO_UVEM_SOLICITUD_NUMERO_ACTIVO_CON_RESPUESTA)
	@Transactional(readOnly = false)
	public String solicitarNumeroActivoConRespuesta(Long arg0) {
		return null;
	}
	
	@Override
	@BusinessOperation(BO_UVEM_SOLICITUD_TASACION_CON_RESPUESTA)
	@Transactional(readOnly = false)
	public String solicitarTasacionConRespuesta(Long arg0) {
		return null;
	}
}
package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;

import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;

import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

import javax.annotation.Resource;

@Component
public class MSVActualizacionSuperficiesProcesar extends AbstractMSVActualizador implements MSVLiberator {

	protected final Log logger = LogFactory.getLog(getClass());

	// Posicion fija de Columnas excel, para cualquier referencia por posicion
	
		public static final int FILA_CABECERA = 0;
		public static final int DATOS_PRIMERA_FILA = 1;
		
		public static final int COL_NUM_ID_ACTIVO_HAYA = 0;
		public static final int COL_NUM_SUP_CONSTRUIDA = 1;
		public static final int COL_NUM_SUP_UTIL = 2;
		public static final int COL_NUM_REPERCUSION_EECC = 3;
		public static final int COL_NUM_PARCELA = 4;		


	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_ACTUALIZACION_SUPERFICIE;
	}
	
	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		
		Activo activo = null;
		NMBInformacionRegistralBien infoRegBien = null;
		ActivoInfoRegistral infoRegistral;						
		
		String idActivo = exc.dameCelda(fila, COL_NUM_ID_ACTIVO_HAYA);
		String supConstruida = exc.dameCelda(fila, COL_NUM_SUP_CONSTRUIDA);
		String supUtil = exc.dameCelda(fila, COL_NUM_SUP_UTIL);
		String repEECC = exc.dameCelda(fila, COL_NUM_REPERCUSION_EECC);
		String parcela = exc.dameCelda(fila, COL_NUM_PARCELA);		
			
		if (!Checks.esNulo(idActivo)) {
			activo = activoApi.getByNumActivo(this.obtenerLongExcel(idActivo));
			infoRegistral = activo.getInfoRegistral();			
			
			if(!Checks.esNulo(supConstruida)) {
				infoRegBien = infoRegistral.getInfoRegistralBien();
				if(supConstruida.trim().equals("@")) {
					infoRegBien.setSuperficieConstruida(null);	
				}else {
					infoRegBien.setSuperficieConstruida(this.obtenerBigDecimalExcel(supConstruida));						
				}
				infoRegistral.setInfoRegistralBien(infoRegBien);
			}
			
			if(!Checks.esNulo(supUtil)) {
				if(supUtil.trim().equals("@")) {
					infoRegistral.setSuperficieUtil(null);
				}else {
					infoRegistral.setSuperficieUtil(this.obtenerFloatExcel(supUtil));	
				}				
			}
		
			if(!Checks.esNulo(repEECC)) {
				if(repEECC.trim().equals("@")) {
					infoRegistral.setSuperficieElementosComunes(null);
				}else {
					infoRegistral.setSuperficieElementosComunes(this.obtenerFloatExcel(repEECC));
				}
			}
			
			if(!Checks.esNulo(parcela)) {
				if(parcela.trim().equals("@")) {
					infoRegistral.setSuperficieParcela(null);
				}else {
					infoRegistral.setSuperficieParcela(this.obtenerFloatExcel(parcela));
				}
			}
			
			activo.setInfoRegistral(infoRegistral);
			
			genericDao.update(NMBInformacionRegistralBien.class, infoRegBien);
			genericDao.update(ActivoInfoRegistral.class, infoRegistral);
			genericDao.update(Activo.class, activo);

			transactionManager.commit(transaction);

			if(activo != null){
				Thread llamadaAsincrona = new Thread(new ConvivenciaAlaska(activo.getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
				llamadaAsincrona.start();
			}

			return new ResultadoProcesarFila();
			
		} else{
			throw new ParseException("Error al procesar la fila " + fila, COL_NUM_ID_ACTIVO_HAYA);
		}
	}

	private Long obtenerLongExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Long.valueOf(celdaExcel);
	}
	
	private Double obtenerDoubleExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Double.valueOf(celdaExcel);
	}
	
	private Float obtenerFloatExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Float.parseFloat(celdaExcel);
	}
	
	private BigDecimal obtenerBigDecimalExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return BigDecimal.valueOf(this.obtenerDoubleExcel(celdaExcel));
	}

	
	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}
}
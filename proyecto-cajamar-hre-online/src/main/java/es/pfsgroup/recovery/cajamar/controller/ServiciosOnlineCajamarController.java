package es.pfsgroup.recovery.cajamar.controller;

import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.contrato.ContratoManager;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDAplicativoOrigen;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.recovery.cajamar.serviciosonline.ResultadoConsultaSaldo;
import es.pfsgroup.recovery.cajamar.serviciosonline.ServiciosOnlineCajamarApi;

@Controller
public class ServiciosOnlineCajamarController {

	private static final String VENTANA_SOLICITAR_TASACION = "plugin/cajamarhre/bienes/solicitarTasacion";
	private static final String SOLICITAR_TASACION_JSON = "plugin/cajamarhre/bienes/solicitarTasacionJSON";
	private static final String VENTANA_CONSULTA_DE_SALDO = "plugin/cajamarhre/bienes/consultaDeSaldo";
	
	private static final String KEY_MAP_RESULTADO = "resultado";

	//alberto
	@Autowired
	private ContratoManager contratoManager;
	//
	
	@Autowired
	private ServiciosOnlineCajamarApi serviciosOnlineCajamar;

	@Resource
	private Properties appProperties;
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String ventanaSolicitudTasacion(
			@RequestParam(value = "idBien", required = true) Long idBien,
			ModelMap map) {
		
		map.put("idBien", idBien);
		return VENTANA_SOLICITAR_TASACION;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String solicitarTasacion(
			@RequestParam(value = "idBien", required = true) Long idBien,
			@RequestParam(value = "cuenta", required = true) Long cuenta,
			@RequestParam(value = "persona", required = true) String persona,
			@RequestParam(value = "telefono", required = true) Long telefono,
			@RequestParam(value = "observaciones", required = false) String observaciones,
			ModelMap map) 
	{
		Boolean res = serviciosOnlineCajamar.solicitarTasacion(idBien, cuenta, persona, telefono, observaciones);
		map.put("solicitudRealizada", res);
		return SOLICITAR_TASACION_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String consultaDeSaldos(Long cntId, ModelMap map) {
		ResultadoConsultaSaldo resultado = serviciosOnlineCajamar.consultaDeSaldos(cntId);
		
		//+++++++++++++++++++++++++++++++++++++++++++++++++++++
		/*ResultadoConsultaSaldo resultado = new ResultadoConsultaSaldo();
		 Contrato cnt = contratoManager.get(cntId);
		 DDAplicativoOrigen aplicativo = cnt.getAplicativoOrigen();
		 //con esto recogemos el valor del aplicativo que despues mostraremos en consulta de saldo
		 resultado.setAplicativo(aplicativo);
		//el resultado.setAplicativo(aplicativo) vendrá ya instanciado del archivo ServiciosOnlineCajamar.java
		resultado.setExcedido("excedido");
		resultado.setFechaImpago("01/12/2015");
		resultado.setNumCuenta("00000000000000000000");
		resultado.setOficina("oficina1");
		resultado.setRiesgoGlobal("30000");
		resultado.setSaldoAct("5000");
		resultado.setSaldoGastos("8000");
		resultado.setSaldoRetenido("2000");
		resultado.setCapitalVencido("2000");
		resultado.setCapitalNoVencido("6000");
		resultado.setDemoraRecibos("demoraRecibos");
		resultado.setDemoras("demoras");
		resultado.setImpagado("2000");
		resultado.setIntereses("10000");
		resultado.setDisponible("5000");
		resultado.setInteresesRecibos("7000");
		resultado.setMovimientos3M("movimientos 3m");
		resultado.setSaldoMedio12M("20000");
		resultado.setSaldoMedio3M("4000");
		resultado.setComisionDevolucion("5");
		resultado.setDispuesto("4000");
		resultado.setFechaMora("01/12/2015");
		resultado.setFinanciado("50000");
		resultado.setImporteLimite("30000");
		resultado.setIva("13%");
		resultado.setCapitalDispuesto("60000");
		resultado.setCapitalRecibosOpen("23000");
		resultado.setCarencia("carencia");
		resultado.setDemoraRecibosOpen("3000");
		resultado.setInteresesRecibosOpen("1000");
		resultado.setIvaRecibosOpen("4%");
		resultado.setImportePol("7000");
		//valores ficticios, linea buena la primera comentada*/
		//++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		map.put(KEY_MAP_RESULTADO, resultado);
		return VENTANA_CONSULTA_DE_SALDO;
	}
	
}

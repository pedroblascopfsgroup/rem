package es.pfsgroup.plugin.proyectoBankiaOnline.procedimiento;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dto.ProcedimientoDto;
import es.capgemini.pfs.expediente.dao.ExpedienteContratoDao;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.proyectoBankiaOnline.procedimiento.api.BankiaProcedimientoApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.MEJProcedimientoApi;

@Component
public class BankiaProcedimientoManager implements BankiaProcedimientoApi {
	
	@Autowired
	ExpedienteContratoDao expedienteContratoDao;
	
	@Autowired
	MEJProcedimientoApi mejProcedimientoManager;
	
	@BusinessOperation(BO_BANKIA_PROCEDIMIENTO_NOLITIGAR)
	@Override
	public void noLitigar (ProcedimientoDto dto) {
		//Hay que crear un procedimiento, por cada contrato diferente que venga, y solo con las personas seleccionadas
		String contratosSeleccionados = dto.getSeleccionContratos();
		String personasSeleccionadas = dto.getSeleccionPersonas();
		
		
		String[] lContratos = contratosSeleccionados.split(",");
		List<String> cexCodigos = new ArrayList<String>();
		for (String contrato : lContratos) {
			if (!cexCodigos.contains(contrato)) {
				cexCodigos.add(contrato);
			}
		}
		
		String[] lPersonas = personasSeleccionadas.split("-");
		List<String> personasId = new ArrayList<String>();
		for (String personaId : lPersonas) {
			if (!personasId.contains(personaId))
				personasId.add(personaId);
		}
		
		for (String cex : cexCodigos) {
			//Por cada cex vamos a cambiar el dto para solo pasarle este contrato
			dto.setSeleccionContratos(cex);
			
			//Y ahora vamos a cambiar el string de personas seleccionadas por solo las seleccionadas de para este cex
			ExpedienteContrato expCnt = expedienteContratoDao.get(Long.decode(cex));
			if (!Checks.esNulo(expCnt)) {
				String personasSel = "";
				for (Persona p : expCnt.getContrato().getIntervinientes()) {
					if (personasId.contains(p.getId().toString())) {
						if (!personasSel.equals(""))
							personasSel += "-";
						personasSel += p.getId().toString();
					}
				}
				//Y ahora cambiamos el dto de la persona y grabamos para este contrato y estas personas
				dto.setSeleccionPersonas(personasSel);
			}
			
			mejProcedimientoManager.salvarProcedimiento(dto);
		}
	}

}

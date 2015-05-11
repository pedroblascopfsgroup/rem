#!/bin/bash


CLASSES_ADICIONALES="
es.capgemini.pfs.configuracion.Constants
es.capgemini.pfs.configuracion.ConfiguracionConstantes
es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation
es.capgemini.pfs.externa.ExternaBusinessOperation
es.capgemini.pfs.primaria.PrimariaBusinessOperation
es.capgemini.pfs.dao.AbstractDao
es.capgemini.pfs.dao.AbstractEntityDao
es.capgemini.pfs.dao.AbstractHibernateDao
es.capgemini.pfs.dao.AbstractMasterDao
es.capgemini.pfs.utils.Describible
es.capgemini.pfs.APPConstants
es.capgemini.pfs.BPMContants
es.capgemini.pfs.ruleengine.state.RuleEndState
es.capgemini.pfs.auditoria.Auditable
es.capgemini.pfs.auditoria.model.Auditoria
es.capgemini.pfs.diccionarios.Dictionary
es.capgemini.pfs.procesosJudiciales.model.TareasProcesosJudicialesConstants
es.capgemini.pfs.cobropago.dto.DtoCobroPago
es.capgemini.pfs.users.FuncionManager
es.capgemini.pfs.ruleengine.RuleResult
es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion
es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea
es.capgemini.pfs.tareaNotificacion.dto.DtoTareaNotificaciones
es.capgemini.pfs.tareaNotificacion.dto.NodoArbolTareas
es.capgemini.pfs.comun.ComunBusinessOperation
es.capgemini.pfs.registro.model.HistoricoProcedimiento
es.capgemini.pfs.exceptions.GenericRollbackException
es.capgemini.pfs.decisionProcedimiento.dto.DtoDecisionProcedimiento
es.capgemini.pfs.decisionProcedimiento.dto.DtoDecisionProcedimientoDerivado
es.pfsgroup.commons.utils.api.BusinessOperationDefinition
es.capgemini.pfs.expediente.model.Evento
es.capgemini.pfs.asunto.dto.DtoAsunto
es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto
es.capgemini.pfs.asunto.dto.DtoFormularioDemanda
es.capgemini.pfs.asunto.dto.DtoRecopilacionDocProcedimiento
es.capgemini.pfs.asunto.dto.FichaAceptacionDto
es.capgemini.pfs.asunto.dto.PersonasProcedimientoDto
es.capgemini.pfs.asunto.dto.ProcedimientoDto
es.capgemini.pfs.asunto.dto.ProcedimientoJerarquiaDto
es.capgemini.pfs.bpm.generic.JBPMEnterEventHandler
es.capgemini.pfs.bpm.generic.JBPMLeaveEventHandler
es.capgemini.pfs.recuperacion.dao.RecuperacionDao
es.capgemini.pfs.procesosJudiciales.dao.DDFaseProcesalDao
es.capgemini.pfs.procesosJudiciales.dao.JuzgadoDao
es.capgemini.pfs.procesosJudiciales.dao.PlazoTareaExternaPlazaDao
es.capgemini.pfs.procesosJudiciales.dao.TareaExternaDao
es.capgemini.pfs.procesosJudiciales.dao.TareaExternaRecuperacionDao
es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao
es.capgemini.pfs.procesosJudiciales.dao.TareaProcedimientoDao
es.capgemini.pfs.contrato.dto.BusquedaContratosDto
es.capgemini.pfs.contrato.dto.DtoBuscarContrato
es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga
es.capgemini.pfs.cliente.process.ClienteBPMConstants
es.capgemini.pfs.telecobro.dao.SolicitudExclusionTelecobroDao
es.capgemini.pfs.telecobro.dao.MotivosExclusionTelecobroDao
es.capgemini.pfs.telecobro.dao.ProveedorTelecobroDao
es.capgemini.pfs.expediente.process.ExpedienteBPMConstants
es.capgemini.pfs.asunto.dao.ProcedimientoContratoExpedienteDao
es.capgemini.pfs.procedimientoDerivado.dto.DtoProcedimientoDerivado
es.capgemini.pfs.bien.dto.DtoBien
es.capgemini.pfs.persona.dto.DtoUmbral
"

function error () {
	echo "ERROR: " $*
	exit 1
}

DSTDIR=$(pwd)/src/main/java

if [ ! -d $DSTDIR ]; then
	error "$DSTDIR: No existe el directorio"
fi


if [ -z "$*" ]; then
	error "Es neceario especificar el directorio base del poyecto rec-common"
fi

SRCPROJECT=$1

if [ ! -d $SRCPROJECT ]; then
	error "$SRCPROJECT: No existe el directorio"
fi

SRCDIR=${SRCPROJECT}/modules/common/main/java

if [ ! -d $SRCDIR ]; then
	error "$SRCDIR: No existe el directorio"
fi

total=0;

for f in $(find $DSTDIR -type f -name *.java -print); do
	rm $f
done
cd $SRCDIR

for f in $(find . -type f -name *.java -print); do
  o="$(cat $f |  grep @Entity)"
  if [ ! -z "$o" ]; then
    total=$(( $total + 1 ))
    echo $f
    package=$(dirname $f)
    #echo "->$package"
    mkdir -p $DSTDIR/$package
    cp $f $DSTDIR/$package
  fi
done
echo "TOTAL=$total"

for c in $CLASSES_ADICIONALES; do
	classfile=$(echo $c | sed "s/\./\//g").java
	file="$SRCDIR/$classfile"
	if [ ! -f $file ]; then
		error "$file : No existe la clase"
	fi
	package=$(dirname $classfile)
	mkdir -p $DSTDIR/$package
	cp $file $DSTDIR/$package

done

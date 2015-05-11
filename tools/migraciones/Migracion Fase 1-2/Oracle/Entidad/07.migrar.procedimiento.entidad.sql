
-- Completar la columna de prc_decidido si tiene un asunto decidido o aceptado
UPDATE prc_procedimientos
   SET prc_decidido = 1
 WHERE (SELECT COUNT (*)
          FROM asu_asuntos a, prc_procedimientos p
         WHERE p.asu_id = a.asu_id AND a.asu_estado IN (2, 3)) > 0;
         


--Movemos los datos de los tipos de procedimientos del master a la entidad
insert into dd_tpo_tipo_procedimiento(
  DD_TPO_ID,
  DD_TPO_CODIGO,
  DD_TPO_DESCRIPCION,
  DD_TPO_DESCRIPCION_LARGA,
  DD_TPO_HTML,
  DD_TPO_XML_JBPM,
  VERSION,
  USUARIOCREAR,
  FECHACREAR,
  USUARIOMODIFICAR,
  FECHAMODIFICAR,
  USUARIOBORRAR,
  FECHABORRAR,
  BORRADO
)
select
  DD_TPO_ID,
  DD_TPO_CODIGO,
  DD_TPO_DESCRIPCION,
  DD_TPO_DESCRIPCION_LARGA,
  '',
  '',
  VERSION,
  USUARIOCREAR,
  FECHACREAR,
  USUARIOMODIFICAR,
  FECHAMODIFICAR,
  USUARIOBORRAR,
  FECHABORRAR,
  BORRADO
from pfsmaster.dd_tpo_tipo_procedimiento;

--Seteamos el estado del procedimiento como estado 'CERRADO'
update PRC_PROCEDIMIENTOS
set dd_epr_id = (select dd_epr_id from pfsmaster.dd_epr_estado_procedimiento where dd_epr_codigo = '05');


commit;
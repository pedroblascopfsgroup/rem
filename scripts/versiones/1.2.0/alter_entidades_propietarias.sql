-- Ejecutar en la entidad

ALTER TABLE DD_ENP_ENTIDADES_PROPIETARIAS
ADD (DD_ENP_ADJUNTO_ADICIONAL VARCHAR2(500 BYTE));

ALTER TABLE LIN001.DD_ENP_ENTIDADES_PROPIETARIAS
ADD (DD_ENP_ADJUNTO_ADICIONAL_DESC VARCHAR2(500 BYTE));

-- Actualizamos filas para adjuntar documento adicional

UPDATE dd_enp_entidades_propietarias dd
   SET dd.dd_enp_adjunto_adicional = 'ESCRITURA_LE.pdf',
       dd.dd_enp_adjunto_adicional_desc = 'Escritura Lindorff España'
 WHERE dd.dd_enp_codigo = 1;
 
UPDATE dd_enp_entidades_propietarias dd
   SET dd.dd_enp_adjunto_adicional = 'Escritura_LHS.pdf',
       dd.dd_enp_adjunto_adicional_desc = 'Escritura Lindorff Holding Spain'
 WHERE dd.dd_enp_codigo = 4; 


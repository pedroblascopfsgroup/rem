--VALIDACIONES

--QUERY QUE VERIFICA QUE NO HAYA OFERTAS EN ESTADO ACEPTADO Y CON FECHA_NOTIFICACION A NULL
SELECT OFR.OFR_NUM_OFERTA,OFR.DD_EOF_ID, OFR.OFR_FECHA_NOTIFICACION FROM OFR_OFERTAS OFR
WHERE OFR.DD_EOF_ID = 1
AND OFR.OFR_FECHA_NOTIFICACION IS NULL
;

--VALIDACION DEL TIPO DE GESTORES EN MIG2_GPR_PROVISION_GASTOS -> EL COUNT TIENE QUE SER EL MISMO
SELECT COUNT(1) AS COUNT, 'JOIN_PROVEEDORES' AS DESCRIPCION  FROM MIG2_GPR_PROVISION_GASTOS MIG
INNER JOIN ACT_PVE_PROVEEDOR PVE
  ON MIG.GPR_COD_GESTORIA = PVE.PVE_COD_UVEM
UNION ALL
SELECT COUNT(1), 'JOIN_PROVEEDORES_GESTORIA' FROM MIG2_GPR_PROVISION_GASTOS MIG
INNER JOIN ACT_PVE_PROVEEDOR PVE
  ON MIG.GPR_COD_GESTORIA = PVE.PVE_COD_UVEM
  AND PVE.DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '01')
;

--COMPROBACION ACTIVOS/OFERTAS/ESTADO_OFERTAS/ESTADO_EXPEDIENTE
SELECT
      ACT.ACT_NUM_ACTIVO                                                                                                                           ACTIVO,
      OFR.OFR_COD_OFERTA                                                                                                                           OFERTA,
      EOF.DD_EOF_DESCRIPCION                                                                                                                      ESTADO_OFERTA,
      DECODE(OFR.OFR_COD_ESTADO_OFERTA,
            '01-01','Pnt. Sanción',
            '01-02','Reservado',
            '01-03','Aprobado',
            '01-04','Contraofertado',
            '01-05','Denegado',
            '01-06','Posicionado',
            '01-07','Firmado',
            '01-08','Anulado',
            '01-09','Vendido',
            NULL
      )                                                                                                                                                             ESTADO_EXPEDIENTE,
      OFR.OFR_FECHA_ALTA                                                                                                                              FECHA_ALTA,
      ROW_NUMBER () OVER (PARTITION BY ACT.ACT_NUM_ACTIVO ORDER BY OFR.OFR_FECHA_ALTA DESC)   ORDEN
FROM MIG2_OFR_OFERTAS OFR
INNER JOIN MIG2_OFA_OFERTAS_ACTIVO OFA ON OFA.OFA_COD_OFERTA = OFR.OFR_COD_OFERTA
INNER JOIN ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = OFA.OFA_ACT_NUMERO_ACTIVO
LEFT JOIN DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_CODIGO = SUBSTR(OFR.OFR_COD_ESTADO_OFERTA,0,2)
;

--OFERTAS DE OFR_OFERTAS SIN RELACION EN LA OFA
SELECT OFR.*
FROM MIG2_OFR_OFERTAS OFR 
LEFT JOIN MIG2_OFA_OFERTAS_ACTIVO OFA ON OFA.OFA_COD_OFERTA = OFR.OFR_COD_OFERTA 
WHERE OFA.OFA_ACT_NUMERO_ACTIVO IS NULL
; --18.454 

--OFERTAS DE AGRUPACIONES
SELECT OFA.OFA_COD_OFERTA
FROM MIG2_OFA_OFERTAS_ACTIVO OFA
GROUP BY OFA.OFA_COD_OFERTA
HAVING COUNT(1) > 1
;

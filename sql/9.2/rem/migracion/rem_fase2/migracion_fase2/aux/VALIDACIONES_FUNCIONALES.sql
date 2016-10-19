--VALIDACIONES

--QUERY QUE VERIFICA QUE NO HAYA OFERTAS EN ESTADO ACEPTADO Y CON FECHA_NOTIFICACION A NULL

SELECT OFR.OFR_NUM_OFERTA,OFR.DD_EOF_ID, OFR.OFR_FECHA_NOTIFICACION FROM OFR_OFERTAS OFR
WHERE OFR.DD_EOF_ID = 1
AND OFR.OFR_FECHA_NOTIFICACION IS NULL;

--VALIDACION DEL TIPO DE GESTORES EN MIG2_GPR_PROVISION_GASTOS -> EL COUNT TIENE QUE SER EL MISMO
SELECT COUNT(1) AS COUNT, 'JOIN_PROVEEDORES' AS DESCRIPCION  FROM MIG2_GPR_PROVISION_GASTOS MIG
INNER JOIN ACT_PVE_PROVEEDOR PVE
  ON MIG.GPR_COD_GESTORIA = PVE.PVE_COD_UVEM
UNION ALL
SELECT COUNT(1), 'JOIN_PROVEEDORES_GESTORIA' FROM MIG2_GPR_PROVISION_GASTOS MIG
INNER JOIN ACT_PVE_PROVEEDOR PVE
  ON MIG.GPR_COD_GESTORIA = PVE.PVE_COD_UVEM
  AND PVE.DD_TPR_ID = (SELECT DD_TPR_ID FROM DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = '01');
